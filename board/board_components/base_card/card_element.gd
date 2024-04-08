class_name CardElement
extends PanelContainer

const card_element_scene: PackedScene = preload("res://board/board_components/base_card/card_element.tscn")

const haystack_card_style: StyleBoxFlat = preload("res://board/board_components/base_card/card_styles/haystack_type_card.tres")
const action_card_style: StyleBoxFlat = preload("res://board/board_components/base_card/card_styles/action_type_card.tres")
const honse_card_style: StyleBoxFlat = preload("res://board/board_components/base_card/card_styles/honse_type_card.tres")

@onready var title_label: Label = %Title
@onready var picture_texture: TextureRect = %Picture
@onready var description_label: Label = %Description

var card: Card # used to create the card

static func create_card_element(base_card: Card) -> CardElement:
	var new_card_element: CardElement = card_element_scene.instantiate()
	new_card_element.card = base_card
	return new_card_element

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	title_label.text = card.card_name
	picture_texture.texture = load(card.image_path)
	description_label.text = card.display_description
	if (card.card_type == card.CardType.ACTION):
		add_theme_stylebox_override('panel', action_card_style)
	elif (card.card_type == card.CardType.HAYSTACK):
		add_theme_stylebox_override('panel', haystack_card_style)
	else:
		add_theme_stylebox_override('panel', honse_card_style)
	
	
func _on_mouse_entered():
	scale = Vector2(1.2, 1.2)
	z_index = 2
	
func _on_mouse_exited():
	scale = Vector2(1,1)
	z_index = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
