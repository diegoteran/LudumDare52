tool
class_name _Interval
extends Reference


var time_tracker
var elapsed_time_key: String
var callback: FuncRef
var interval: float
var arguments: Array
var next_trigger_time: float
var id: int
var parent


func _init(
        parent,
        time_type: int,
        callback: FuncRef,
        interval: float,
        arguments: Array) -> void:
    self.parent = parent
    self.time_tracker = Sc.time._get_time_tracker_for_time_type(time_type)
    self.elapsed_time_key = \
            Sc.time._get_elapsed_time_key_for_time_type(time_type)
    self.callback = callback
    self.interval = interval
    self.arguments = arguments
    self.next_trigger_time = \
            time_tracker.get(elapsed_time_key) + interval
    self.id = Sc.time.get_next_task_id()


func get_has_reached_next_trigger_time() -> bool:
    var elapsed_time: float = time_tracker.get(elapsed_time_key)
    return elapsed_time >= next_trigger_time


func trigger() -> void:
    if !callback.is_valid():
        return
    next_trigger_time = \
            time_tracker.get(elapsed_time_key) + interval
    callback.call_funcv(arguments)
