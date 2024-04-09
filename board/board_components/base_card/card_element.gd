class_name CardElement
extends PanelContainer

const card_element_scene: PackedScene = preload("res://board/board_components/base_card/card_element.tscn")

const haystack_card_style: StyleBoxFlat = preload("res://board/board_components/base_card/card_styles/haystack_type_card.tres")
const action_card_style: StyleBoxFlat = preload("res://board/board_components/base_card/card_styles/action_type_card.tres")
const honse_card_style: StyleBoxFlat = preload("res://board/board_components/base_card/card_styles/honse_type_card.tres")

signal card_clicked(card_index: int)

@onready var title_label: Label = %Title
@onready var picture_texture: TextureRect = %Picture
@onready var description_label: Label = %Description

var card: Card # used to create the card
var card_index: int # used to keep track of where card is in the hand/board
var is_mouse_over: bool = false # used to check if card is clicked

static func create_card_element(base_card: Card, index: int) -> CardElement:
	var new_card_element: CardElement = card_element_scene.instantiate()
	new_card_element.card = base_card
	new_card_element.card_index = index
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

func _input(event):
	if event.is_action_pressed('ui_select') && is_mouse_over:
		card_clicked.emit(card_index)
	
func _on_mouse_entered():
	scale = Vector2(1.2, 1.2)
	z_index = 2
	is_mouse_over = true
	
func _on_mouse_exited():
	scale = Vector2(1,1)
	z_index = 0
	is_mouse_over = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
