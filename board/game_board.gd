extends Control

@onready var end_turn_button: Button = %EndTurnButton
@onready var player_hand: HBoxContainer = %PlayerHand

var local_turn_order: Array[int] = []

var test_card_1: Card = Card.new(0, Card.CardType.ACTION, 'Honse 1', 'test honse 1', 'res://icon.svg')
var test_card_2: Card = Card.new(0, Card.CardType.HAYSTACK, 'hay', 'please?', 'res://assets/og_honse.jpeg')

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.new_turn_begun.connect(on_new_turn_begun)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	$PlayerLabel.text = GameManager.get_player_info_by_id(multiplayer.get_unique_id()).player_name
	
	var card_element_1: CardElement = CardElement.create_card_element(test_card_1)
	var card_element_2: CardElement = CardElement.create_card_element(test_card_2)
	player_hand.add_child(card_element_1)
	player_hand.add_child(card_element_2)
	
	#set up board in clockwise fashion
	set_local_turn_order()
	refresh_elements()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func refresh_elements():
	%CurrentTurnLabel.text = GameManager.get_player_info_by_id(GameManager.turn_order_list[GameManager.current_turn_index]).player_name
	if (GameManager.turn_order_list[GameManager.current_turn_index]) == multiplayer.get_unique_id():
		end_turn_button.disabled = false
	else:
		end_turn_button.disabled = true

func set_local_turn_order():
	var player_turn_index = GameManager.turn_order_list.find(multiplayer.get_unique_id())
	local_turn_order.append_array(GameManager.turn_order_list.slice(player_turn_index))
	local_turn_order.append_array(GameManager.turn_order_list.slice(0, player_turn_index))
	
func on_new_turn_begun():
	print('new turn')
	refresh_elements()
		
func _on_end_turn_pressed():
	GameManager.end_turn.rpc_id(1)

func _process(delta):
	pass
