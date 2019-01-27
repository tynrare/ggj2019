extends Node
var decks = {
	"wood": [],
	"coal": [],
	"food": []
}

func _ready():
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

func _mr(chance : float, count : int = 1, type : String = "") -> Dictionary:
	return {"chance": chance, "count": count, "type": type}

func _add_card_d(region : String, list : Array):
	decks[region].push_back({
		"resources":list,
		"region": region
	});

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
	
	decks[region].push_back({
			"resources":resources,
			"region": region
		});