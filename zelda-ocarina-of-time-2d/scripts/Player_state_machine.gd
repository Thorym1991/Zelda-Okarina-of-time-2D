class_name PlayerStateMachine extends Node


var states : Array[ state ]
var prev_state : state
var current_state : state
@onready var player : Player = $".."



func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	pass
	
	


func _process(delta):
	change_state( current_state.Process( delta ) )
	pass


func _physics_process(delta):
	change_state( current_state.Process( delta ) )
	pass



func _unhandled_input(event):
	change_state( current_state .HandleInput(event)) 
pass



func Initialize( _player : Player ) -> void:
	states = []
	
	for c in get_children():
		if c is state:
			states.append(c)
	
	if states.size() == 0:
		return
	
	states[0].player = player
	states[0].state_machine = self 
	
	for state in states:
		state.init()
		
	
	change_state( states[0] )
	process_mode = Node.PROCESS_MODE_INHERIT



func change_state( new_state : state ) -> void:
	if new_state == null || new_state == current_state:
		return
	
	if current_state:
		current_state.Exit()
	
	prev_state = current_state
	current_state = new_state
	current_state.Enter()
