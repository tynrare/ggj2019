extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# надо вручную проставлять
var gameModel = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func update_scene():
	#example
	if gameModel.roundCounter == 0:
		set_text("Welcome!\n 123?:?:;% тест")
		make_dialogue_btns("first_test_di", ["Nope", "Yep", "SARKASM", "Getta out"]);

func set_location(name : String):
	get_node("back").texture = load("res://img/dialogues/locations/"+name+".jpg");

func set_character(name : String):
	get_node("character").texture = load("res://img/dialogues/characters/"+name+".png");
	
func set_text(text : String):
	get_node("textPanel/label").text = text;
	
func _dialogue_selected(frameId : String, selectId : int):
	match frameId:
		"first_test_di":
			if selectId == 3:
				get_node("..").enter_to_map();
			else:
				set_text("Folk you");
	print(frameId, selectId);
	
func make_dialogue_btns(id : String, variants : Array):
	for el in variants:
		var b = Button.new();
		get_node("buttonsContainer").add_child(b);
		b.connect("pressed", self, "_dialogue_selected",[id, variants.find(el)])
		b.text = el;