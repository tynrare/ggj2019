extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var questItem1 = false;
var questItem2 = false;
var questItem3 = false;

signal chain_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func update_scene():
	#example
	if math_model.roundCounter == 1:
	#	toggle_character_visible()
		set_character("deer_flats")
		set_location('BG_attic_rendered')
		make_monologue_chain("id_sooqa2", [ "A house comes out of nowhere.", "Praying for the best, you put the key into the keyhole and spin in several times before opening the antique door and rushing in.", "Any other day you probably would have taken your sweet time looking around the house you have just entered, but right now you find yourself very focused.", "Your attention is occupied by a fireplace.", "You feel like you have no control over your body, as it takes you straightnas it takes you straight to the pile of woods and starts the fire."])
		
	if math_model.roundCounter == 2:
		toggle_character_visible()
		set_character("deer_poses_norm_line_flats")
		set_location('basement')
		make_monologue_chain("id2", ["You are getting used to waking up without snow on your nose. This time though, you have a strange feeling.",  "After a brief look around, you realize that the Deer’s head is missing.", "You freeze for a moment and try to listen closely only to catch some strange sounds from the basement.", "Struggling to find another option, you rush towards the source of the sound."])
		yield(self, "chain_finished")
		set_location('BG_basement_rendered')
		make_monologue_chain("id_sooqa", ["You are on your way downstairs when a knife flows right in front of your face."])

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
				chain.push_back("The Host grinned.")
				chain.push_back("- Though you have a pretty good visual impression of that.")
				
			elif selectId == 1:
				set_character("deer_poses_oh_flats")
				chain.push_back("The Host rolled his eyes")
				chain.push_back("- Again? Does everything new you see make you stoned like a gargoyle?")
				chain.push_back("- It might be a problem for our so-called partnership.")
			elif selectId == 2:
				set_character("deer_poses_baka_flats")
				chain.push_back("- Watch it, human, you are walking on a thin ice here.")
				chain.push_back("He sits back on the chair, staring at the mark he has just made by his knife. ")
			
			make_monologue_chain("next1", chain);
			yield(self, "chain_finished");
			set_character("deer_poses_norm_line_flats")
			make_monologue_chain("next2", ["He sat back on the chair, staring at the mark he has just made by his knife.", "- Wild is a dangerous place, you know, human. It can feed you or feast you, upgrade you or gather you…","You managed to notice a microscopic eye-twich on his face.", "Host turned his eyes down for a moment." ]);
			yield(self, "chain_finished");
			set_character("deer_poses_arm_flats")
			make_monologue_chain("next3", ["- Speaking of places.", "- How did you end up here?"]);
		"id_sooqa":
			make_monologue_chain("first_test_di", ["- Easy there, human. I don’t want to clean them all from blood again...", "The Host makes 3 big steps towards the dagger and pulls it out of the wall, then turns to your surprised face.", "- What?"]);
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
			yield(self, "chain_finished")
			get_node("..").enter_to_map()
				
			
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