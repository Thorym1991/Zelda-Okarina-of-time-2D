extends CanvasLayer

var hearts : Array[ HeartGUI ] = []

@export var button_focus_audio : AudioStream
@export var button_press_audio : AudioStream

@onready var game_over: Control = $Control/Gameover
@onready var continue_button: Button = $Control/Gameover/VBoxContainer/fortzetzen
@onready var title_button: Button = $Control/Gameover/VBoxContainer/back
@onready var animation_player: AnimationPlayer = $Control/Gameover/VBoxContainer/AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $Control/Gameover/VBoxContainer/AudioStreamPlayer2D



func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI: 
			hearts.append( child )
			child.visible = false
	
	
	hide_game_over_screen()
	continue_button.focus_entered.connect( play_audio.bind( button_focus_audio))
	continue_button.pressed.connect( load_game)
	title_button.focus_entered.connect( play_audio.bind(button_focus_audio))
	title_button.pressed.connect(title_screen)
	LevelManager.level_load_started.connect(hide_game_over_screen)
	pass 


func update_hp( _hp: int, _max_hp: int ) -> void:
	update_max_hp( _max_hp )
	for i in _max_hp: 
		update_heart(i, _hp )
		pass
	pass


func update_heart( _index : int, _hp : int ) -> void:
	var _value : int = clampi( _hp - _index * 2,0,2)
	hearts[ _index].value = _value
	pass
	

func update_max_hp( _max_hp : int ) -> void:
	var _heart_count : int = roundi(_max_hp * 0.5 )
	for i in hearts.size(): 
		if i < _heart_count:
			hearts[i].visible = true
		else :
			hearts[i].visible = false
	
	
	pass


func show_game_over_screen() -> void:
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var can_continue : bool = SaveManager.get_save_file() != null
	continue_button.visible = can_continue
	
	animation_player.play("show_game_over")
	await animation_player.animation_finished
	
	if can_continue == true:
		continue_button.grab_focus()
	else:
		title_button.grab_focus()
	pass

func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color( 1,1,1,0 )

func load_game() -> void:
	play_audio(button_press_audio)
	await fade_to_black()
	SaveManager.load_game()

func title_screen() -> void:
	play_audio(button_press_audio)
	await fade_to_black()
	LevelManager.load_new_level("res://Levels/title_screen.tscn", "", Vector2.ZERO)

func fade_to_black() -> bool:
	#animation_player.play("fade to black")
	#await animation_player.animation_finshed
	PlayerManager.player.revive_player()
	return true

func play_audio ( _a : AudioStream ) ->void:
	audio.stream = _a
	audio.play()
