class_name state_idle extends state

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
@onready var Player : Player =  $"../.."
@onready var walk : state = $"../walk"
@onready var attack : state = $"../attack"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func Enter() -> void:
	Player.UpdateAnimation("Idle")
	pass
	
	
func Exit() -> void:
	pass
		
		
		
func Process( _delta: float ) -> state:
	if Player.direction != Vector2.ZERO:
		return walk
		Player.velocity = Vector2.ZERO
		
	return null
	
	
func Physics( _delta : float ) -> state:
	return null
	


func HandleInput( _event: InputEvent ) -> state:
	if _event.is_action_pressed("attack"):
		return attack
	return null
	
 
func init() -> void:

	pass
