extends Control

var upgradeName = "Upgrade"
var description = "Describe here what it does"
var iconPath = "res://icon.png"

func setValues():
	$Name.text = upgradeName
	$Description.text = description
	var texture = ImageTexture.new();
	var image = Image.new();
	image.load(iconPath);
	texture.create_from_image(image)
	$Sprite.texture = texture;

func apply_upgrade():
	# Do something to the player probably
	return;


func _on_Button_pressed():
	apply_upgrade()
	get_parent().get_parent().upgrade_chosen();
	pass # Replace with function body.
