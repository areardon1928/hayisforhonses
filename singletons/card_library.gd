extends Node

# List of all cards and their attributes
const card_definitions = {
	0: {
		'id': 0,
		'type': Card.CardType.HAYSTACK,
		'title': 'Basic Haystack',
		'description': '+1 Hay',
		'img':  "res://assets/standard_hay.jpg",
		'type_values': {
			'hay_value': 1
		}
	},
	1: {
		'id': 1,
		'type': Card.CardType.ACTION,
		'title': 'ACTION CARD',
		'description': 'This is the second card',
		'img': "res://icon.svg",
	}
}
# Used to store card info in Card format
var card_master_list: Array[Card] = []

# List of how many of each card should be put in the deck
#	- Index is the id of the card, value is the amount
const deck_composition: Array[int] = [3, 2]

func _ready():
	for key in card_definitions:
		var new_card = card_definitions[key]
		var type_vals = {}
		if new_card.has('type_values'):
			type_vals = new_card['type_values']
		card_master_list.append(Card.new(new_card['id'], new_card['type'], new_card['title'], new_card['description'], new_card['img'], type_vals))

func get_card_info_by_id(id: int) -> Card:
	if id < card_master_list.size():
		return card_master_list[id]
	else:
		return null
