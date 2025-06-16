extends AudioStreamPlayer

const music1 = preload("res://Asset/Alone.mp3")
const music2 = preload("res://Asset/Journey.mp3")

var current_track = 0

func _ready():
	connect("finished", Callable(self, "_on_music_finished"))
	play_music_level()

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()

func play_music_level():
	current_track = 0
	_play_music(music1)

func _on_music_finished():
	current_track += 1
	match current_track:
		1:
			_play_music(music2)
		_:
			# Reinicia a playlist (ou pare, dependendo do que você quer)
			current_track = 0
			_play_music(music1)
