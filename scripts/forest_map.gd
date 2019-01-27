extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var point_ref = preload("res://scene/map_activity_point.tscn")
var cam_target : Vector3 = Vector3(0,0,0)
var cam_target_angle : float = -30;
var cam_target_fow : int = 50;

var character_target : Vector3 = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_scene():
	_discard_camera_targets();
	get_node("ui/label").visible = false;
	get_node("character").translation = Vector3(0,0,0);
	update();
	
	#special cases
	if math_model.mapRegion != null:
		match math_model.mapRegion:
			"tutorial":
				get_node("character").translation = get_node("nav_points").get_children()[0].translation
	
func update():
	_clear_navpoints();
	gen_navpoints();
	update_inventory_text();
	get_node("ui/buttons/select_btn").visible = false;

func gen_navpoints():
	for c in math_model.hand:
		var p = point_ref.instance();
		get_node("nav_points").add_child(p);
		
		var pos = get_base_translation(c);
		p.translation = Vector3(pos.y*10+rand_range(-5,5), 0, pos.x*10+rand_range(-2,2));
		p.connect("clicked", self, "_navpoint_clicked",[p, math_model.hand.find(c)])
		p.connect("selected", self, "_navpoint_selected",[p, math_model.hand.find(c)])
		
	if get_node("nav_points").get_children().size():
		var closest = 9999999;
		for c in get_node("nav_points").get_children():
			var x = c.translation.x
			if x < closest:
				closest = x;
		cam_target.x = closest + 10

func get_base_translation(card) -> Vector2:
	if math_model.mapRegion == null:
		match card.region:
			"wood":
				return Vector2(0, math_model.turn);
			"coal":
				return Vector2(-1, math_model.turn);
			"food":
				return Vector2(1, math_model.turn);
			_:
				return Vector2(0, math_model.turn);
	else:
		match math_model.mapRegion:
			"tutorial":
				var total = decks_presets.get_deck_cards("tutorial").size();
				return Vector2(rand_range(-1, 1), total-math_model.turn+1);
			_:
				var index = math_model.hand.find(card)
				var total = float(math_model.hand.size())
				return Vector2((-total/2 + index), math_model.turn+rand_range(-2, 2) + 2);
	

func set_ui_text(text : String):
	var l = get_node("ui/label")
	l.visible = true;
	l.text = text;

func update_inventory_text():
	var m = math_model
	var l = get_node("ui/inventory")
	var text = "";
	for key in m.inventory:
		text += "> " + key + ": x" + String(m.inventory[key]) + " <\n";
	
	text.erase(text.length() - 2, 2);
	l.text = text;

var selected_point = null
var selected_card_id = null

func _on_select_btn_pressed():
	if selected_point == null || selected_card_id == null:
		return
	
	_navpoint_selected(selected_point, selected_card_id);
	
	pass # Replace with function body.
	
func _navpoint_clicked(point, card_id):
	cam_target.z = point.translation.z;
	selected_point = point;
	selected_card_id = card_id;
	
	if !math_model.playing:
		_discard_camera_targets();
		return;
		
	get_node("ui/buttons/select_btn").visible = true;
	
	var card = math_model.hand[card_id];
	if card.has("description") || card.resources.size() > 0:
		var text = "";
		
		if card.resources.size() > 0:
			text += "Region: " + card.region;
			for res in card.resources:
				if res.chance > 0:
					text += "\n >> " + res.type + ": " + String(res.chance*100) + "% x" + String(res.count);
		if card.has("description"):
			text += card.description;
		
		set_ui_text(text);
	
func _navpoint_selected(point, card_id):
	#История это то что мы узнаем о разыгранной карточке
	var card = math_model.hand[card_id];
	selected_point = null;
	selected_card_id = null;
	character_target = point.translation
	
	_clear_navpoints();
	
	if card.has("story"):
		set_ui_text(card.story);
		cam_target_angle = -40;
		cam_target_fow = 30;
		yield(get_tree().create_timer(2), "timeout")
	else:
		get_node("ui/label").visible = false;
	
	yield(get_tree().create_timer(2), "timeout")
	
	_discard_camera_targets();
	
	math_model.play_card(card_id)
	update();
	
	if !math_model.playing:
		yield(get_tree().create_timer(2), "timeout")
		get_node("..").enter_to_home();

func _clear_navpoints():
	var b = get_node("nav_points");
	for c in b.get_children():
		c.hide_animation();

func _move_node_to(node, target, width):
	var t = node.translation
	node.translation = Vector3(lerp(t.x, target.x, width), lerp(t.y, target.y, width), lerp(t.z, target.z, width))

func _process(delta):
	var cam = get_node("WorldEnvironment/cam_pivot/Camera");
	_move_node_to(cam, cam_target, 0.05);
	_move_node_to(get_node("character"), character_target, 0.01);
	
	cam.rotation_degrees.x = lerp(cam.rotation_degrees.x, cam_target_angle, 0.05);
	cam.fov = lerp(cam.fov, cam_target_fow, 0.03);
	
func _discard_camera_targets():
	cam_target = Vector3(0,0,0);
	cam_target_angle = -30;
	cam_target_fow = 50;
