extends Node2D

const  START_LEVEL : String = "res://Levels/Kokiriwald/links_home.tscn"

@export var music : AudioStream

@export var button_press_audio : AudioStream

@onready var button: Button = $Button
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D



func _ready() -> void:
	get_tree().paused = true
	PlayerManager.player.visible = false
	AudioManager.play_music( music )
	
	
	PlayerHud.visible = false
	
	setup_title_screen()
	button.grab_focus()
	
	LevelManager.level_load_started.connect( exit_title_screen )
	
	pass










func setup_title_screen() -> void:
	button.pressed.connect( start_game )
	
	#button.focus_entered.connect( play_audio.bind( button_press_audio) )
	pass



func start_game() -> void:
	play_audio(button_press_audio)
	LevelManager.load_new_level( START_LEVEL, "", Vector2.ZERO )
	pass
	

func exit_title_screen() -> void:
	PlayerManager.player.visible = true
	PlayerHud.visible= true
	
func play_audio ( _a : AudioStream ) ->void:
	audio.stream = _a
	audio.play()
	
	self.queue_free()
	pass
