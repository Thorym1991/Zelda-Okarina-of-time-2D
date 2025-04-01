extends Node


var music_audio_player_count : int = 2
var current_music_player : int = 0
var music_players : Array[ AudioStreamPlayer ] = []
var music_bus : String = "Music"

var music_fade_duration : float = 0.5


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in music_audio_player_count: 
		var player = AudioStreamPlayer.new()
		add_child( player )
		player.bus = music_bus
		music_players.append( player )
		

func play_music( _audio : AudioStream ) -> void:
	if _audio == music_players[ current_music_player ].stream:
		return
	
	music_players[0].stream = _audio
	music_players[0].play( 0 )
