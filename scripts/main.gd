extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	enter_to_map();
	pass # Replace with function body.

func enter_to_map():
	get_node("dialogue_screen").visible = false;
	math_model.begin_round();
	diversificate_math_model();
	math_model.next_turn();
	get_node("map").visible = true;
	get_node("map").update_scene();
	
func enter_to_home():
	get_node("dialogue_screen").visible = true;
	get_node("dialogue_screen").update_scene();
	get_node("map").visible = false;
	get_node("map/ui").visible = false;

func diversificate_math_model():
	#start quest
	if math_model.roundCounter == 1:
		math_model.mapRegion = 'tutorial';
		math_model.regionDecks.tutorial = decks_presets.get_deck_cards("tutorial");
	elif math_model.roundCounter == 2:
		get_node("map/ui/buttons/go_home_btn").visible = true;