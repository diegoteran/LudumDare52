tool
class_name Notifications
extends Node


const _NOTIFICATION_PANEL_SCENE := preload(
        "res://addons/scaffolder/src/gui/notifications/notification_panel.tscn")

const CLOSED_WITH_TAP_ANYWHERE_MIN_DELAY := 0.3

var duration_short_sec := 1.8
var duration_long_sec := 4.0

var fade_in_duration := 0.15
var fade_out_duration := 0.3

var size_small := Vector2(200.0, 67.0)
var size_medium := Vector2(400.0, 133.0)
var size_large := Vector2(600.0, 200.0)

var margin_bottom := 16.0
var margin_sides := 16.0

var opacity := 0.9

var slide_in_displacement := Vector2(0.0, -25.0)

var _active_panel: Control

# Array<NotificationPanel>
var _queue := []


func _parse_manifest(manifest: Dictionary) -> void:
    if manifest.has("duration_short_sec"):
        self.duration_short_sec = manifest.duration_short_sec
    if manifest.has("duration_long_sec"):
        self.duration_long_sec = manifest.duration_long_sec
    
    if manifest.has("fade_in_duration"):
        self.fade_in_duration = manifest.fade_in_duration
    if manifest.has("fade_out_duration"):
        self.fade_out_duration = manifest.fade_out_duration
    
    if manifest.has("size_small"):
        self.size_small = manifest.size_small
    if manifest.has("size_medium"):
        self.size_medium = manifest.size_medium
    if manifest.has("size_large"):
        self.size_large = manifest.size_large
    
    if manifest.has("margin_bottom"):
        self.margin_bottom = manifest.margin_bottom
    if manifest.has("margin_sides"):
        self.margin_sides = manifest.margin_sides
    
    if manifest.has("opacity"):
        self.opacity = manifest.opacity
    
    if manifest.has("slide_in_displacement"):
        self.slide_in_displacement = manifest.slide_in_displacement


func show_toast(data: NotificationData) -> void:
    var container: CanvasLayer = Sc.canvas_layers.layers["notification"]
    var panel: Control = _NOTIFICATION_PANEL_SCENE.instance()
    _queue.push_front(panel)
    container.add_child(panel)
    container.move_child(panel, 0)
    panel.connect("fade_out_started", self, "_on_fade_out_started", [panel])
    panel.connect("faded_out", self, "_on_faded_out", [panel])
    panel.set_up(data)
    if _queue.size() == 1:
        _active_panel = panel
        _active_panel.open()


func close_toast() -> void:
    if is_instance_valid(_active_panel):
        _active_panel.close()


func get_panel_size(type: int) -> Vector2:
    var viewport_size: Vector2 = Sc.device.get_viewport_size()
    
    var target_size: Vector2
    match type:
        NotificationsSize.SMALL:
            target_size = size_small * Sc.gui.scale
        NotificationsSize.MEDIUM:
            target_size = size_medium * Sc.gui.scale
        NotificationsSize.LARGE:
            target_size = size_large * Sc.gui.scale
        NotificationsSize.TOP_SIDE, \
        NotificationsSize.BOTTOM_SIDE:
            return Vector2(
                    viewport_size.x,
                    size_large.y * Sc.gui.scale)
        NotificationsSize.LEFT_SIDE, \
        NotificationsSize.RIGHT_SIDE:
            return Vector2(
                    size_large.x * Sc.gui.scale,
                    viewport_size.y)
        NotificationsSize.FULL_SCREEN:
            return viewport_size
        NotificationsSize.UNKNOWN, \
        _:
            Sc.logger.error("Notifications.get_panel_size")
            return Vector2.INF
    
    var max_width_with_margins := viewport_size.x - margin_sides * 2
    target_size.x = min(target_size.x, max_width_with_margins)
    
    return target_size


func _on_fade_out_started(panel: Control) -> void:
    _queue.erase(panel)
    if !_queue.empty() and \
            panel == _active_panel:
        _active_panel = _queue.back()
        _active_panel.open()


func _on_faded_out(panel: Control) -> void:
    panel._destroy()
