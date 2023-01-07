tool
class_name Profiler
extends Node
# Measures and records timings.


const DEFAULT_THREAD_ID := ""

# A mapping from thread ID to Stopwatch.
# Dictionary<String, Stopwatch>
var _stopwatches := {}

# A mapping from thread ID, to metric ID, to a list of duration values, in
# milliseconds.
# Dictionary<String, Dictionary<String, Array<float>>>
var _timings := {}

# A mapping from thread ID, to metric ID, to a count.
# Dictionary<String, Dictionary<String, int>>
var _counts := {}

# This can be useful if you want to list metrics in a report even if they
# weren't actually used.
# Array<String>
var _preregistered_metric_keys := []


func _init() -> void:
    Sc.logger.on_global_init(self, "Profiler")
    init_thread(DEFAULT_THREAD_ID)


func init_thread(thread_id: String) -> void:
    _stopwatches[thread_id] = Stopwatch.new()
    _timings[thread_id] = {}
    _counts[thread_id] = {}


func start(
        metric: String,
        thread_id := DEFAULT_THREAD_ID) -> void:
    if !Sc.metadata.is_profiler_enabled:
        return
    _stopwatches[thread_id].start(metric)


func stop(
        metric: String,
        thread_id := DEFAULT_THREAD_ID,
        records := true,
        additional_timings_storage = null) -> float:
    if !Sc.metadata.is_profiler_enabled:
        return -1.0
    
    var duration: float = _stopwatches[thread_id].stop(metric)
    
    if records:
        var timings_for_thread: Dictionary = _timings[thread_id]
        if !timings_for_thread.has(metric):
            timings_for_thread[metric] = []
        timings_for_thread[metric].push_back(duration)
    
    if additional_timings_storage != null:
        if !additional_timings_storage.has(metric):
            additional_timings_storage[metric] = []
        additional_timings_storage[metric].push_back(duration)
    
    return duration


func stop_with_optional_metadata(
        metric: String,
        thread_id := DEFAULT_THREAD_ID,
        records_profile_or_metadata_container = null) -> float:
    if records_profile_or_metadata_container != null:
        if records_profile_or_metadata_container is Object and \
                records_profile_or_metadata_container.timings != null:
            return stop(
                    metric,
                    thread_id,
                    records_profile_or_metadata_container.records_profile,
                    records_profile_or_metadata_container.timings)
        else:
            return stop(
                    metric,
                    thread_id,
                    records_profile_or_metadata_container)
    else:
        return stop(
                metric,
                thread_id)


func increment_count(
        metric: String,
        thread_id := DEFAULT_THREAD_ID,
        metadata_container = null) -> int:
    var counts_for_thread: Dictionary = _counts[thread_id]
    if !counts_for_thread.has(metric):
        counts_for_thread[metric] = 0
    counts_for_thread[metric] += 1
    
    if metadata_container != null and \
            metadata_container.records_profile:
        if !metadata_container.counts.has(metric):
            metadata_container.counts[metric] = 0
        metadata_container.counts[metric] += 1
    
    return counts_for_thread[metric]


func get_timing(
        metric: String,
        metadata_container = null) -> float:
    assert(Sc.metadata.is_profiler_enabled)
    if metadata_container != null:
        var list: Array = metadata_container.timings[metric]
        assert(list.size() == 1)
        return list[0]
    else:
        assert(_timings.has(DEFAULT_THREAD_ID))
        var list: Array = _timings[DEFAULT_THREAD_ID][metric]
        assert(list.size() == 1)
        return list[0]


func get_timing_list(
        metric: String,
        metadata_container = null) -> Array:
    assert(Sc.metadata.is_profiler_enabled)
    if metadata_container != null:
        var timings: Dictionary = metadata_container.timings
        return timings[metric] if \
                timings.has(metric) else \
                []
    else:
        var timings := []
        for thread_id in _timings:
            if _timings[thread_id].has(metric):
                Sc.utils.concat(
                        timings,
                        _timings[thread_id][metric])
        return timings


func get_mean(
        metric: String,
        metadata_container = null) -> float:
    assert(Sc.metadata.is_profiler_enabled)
    var count := get_count(
            metric,
            metadata_container)
    if count == 0:
        return INF
    else:
        return get_sum(
                metric,
                metadata_container) / count


func get_min(
        metric: String,
        metadata_container = null) -> float:
    assert(Sc.metadata.is_profiler_enabled)
    if get_count(
            metric,
            metadata_container) == 0:
        return INF
    else:
        return get_timing_list(
                metric,
                metadata_container).min()


func get_max(
        metric: String,
        metadata_container = null) -> float:
    assert(Sc.metadata.is_profiler_enabled)
    if get_count(
            metric,
            metadata_container) == 0:
        return INF
    else:
        return get_timing_list(
                metric,
                metadata_container).max()


func get_sum(
        metric: String,
        metadata_container = null) -> float:
    assert(Sc.metadata.is_profiler_enabled)
    var sum := 0.0
    for timing in get_timing_list(
            metric,
            metadata_container):
        sum += timing
    return sum


func get_count(
        metric: String,
        metadata_container = null) -> int:
    assert(Sc.metadata.is_profiler_enabled)
    
    var is_timing := is_timing(
            metric,
            metadata_container)
    var is_count := is_count(
            metric,
            metadata_container)
    assert(!is_timing or !is_count)
    
    if metadata_container != null:
        return metadata_container.counts[metric] if \
                is_count else \
                get_timing_list(
                        metric,
                        metadata_container).size()
    else:
        if is_count:
            var count := 0
            for thread_id in _counts:
                if _counts[thread_id].has(metric):
                    count += _counts[thread_id][metric]
            return count
        else:
            return get_timing_list(metric).size()


func is_timing(
        metric: String,
        metadata_container = null) -> bool:
    if metadata_container != null:
        return metadata_container.timings.has(metric)
    else:
        for thread_id in _timings:
            if _timings[thread_id].has(metric):
                return true
        return false


func is_count(
        metric: String,
        metadata_container = null) -> bool:
    if metadata_container != null:
        return metadata_container.counts.has(metric)
    else:
        for thread_id in _counts:
            if _counts[thread_id].has(metric):
                return true
        return false


func get_active_metric_keys() -> Array:
    var keys := _timings.keys()
    Sc.utils.concat(keys, _counts.keys())
    return keys


func preregister_metric_keys(metric_keys: Array) -> void:
    Sc.utils.concat(_preregistered_metric_keys, metric_keys)


func get_preregistered_metric_keys() -> Array:
    return _preregistered_metric_keys
