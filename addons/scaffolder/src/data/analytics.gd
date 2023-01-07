tool
class_name Analytics
extends Node
# This class depends on the proprietary third-party Google Analytics service.
# 
# -   Fortunately, Google Analytics is at least free to use.
# -   To get started with Google Analytics, read this doc:
#     https://support.google.com/analytics/answer/1008015?hl=en
# -   To learn more about the "Measurement Protocol" API that this class uses
#     to send event info, read this doc:
#     https://developers.google.com/analytics/devguides/collection/protocol/v1
# -   To learn more about the "Reporting API" you could use to run arbitrary
#     queries on your recorded analytics, read this doc:
#     https://developers.google.com/analytics/devguides/reporting/core/v4
#     -   Alternatively, you could just use Google's convenient web client:
#         http://analytics.google.com/


signal session_ended

const VERBOSE := false

const UUID := preload("res://addons/scaffolder/addons/crypto_uuid_v4/uuid.gd")

# NOTE: These pings are also used to check for whether there is Internet
#       connection, so don't increase this too much.
const PING_INTERVAL := 60.0
const BATCH_SIZE_LIMIT := 20

const GOOGLE_ANALYTICS_DOMAIN := "https://www.google-analytics.com"
const GOOGLE_ANALYTICS_COLLECT_URL := GOOGLE_ANALYTICS_DOMAIN + "/collect"
const GOOGLE_ANALYTICS_BATCH_URL := GOOGLE_ANALYTICS_DOMAIN + "/batch"
const HEADERS := []

const CLIENT_ID_SAVE_KEY := "client_id"

var client_id: String
var _has_session_started := false
var _last_ping_time := -INF
# Array<_AnalyticsEntry>
var _retry_queue := []


func _init() -> void:
    Sc.logger.on_global_init(self, "Analytics")


func _ready() -> void:
    client_id = _get_client_id()
    _log("Analytics client ID: %s" % client_id)


func _process(_delta: float) -> void:
    if _has_session_started and \
            Sc.time.get_app_time() - _last_ping_time > \
                    PING_INTERVAL:
        _last_ping_time = Sc.time.get_app_time()
        _ping()


func start_session() -> void:
    var extra_details := "&sc=start"
    _ping(extra_details)
    _log_device_info()


func end_session() -> void:
    var extra_details := "&sc=end"
    _ping(extra_details, true)


func screen(name: String) -> void:
    var details := "&cd=%s" % [
        name.http_escape(),
    ]
    var payload := _get_payload(
            "screenview",
            details)
    _trigger_collect(payload, details)


func event(
        category: String,
        action: String,
        label: String,
        value: int = -1,
        non_interaction := false,
        extra_details = null,
        is_session_end := false) -> void:
    var details := (
        "&ec=%s" +
        "&ea=%s" +
        "&el=%s"
    ) % [
        category.http_escape(),
        action.http_escape(),
        label.http_escape(),
    ]
    if value >= 0:
        details += "&ev=%s" % value
    if non_interaction:
        details += "&ni=1"
    if extra_details != null:
        details += extra_details
    var payload := _get_payload(
            "event",
            details)
    _trigger_collect(
            payload,
            details,
            is_session_end)


func _log_device_info() -> void:
    event(
            "device",
            OS.get_name(),
            Sc.device.get_model_name(),
            int(Sc.device.get_viewport_diagonal_inches() * 1000),
            true)


func _ping(
        extra_details = null,
        is_session_end := false) -> void:
    event(
            "ping",
            "ping",
            "ping",
            Sc.time.get_app_time(),
            true,
            extra_details,
            is_session_end)


func _get_client_id() -> String:
    var id = Sc.save_state.get_setting(CLIENT_ID_SAVE_KEY)
    if id == null:
        id = str(UUID.new())
        Sc.save_state.set_setting(
                CLIENT_ID_SAVE_KEY,
                id)
    return id


