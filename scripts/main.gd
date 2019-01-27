extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	enter_to_map();
	math_model.connect("card_played", self, "_card_played");
	math_model.connect("round_ended", self, "_round_ended");
	pass # Replace with function body.

func enter_to_map():
	get_node("dialogue_screen").visible = false;
	math_model.begin_round();
	diversificate_math_model();
	math_model.next_turn();
	get_node("map").visible = true;
	get_node("map/ui").visible = true;
	get_node("map").update_scene();
	
func enter_to_home():
	get_node("dialogue_screen").visible = true;
	get_node("dialogue_screen").update_scene();
	get_node("map").visible = false;
	get_node("map/ui").visible = false;

var quest1starter = false;
var quest1result = true;
func _card_played(card):
	match card.region:
		"quest1":
			quest1starter = true
			if card.id != "true": 
				quest1result = false;
		_:
			quest1starter = false
			quest1result = false;


func _round_ended():
	if(math_model.mapRegion == 'quest1'):
		get_node("dialogue_screen").questItem1 = quest1result;
		get_node("dialogue_screen").questProgress1 = quest1starter;

func diversificate_math_model():
	#start quest
	if math_model.roundCounter == 1:
		math_model.mapRegion = 'tutorial';
		math_model.regionDecks.tutorial = decks_presets.get_deck_cards("tutorial");
	elif math_model.roundCounter == 2:
		
		math_model.inventory.wood = 2;
		math_model.inventory.food = 2;
		math_model.inventory.coal = 2;
		
		get_node("map/ui/buttons/go_home_btn").visible = true;
	elif math_model.roundCounter > 2:
		quest1result = true;
		if get_node("dialogue_screen").questItem1 == false:  math_model.add_deck("quest1");