extends Node

signal level_load_started
signal level_loaded
signal tilemap_bounds_changed(bounds : Array[ Vector2 ])

var current_tilemap_bounds : Array [ Vector2 ]
var target_transition : String
var position_offset : Vector2


func  _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

func change_tilemap_bounds (bounds : Array [ Vector2])-> void:
	current_tilemap_bounds = bounds
	tilemap_bounds_changed.emit(bounds)


func load_new_level(
		level_path : String,
		_target_transition : String,
		_position_offset : Vector2
	)-> void:
	
	# Pause das Spiel während der Level-Übergänge
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	
	#await SceneTransition.fade_out()
	
	# Emitte das Signal, dass der Level-Wechsel gestartet wurde
	level_load_started.emit()
	
	await get_tree().process_frame # Level Transition
	
	# Emitte das Signal, dass der Level-Wechsel gestartet wurde
	
	
	await get_tree().process_frame
	
	 # Wechsle zur neuen Szene
	get_tree().change_scene_to_file( level_path )
	
	
	await get_tree().process_frame # Level Transition
	
	#await SceneTransition.fade_in()
	# Setze das Spiel fort, nachdem das neue Level geladen wurde
	get_tree().paused = false
	
	await get_tree().process_frame
	
	# Emitte das Signal, dass das Level erfolgreich geladen wurde
	level_loaded.emit()
	
	pass
