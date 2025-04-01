class_name state_stun extends state

@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurt_box : HurtBox
var direction : Vector2

var next_state : state = null

@onready var Idle : state = $"../Idle"
@onready var death: Node = $"../death"

@onready var audio: AudioStreamPlayer2D = $"../../audio/AudioStreamPlayer2D"
@export var walk_sound : AudioStream
# Called when the node enters the scene tree for the first time.


func init() -> void:
	player.player_damaged.connect( _player_damaged )
	pass

func _ready() -> void:
	pass # Replace with function body.



func Enter() -> void:
	player.UpdateAnimation("stun")
	player.animation_player.animation_finished.connect( _animation_finished)
	
	direction = player.global_position.direction_to( hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	player.set_direction()
	
	player.make_invulnerable( invulnerable_duration ) 
	player.effect_animation_player.play("damaged")
	
	audio.stream = walk_sound
	audio.play()
	pass
	
	
func Exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_animation_finished)
	pass
		

func Process( _delta: float ) -> state:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state

func Physics( _delta : float ) -> state:
	return null
	

func HandleInput( _event: InputEvent ) -> state:
	return 
	
func _player_damaged( _hurt_box : HurtBox ) -> void:
	hurt_box = _hurt_box
	if state_machine.current_state != death:
		state_machine.change_state( self )
	pass


func _animation_finished(  _a: String ) -> void:
	next_state = Idle
	if player.hp <=0:
		next_state = death
