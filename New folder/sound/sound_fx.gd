extends Node

var sounds_path = "res://sound/sounds/"
var music_path = "res://sound/music/"

const SELECT_DURATION = 0.25

# Keep sorted please
var sounds = {
	"dead" : load(sounds_path + "dead.wav"),
	"dino_mace" : load(sounds_path + "dino_mace.wav"),
	"hit" : load(sounds_path + "hit.wav"),
	"hurt" : load(sounds_path + "hurt.wav"),
	"menu" : load(sounds_path + "menu.wav"),
	"mosquito_slash" : load(sounds_path + "mosquito_slash.wav"),
	"pufferfish_gun" : load(sounds_path + "pufferfish_gun.wav"),
	"scalpel" : load(sounds_path + "scalpel.wav"),
	"scorpion_slash" : load(sounds_path + "scorpion_slash.wav"),
	"select" : load(sounds_path + "select.wav"),
	"slime_jump" : load(sounds_path + "slime_jump.wav"),
	"victory_cadence" : load(sounds_path + "victory_cadence.wav"),
	"game_over_cadence" : load(sounds_path + "game_over_cadence.wav"),
}

var music ={
	"what_must_be_done" : load(music_path + "what_must_be_done.wav"),
	"what_it_was_done_for" : load(music_path + "what_it_was_done_for.wav"),
	"what_lurks_below" : load(music_path + "what_lurks_below.wav"),
	"where_does_this_path_lead" : load(music_path + "where_does_this_path_lead.wav"),
}

onready var sound_players = get_node("2D").get_children()
onready var sound_players_menu = get_node("Menu").get_children()
onready var music_player = $Music/AudioStreamPlayer
onready var tween = $Music/Tween

var queued_track : String = ""

func play(sound_string, from_location, pitch_scale = 1, volume_db = 0):
	for soundPlayer in sound_players:
		if not soundPlayer.playing:
			soundPlayer.attenuation = 10
			soundPlayer.pitch_scale = pitch_scale
			soundPlayer.volume_db = volume_db
			soundPlayer.stream = sounds[sound_string]
			soundPlayer.global_position = from_location
			soundPlayer.play()
			return
	print("Too many sounds playing at once.")

func play_menu(sound_string, pitch_scale = 1, volume_db = 0):
	for soundPlayer in sound_players_menu:
		if not soundPlayer.playing:
			soundPlayer.pitch_scale = pitch_scale
			soundPlayer.volume_db = volume_db
			soundPlayer.stream = sounds[sound_string]
			soundPlayer.play()
			return
	print("Too many sounds playing for menu at once.")

func on_button_pressed():
	play_menu("select")

func play_music(sound_string):
	queued_track = sound_string
	if music_player.playing:
		fade_out()
	else:
		start_music()

func start_music():
	music_player.stream = music[queued_track]
	music_player.play()
	queued_track = ""

func fade_out():
	tween.interpolate_property(music_player, "volume_db", music_player.volume_db, -80, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_Tween_tween_completed(object, _key):
	object.stop()
	object.volume_db = 0
	if queued_track != "":
		start_music()
