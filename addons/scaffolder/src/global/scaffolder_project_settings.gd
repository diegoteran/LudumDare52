tool
class_name ScaffolderProjectSettings
extends Node
# This global singleton automatically configures Godot's "Project Settings",
# General and Input Map, according to Scaffolder's requirements.


const DEFAULT_INPUT_MAP := [
    {
        name = "screenshot",
        events = [
            {physical_scancode = KEY_L},
            {physical_scancode = KEY_P},
        ],
    },
    {
        name = "toggle_hud",
        events = [
            {physical_scancode = KEY_H},
        ],
    },
    {
        name = "sc_back",
        events = [
            {mouse_button_index = BUTTON_XBUTTON1},
        ],
    },
    {
        name = "zoom_in",
        events = [
            {mouse_button_index = BUTTON_WHEEL_UP},
            {physical_scancode = KEY_EQUAL, control = true},
            {physical_scancode = KEY_BRACERIGHT, control = true},
        ],
    },
    {
        name = "zoom_out",
        events = [
            {mouse_button_index = BUTTON_WHEEL_DOWN},
            {physical_scancode = KEY_MINUS, control = true},
            {physical_scancode = KEY_BRACELEFT, control = true},
        ],
    },
    {
        name = "pan_up",
        events = [
        {physical_scancode = KEY_UP, control = true},
        ],
    },
    {
        name = "pan_down",
        events = [
            {physical_scancode = KEY_DOWN, control = true},
        ],
    },
    {
        name = "pan_left",
        events = [
            {physical_scancode = KEY_LEFT, control = true},
        ],
    },
    {
        name = "pan_right",
        events = [
            {physical_scancode = KEY_RIGHT, control = true},
        ],
    },
    {
        name = "jump",
        events = [
            {physical_scancode = KEY_SPACE},
            {physical_scancode = KEY_Q},
            {physical_scancode = KEY_X},
        ],
    },
    {
        name = "move_up",
        events = [
            {physical_scancode = KEY_UP},
            {physical_scancode = KEY_W},
            {physical_scancode = KEY_COMMA},
        ],
    },
    {
        name = "move_down",
        events = [
            {physical_scancode = KEY_DOWN},
            {physical_scancode = KEY_S},
            {physical_scancode = KEY_O},
        ],
    },
    {
        name = "move_left",
        events = [
            {physical_scancode = KEY_LEFT},
            {physical_scancode = KEY_A},
        ],
    },
    {
        name = "move_right",
        events = [
            {physical_scancode = KEY_RIGHT},
            {physical_scancode = KEY_D},
            {physical_scancode = KEY_E},
        ],
    },
    {
        name = "dash",
        events = [
            {physical_scancode = KEY_SEMICOLON},
            {physical_scancode = KEY_APOSTROPHE},
            {physical_scancode = KEY_Z},
        ],
    },
    {
        name = "grab",
        events = [
            {physical_scancode = KEY_C},
            {physical_scancode = KEY_J},
        ],
    },
    {
        name = "face_left",
        events = [
        ],
    },
    {
        name = "face_right",
        events = [
        ],
    },
]

const DEFAULT_MOVEMENT_ACTIONS := [
    "jump",
    "move_up",
    "move_down",
    "move_left",
    "move_right",
    "dash",
    "grab",
    "face_left",
    "face_right",
]

var movement_action_key_set := {}


func _override_project_settings() -> void:
    if !Sc.metadata.overrides_project_settings:
        return
    
    _validate_preexisting_project_settings()
    
    var framebuffer_2d_without_sampling := 1
    var orientation_sensor := "sensor"
    var window_stretch_mode_disabled := "disabled"
    var window_stretch_aspect_expanded := "expand"
    var physics_2d_thread_model_single_unsafe := 0
    var physics_2d_thread_model_multi_threaded := 2
    
    var project_settings_overrides := {
        "application/config/name": Sc.metadata.app_name,
        "application/config/auto_accept_quit": false,
        "application/config/quit_on_go_back": false,
        "application/boot_splash/bg_color": Sc.palette.get_color("boot_splash_background"),
        "rendering/environment/default_clear_color": Sc.palette.get_color("background"),
        "rendering/2d/snapping/use_gpu_pixel_snap": true,
        "rendering/quality/intended_usage/framebuffer_allocation":
                framebuffer_2d_without_sampling,
        "rendering/quality/intended_usage/framebuffer_allocation.mobile":
                framebuffer_2d_without_sampling,
        "display/window/handheld/orientation": orientation_sensor,
        "display/window/stretch/mode": window_stretch_mode_disabled,
        "display/window/stretch/aspect": window_stretch_aspect_expanded,
        "logging/file_logging/enable_file_logging": true,
        "input_devices/pointing/emulate_touch_from_mouse": true,
        "input_devices/pointing/emulate_mouse_from_touch": true,
        "input_devices/pointing/ios/touch_delay": 0.005,
        "physics/common/physics_fps": ScaffolderTime.PHYSICS_FPS,
        "layer_names/2d_physics/layer_1": "surfaces_tilemaps",
        "layer_names/2d_render/layer_2": "character",
        # TODO: Figure out if this actually matters...
#        "physics/2d/thread_model": physics_2d_thread_model_multi_threaded,
    }
    for key in project_settings_overrides:
        ProjectSettings.set_setting(key, project_settings_overrides[key])


func _validate_preexisting_project_settings() -> void:
    # These are settings that can't be programmatically saved to project.godot.
    assert(ProjectSettings.get_setting("application/config/name") != "")


func _override_input_map(input_map_overrides: Array) -> void:
    if !Sc.metadata.overrides_input_map:
        return
    
    var input_map_map := {}
    for entry in DEFAULT_INPUT_MAP:
        input_map_map[entry.name] = entry.events
    
    var input_map_overrides_map := {}
    for entry in input_map_overrides:
        input_map_overrides_map[entry.name] = entry.events
    
    Sc.utils.merge(input_map_map, input_map_overrides_map)
    
    for action_name in input_map_map:
        if !InputMap.has_action(action_name):
            InputMap.add_action(action_name)
        for event_config in input_map_map[action_name]:
            var event: InputEventWithModifiers
            if event_config.has("mouse_button_index") and \
                    event_config.mouse_button_index >= 0:
                event = InputEventMouseButton.new()
                event.button_index = event_config.mouse_button_index
            elif event_config.has("physical_scancode") and \
                    event_config.physical_scancode >= 0:
                event = InputEventKey.new()
                event.physical_scancode = event_config.physical_scancode
            else:
                # FIXME: ----------
                # - Think of a better way of distinguishing between an error
                #   config and the default type-suggestion config that's added
                #   automatically in _get_input_map_schema.
#                Sc.logger.error("ScaffolderProjectSettings._override_input_map")
                continue
            
            if event_config.has("control"):
                event.control = event_config.control
            
            if !InputMap.action_has_event(action_name, event):
                InputMap.action_add_event(action_name, event)
    
    for action in DEFAULT_MOVEMENT_ACTIONS:
        for config in input_map_map[action]:
            if !config.has("physical_scancode"):
                continue
            movement_action_key_set[config.physical_scancode] = true


static func _get_input_map_schema() -> Array:
    var schema := DEFAULT_INPUT_MAP.duplicate(true)
    var event_default_key_values := [
        ["physical_scancode", -1],
        ["mouse_button_index", -1],
        ["control", false],
    ]
    for entry in schema:
        if entry.events.empty():
            entry.events.push_back({})
        for event in entry.events:
            for default_key_value in event_default_key_values:
                if !event.has(default_key_value[0]):
                    event[default_key_value[0]] = default_key_value[1]
    return schema
