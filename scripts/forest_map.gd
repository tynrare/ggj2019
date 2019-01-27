extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var point_ref = preload("res://scene/map_activity_point.tscn")
var cam_target : Vector3 = Vector3(0,0,0)
var cam_target_angle : float = -30;
var cam_target_fow : int = 50;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_scene():
	_discard_camera_targets();
	get_node("ui/label").visible = false;
	update();
	
func update():
	_clear_navpoints();
	gen_navpoints();
	get_node("ui/buttons/select_btn").visible = false;

func gen_navpoints():
	for c in math_model.hand:
		var p = point_ref.instance();
		get_node("nav_points").add_child(p);
		
		var pos = get_base_translation(c);
		p.translation = Vector3(pos.y*10+rand_range(-1,1), 0, pos.x*10+rand_range(-1,1));
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
	match card.region:
		"wood":
			return Vector2(2, math_model.turn);
		"coal":
			return Vector2(-2, math_model.turn);
		"food":
			return Vector2(2, math_model.turn);
		"tutorial":
			var total = decks_presets.get_deck_cards("tutorial").size();
			return Vector2(rand_range(-1, 1), total-math_model.turn+1);
		_:
			return Vector2(0, math_model.turn);

func set_ui_text(text : String):
	var l = get_node("ui/label")
	l.visible = true;
	l.text = text;

func _navpoint_clicked(point, card_id):
	cam_target.z = point.translation.z;
	
	if !math_model.playing:
		_discard_camera_targets();
		return;
		
	get_node("ui/buttons/select_btn").visible = true;
	get_node("ui/buttons/select_btn").connect("pressed", self, "_navpoint_selected", [point, card_id])
	
	var card = math_model.hand[card_id];
	if card.has("description") || card.resources.size() > 0:
		var text = "";
		
		if card.resources.size() > 0:
			text += "Region: " + card.region;
			for res in card.resources:
				text += "\n >> " + res.type + ": " + String(res.chance*100) + "% x" + String(res.count);
		if card.has("description"):
			text += card.description;
		
		set_ui_text(text);
	
func _navpoint_selected(point, card_id):
	#История это то что мы узнаем о разыгранной карточке
	var card = math_model.hand[card_id];
	_clear_navpoints();
	
	if card.has("story"):
		set_ui_text(card.story);
		cam_target.x += 20;
		cam_target_angle = -40;
		cam_target_fow = 30;
		yield(get_tree().create_timer(2), "timeout")
	else:
		get_node("ui/label").visible = false;
	
	_discard_camera_targets();
	
	math_model.next_turn()
	update();
	
	if !math_model.playing:
		yield(get_tree().create_timer(2), "timeout")
		get_node("..").enter_to_home();

func _clear_navpoints():
	var b = get_node("nav_points");
	for c in b.get_children():
		c.hide_animation();

func _process(delta):
	var cam = get_node("WorldEnvironment/cam_pivot/Camera")
	var t = cam.translation;
	var w = 0.05;
	cam.translation = Vector3(lerp(t.x, cam_target.x, w), 0, lerp(t.z, cam_target.z, w))
	
	cam.rotation_degrees.x = lerp(cam.rotation_degrees.x, cam_target_angle, 0.05);
	cam.fov = lerp(cam.fov, cam_target_fow, 0.03);
	
func _discard_camera_targets():
	cam_target = Vector3(0,0,0);
	cam_target_angle = -30;
	cam_target_fow = 50;