func _get_payload(
        hit_type: String,
        details: String) -> String:
    var viewport_size: Vector2 = Sc.device.get_viewport_size()
    var viewport_size_str := str(viewport_size.x) + "x" + str(viewport_size.y)
    # See the Google Analytics Measurement Protocol Parameter Reference here:
    # https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
    return (
        # Google Analytics version
        "v=1" +
        # Our app's tracking ID
        "&tid=%s" +
        # Anonymous client ID
        "&cid=%s" +
        # Hit type
        "&t=%s" +
        # Parameters for the given hit type
        "%s" +
        # Viewport size
        "&vp=%s" +
        # User language
        "&ul=%s" +
        # Application name
        "&an=%s" +
        # Application ID
        "&aid=%s" +
        # Application Version 
        "&av=%s" +
        # Anonymize IP
        "&aip=1" +
        # Data source
        "&ds=app" +
        # Cache buster
        "&z=%s"
    ) % [
        Sc.metadata.google_analytics_id,
        client_id,
        hit_type,
        details,
        viewport_size_str,
        OS.get_locale(),
        Sc.metadata.app_name.http_escape(),
        Sc.metadata.app_id.http_escape(),
        Sc.metadata.app_version.http_escape(),
        str(randi()),
    ]


func _trigger_collect(
        payload: String,
        details: String,
        is_session_end := false) -> void:
    _log("Analytics._trigger_collect: %s" % details)
    if VERBOSE:
        _log("  Payload (readable):\n    %s" % payload.replace("&", "\n    &"),
                true)
    
    if Sc.metadata.debug:
        # Skipping Analytics collection in debug environment
        if is_session_end:
            emit_signal("session_ended")
        return
    
    var url := GOOGLE_ANALYTICS_COLLECT_URL + "?" + payload
    var body := payload
    var entry := _AnalyticsEntry.new(payload)
    
    if !Sc.metadata.agreed_to_terms or \
            !Sc.metadata.is_data_tracked:
        # User hasn't agreed to data collection. Try again later.
        _retry_queue.push_back(entry)
        return
    
    var request := HTTPRequest.new()
    request.use_threads = true
    request.connect(
            "request_completed",
            self,
            "_on_collect_request_completed",
            [entry, request, url, is_session_end])
    add_child(request)
    
    var status: int = request.request(
            url,
            HEADERS,
            true,
            HTTPClient.METHOD_POST,
            body)
    
    if status != OK:
        Sc.logger.error(
                "Analytics._trigger_collect failed: status=%d, url=%s" % \
                        [status, url],
                false)


func _on_collect_request_completed(
        result: int,
        response_code: int,
        headers: PoolStringArray,
        body: PoolByteArray,
        entry: _AnalyticsEntry,
        request: HTTPRequest,
        url: String,
        is_session_end: bool) -> void:
    if VERBOSE:
        _log("Analytics._on_collect_request_completed: result=%d, code=%d" % [
                    result,
                    response_code,
                ],
                true)
        _log("  Body:\n    %s" % body.get_string_from_utf8(), true)
        _log("  Headers:\n    %s" % Sc.utils.join(headers, ",\n    "), true)
    
    request.queue_free()
    
    if result == HTTPRequest.RESULT_SUCCESS and \
            response_code >= 200 and response_code < 300:
        # Success! Retry any entries that have been queued, since the Internet
        # connection is back.
        _retry_queued_entries()
        if is_session_end:
            emit_signal("session_ended")
    elif result == HTTPRequest.RESULT_CANT_CONNECT or \
            result == HTTPRequest.RESULT_CANT_RESOLVE or \
            result == HTTPRequest.RESULT_CONNECTION_ERROR or \
            result == HTTPRequest.REQUEST_SSL_HANDSHAKE_ERROR or \
            result == HTTPRequest.RESULT_NO_RESPONSE or \
            result == HTTPRequest.RESULT_REQUEST_FAILED or \
            result == HTTPRequest.RESULT_TIMEOUT or \
            (response_code >= 500 and response_code < 600):
        # Probably a temporary failure! Try again later.
        if Sc.metadata.debug:
            _log("Analytics._on_collect_request_completed: " +
                    "Queuing entry for re-attempt")
        _retry_queue.push_back(entry)
    else:
        Sc.logger.error(
                ("Analytics._on_collect_request_completed failed: " +
                "result=%d, code=%d, url=%s, body=%s") % [
                    result, 
                    response_code, 
                    url, 
                    body.get_string_from_utf8(),
                ],
                false)


