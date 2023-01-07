tool
class_name FooLevel, \
"res://addons/scaffolder/assets/images/editor_icons/scaffolder_level.png"
extends Node2D


const MIN_CONTROLS_DISPLAY_TIME := 0.5

var touch_listener: LevelTouchListener
var level_control_press_controller: LevelControlPressController

var session: ScaffolderLevelSession

var _is_ready := false
var _configuration_warning := ""


func _init() -> void:
    if Engine.editor_hint:
        return
    self.touch_listener = LevelTouchListener.new()
    Sc.canvas_layers.layers.top.add_child(touch_listener)
    self.level_control_press_controller = LevelControlPressController.new()
    Sc.canvas_layers.layers.top.add_child(level_control_press_controller)


func _enter_tree() -> void:
    session = Sc.levels.session
    _update_session_in_editor()


func _ready() -> void:
    _is_ready = true
    Sc.device.connect(
            "display_resized",
            self,
            "_on_resized")
    _on_resized()


func _load() -> void:
    _create_hud()


func _start() -> void:
    Sc.audio.play_music(get_music_name())
    Sc.save_state.set_level_total_plays(
            Sc.levels.session.id,
            Sc.save_state.get_level_total_plays(Sc.levels.session.id) + 1)
    Sc.analytics.event(
            "level",
            "start",
            Sc.levels.get_level_version_string(Sc.levels.session.id))
    
    if Sc.gui.hud_manifest.is_hud_visible_by_default:
        Sc.gui.hud.visible = true
    
    call_deferred("_on_started")


func _on_started() -> void:
    var start_time_scaled: float = Sc.time.get_scaled_play_time()
    var start_time_unscaled: float = Sc.time.get_play_time()
    Sc.levels.session._level_start_play_time_scaled = start_time_scaled
    Sc.levels.session._level_start_play_time_unscaled = start_time_unscaled
    Sc.logger.print("Level started:               %8.3f" % start_time_unscaled)


func _create_hud() -> void:
    Sc.gui.hud = Sc.gui.hud_manifest.hud_class.new()
    Sc.gui.hud.visible = false
    Sc.canvas_layers.layers.hud.add_child(Sc.gui.hud)


func _destroy() -> void:
    _hide_welcome_panel()
    Sc.info_panel.close_panel()
    if is_instance_valid(Sc.gui.hud):
        Sc.gui.hud._destroy()
    if is_instance_valid(touch_listener):
        touch_listener._destroy()
    if is_instance_valid(level_control_press_controller):
        level_control_press_controller._destroy()
    Sc.level = null
    Sc.levels.session._is_destroyed = true
    if Sc.levels.session.is_restarting:
        Sc.nav.open(
                "loading",
                ScreenTransition.DEFAULT,
                {level_id = Sc.levels.session.id})
    if !is_queued_for_deletion():
        queue_free()


func quit(
        has_finished: bool,
        immediately: bool) -> void:
    Sc.levels.session._level_end_play_time_unscaled = Sc.time.get_play_time()
    Sc.audio.stop_music()
    Sc.levels.session._update_for_level_end(has_finished)
    Sc.slow_motion.is_enabled = false
    if immediately:
        if !Sc.levels.session.is_restarting:
            Sc.nav.open("game_over", ScreenTransition.FANCY)
        _destroy()
    else:
        var sound_name: String = \
                Sc.audio_manifest.level_end_sound_win if \
                has_finished else \
                Sc.audio_manifest.level_end_sound_lose
        Sc.audio.get_sound_player(sound_name) \
                .connect(
                        "finished",
                        self,
                        "_on_level_quit_sound_finished",
                        [has_finished])
        Sc.audio.play_sound(sound_name)


func restart() -> void:
    Sc.levels.session._is_restarting = true
    quit(false, true)


func _input(event: InputEvent) -> void:
    if Engine.editor_hint:
        return
    
    if !Sc.levels.session.has_initial_input_happened and \
            Sc.gui.is_player_interaction_enabled and \
            Sc.levels.session.level_play_time_unscaled > \
                    MIN_CONTROLS_DISPLAY_TIME and \
            (event is InputEventMouseButton or \
                    event is InputEventScreenTouch or \
                    event is InputEventKey) and \
            Sc.levels.session.has_started:
        _on_initial_input()


func _unhandled_input(event: InputEvent) -> void:
    if Engine.editor_hint:
        return
    
    if event is InputEventMouseButton or \
            event is InputEventScreenTouch:
        # This ensures that pressing arrow keys won't change selections in any
        # overlay UI.
        Sc.utils.release_focus()


func _on_initial_input() -> void:
    Sc.logger.print(
            "_on_initial_input():         %8.3f" % \
            Sc.time.get_play_time())
    Sc.levels.session._has_initial_input_happened = true
    # Close the welcome panel on any mouse or key click event.
    if is_instance_valid(Sc.gui.welcome_panel):
        _hide_welcome_panel()


func _on_resized() -> void:
    pass


func pause() -> void:
    if Sc.audio_manifest.pauses_level_music_on_pause:
        Sc.levels.session._pre_pause_music_name = Sc.audio.get_music_name()
        Sc.levels.session._pre_pause_music_position = \
                Sc.audio.get_playback_position()
        if Sc.audio_manifest.pause_menu_music != "":
            Sc.audio.play_music(Sc.audio_manifest.pause_menu_music)
        else:
            Sc.audio.stop_music()
    Sc.nav.open("pause")


func on_unpause() -> void:
    if Sc.audio_manifest.pauses_level_music_on_pause and \
            !session.is_ended:
        Sc.audio.play_music(Sc.levels.session._pre_pause_music_name)
        Sc.audio.seek(Sc.levels.session._pre_pause_music_position)


func _show_welcome_panel() -> void:
    if !Sc.gui.is_welcome_panel_shown or \
            !Sc.gui.does_app_contain_welcome_panel:
        return
    assert(Sc.gui.welcome_panel == null)
    Sc.gui.welcome_panel = Sc.utils.add_scene(
            Sc.canvas_layers.layers.hud,
            Sc.gui.welcome_panel_scene)


func _hide_welcome_panel() -> void:
    if is_instance_valid(Sc.gui.welcome_panel):
        Sc.gui.welcome_panel._destroy()
        Sc.gui.welcome_panel = null


func _on_level_quit_sound_finished(level_finished: bool) -> void:
    var sound_name: String = \
            Sc.audio_manifest.level_end_sound_win if \
            level_finished else \
            Sc.audio_manifest.level_end_sound_lose
    Sc.audio.get_sound_player(sound_name) \
            .disconnect("finished", self, "_on_level_quit_sound_finished")
    var is_rate_app_screen_next: bool = \
            Sc.gui.is_rate_app_shown and \
            _get_is_rate_app_screen_next()
    var next_screen := \
            "rate_app" if \
            is_rate_app_screen_next else \
            "game_over"
    Sc.nav.open(next_screen, ScreenTransition.FANCY)


func get_music_name() -> String:
    return Sc.audio_manifest.default_level_music


func get_slow_motion_music_name() -> String:
    return ""


func _get_is_rate_app_screen_next() -> bool:
    return false


func _update_session_in_editor() -> void:
    if !Engine.editor_hint:
        return
    
    Sc.levels.session.reset("0")
    
    var tilemaps: Array = Sc.utils.get_children_by_type(self, TileMap)
    Sc.levels.session.config.cell_size = \
            Vector2.INF if \
            tilemaps.empty() else \
            tilemaps[0].cell_size
