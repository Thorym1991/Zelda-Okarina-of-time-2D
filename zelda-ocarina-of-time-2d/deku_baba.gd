extends Node2D

# Variablen für den Deku Baba
var attack_range = 100.0  # Der Radius, in dem der Spieler aktiv wird
var is_active = false  # Flag, ob der Deku Baba aktiv ist
var player: Node2D  # Der Spieler (wird im Inspector gesetzt)
var animation_player: AnimationPlayer  # Der AnimationPlayer (wird im Inspector gesetzt)
var rotation_speed = 180  # Grad pro Sekunde für die Drehung

# Funktion, die beim Start ausgeführt wird
func _ready():
	# AnimationPlayer Referenz holen (falls noch nicht zugewiesen)
	animation_player = $AnimationPlayer

	# Animation erstellen, falls nicht vorhanden
	create_rotation_animation()

# Funktion, die den Spieler überprüft und die Rotation anpasst
func _process(delta):
	if player:
		# Berechne die Richtung zum Spieler
		var direction_to_player = (player.position - position).normalized()

		# Berechne den Zielwinkel (im Bogenmaß), der auf den Spieler zeigt
		var target_rotation = direction_to_player.angle()

		# Wenn der Deku Baba aktiv ist, animiere die Rotation kontinuierlich in Richtung des Spielers
		if is_active:
			smooth_rotate_to(target_rotation, delta)

# Funktion, um die Animation der Rotation zu erstellen (falls nicht vorhanden)
func create_rotation_animation():
	var animation = animation_player.get_animation("rotate")
	if animation == null:
		animation = Animation.new()
		animation.length = 2  # Dauer der Animation in Sekunden
		animation.loop = true  # Animation soll kontinuierlich laufen
		animation_player.add_animation("rotate", animation)
		animation.track_insert_key(0, 0, rotation)  # Keyframe bei 0 Sekunden
		animation.track_insert_key(0, 2, rotation + deg_to_rad(360))  # Keyframe bei 2 Sekunden (360 Grad)

# Funktion für eine sanfte Drehung zum Zielwinkel
func smooth_rotate_to(target_rotation: float, delta: float):
	var angle_diff = (target_rotation - rotation)

	# Wenn der Unterschied in der Drehung zu groß ist, berücksichtigen wir den kürzesten Winkel
	if angle_diff > PI:
		angle_diff -= 2 * PI
	elif angle_diff < -PI:
		angle_diff += 2 * PI

	# Rotation schrittweise in Richtung des Zielwinkels anpassen
	rotation += angle_diff * rotation_speed * delta
