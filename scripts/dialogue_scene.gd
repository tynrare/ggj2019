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
		make_monologue_chain("first_test_di", ["Welcome!", "1", "2", "3", "what next?"]);

func set_location(name : String):
	get_node("back").texture = load("res://img/dialogues/locations/"+name+".jpg");

func toggle_character_visible():
	get_node("character").visible = !get_node("character").visible;

func set_character(name : String):
	get_node("character").texture = load("res://img/dialogues/characters/"+name+".png");
	
func set_text(text : String):
	get_node("textPanel/label").text = text;
	
func _dialogue_selected(frameId : String, selectId : int):
	match frameId:
		"first_test_di":
			#exit from chain
			if selectId == -1:
				make_dialogue_btns("first_test_di", ["Nope", "Yep", "SARKASM", "Getta out"]);
			#selected exit 
			elif selectId == 3:
				get_node("..").enter_to_map();
			#other
			else:
				set_text("Folk you");
	print(frameId, selectId);

var _monologue_chain_data = [];

func make_monologue_chain(frameId : String, text : Array):
	_monologue_chain_data = text;
	_monologue_chain_next(frameId);
	
func _monologue_chain_next(frameId):
	_remove_all_btns();
	if !_monologue_chain_data.size():
		_dialogue_selected(frameId, -1);
		return;
		
	set_text(_monologue_chain_data.pop_front());
	
	var b = Button.new();
	get_node("buttonsContainer").add_child(b);
	b.connect("pressed", self, "_monologue_chain_next",[frameId])
	b.text = "next";

func _remove_all_btns():
	for c in get_node("buttonsContainer").get_children():
    	c.queue_free()

func make_dialogue_btns(id : String, variants : Array):
	_remove_all_btns();
		
	for el in variants:
		var b = Button.new();
		get_node("buttonsContainer").add_child(b);
		b.connect("pressed", self, "_dialogue_selected",[id, variants.find(el)])
		b.text = el;