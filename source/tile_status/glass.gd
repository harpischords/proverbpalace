extends "res://source/tile_status/default.gd"
class_name GlassStatus

const DEFAULT_HOLE_MASK = preload("res://arte/tiles/hole_mask.png")
const ALT_HOLE_MASK = preload("res://mods/proverbpalace/arte/tiles/alt_hole3.png")
const ALT_HOLE_VALUELESS_MASK = preload("res://mods/proverbpalace/arte/tiles/alt_hole4.png")

const DEFAULT_HOLE_OUTLINE = preload("res://arte/tiles/hole_outline.png")
const ALT_HOLE_OUTLINE = preload("res://mods/proverbpalace/arte/tiles/alt_hole2.png")

const PLASTIC_ALT_HOLES = preload("res://mods/proverbpalace/arte/tiles/plastic_alt_holes.png")
const PLASTIC_GLASS_HOLES_VALUELESS = preload("res://mods/proverbpalace/arte/tiles/plastic_glass_holes_valueless.png")


const WOOD_ALT_HOLES = preload("res://mods/proverbpalace/arte/tiles/wood_alt_holes.png")
const WOOD_GLASS_HOLES_VALUELESS = preload("res://mods/proverbpalace/arte/tiles/wood_glass_holes_valueless.png")


const GLASS_OVERLAY = preload("res://mods/proverbpalace/source/effects/glass_overlay.tscn")

signal disconnect_shit

const SOUNDS = {
	CRACK = {
		SOUND = preload("res://mods/proverbpalace/sounds/tiles/glasstile.wav"), 
		PITCH_VARIANCE = 0.15, 
	}, 
	SMASH = {
		SOUND = preload("res://sounds/greeb/greebbongshatter.wav"), 
		PITCH_VARIANCE = 0.075, 
	}, 
	SHARDS = {
		SOUND = preload("res://mods/proverbpalace/sounds/tiles/glass_shards.wav"), 
		PITCH_VARIANCE = 0.075, 
		
	}
}

var broken :
	get():
		return broken_stage > 0

var broken_stage := 0

var face_when_broken := ""
var slashed_faces_when_broken := []

const GLASS_DAMAGE_SCALAR := 1

func get_save_data():
	return {
		broken_stage=broken_stage,
		face_when_broken=face_when_broken,
		slashed_faces_when_broken=slashed_faces_when_broken
	}

func load_save_data(data):
	broken_stage = data.broken_stage
	face_when_broken = data.face_when_broken
	slashed_faces_when_broken = data.slashed_faces_when_broken

func handles_click() -> bool:
	return broken

func preventing_dragging() -> bool:
	return broken

var remaining_turns := 2

static var glass_damage: int :
	get():
		return Game.balance.status_added_value*GLASS_DAMAGE_SCALAR

func get_tooltip_context():
	return {broken = broken,remaining_turns = remaining_turns, glass_damage = glass_damage,broken_stage = broken_stage}

func overrides_default_title() -> bool:
	return broken

func handle_click() -> bool:
	if tile.player.is_recomposing:
		return true
	tile.animation.play("RESET")
	tile.animation.play("pressed")
	if broken_stage == 2:
		AudioManager.play_sound(
			SOUNDS.SHARDS
		)
		
		tile.player.hurt(0,Globals.DamageType.DIRECT,false)
		tile.player.is_recomposing = false
		tile.player.anim_player.clear_queue()
		tile.player.recompose()
	return true

func is_faceless() -> bool:
	#return false
	return broken

func update_overlay() -> void:
	if overlay:
		overlay.sprite.frame = broken_stage
		overlay.shatter_sprite.frame = broken_stage + 3
		


func _on_hole_texture_changed():
	
	if !tile.has_status("proverbpalace:glass"):
		return
	
	if tile.has_value():
		tile.tile_sprite.hole_sprite.texture = WOOD_ALT_HOLES if tile.type == TileType.DAMAGE else PLASTIC_ALT_HOLES
	else:
		tile.tile_sprite.hole_sprite.texture = WOOD_GLASS_HOLES_VALUELESS if tile.type == TileType.DAMAGE else PLASTIC_GLASS_HOLES_VALUELESS
	
	tile.tile_sprite.material.set_shader_parameter("hole_mask",
		ALT_HOLE_MASK if tile.has_value() else ALT_HOLE_VALUELESS_MASK
	)
	

	
var overlay: GlassOverlay

#func _status_connect() -> void:
	#
	#if !tile.tile_sprite.has_node("PaintedOverlay"):
		#overlay = PAINTED_OVERLAY.instantiate()
		#tile.tile_sprite.add_child(overlay)
		#tile.tile_sprite.material_inheritors.append(overlay.sprite)
		#tile.tile_sprite.move_child(overlay,tile.tile_sprite.hole_sprite.get_index()-1)
		#
		#overlay.color = color
	#
	#update_frame()
	#
	#tile.tile_face.draw.connect(_tile_face_pre_draw)
#
#func clear():
	#var node = tile.tile_sprite.get_node_or_null("PaintedOverlay")
	#if node:
		#tile.tile_sprite.material_inheritors.erase(node.sprite)
		#node.name = "fuck"
		#node.queue_free()
		#node.hide()

var deboss_color = Color("85b7df88")

