extends Status
class_name PaintedStatus


enum Colors {
	RED,
	YELLOW,
	GREEN,
	CYAN,
	BLUE,
	MAGENTA
}

const EXCLUSIVE_STATUSES = [
	TileStatus.CAPITAL,
	TileStatus.PERIOD,
]

const COLOR_GRADIENT = preload("res://mods/proverbpalace/arte/effects/painted_gradient.tres")
const PAINTED_OVERLAY = preload("res://mods/proverbpalace/source/effects/painted_overlay.tscn")



var overlay: PaintedOverlay
var color: Colors :
	set(v):
		color = v
		if overlay:
			overlay.color = v
var paint_frame := 0 :
	set(v):
		paint_frame = v
		if overlay:
			overlay.sprite.frame = v

func get_save_data():
	return {
		color=color,
		frame=paint_frame
	}

func update_frame() -> void :
	pass
func update():
	super()
	var current_frame = tile.tile_sprite.base_sprite.frame
	if tile.has_status(TileStatus.HOLE):
		tile.tile_sprite.set_frame(current_frame,26)
		tile.tile_sprite.hole_sprite.modulate = get_color_value(color)
		print("what")
	

func load_save_data(data):
	paint_frame = data.frame
	color = data.color

static func get_color_value(sample_color: Colors) -> Color:
	return COLOR_GRADIENT.sample(
		float(sample_color)/6.
	)

static func get_color_name(c: Colors):
	var color_name = Colors.keys()[int(c)].to_lower()
	return (EffectRegistry.get_data("proverbpalace:painted").get_string_group().get_string(color_name))
	

var deboss_color :
	get():
		var c = get_color_value(color)
		c.v *= 1.2
		c.s *= .7
		return c

	
func get_tooltip_context():
	return {
		color = get_color_name(color)
	}

func _tile_face_pre_draw() -> void:
	#tile.tile_face.set_color(
		#"#FFFFFF"
	#)
	#tile.tile_face.value_color = "#FFFFFF"
	tile.tile_face.set_deboss_color(
		Color(deboss_color,tile.tile_face.deboss_highlight_color.a)
	)


func _status_connect() -> void:
	
	if !tile.tile_sprite.has_node("PaintedOverlay"):
		overlay = PAINTED_OVERLAY.instantiate()
		tile.tile_sprite.add_child(overlay)
		tile.tile_sprite.material_inheritors.append(overlay.sprite)
		tile.tile_sprite.move_child(overlay,tile.tile_sprite.hole_sprite.get_index()-1)
		
		overlay.color = color
	
	update_frame()
	
	tile.tile_face.draw.connect(_tile_face_pre_draw)

func clear():
	var node = tile.tile_sprite.get_node_or_null("PaintedOverlay")
	if node:
		tile.tile_sprite.material_inheritors.erase(node.sprite)
		node.name = "i would never name something fuck"
		node.queue_free()
		node.hide()

func apply(applied_color := Colors.RED):
	color=applied_color
	paint_frame = randi()%3


var invalidating_color_left: Colors
var invalidating_color_right: Colors

func invalidates_word():
	if not tile.in_word() or tile.has_faceless_status():
		return false
	
	return Game.word_builder.get_tile_index_in_word(tile, true) != 0
