class_name EnemyStateAttack extends EnemyState

@export var attack_types : Array = ["attack_left", "attack_right", "heavy_attack", "combo_attack"]  # Mögliche Angriffsarten
@export var attack_duration : float = 1.0  # Dauer des Angriffs
@export var attack_area : HurtBox  # Bereich für den Angriff (z. B. für Kollisionsüberprüfung)
@export var next_state : EnemyState  # Nächster Zustand nach dem Angriff (z. B. zurück zum Chasing)

@export var damage_values : Dictionary = {  # Schaden für jede Angriffstype
	"attack_left": 10,
	"attack_right": 10,
	"heavy_attack": 25,  # Schwerer Angriff verursacht mehr Schaden
	"combo_attack": 15
}

var _timer : float = 0.0
var _current_attack : String = ""  # Der aktuelle Angriff

func enter() -> void:
	_timer = attack_duration  # Setzt den Timer für die Dauer des Angriffs
	_current_attack = attack_types[randi() % attack_types.size()]  # Wählt zufällig einen Angriff
	enemy.update_animation(_current_attack)  # Setzt die Animation für den Angriff
	if attack_area:
		attack_area.monitoring = true  # Aktiviert die Kollisionsüberprüfung für den Angriff
	pass

func exit() -> void:
	if attack_area:
		attack_area.monitoring = false  # Deaktiviert die Kollisionsüberprüfung nach dem Angriff
		enemy.update_animation("")  # Stoppt die Angriffsanimation
	pass

func process(_delta: float) -> EnemyState:
	if _timer <= 0:
		# Nach dem Angriff wechseln wir in den nächsten Zustand (z. B. zurück zum Chasing)
		return next_state

	_timer -= _delta  # Reduziert den Timer
	return null  # Weiter im aktuellen Zustand bleiben, bis der Timer abgelaufen ist

func apply_damage() -> void:
	# Berechnet den Schaden, abhängig vom aktuellen Angriff
	var damage : int = damage_values.get(_current_attack, 0)  # Hole den Schaden für den aktuellen Angriff

	# Beispiel für die Schadensverwendung: Wenn der Gegner den Spieler trifft, wird Schaden angewendet
	if attack_area.is_colliding():
		var player = attack_area.get_colliding_body()
		if player and player.has_method("take_damage"):  # Der Spieler hat eine `take_damage`-Methode
			player.take_damage(damage)  # Wendet den Schaden auf den Spieler an
	pass

func physics(_delta: float) -> EnemyState:
	# Keine Bewegung während des Angriffs
	return null
