class_name Plant extends Node2D

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$HitBox.Damaged.connect( TakeDamage ) 
	pass # Replace with function body.



func TakeDamage( hurt_box : HurtBox ) -> void:
	animation_player.play("destroy")
	queue_free()
	pass
	
