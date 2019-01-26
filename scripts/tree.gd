extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var treeIndex : int = 1 setget setter_index

func _ready():
	var t = get_node("texture");
	t.flip_h = randi()%2 < 1;
	t.set_texture(load("res://img/forest/tree-white-"+String(treeIndex)+".png"));
	pass # Replace with function body.

func set_snow_level(val : float):
	get_node("green").opacity = val;

func setter_index(i):
	treeIndex = i;
	var t = get_node("texture");
	t.set_texture(load("res://img/forest/tree-white-"+String(treeIndex)+".png"));
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
