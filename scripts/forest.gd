extends Node
tool

export var density : float = 1.4
export var radius : int = 4
export var treeIndex : int = 1 setget setterIndex

onready var treeRef = preload("res://tree.tscn")

func _ready():
	makeForest();
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func setterIndex(i):
	treeIndex = i;
	makeForest();

func makeForest():
	if typeof(treeRef) == 0:
		return;
		
	for c in get_children():
		remove_child(c);
	for x in range(-count*5, count*5):
		for z in range(-count*5, count*5):
			createTree(Vector3(x*density+rand_range(-0.5, 0.5),0,z*density+rand_range(-0.5, 0.5)));

func createTree(pos : Vector3) -> void:
	var treeinst = treeRef.instance();
	treeinst.translation = pos;
	treeinst.treeIndex = treeIndex;
	add_child(treeinst);
	
	pass