extends Node
var decks = {
	"wood": [],
	"coal": [],
	"food": []
}

func _ready():
	_add_card("wood", _mr(0.7), null, _mr(0.1, 2));
	_add_card("wood", _mr(0.7), null, _mr(0.1, 2));
	_add_card("wood", _mr(0.7), null, _mr(0.1, 2));
	_add_card("wood", _mr(0.7), null, _mr(0.1, 2));
	_add_card("wood", _mr(0.7), null, _mr(0.1, 2));
	_add_card("wood", _mr(0.7), null, _mr(0.1, 2));
	_add_card("wood", _mr(0.7), null, _mr(0.1, 2));
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

func _mr(chance : float, count : int = 1) -> Dictionary:
	return {"chance": chance, "count": count}

func _add_card(region : String, wood, food, coal):
	var resources = {};
	
	if wood:
		resources.wood = wood;
	if food:
		resources.food = food;
	if coal:
		resources.coal = coal;
	
	decks[region].push_back({
			"resources":resources,
			"region": region
		});