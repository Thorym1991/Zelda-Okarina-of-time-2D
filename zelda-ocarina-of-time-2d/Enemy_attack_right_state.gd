class_name EnemyStateAttackRight extends EnemyState

@export var anim_name : String = "right_attack"
@export var damage : int = 1
@export var attack_duration : float = 0.5  # Wie lange der Angriff dauert
@export var attack_area : HurtBox
@export var next_state : EnemyState

var _attack_timer : float = 0.0

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
		return next_state  # Nach dem Angriff zurück zum nächsten Zustand (Idle oder Chase)
	return null

func physics(_delta: float) -> EnemyState:
	return null
