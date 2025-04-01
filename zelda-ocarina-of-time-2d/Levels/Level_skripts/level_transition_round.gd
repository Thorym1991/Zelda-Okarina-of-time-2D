@tool
class_name LevelTransitionround extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file( "*.tscn" ) var level
@export var target_transition_area : String = "LevelTransition"
@export var center_player : bool = false

@export_category("Collision Area Settings")
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export_range( 1, 12, 1, "or_greater") var size : int = 2 :
	set( _v ):
		size = _v

@export var side: SIDE = SIDE.LEFT :
	set( _v ):
		side = _v
		_update_area()



func _ready() -> void:

	if Engine.is_editor_hint():
		return
	
	monitoring = false
	_place_player()
	
	await LevelManager.level_loaded
	
	monitoring = true
	body_entered.connect( _player_entered )
	
	pass



func _player_entered( _p : Node2D ) -> void:
	LevelManager.load_new_level( level, target_transition_area, get_offset() )
	pass


func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position( global_position + LevelManager.position_offset )


func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = PlayerManager.player.global_position
	
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		if center_player == true:
			offset.y = 0
		else:
			offset.y = player_pos.y - global_position.y
		offset.x = 16
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		if center_player == true:
			offset.x = 0
		else:
			offset.x = player_pos.x - global_position.x
		offset.y = 16
		if side == SIDE.TOP:
			offset.y *= -1

	return offset
	
func _update_area() -> void:
	var new_circle : Vector2 = Vector2(16, 16)
	var new_position : Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_circle.x *=size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_circle.x *= size
		new_position.y +=16
	elif side == SIDE.LEFT:
		new_circle.y *= size
		new_position.x -=16
	elif side == SIDE.RIGHT:
		new_circle.y *= size
		new_position.x +=16
	# Berechnungen für new_rect und new_position basierend auf side
	# ...

	# Sicherstellen, dass collision_shape nicht null ist
	if collision_shape:
		collision_shape.shape.size = new_circle
		collision_shape.position = new_position
