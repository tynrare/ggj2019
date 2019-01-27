extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal chain_finished

# надо вручную проставлять
var gameModel = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func update_scene():
	#example
	if gameModel.roundCounter == 0:
		set_location('BG_basement_rendered')
		set_character("deer_poses_norm_line_flats")
		toggle_character_visible()
		make_monologue_chain("id_sooqa", ["You were on your way downstairs when a knife flew right in front of your face."])

func set_location(name : String):
	get_node("back").texture = load("res://img/dialogues/locations/"+name+".jpg");

func toggle_character_visible():
	get_node("character").visible = !get_node("character").visible;

func set_character(name : String):
	get_node("character").texture = load("res://img/dialogues/characters/"+name+".png");
	
func set_text(text : String):
	var l = get_node("textPanel/label");
	l.text = text;
	if text[0] == '-':
		l.add_color_override("font_color", Color(1, 1, 0))
	else:
		l.add_color_override("font_color", Color(1, 1, 1))
	
func _dialogue_selected(frameId : String, selectId : int):
	match frameId:
		"first_test_di":
			
			#exit from chain
			if selectId == -1:
				make_dialogue_btns("first_test_di", ["Wait..you have a body?", "What the …??!!??", "That was REALLY, REALLY close"]);
				return
			
			var chain = [];
			if selectId == 0:
				chain.push_back("- Oh, you have no idea, human, you have no idea…")
				chain.push_back("The Host Grinned.")
				chain.push_back("- Though you have a pretty good visual impression of that.")
				
			elif selectId == 1:
				set_character("deer_poses_oh_flats")
				chain.push_back("The Host rolled his eyes")
				chain.push_back("- Again? Does everything new you see make you stoned like a gargoyle?")
				chain.push_back("- It might be a problem in our so-called partnership.")
			elif selectId == 2:
				set_character("deer_poses_baka_flats")
				chain.push_back("- Watch there, you are walking on some thin ice here, human.")
				chain.push_back("He sat back on the chair, staring at the mark he has just made by his knife. ")
			
			make_monologue_chain("next1", chain);
			yield(self, "chain_finished");
			set_character("deer_poses_norm_line_flats")
			make_monologue_chain("next2", ["He sat back on the chair, staring at the mark he has just made by his knife.", "- Wild is a dangerous place, you know, human. It can feed you or feast you, upgrade you or gather you…","You managed to notice a microscopic eye-twich on his face.", "Host turned his eyes down for a moment." ]);
			yield(self, "chain_finished");
			set_character("deer_poses_arm_flats")
			make_monologue_chain("next3", ["- Speaking of places.", "- How did you end up here?"]);
		"id_sooqa":
			make_monologue_chain("first_test_di", ["- Easy there, human. I don’t want to clean them all from blood again...", "The Host made 3 big steps towards the dagger and pulled it out of the wall, then turned to your surprised face.", "- What?"]);
			toggle_character_visible()
		"next3":
			if selectId == -1:
				make_dialogue_btns("next3", ["I was on my way to settle my home in the town when the blizzard caught me.", "I was on my way away from my village where I could not feel myself at home anymore..."]);
				return
			var longchain=[]
			
			if (selectId == 0) or (selectId == 1):
				set_character("deer_poses_thinking_flats")
				longchain.push_back("- Home? Heh...yeah.")
				longchain.push_back("- Same applies to home, I guess.")
				longchain.push_back("*sigh*")
				
			make_monologue_chain("next4", longchain)
			yield(self, "chain_finished")
			set_character("deer_poses_norm_line_flats")
			make_monologue_chain("next5",["- But enough of this.", "He stood up, hiding knives behind his back.", "- I was just about to call for you. You see, there were some unpleasant encounters while you were asleep.", "- There is no danger now, but one of my knives is out there and I am not able to go there myself, and it would not be safe for such uncommon thing to just lie around for anyone to possibly get it.", "- Primitively speaking, I need you to go and get it for me.", "You’ll do it, right?", "You nodded without hesitation, even though that “no danger now” part did not boost any of your confidence.", "- Great, now listen here.", "- Go west from here. You will reach a small creek. Jump over it and walk about 350 meters, then turn right. The dagger is shiny, you’ll definitely notice it.", "- All clear?", "You nodded again.", "- Well go on then, hurry up."])
				
				
			
	print(frameId, selectId);

var _monologue_chain_data = [];

func make_monologue_chain(frameId : String, text : Array):
	_monologue_chain_data = text;
	_monologue_chain_next(frameId);
	
func _monologue_chain_next(frameId):
	_remove_all_btns();
	if !_monologue_chain_data.size():
		_dialogue_selected(frameId, -1);
		emit_signal("chain_finished")
		return;
		
	set_text(_monologue_chain_data.pop_front());
	
	var b = Button.new();
	get_node("buttonsContainer").add_child(b);
	b.connect("pressed", self, "_monologue_chain_next",[frameId])
	b.text = "next";

func _remove_all_btns():
	var b = get_node("buttonsContainer");
	for c in b.get_children():
		b.remove_child(c)
	b.margin_left = 0;
	

func make_dialogue_btns(id : String, variants : Array):
	_remove_all_btns();
		
	for el in variants:
		var b = Button.new();
		get_node("buttonsContainer").add_child(b);
		b.connect("pressed", self, "_dialogue_selected",[id, variants.find(el)])
		b.text = el;