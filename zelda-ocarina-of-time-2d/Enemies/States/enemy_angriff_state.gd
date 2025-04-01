class_name EnemyStateAttack extends EnemyState

@export var attack_anim_name : String = "attack"
@export var attack_radius: float = 200.0
@export var attack_cooldown: float = 4.0
@export var next_state : EnemyState

var player: Node2D = null
var _attack_timer: float = 0.0
var _animation_finished: bool = false
var _player_ready: bool = false  # Überprüft, ob der Spieler im Szenenbaum ist

func _ready():
	# Überprüfe, ob der Spieler im Szenenbaum ist
	if is_instance_valid(get_node("res://scenes/player.tscn")):
		player = get_node("res://scenes/player.tscn")  # Hole den Spieler
		_player_ready = true  # Spieler ist jetzt verfügbar
		print("Spieler gefunden:", player)
	else:
		print("Spieler noch nicht verfügbar!")

	_attack_timer = attack_cooldown

func play_attack_animation():
	var animation_player = $"../../AnimationPlayer"
	if animation_player:
		print("Spiele Angriff-Animation ab...")
		if animation_player.is_playing():
			animation_player.stop()
		animation_player.play(attack_anim_name)

func attack_player():
	if player and _player_ready:  # Stelle sicher, dass der Spieler bereit ist
		var player_position = player.global_position
		var direction_to_player = (player_position - enemy.global_position).normalized()
		enemy.look_at(player_position)  # Drehe den Gegner zur Spielerposition

		# Prüfe, ob der Spieler im Angriffsbereich ist
		var distance_to_player = enemy.global_position.distance_to(player_position)
		if distance_to_player <= attack_radius:
			print("Angriff auf den Spieler!")
			play_attack_animation()  # Attacke ausführen (Animation abspielen)
		else:
			print("Spieler außerhalb des Angriffsbereichs.")
	else:
		print("Der Spieler ist noch nicht bereit.")

func process(_delta: float) -> EnemyState:
	_attack_timer -= _delta
	if _attack_timer <= 0:
		attack_player()
		_attack_timer = attack_cooldown

	if _animation_finished:
		print("Angriff beendet, zurück zum Kampf-Zustand.")
		return next_state
	return self

func _on_attack_animation_finished():
	_animation_finished = true  # Setze das Flag, dass die Animation abgeschlossen ist
