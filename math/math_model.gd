extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#properties
var roundCost = {
	"wood": 2,
	"food": 2,
	"coal": 2
}
var defaultRegions = ["wood", "coal", "food"]
#gameState
var playing = false;
var turn = 0
var roundCounter = 0

var inventory = {
	"wood": 2,
	"food": 2,
	"coal": 2
}

var regionDecks = {
	"wood": [],
	"coal": [],
	"food": []
}
var avaibleRegions = defaultRegions.duplicate();

var hand = [];

var mapRegion = null;

func _ready():
	init();
	pass # Replace with function body.

func init():
	turn = 0;
	roundCounter = 0;

func begin_round():
	playing = true;
	turn = 0;
	roundCounter += 1;
	mapRegion = null;
	avaibleRegions = defaultRegions.duplicate();
	gen_decks();
	
func end_round():
	playing = false;
	for key in roundCost:
		inventory[key] -= roundCost[key];

func next_turn():
	turn += 1;
	
	hand = [];
	
	if mapRegion == null:
		for i in avaibleRegions:
			hand.push_back(regionDecks[i].pop_back());
	else:
		var cardsLeft = regionDecks[mapRegion].size();
		if cardsLeft == 0:
			end_round();
			return;
		var cardsToDraw = min(min(turn, decks_presets.get_deck_props(mapRegion).max_hand_size), cardsLeft);
		for i in range(cardsToDraw):
			hand.push_back(regionDecks[mapRegion].pop_front());
		
func play_card(handIndex : int):
	var playedCard = hand[handIndex];
	
	if mapRegion == null:
		mapRegion = playedCard.region
	
	for res in playedCard.resources:
		if rand_range(0, 1) <= res.chance:
			inventory[res.type] += res.count;
	
	next_turn();

func get_resource(chance : float, count : int = 1) -> Dictionary:
	return {"chance": chance, "count": count}
	
func gen_decks() -> void:
	for key in avaibleRegions:
		var d = decks_presets.get_deck_cards(key);
		while d.size():
			var i = randi()%d.size();
			regionDecks[key].push_back(d[i]);
			d.remove(i);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
