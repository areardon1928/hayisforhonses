class_name LobbyScene
extends Control

@onready var ready_button: Button = %ReadyButton
@onready var start_button: Button = %StartButton
@onready var ready_warning_label: Label = %ReadyWarningLabel
@onready var loading_screen: PanelContainer = %LoadingScreen

var player_label_list: Array[Label] = []
var player_ready_button_list: Array[CheckBox] = []

var is_readied = false
var ready_players: Array = []

signal game_start_intiated()

# Called when the node enters the scene tree for the first time.
func _ready():
	#update players each time one is added
	GameManager.player_joined.connect(update_player_names)
	GameManager.game_scene_loaded.connect(_on_game_scene_loaded)
	ready_button.pressed.connect(_on_ready_pressed)
	start_button.pressed.connect(_on_start_pressed)
	# add player list to array
	player_label_list.append(%Player1Label)
	player_label_list.append(%Player2Label)
	player_label_list.append(%Player3Label)
	player_label_list.append(%Player4Label)
	player_label_list.append(%Player5Label)
	player_label_list.append(%Player6Label)
	# add player ready buttons to array
	player_ready_button_list.append(%Player1ReadyBox)
	player_ready_button_list.append(%Player2ReadyBox)
	player_ready_button_list.append(%Player3ReadyBox)
	player_ready_button_list.append(%Player4ReadyBox)
	player_ready_button_list.append(%Player5ReadyBox)
	player_ready_button_list.append(%Player6ReadyBox)
	ready_warning_label.modulate = Color.TRANSPARENT
	
	# get ready players if you aren't the server
	if !multiplayer.is_server():
		get_ready_players.rpc_id(1, multiplayer.get_unique_id())
	update_player_names()

func update_player_names():
	var player_info_list: Array[PlayerInfo] = GameManager.get_all_players_info()
	for i in range(0, player_info_list.size()):
		player_label_list[i].text = player_info_list[i].player_name
		if player_info_list[i].id in ready_players:
			player_ready_button_list[i].button_pressed = true
		else:
			player_ready_button_list[i].button_pressed = false
		

func _on_ready_pressed():
	if !is_readied:
		add_ready_player.rpc_id(1, multiplayer.get_unique_id())
		is_readied = true
		ready_button.text = 'Unready'
	elif is_readied:
		remove_ready_player.rpc_id(1, multiplayer.get_unique_id())
		is_readied = false
		ready_button.text = 'Ready'
	update_player_names()
	
# call server and tell it to initiate the game
func _on_start_pressed():
	initiate_game_start.rpc_id(1)

@rpc('any_peer', 'call_local')
func add_ready_player(player_id: int):
	if (player_id not in ready_players):
		ready_players.append(player_id)
	
	#update everyone
	if multiplayer.is_server():
		set_ready_players.rpc(ready_players)
	
	update_player_names()
	
@rpc('any_peer', 'call_local')
func remove_ready_player(player_id: int):
	ready_players.erase(player_id)
	
	if multiplayer.is_server():
		set_ready_players.rpc(ready_players)
	
	update_player_names()
	
@rpc('any_peer', 'call_remote')
func get_ready_players(requester_id: int):
	if multiplayer.is_server():
		set_ready_players.rpc_id(requester_id, ready_players)

@rpc('any_peer', 'call_remote')
func set_ready_players(new_ready_players):
	ready_players = new_ready_players.duplicate()
	update_player_names()
	
@rpc('any_peer', 'call_local')
func initiate_game_start():
	#get peers and add server value
	var connected_peers = multiplayer.get_peers()
	connected_peers.append(1)
	if (Utils.arrays_have_same_content(connected_peers, ready_players)):
		game_start_intiated.emit()
		show_loading_screen.rpc()
	else:
		display_unready_warning.rpc_id(multiplayer.get_remote_sender_id())
		
@rpc('authority', 'call_local')
func show_loading_screen():
		loading_screen.visible = true
		
@rpc('any_peer', 'call_local')
func display_unready_warning():
	ready_warning_label.modulate = Color.WHITE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_game_scene_loaded():
	self.queue_free()
