class_name State_Death extends state




func init() ->void:
	pass


func Enter() -> void:
	player.animation_player.play("death")
	PlayerHud.show_game_over_screen()
	
	pass
	
	
func Exit() -> void:
	pass
		
		
		
func Process( _delta: float ) -> state:
	player.velocity = Vector2.ZERO
	return null
	
	
func Physics( _delta : float ) -> state:
	return null
	


func HandleInput( _event: InputEvent ) -> state:
	return null
	
