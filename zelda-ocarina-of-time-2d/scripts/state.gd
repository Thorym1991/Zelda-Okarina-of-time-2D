class_name state extends Node

static var player: Player
static var state_machine: PlayerStateMachine


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func Enter() -> void:
	pass
	
	
func Exit() -> void:
	pass
		
		
		
func Process( _delta: float ) -> state:
	return null
	
	
func Physics( _delta : float ) -> state:
	return null
	


func HandleInput( _event: InputEvent ) -> state:
	return null
	
