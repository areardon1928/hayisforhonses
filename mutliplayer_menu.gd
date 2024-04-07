extends Control

@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton
@onready var player_name_input: LineEdit = %NameEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	host_button.button_down.connect(_on_host_button_down)
	join_button.button_down.connect(_on_join_button_down)
	
	GameManager.initial_connect_succeeded.connect(_on_connection_succeeded)


func _on_host_button_down():
	UiManager.host_game_pressed.emit(player_name_input.text)
	self.hide()
	pass
	
func _on_join_button_down():
	UiManager.player_join_pressed.emit(player_name_input.text)
	pass
	
func _on_connection_succeeded():
	self.hide()