func _retry_queued_entries() -> void:
    if _retry_queue.empty():
        return
    
    # Partition the queued entries into batches.
    var batches := []
    var current_batch := []
    batches.push_back(current_batch)
    while !_retry_queue.empty():
        if current_batch.size() == BATCH_SIZE_LIMIT:
            current_batch = []
            batches.push_back(current_batch)
        current_batch.push_back(_retry_queue.pop_front())
    
    for batch in batches:
        _trigger_batch(batch)


func _trigger_batch(batch: Array) -> void:
    # Create the batch payload.
    var payload := ""
    for entry in batch:
        var queue_time_ms := \
                int((Sc.time.get_app_time() - entry.time) * 1000)
        var entry_payload: String = \
                "qt=%d&%s\n" % [queue_time_ms, entry.payload]
        payload += entry_payload
    
    if VERBOSE:
        _log("Analytics._trigger_batch", true)
        _log("  Payload:\n    %s" % payload, true)
        _log("  Payload (readable):\n    %s" % \
                payload.replace("&", "\n    &"),
                true)
    
    var url := GOOGLE_ANALYTICS_BATCH_URL
    var body := payload
    
    var request := HTTPRequest.new()
    request.use_threads = true
    request.connect(
            "request_completed",
            self,
            "_on_batch_request_completed",
            [batch, request, url])
    add_child(request)
    
    var status: int = request.request(
            url,
            HEADERS,
            true,
            HTTPClient.METHOD_POST,
            body)
    
    if status != OK:
        Sc.logger.error(
                "Analytics._trigger_batch failed: status=%d, url=%s" % \
                        [status, url],
                false)


func _on_batch_request_completed(
        result: int,
        response_code: int,
        headers: PoolStringArray,
        body: PoolByteArray,
        batch: Array,
        request: HTTPRequest,
        url: String) -> void:
    if VERBOSE:
        _log("Analytics._on_batch_request_completed: result=%d, code=%d" % [
                    result,
                    response_code,
                ],
                true)
        _log("  Body:\n    %s" % body.get_string_from_utf8(), true)
        _log("  Headers:\n    %s" % Sc.utils.join(headers, ",\n    "), true)
    
    request.queue_free()
    
    if result == HTTPRequest.RESULT_SUCCESS and \
            response_code >= 200 and response_code < 300:
        # Success! Retry any entries that have been queued, since the Internet
        # connection is back.
        _retry_queued_entries()
    elif result == HTTPRequest.RESULT_CANT_CONNECT or \
            result == HTTPRequest.RESULT_CANT_RESOLVE or \
            result == HTTPRequest.RESULT_CONNECTION_ERROR or \
            result == HTTPRequest.REQUEST_SSL_HANDSHAKE_ERROR or \
            result == HTTPRequest.RESULT_NO_RESPONSE or \
            result == HTTPRequest.RESULT_REQUEST_FAILED or \
            result == HTTPRequest.RESULT_TIMEOUT or \
            (response_code >= 500 and response_code < 600):
        # Probably a temporary failure! Try again later.
        if Sc.metadata.debug:
            _log("Analytics._on_batch_request_completed: " +
                    "Queuing batch for re-attempt")
        for entry in batch:
            _retry_queue.push_back(entry)
    else:
        Sc.logger.warning(
                ("Analytics._on_batch_request_completed failed: " +
                "result=%d, code=%d, url=%s, body=%s") % [
                    result, 
                    response_code, 
                    url, 
                    body.get_string_from_utf8(),
                ])


func _log(
        message: String,
        is_verbose = false) -> void:
    if Sc.metadata.logs_analytics_events and \
            (!is_verbose or \
            VERBOSE):
        Sc.logger.print(message)


class _AnalyticsEntry extends Reference:
    
    
    var payload: String
    var time: float
    
    
    func _init(payload: String) -> void:
        self.payload = payload
        self.time = Sc.time.get_app_time()
