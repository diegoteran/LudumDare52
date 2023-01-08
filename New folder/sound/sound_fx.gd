extends Node

var sounds_path = "res://sound/sounds/"
var music_path = "res://sound/music/"

# Keep sorted please
var sounds = {
	"menu" : load(sounds_path + "menu.wav"),
}

var music ={
	"what_must_be_done" : load(music_path + "what_must_be_done.wav"),
}

onready var sound_players = get_node("2D").get_children()
onready var sound_players_menu = get_node("Menu").get_children()
onready var music_player = $Music/AudioStreamPlayer

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

func play_music(sound_string, pitch_scale = 1, volume_db = 0):
	if not music_player.playing:
		music_player.pitch_scale = pitch_scale
		music_player.volume_db = volume_db
		music_player.stream = music[sound_string]
		music_player.play()
		return
