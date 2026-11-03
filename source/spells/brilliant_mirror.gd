extends Spell

const MIRROR_CHARS_HORIZONTAL = [
	"bd","pq","oo","vv","ww","ԑ3"
]

const MIRROR_CHARS_VERTICAL = [
	"ss", "oo", "bp", "dq", "mw"
]

enum MirrorMode {
	ROTATED,
	HORIZONTAL
}

func get_tooltip_context():
	return {
		face = current_face,
		#face_mirrored = mirrored_face
	}

var current_face := "ob"
	
	


func set_status_tooltips():
	status_tooltips = [ProverbPalace.EFFECTS.GLASS,TileStatus.CRIT]


#func reroll_faces():
	#current_mirror_mode = rng.spell.randi()%2 as MirrorMode
	#current_face = rng.spell.pick_random(
		#BIGRAM_CHOICES[current_mirror_mode]
	#)

func _use():
	var tile = await get_selection()

	if tile == null:
		_end_use()
		return

	_post_use()
	
	
	
	description_updated.emit()


func is_tile_selectable(tile: Tile) -> bool:
	return true