func _tile_face_pre_draw() -> void:
	var latent_color = tile.get_deboss_color()
	
	tile.tile_face.set_color(
		lerp(latent_color,Color.WHITE,.85)
	)
	#tile.tile_face.value_color = desired_face_color
	tile.tile_face.set_deboss_color(
		Color(latent_color,.5)
	)
	if overlay:
		overlay.sprite.set_instance_shader_parameter("tile_color", latent_color)
	
	await tile.get_tree().process_frame
	
	if tile:
		apply_hole_variant()
		
	

var settling := false



var last_y_coordinate = 0

func shatter() -> void:
	tile.animation.play("cursed_fish_chomp")
	face_when_broken = tile.face
	slashed_faces_when_broken = tile.tile_face.slashed_faces
	tile.set_face(" ",false)
	broken_stage = 1
	AudioManager.play_sound(
		SOUNDS.CRACK
	)
	update_overlay()
	
	#tile.add_status(TileStatus.BLEED)
	#tile.add_poofcloud(Globals.COLORS.BLOOD)
	

func _on_tile_state_updated():
	if tile.state == Tile.State.SETTLING:
		settling = true
	elif settling and !broken:
		settling = false
		if tile.get_coord().y < last_y_coordinate and tile.tile_board.is_settling:
			shatter()
	if tile.state != Tile.State.SETTLING:
		last_y_coordinate = tile.get_coord().y
	
func will_destroy_on_turn_end() -> bool:
	return broken_stage == 2

func will_shatter_on_turn_end():
	if broken_stage == 2:
		return false
	if broken_stage == 1:
		return true
	
	var check_strict := false
	
	if !tile.will_exist_on_turn_end():
		check_strict = true
	
	if not tile_exists() or not tile.can_fall():
		return false

	var coord = tile.get_coord()
	if coord == null:
		return false

	if coord.y == 0:
		return false

	var tiles_below = Game.tile_board.get_tiles({
		columns = [coord.x], 
		rows = Game.tile_board.get_row_coords(true, true, coord.y, false), 
		sorted = true,
	})

	for below_tile: Tile in tiles_below:
		if (!below_tile.will_exist_on_turn_end() and !check_strict) or (check_strict and below_tile.will_be_submitted()):
			return true
		if !below_tile.can_fall():
			return false

	return false

func _status_connect() -> void:
	apply_hole_variant()
	super()
	if !tile.tile_sprite.has_node("GlassOverlay"):
		overlay = GLASS_OVERLAY.instantiate()
		tile.tile_sprite.add_child(overlay)
		#tile.tile_sprite.material_inheritors.append(overlay.sprite)
		tile.tile_sprite.move_child(overlay,tile.tile_sprite.hole_sprite.get_index()+1)
	
	
	
	last_y_coordinate = tile.get_coord().y
	
	tile.state_updated.connect(
		_on_tile_state_updated
	)
	
	tile.tile_face.draw.connect(_tile_face_pre_draw)
	disconnect_shit.connect(
		func():
			tile.tile_face.draw.disconnect(_tile_face_pre_draw)
	)
	
func clear():
	remove_hole_variant()
	super()
	var node = tile.tile_sprite.get_node_or_null("GlassOverlay")
	if node:
		node.name = "its tradition"
		node.queue_free()
		node.hide()

	
func remove_hole_variant() -> void:
	disconnect_shit.emit()
	
	var should_be_hole_after = tile.has_status(TileStatus.HOLE)
	
	tile.tile_sprite.material.set_shader_parameter("hole_mask", DEFAULT_HOLE_MASK)
	tile.tile_sprite.hole_outline.texture = DEFAULT_HOLE_OUTLINE
	
	var hole_global_position = tile.tile_sprite.hole_sprite.global_position - Vector2(4.0, 4.0)
	tile.tile_sprite.set_instance_shader_parameter("hole_local_position", hole_global_position - tile.tile_sprite.global_position)
	for inheritor in tile.tile_sprite.material_inheritors:
		inheritor.set_instance_shader_parameter("hole_enabled", should_be_hole_after)
		inheritor.set_instance_shader_parameter("hole_local_position", hole_global_position - inheritor.global_position)
	tile.tile_sprite.hole_sprite.visible = should_be_hole_after
func apply_hole_variant() -> void:
	tile.tile_sprite.material = tile.tile_sprite.material.duplicate()
	
	tile.tile_sprite.hole_outline.texture = ALT_HOLE_OUTLINE
	
	tile.tile_sprite.hole_sprite.show()
	
	
	if !(tile.tile_sprite.hole_sprite.texture_changed).is_connected(_on_hole_texture_changed):
		tile.tile_sprite.hole_sprite.texture_changed.connect(_on_hole_texture_changed)
		disconnect_shit.connect(
			func():
				tile.tile_sprite.hole_sprite.texture_changed.disconnect(_on_hole_texture_changed)
		)
	_on_hole_texture_changed()
	var hole_global_position = tile.tile_sprite.hole_sprite.global_position - Vector2(8.0, 8.0)
	tile.tile_sprite.set_instance_shader_parameter("hole_local_position", hole_global_position - tile.tile_sprite.global_position)
	for inheritor in tile.tile_sprite.material_inheritors:
		if inheritor is TileFace:
			continue
		inheritor.set_instance_shader_parameter("hole_enabled", true)
		inheritor.set_instance_shader_parameter("hole_local_position", hole_global_position - inheritor.global_position)
