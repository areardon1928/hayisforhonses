class_name Card
extends Resource

enum CardType {ACTION, HAYSTACK}

var id: int = 0# Unique id used to reference each card
var card_type: CardType = CardType.ACTION
var card_name: String = 'Placeholder'
var display_description: String = 'Placeholder Description'
var image_path: String = "res://assets/og_honse.jpeg"

# Called when the node enters the scene tree for the first time.
func _init(id: int, type: CardType, new_name: String, desc: String, img: String):
	id = id
	card_type = type
	card_name = new_name
	display_description = desc
	image_path = img
