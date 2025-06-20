class_name EnemyStateAttackReady extends EnemyState

@export var anim_name : String = "attack_ready"
@export var attack_cooldown : float = 15.0
@export var attack_area : HurtBox
@export var attack_states : Array = [EnemyStateAttackRight][EnemyStateAttackCombo][EnemyStateAttackHeavy][EnemyAttackLeftState]
@export var damage_values : Array = [1, 1, 2, 2]  # Schaden für Angriffsarten
@export var attack_duration : float = 0.5
@export var next_state : EnemyState

var _timer : float = 0.0
var _attack_timer : float = 0.0
var _is_in_range : bool = false
var _attack_choice : int = -1
var timer: float = 0.0


#'func enter() -> void:
#	_timer = attack_cooldown
#	_attack_timer = 0.0
#	enemy.update_animation(anim_name)
#	_is_in_range = check_player_range()  # Überprüft, ob der Spieler in Reichweite ist
#	if _is_in_range:
#		choose_attack()
#	pass

func exit() -> void:
	# Nichts zu tun, wenn der Zustand verlassen wird
	pass

func process(_delta: float) -> EnemyState:
	if _attack_timer > 0:
		_attack_timer -= _delta
		if _attack_timer <= 0:
			attack_area.monitoring = false  # Deaktiviere die Hurtbox nach der Attacke

	if _is_in_range and _attack_timer <= 0:
		if _attack_choice != -1:
			return perform_attack()

	_timer -= _delta
	if _timer <= 0:
		return next_state  
	return null

func physics(_delta: float) -> EnemyState:
	return null

# Überprüft, ob der Spieler in Reichweite ist
func check_player_range() -> bool:
	return enemy.global_position.distance_to(PlayerManager.player.global_position) < 200  # Reichweite für den Angriff

# Wählt zufällig einen Angriff aus
func choose_attack() -> void:
	_attack_choice = randi_range(0, attack_states.size() - 1)
	attack_area.monitoring = true  # Aktiviert die Hurtbox für den Angriff
	enemy.update_animation(attack_states[_attack_choice].anim_name)  # Spielt die entsprechende Angriff-Animation ab
	_attack_timer = attack_duration
	attack_area.damage = damage_values[_attack_choice]  # Setzt den Schaden basierend auf der Wahl des Angriffs

# Führt den gewählten Angriff aus
func perform_attack() -> EnemyState:
	# Der Angriff ist abgeschlossen und wir wechseln zurück in den nächsten Zustand
	attack_area.monitoring = false
	_attack_choice = -1  # Setzt die Wahl zurück
	_attack_timer = attack_cooldown  # Cooldown für den nächsten Angriff
	return attack_states[_attack_choice]  # Wechsel zu dem ausgewählten Angriffszustand


func _on_vision_area_area_entered(area: Area2D) -> void:
	timer = attack_cooldown
	_attack_timer = 0.0
	enemy.update_animation(anim_name)
	_is_in_range = check_player_range()  # Überprüft, ob der Spieler in Reichweite ist
	if _is_in_range:
		choose_attack()
	pass # Replace with function body.
