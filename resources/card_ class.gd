class_name Card
extends Resource

enum CardType {ACTION, HAYSTACK}

var id: int = 0# Unique id used to reference each card
var card_type: CardType = CardType.ACTION
var card_name: String = 'Placeholder'
var display_description: String = 'Placeholder Description'
var image_path: String  = "res://assets/og_honse.jpeg"

# Haystack specific values
var hay_value: int

# Called when the node enters the scene tree for the first time.
func _init(id: int, type: CardType, new_name: String, desc: String, img: String, type_values: Dictionary = {}):
	id = id
	card_type = type
	card_name = new_name
	display_description = desc
	image_path = img
	if card_type == CardType.HAYSTACK:
		set_haystack_details(type_values)
		
func set_haystack_details(type_values):
	hay_value = type_values['hay_value']
