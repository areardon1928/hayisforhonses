class_name DeckManager
extends Node

var deck: Array[int] = [] #An array of card ids which represents the current deck 

# Called when the node enters the scene tree for the first time.
func _ready():
	build_deck()
	
func build_deck():
	for i in range(0, CardLibrary.deck_composition.size()):
		for j in range(0, CardLibrary.deck_composition[i]):
			deck.append(i) 
	deck.shuffle()
	print('DECK')
	print(deck)

# In the furture probably want this pull from a discard pile or something but for now I'll just 
# 	have it reset the whole deck	
func reshuffle_deck():
	deck.clear()
	build_deck()
	
func get_next_card() -> Card:
	var next_card: Card = CardLibrary.get_card_info_by_id(deck.pop_front())
	if deck.is_empty():
		reshuffle_deck()
	return next_card
