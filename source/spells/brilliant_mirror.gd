extends Spell

const MIRROR_CHARS_HORIZONTAL = [
	"bd","pq","oo","vv","ww","88"    #,"Ԑ3"
]
const MIRROR_CHARS_180 = [
	"69", "ss", "88", "oo", "bq", "dp", "mw"
]

enum MirrorMode {
	ROTATED,
	HORIZONTAL
}

func get_tooltip_context():
	return {
		face = current_face,
		face_mirrored = mirrored_face
	}
func has_any_number(s: String):
	for let in s:
		if let in Letters.NUMBERS:
			return true
	return false

const BIGRAM_CHOICES = {
	MirrorMode.ROTATED: [
		"66", "69", "96", "99", "6s", "s6", "9s", "s9",
		"68", "86", "98", "89", "6o", "o6", "9o", "o9",
		"6d", "d6", "6p", "p6", "9d", "d9", "9p", "p9",
		"6m", "m6", "6w", "w6", "9m", "m9", "9w", "w9",
		"ss", "s8", "8s", "so", "os", "sm", "ms", "sw",
		"ws", "88", "8o", "o8", "8d", "d8", "8p", "p8",
		"8m", "m8", "8w", "w8", "oo", "od", "do", "op",
		"po", "om", "mo", "ow", "wo"],
	MirrorMode.HORIZONTAL: [
		"bb", "bd", "db", "dd", "bo", "ob", "do", "od",
		"b8", "8b", "d8", "8d", "oo", "ov", "vo", "ow",
		"wo", "o8", "8o", "v8", "8v", "w8", "8w", "88"]
}

var current_mirror_mode := MirrorMode.HORIZONTAL

var current_face := "ob"
var mirrored_face : String :
	get():
		return get_mirrored_ngram(
			current_face, MIRROR_CHARS_HORIZONTAL if current_mirror_mode == MirrorMode.HORIZONTAL else MIRROR_CHARS_180
		)
	
	

func get_mirrored_ngram(ngram: String,mirror_set: Array):
	var output := ""
	
	for let in ngram:
		for mirroring in mirror_set:
			if let in mirroring:
				var i = 1-mirroring.find(let)
				output += mirroring[i]
	return output.reverse()

func set_status_tooltips():
	status_tooltips = [ProverbPalace.EFFECTS.GLASS,TileStatus.CRIT]


func _use():
	var tile = await get_selection()

	if tile == null:
		_end_use()
		return

	_post_use()


func is_tile_selectable(tile: Tile) -> bool:
	return true
