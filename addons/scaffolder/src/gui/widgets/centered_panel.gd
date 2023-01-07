tool
class_name CenteredPanel, \
"res://addons/scaffolder/assets/images/editor_icons/centered_panel.png"
extends PanelContainer


export var stretches_horizontally := false \
        setget _set_stretches_horizontally,_get_stretches_horizontally
export var stretches_vertically := false \
        setget _set_stretches_vertically,_get_stretches_vertically


func _init() -> void:
    theme = Sc.gui.theme
    add_font_override("font", Sc.gui.fonts.main_m)


func _ready() -> void:
    Sc.device.connect(
            "display_resized",
            self,
            "_on_resized")
    _on_resized()


func _on_resized() -> void:
    var viewport := get_viewport()
    if viewport == null:
        return
    
    rect_position = \
            (viewport.size - Sc.gui.game_area_region.size) * 0.5
    rect_min_size = Sc.gui.game_area_region.size
    rect_size = Sc.gui.game_area_region.size
    
    if stretches_horizontally:
        size_flags_horizontal = Control.SIZE_EXPAND_FILL
        rect_position.x = 0.0
        rect_min_size.x = 0.0
        rect_size.x = 0.0
    else:
        size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    if stretches_vertically:
        size_flags_vertical = Control.SIZE_EXPAND_FILL
        rect_position.y = 0.0
        rect_position.y = 0.0
        rect_min_size.y = 0.0
        rect_size.y = 0.0
    else:
        size_flags_vertical = Control.SIZE_SHRINK_CENTER


func _set_stretches_horizontally(value: bool) -> void:
    stretches_horizontally = value
    _on_resized()


func _get_stretches_horizontally() -> bool:
    return stretches_horizontally


func _set_stretches_vertically(value: bool) -> void:
    stretches_vertically = value
    _on_resized()


func _get_stretches_vertically() -> bool:
    return stretches_vertically
