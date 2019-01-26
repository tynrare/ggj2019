extends Node
var decks = {
	"wood": [],
	"coal": [],
	"food": []
}

func _ready():
	_add_card_d("wood", [ _mr(0.5, 1, "wood"), _mr(0.5, 1, "wood") ]);
	_add_card("wood", _mr(0.7), null, _mr(0.1, 2));
	_add_card("wood", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("coal", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("coal", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("coal", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("coal", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("coal", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("coal", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("coal", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("coal", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("food", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("food", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("food", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("food", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("food", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("food", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("food", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	_add_card("food", _mr(0.7), _mr(0.1, 2), _mr(0.1, 2));
	

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