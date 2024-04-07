extends Node

signal player_joined()
signal initial_connect_succeeded()
signal game_scene_loaded()
signal game_setup_complete() #inidcates when all inital game set up has been completed by server and recieved by clients

var players_info: Array[PlayerInfo] = []

# Turn Management vars
var turn_order_list: Array = [] #array of player ids which indicates turn order
var current_turn_index: int = 0      #reference to the index of the current turn in the order list

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#region Player Info Management
func add_player_info(player_name: String, id: int):
	var new_player = PlayerInfo.new(id, player_name)
	players_info.append(new_player)
	player_joined.emit()
	print_all_players()
	
func get_player_info_by_id(id: int) -> PlayerInfo:
	for player in players_info:
		if player.id == id:
			return player
	return null

func check_for_id(id: int) -> bool:
	for player in players_info:
		if player.id == id:
			return true
	return false

func get_all_players_info() -> Array[PlayerInfo]:
	return players_info

func print_all_players():
	var i = 1
	for player in players_info:
		print('Player ' + str(i) + ': ' + player.player_name + ', ' + str(player.id))

#endregion

#region Setup Management
func setup_game():
	for player in players_info:
		turn_order_list.append(player.id)
	set_inital_game_info.rpc(turn_order_list)
		
@rpc("authority", "call_local")
func set_inital_game_info(initial_turn_order: Array):
	# Do intial set up for players
	if !multiplayer.is_server():
		turn_order_list = initial_turn_order
	GameManager.game_setup_complete.emit()
	
#endregion
