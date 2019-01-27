extends Node

func get_deck_cards(key : String):
	return _decks[key].cards.duplicate();
	
func get_deck_props(key : String):
	return _decks[key].props.duplicate();

var _decks = {
	"wood": {
		"cards": [],
		"props":{
			"max_hand_size": 5,
		}
	},
	"coal": {
		"cards": [],
		"props":{
			"max_hand_size": 5,
		}
	},
	"food": {
		"cards": [],
		"props":{
			"max_hand_size": 5,
		}
	},
	"tutorial":{
		"cards": [],
		"props":{
			"max_hand_size": 1,
		}
	},
	"quest1":{
		"cards": [],
		"props":{
			"max_hand_size": 3,
			"straight_order":true
		}
	}
}

func _ready():
	#
	# Usual
	#
	_add_card_d("wood", [ _mr(1, 1, "wood"), _mr(0.5, 1, "wood") ]);
	_add_card("wood", _mr(1), _mr(0.5), null);
	_add_card("wood", _mr(1), _mr(0.6), null);
	_add_card("wood", _mr(1), _mr(0.7), null);
	_add_card("wood", _mr(1), _mr(0.8), null);
	_add_card("wood", _mr(1), _mr(0.9), null);
	_add_card("wood", _mr(1), _mr(1), null);
	_add_card("wood", _mr(1), null, _mr(0.5));
	_add_card("wood", _mr(1), null, _mr(0.6));
	_add_card("wood", _mr(1), null, _mr(0.7));
	_add_card("wood", _mr(1), null, _mr(0.8));
	_add_card("wood", _mr(1), null, _mr(0.9));
	_add_card("wood", _mr(1), null, _mr(1));
	_add_card("wood", _mr(1), _mr(0.5), _mr(0.5));
	_add_card("wood", _mr(1), _mr(0.3), _mr(0.3));
	_add_card_d("coal", [ _mr(1, 1, "coal"), _mr(0.5, 1, "coal") ]);
	_add_card("coal", _mr(0.5), null, _mr(1));
	_add_card("coal", _mr(0.6), null, _mr(1));
	_add_card("coal", _mr(0.7), null, _mr(1));
	_add_card("coal", _mr(0.8), null, _mr(1));
	_add_card("coal", _mr(0.9), null, _mr(1));
	_add_card("coal", _mr(1), null, _mr(1));
	_add_card("coal", null, _mr(0.5), _mr(1));
	_add_card("coal", null, _mr(0.6), _mr(1));
	_add_card("coal", null, _mr(0.7), _mr(1));
	_add_card("coal", null, _mr(0.8), _mr(1));
	_add_card("coal", null, _mr(0.9), _mr(1));
	_add_card("coal", null, _mr(1), _mr(1));
	_add_card("coal", _mr(0,5), _mr(0.5), _mr(1));
	_add_card("coal", _mr(0,3), _mr(0.3), _mr(1));
	_add_card_d("food", [ _mr(1, 1, "food"), _mr(0.5, 1, "food") ]);
	_add_card("food", null, _mr(1), _mr(0.5));
	_add_card("food", null, _mr(1), _mr(0.6));
	_add_card("food", null, _mr(1), _mr(0.7));
	_add_card("food", null, _mr(1), _mr(0.8));
	_add_card("food", null, _mr(1), _mr(0.9));
	_add_card("food", null, _mr(1), _mr(1));
	_add_card("food", _mr(0.5), _mr(1), null);
	_add_card("food", _mr(0.6), _mr(1), null);
	_add_card("food", _mr(0.7), _mr(1), null);
	_add_card("food", _mr(0.8), _mr(1), null);
	_add_card("food", _mr(0.9), _mr(1), null);
	_add_card("food", _mr(1), _mr(1), null);
	_add_card("food", _mr(0,5), _mr(0.5), _mr(1));
	_add_card("food", _mr(0,3), _mr(0.3), _mr(1));
	
	#
	# Quests
	#
	_add_card_story("tutorial", "It seems you are lost. You have no idea where are you heading.");
	_add_card_story("tutorial", "Your can't feel any fingers on your body, you have to find a shelter.");
	_add_card_story("tutorial", "Wait, what's that light?");
	
	_add_card_story("quest1", "You move further in the forest", "Go forward", "true");
	_add_card_story("quest1", "You decided to go closer the creek", "Come closer to the creek", "true" );
	_add_card_story("quest1", "You decide not to take any risks", "Stay a little further", "true");
	_add_card_story("quest1", "You make a gigantic leap over. Could have just stepped over, by the way. ", "Jump over the creek", "true");
	_add_card_story("quest1", "You decided to go down the creek", "Follow the creek's course", "false");
	_add_card_story("quest1", "You have just crossed the creek", "Step over the creek", "true");
	_add_card_story("quest1", "Great. Next action?", "Walk for 350 meters", "true");
	_add_card_story("quest1", "Great. Next action?", "Walk for 300 meters", "false");
	_add_card_story("quest1", "Great. Next action?", "Walk for 450 meters", "false");
	_add_card_story("quest1", "Have you found anything?", "Turn left", "false");
	_add_card_story("quest1", "Have you found anything?", "Turn right", "true");
	_add_card_story("quest1", "Have you found anything?", "Go forward", "false" );

func _mr(chance : float, count : int = 1, type : String = "") -> Dictionary:
	return {"chance": chance, "count": count, "type": type}

func _add_card_d(region : String, list : Array):
	_decks[region].cards.push_back({
		"resources":list,
		"region": region
	});

func _add_card_story(region : String, text : String, description : String = "", id : String = "", resources : Array = []):
	var c = {
		"resources":resources,
		"story": text,
		"region": region,
		"id": id
	};
	if description.length() > 0:
		c.description = description;
		
	_decks[region].cards.push_back(c);

#old style func
func _add_card(region : String, wood, food, coal):
	var resources = [];

	if wood:
		wood.type = "wood"
		resources.push_back(wood);
	if food:
		food.type = "food"
		resources.push_back(food);
	if coal:
		coal.type = "coal"
		resources.push_back(coal);

	_decks[region].cards.push_back({
			"resources":resources,
			"region": region
		});
