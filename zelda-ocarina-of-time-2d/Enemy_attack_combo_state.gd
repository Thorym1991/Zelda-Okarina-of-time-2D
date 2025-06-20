class_name EnemyStateAttackCombo extends EnemyState

@export var anim_name : String = "combo_attack"
@export var damage : int = 2
@export var attack_duration : float = 1.0
@export var attack_area : HurtBox
@export var next_state : EnemyState

var _attack_timer : float = 0.0

func enter() -> void:
	_attack_timer = attack_duration
	attack_area.monitoring = true
	enemy.update_animation(anim_name)
	attack_area.damage = damage
	pass

func exit() -> void:
	attack_area.monitoring = false
	pass

func process(_delta: float) -> EnemyState:
	_attack_timer -= _delta
	if _attack_timer <= 0:
		return next_state  # Nach dem Combo-Angriff zurück zum nächsten Zustand
	return null

func physics(_delta: float) -> EnemyState:
	return null
