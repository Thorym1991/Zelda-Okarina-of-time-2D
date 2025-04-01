class_name state_walk extends state


var direction : Vector2 = Vector2.ZERO
@onready var Player : Player = $"../.."
@export var move_speed : float = 100.0
@onready var Idle : state = $"../Idle"
@onready var attack : state = $"../attack"
@onready var audio: AudioStreamPlayer2D = $"../../audio/AudioStreamPlayer2D"

@export var walk_sound : AudioStream
# Called when the node enters the scene tree for the first time.


func init() -> void:
	pass

func _ready() -> void:
	pass # Replace with function body.


func Enter() -> void:
	Player.UpdateAnimation("walk")
	audio.stream = walk_sound
	audio.play()
	pass
	
	
func Exit() -> void:
	pass
		

func Process( _delta: float ) -> state:
	if Player.direction == Vector2.ZERO:
		Player.velocity = Player.direction.normalized() * move_speed
		return Idle

	Player.velocity = Player.direction * move_speed
	
	if Player.set_direction():
		Player.UpdateAnimation("walk")
	return null

func Physics( _delta : float ) -> state:
	return null
	

func HandleInput( _event: InputEvent ) -> state:
	if _event.is_action_pressed("attack"):
		return attack
	return null
	
