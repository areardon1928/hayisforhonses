extends Node

# Join Menu Signals
signal player_join_pressed(player_name: String)
signal host_game_pressed(player_name: String)

# Lobby Menu Signals
signal start_game_pressed()
signal ready_pressed(player_id: int)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
