extends CharacterBody2D

var speed = 45  # Geschwindigkeit des Gegners
var player_chase = false  # Ob der Gegner den Spieler verfolgt
var player: CharacterBody2D  # Referenz auf den Spieler
var min_follow_distance = 5  # Mindestabstand, bei dem der Gegner den Spieler verfolgen soll

# Diese Methode wird beim Start des Spiels aufgerufen
func _ready():
	# Standardmäßig ist der Gegner nicht im Verfolgungsmodus
	player_chase = false
	
	# Warte, bis der Spieler geladen wurde (1 Sekunde Verzögerung)
	await get_tree().create_timer(1.0).timeout
	
	# Überprüfen, ob der Spieler korrekt in der Gruppe "player" ist
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]  # Hole den ersten Spieler aus der Gruppe
		print_debug("Spieler gefunden: ", player.name)
	else:
		print_debug("Kein Spieler in der Gruppe gefunden!")

# Diese Methode wird bei jedem Frame aufgerufen
func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		velocity.y=0
		$AnimatedSprite2D.play("side_walk")
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.play("side_walk")
		$AnimatedSprite2D.flip_h = true
	elif velocity.y > 0:
		$AnimatedSprite2D.play("down_walk")
	elif velocity.y < 0: 
		$AnimatedSprite2D.play("up_walk")
	else:
		$AnimatedSprite2D.play("idle")
	
	if player_chase and player:
		# Berechne die Richtung zum Spieler
		var direction = player.global_position - global_position  # Richtung vom Gegner zum Spieler
		var distance = direction.length()  # Berechne den Abstand zum Spieler

		# Debugging-Ausgaben
		print_debug("Gegner Position: ", global_position)
		print_debug("Spieler Position: ", player.global_position)
		print_debug("Richtung zum Spieler: ", direction)
		print_debug("Abstand zum Spieler: ", distance)

		if distance > min_follow_distance:  # Nur bewegen, wenn der Abstand größer als min_follow_distance ist
			direction = direction.normalized()  # Normalisiere den Vektor, damit die Geschwindigkeit konstant bleibt
			velocity = direction * speed  # Setze die Geschwindigkeit des Gegners in Richtung Spieler

			# Debugging der Velocity
			print_debug("Velocity: ", velocity)

			# Bewege den Gegner mit move_and_slide() (auf die velocity wird automatisch zugegriffen)
			move_and_slide()  # Bewege den Gegner basierend auf der 'velocity'
		else:
			# Spieler innerhalb der Verfolgebereich, stoppe den Gegner
			velocity = Vector2.ZERO  # Stoppt die Bewegung, wenn der Abstand klein genug ist
			move_and_slide()  # Stelle sicher, dass der Gegner gestoppt wird

	else:
		# Wenn der Spieler nicht verfolgt wird, stoppe die Bewegung
		velocity = Vector2.ZERO
		move_and_slide()

# Diese Methode wird aufgerufen, wenn der Spieler den Erkennungsbereich des Gegners betritt
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		print_debug("Spieler hat den Erkennungsbereich betreten")
		player_chase = true  # Der Gegner beginnt, den Spieler zu verfolgen

# Diese Methode wird aufgerufen, wenn der Spieler den Erkennungsbereich des Gegners verlässt
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		print_debug("Spieler hat den Erkennungsbereich verlassen")
		player_chase = false  # Der Gegner hört auf, den Spieler zu verfolgen
		velocity = Vector2.ZERO  # Stoppt die Bewegung des Gegners
		move_and_slide()  # Stelle sicher, dass der Gegner gestoppt wird
