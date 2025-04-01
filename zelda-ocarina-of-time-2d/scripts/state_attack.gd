class_name State_Attack extends state

var attacking : bool = false
@export var attack_sound : AudioStream
@export_range(1,20,0.5) var decelerate_speed : float = 5.0


@onready var Player : Player = $"../.."
@onready var walk : state = $"../walk"
@onready var Idel : state = $"../Idle"
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim : AnimationPlayer = $"../../Sprite2D/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../audio/AudioStreamPlayer2D"
@onready var hurt_box : HurtBox = %AttackHurtBox


func init() -> void:
	pass

func Enter() -> void:
	Player.UpdateAnimation("attack")
	attack_anim.play( Player.AnimDirection() + "_attack" )
	animation_player.animation_finished.connect( EndAttack )
	
	audio.stream = attack_sound
	audio.play()
	attacking = true
	
	await get_tree().create_timer(0.05).timeout
	hurt_box.monitoring = true
	pass

func Exit() -> void:
	animation_player.animation_finished.disconnect( EndAttack )
	attacking = false
	hurt_box.monitoring = false
	pass


func Process( _delta: float ) -> state:
	Player.velocity -= Player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if Player.direction == Vector2.ZERO:
			return Idel
		else:
			return walk
	return null
	
	
func Physics( _delta : float ) -> state:
	return null
	


func HandleInput( _event: InputEvent ) -> state:
	return null
	
func EndAttack(_newAnimName : String ) -> void:
	attacking = false
