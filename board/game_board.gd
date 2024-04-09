extends Control

@onready var end_turn_button: Button = %EndTurnButton
@onready var player_hand: HBoxContainer = %PlayerHand
@onready var player_haystack: HBoxContainer = %PlayerHaystack
@onready var player_hay_progress_bar: TextureProgressBar = %PlayerHayProgressBar
@onready var player_hay_count_label: Label = %PlayerHayCountLabel

var local_turn_order: Array[int] = []

# TODO: This board has the potential to get really big...probably worth splitting into 
#	smaller scenes later

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.new_turn_begun.connect(on_new_turn_begun)
	GameManager.card_dealt.connect(_on_card_dealt)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	$PlayerLabel.text = GameManager.get_player_info_by_id(multiplayer.get_unique_id()).player_name
	
	#set up board in clockwise fashion
	set_local_turn_order()
	# Load Initial cards
	load_initial_hand()
	refresh_elements()

func refresh_elements():
	%CurrentTurnLabel.text = GameManager.get_player_info_by_id(GameManager.get_current_turn_player_id()).player_name
	player_hay_count_label.text = str(GameManager.current_player_hay_value)
	player_hay_progress_bar.value = GameManager.current_player_hay_value
	if (GameManager.turn_order_list[GameManager.current_turn_index]) == multiplayer.get_unique_id():
		end_turn_button.disabled = false
	else:
		end_turn_button.disabled = true

func set_local_turn_order():
	var player_turn_index = GameManager.turn_order_list.find(multiplayer.get_unique_id())
	local_turn_order.append_array(GameManager.turn_order_list.slice(player_turn_index))
	local_turn_order.append_array(GameManager.turn_order_list.slice(0, player_turn_index))

func load_initial_hand():
	var i = 0
	for card in GameManager.current_player_hand:
		var card_element = CardElement.create_card_element(card, i)
		card_element.card_clicked.connect(_on_hand_card_clicked)
		player_hand.add_child(card_element)
		i += 1
	
func on_new_turn_begun():
	refresh_elements()
	
func _on_hand_card_clicked(card_index: int):
	# Check if its players turn
	if GameManager.get_current_turn_player_id() == multiplayer.get_unique_id():
		print('PLAYER CLICKED CARD')
		print(card_index)
	else: 
		print('not your turn')

func _on_card_dealt(new_card: Card, hand_index: int):
	var card_element = CardElement.create_card_element(new_card, hand_index)
	card_element.card_clicked.connect(_on_hand_card_clicked)
	player_hand.add_child(card_element)
		
func _on_end_turn_pressed():
	GameManager.end_turn.rpc_id(1)

func _process(delta):
	pass
