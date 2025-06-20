class_name Plant extends Node2D

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

var _damagetaken = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$HitBox.Damaged.connect( TakeDamage ) 
	pass # Replace with function body.



func TakeDamage( hurt_box : HurtBox ) -> void:
	_damagetaken = true
	animation_player.play("destroy")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "destroy":
		queue_free()
