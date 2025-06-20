class_name EnemyAttackLeftState extends EnemyState

@export var anim_name : String = "attack_left"
@export var damage : int = 1
@export var attack_duration : float = 0.5  # Wie lange der Angriff dauert
@export var attack_area : HurtBox
@export var next_state : EnemyState

var _attack_timer : float = 0.0
signal attack_hit

func enter() -> void:
	_attack_timer = attack_duration
	attack_area.monitoring = true  # Aktiviert die Hurtbox für den Angriff
	enemy.update_animation(anim_name)
	attack_area.damage = damage  # Setzt den Schaden für diesen Angriff
	pass

func exit() -> void:
	attack_area.monitoring = false  # Deaktiviert die Hurtbox nach dem Angriff
	pass

func process(_delta: float) -> EnemyState:
	_attack_timer -= _delta
	if _attack_timer <= 0:
		return next_state  
	return null

func physics(_delta: float) -> EnemyState:
	return null
