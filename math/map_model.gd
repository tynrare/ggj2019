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
	turn = 0;
	roundCounter = 0;
	pass # Replace with function body.

func begin_round():
	turn = 0;
	roundCounter += 1;
	mapRegion = null;
	avaibleRegions = defaultRegions.duplicate();
	gen_decks();
	
func end_round():
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
			begin_round();
			next_turn();
			return;
		var cardsToDraw = min(min(turn, decks_presets.decks[mapRegion].properties.max_hand_size), cardsLeft);
		for i in range(cardsToDraw):
			hand.push_back(regionDecks[mapRegion].pop_back());
		
func play_card(handIndex : int):
	var playedCard = hand[handIndex];
	
	if mapRegion == null:
		mapRegion = playedCard.region
	
	for res in playedCard.resources:
		if rand_range(0, 1) >= res.chance:
			inventory[res.type] += res.count;
	
	next_turn();

func get_resource(chance : float, count : int = 1) -> Dictionary:
	return {"chance": chance, "count": count}
	
func gen_decks() -> void:
	var decks = decks_presets.decks.cards;
	for key in avaibleRegions:
		var d = decks[key].duplicate();
		while d.size():
			var i = randi()%d.size();
			regionDecks[key].push_back(d[i]);
			d.remove(i);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
