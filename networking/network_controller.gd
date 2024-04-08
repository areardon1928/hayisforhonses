extends Node

@export var HOST_ADDRESS = '192.168.0.38'
@export var PORT = 8910

var peer: ENetMultiplayerPeer 
var temp_player_name: String = 'honse' #used to store temp player name

# Called when the node enters the scene tree for the first time.
func _ready():
	#ui signals
	UiManager.host_game_pressed.connect(host_game)
	UiManager.player_join_pressed.connect(player_join)
	
	# Game manager signals
	GameManager.game_setup_complete.connect(start_game)
	
	#multiplayer signals
	multiplayer.peer_connected.connect(on_player_connected)
	multiplayer.peer_disconnected.connect(on_player_disconnected)
	multiplayer.connected_to_server.connect(on_connected_to_server)
	multiplayer.connection_failed.connect(on_connection_failed)


# called on server and client
func on_player_connected(id):
	print('Player connected ' + str(id))
	
# calle don server and client
func on_player_disconnected(id):
	print('Player disconnected ' + str(id))

# just called on client
func on_connected_to_server():
	send_player_info.rpc_id(1, temp_player_name, multiplayer.get_unique_id()) # calls this function on the server only
	print('connected to server')
	GameManager.initial_connect_succeeded.emit()
	send_to_lobby()
	
# just called on client
func on_connection_failed():
	print('Couldn\'t connect')


@rpc('any_peer')
func send_player_info(player_name: String, id: int):
	if !GameManager.check_for_id(id):
		GameManager.add_player_info(player_name, id)
	
	# if the player is the server, call it to everyone else so they're up to date
	if multiplayer.is_server():
		for player in GameManager.players_info:
			send_player_info.rpc(player.player_name, player.id)
	
#@rpc('any_peer', 'call_local')
func start_game():
	var scene = load("res://board/game_board.tscn").instantiate()
	get_tree().root.add_child(scene)
	
	GameManager.game_scene_loaded.emit()
	#self.hide()

func player_join(player_name: String):
	peer = ENetMultiplayerPeer.new()
	#point to port
	var error = peer.create_client(HOST_ADDRESS, PORT)
	if error != OK:
		print('cannot join' + str(error))
	temp_player_name = player_name
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) # compression needs to be the same for client and server
	multiplayer.set_multiplayer_peer(peer)
	

func host_game(player_name: String):
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, 6)
	if error != OK:
		print('cannot host' + str(error))
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	# sets server as peer/host 
	multiplayer.set_multiplayer_peer(peer)
	send_player_info(player_name, multiplayer.get_unique_id()) # TODO: May need to remove if host is not playing
	print("Waiting for players...")
	send_to_lobby()

# do intial set up for game
func _on_game_start_initiated():
	GameManager.setup_game() 

func send_to_lobby():
	var lobby_scene: LobbyScene = load("res://screens/lobby_screen/lobby.tscn").instantiate()
	lobby_scene.game_start_intiated.connect(_on_game_start_initiated)
	get_tree().root.add_child(lobby_scene)
