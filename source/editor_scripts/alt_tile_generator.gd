@tool
extends EditorScript

const TILE_SIZE: = Vector2i(32, 32)

var WOOD_FISH_COLOR_COORDS: Dictionary[String, Vector2i] = {
	base = Vector2i(11, 11), 
	dark = Vector2i(10, 9), 
}
var PLASTIC_FISH_COLOR_COORDS: Dictionary[String, Vector2i] = {
	base = Vector2i(11, 11), 
	dark = Vector2i(10, 9), 
	highlight = Vector2i(11, 9), 
}

const EVIL_WOOD_FISH_COLOR_COORDS: Dictionary[String, Vector2i] = {
	base = Vector2i(18, 7), 
	dark = Vector2i(17, 7), 
}

const EVIL_CHARGING_WOOD_FISH_COLOR_COORDS: Dictionary[String, Vector2i] = {
	base = Vector2i(12, 6), 
	dark = Vector2i(11, 6), 
}

const EVIL_PLASTIC_FISH_COLOR_COORDS: Dictionary[String, Vector2i] = {
	base = Vector2i(19, 9), 
	dark = Vector2i(17, 7), 
	highlight = Vector2i(17, 8), 
}

const EVIL_CHARGING_PLASTIC_FISH_COLOR_COORDS: Dictionary[String, Vector2i] = {
	base = Vector2i(12, 8), 
	dark = Vector2i(11, 6), 
	highlight = Vector2i(12, 6), 
}

var HOLE_COLOR_COORDS: Dictionary[String, Vector2i] = {
	dark = Vector2i(5, 1), 
	part_dark = Vector2i(4, 1), 
	base = Vector2i(14, 7), 
	highlight = Vector2i(14, 9)
}
var ALT_HOLE_COLOR_COORDS: Dictionary[String, Vector2i] = {
	dark = Vector2i(5, 0), 
	part_dark = Vector2i(0, 1), 
	base = Vector2i(3, 15), 
	highlight = Vector2i(12, 15)
}


var WOOD_TILE_COLOR_COORDS: Dictionary[String, Vector2i] = {
	base = Vector2i(10, 9), 
	dark = Vector2i(7, 6), 
	part_dark = Vector2i(12, 8), 
}
var PLASTIC_TILE_COLOR_COORDS: Dictionary[String, Vector2i] = {
	base = Vector2i(9, 8), 
	dark = Vector2i(7, 6), 
	highlight = Vector2i(8, 6)
}

var FRAME_TO_STATUS: Dictionary[int, String] = {
	0: Globals.TileStatus.DEFAULT
}

var STATUS_COLORS: Dictionary[String, Dictionary] = {

}


func _run() -> void :
	var highest_status_frame: = 0
	for status in Globals.TileStatusFrame:
		var frame = Globals.TileStatusFrame[status]
		if frame != 0:
			highest_status_frame = max(highest_status_frame, frame)
			FRAME_TO_STATUS[frame] = status

	var last_status: String
	for frame in highest_status_frame + 1:
		if frame in FRAME_TO_STATUS:
			last_status = FRAME_TO_STATUS[frame]
		else:
			FRAME_TO_STATUS[frame] = last_status

	var plastic_fish_image: Image = load("res://arte/tiles/fish/plastic_fish_parts.png").get_image()
	var wood_fish_image: Image = load("res://arte/tiles/fish/wood_fish_parts.png").get_image()
	var plastic_fish_base: = BaseImage.new(plastic_fish_image, PLASTIC_FISH_COLOR_COORDS)
	var plastic_fish_flipped: = plastic_fish_base.flipped()
	var wood_fish_base: = BaseImage.new(wood_fish_image, WOOD_FISH_COLOR_COORDS)
	var wood_fish_flipped: = wood_fish_base.flipped()

	var evil_wood_fish_image: Image = load("res://arte/tiles/fish/evil_wood_fish_parts.png").get_image()
	var evil_wood_fish_base: = BaseImage.new(evil_wood_fish_image, EVIL_WOOD_FISH_COLOR_COORDS, Vector2i(16, 0))
	var evil_wood_fish_flipped: = evil_wood_fish_base.flipped(Vector2i(16, 0))
	var evil_charging_wood_fish_image: Image = load("res://arte/tiles/fish/evil_charging_wood_fish_parts.png").get_image()
	var evil_charging_wood_fish_base: = BaseImage.new(evil_charging_wood_fish_image, EVIL_CHARGING_WOOD_FISH_COLOR_COORDS, Vector2i(16, 0))
	var evil_charging_wood_fish_flipped: = evil_charging_wood_fish_base.flipped(Vector2i(16, 0))

	var evil_plastic_fish_image: Image = load("res://arte/tiles/fish/evil_plastic_fish_parts.png").get_image()
	var evil_plastic_fish_base: = BaseImage.new(evil_plastic_fish_image, EVIL_PLASTIC_FISH_COLOR_COORDS, Vector2i(16, 0))
	var evil_plastic_fish_flipped: = evil_plastic_fish_base.flipped(Vector2i(16, 0))
	var evil_charging_plastic_fish_image: Image = load("res://arte/tiles/fish/evil_charging_plastic_fish_parts.png").get_image()
	var evil_charging_plastic_fish_base: = BaseImage.new(evil_charging_plastic_fish_image, EVIL_CHARGING_PLASTIC_FISH_COLOR_COORDS, Vector2i(16, 0))
	var evil_charging_plastic_fish_flipped: = evil_charging_plastic_fish_base.flipped(Vector2i(16, 0))

	var hole_image: Image = load("res://mods/proverbpalace/arte/tiles/alt_hole1.png").get_image()
	var hole_base: = BaseImage.new(hole_image, ALT_HOLE_COLOR_COORDS)

	generate_tile_sheets(
		load("res://arte/tiles/plastic_tiles.png"), 
		PLASTIC_TILE_COLOR_COORDS, 
		true, 
		[
			HoleSheet.new("plastic_alt_holes", hole_base), 
		]
	)
	for variant in ["_a", "_b", "_c"]:
		var sheets: Array[SheetGenerator] = [
			
		]
		if variant == "_a":
			sheets.append(HoleSheet.new("wood_alt_holes", hole_base))

		generate_tile_sheets(
			load("res://arte/tiles/wood_tiles" + variant + ".png"), 
			WOOD_TILE_COLOR_COORDS, 
			false, 
			sheets
		)

	var base_colors = {}
	for status in STATUS_COLORS:
		var color_data = STATUS_COLORS[status]
		base_colors[status] = [color_data.wood.base, color_data.plastic.base]

	PrintUtil.print_dictionary(base_colors, 1, [PrintUtil.BackEnum.new(Globals.TileStatus, "TileStatus")])


func generate_tile_sheets(tile_texture: Texture2D, tile_color_coords: Dictionary[String, Vector2i], is_plastic: bool, sheets: Array[SheetGenerator]) -> void :
	var tile_image: = tile_texture.get_image()
	var tile_texture_size: Vector2i = tile_image.get_size()
	var frames: = tile_texture_size / TILE_SIZE

	for sheet in sheets:
		sheet.create_sheet(frames)

	for hframe in frames.x:
		for vframe in frames.y:
			var hvframe: = Vector2i(hframe, vframe)
			var frame: = frames.x * vframe + hframe
			var tile_rect: = Rect2i(hvframe * TILE_SIZE, TILE_SIZE)

			var status: = ""
			if frame in FRAME_TO_STATUS:
				status = FRAME_TO_STATUS[frame]

			var tile_colors: = RecolorUtil.get_colors_from_coordinates(tile_image, tile_color_coords, tile_rect.position)
			if not is_plastic:
				if status != "":
					if status in Globals.TILE_DEBOSS_COLOR:
						var colors = Globals.TILE_DEBOSS_COLOR[status]
						tile_colors.highlight = colors[0]
			else:
				var half_opacity_dark: Color = Color(tile_colors.dark, 0.5)
				tile_colors.part_dark = half_opacity_dark.blend(tile_colors.base)

			if status != "":
				var status_color_dictionary = STATUS_COLORS.get_or_add(status, {})
				if is_plastic and not "plastic" in status_color_dictionary:
					status_color_dictionary.plastic = tile_colors
				elif not is_plastic and not "wood" in status_color_dictionary:
					status_color_dictionary.wood = tile_colors

			for sheet in sheets:
				sheet.render_frame(hvframe, tile_colors, tile_image, tile_rect)

	for sheet in sheets:
		sheet.store_file()


class BaseImage extends RefCounted:
	var image: Image
	var size: Vector2i
	var blit_offset: Vector2i
	var color_coordinate_lists: Dictionary[String, Array]
	func _init(_image: Image, color_coords: Dictionary[String, Vector2i] = {}, tile_blit_offset: Vector2i = Vector2i(8, 0)) -> void :
		image = _image
		size = image.get_size()
		blit_offset = tile_blit_offset
		if color_coords.is_empty():
			return

		color_coordinate_lists = RecolorUtil.get_color_coordinate_lists(image, color_coords)


	func flip() -> void :
		image.flip_x()
		for color in color_coordinate_lists:
			var new_list: Array[Vector2i] = []
			for coord in color_coordinate_lists[color]:
				new_list.append(Vector2i((size.x - 1) - coord.x, coord.y))

			color_coordinate_lists[color] = new_list


	func flipped(new_blit_offset: Vector2i = blit_offset) -> BaseImage:
		var new_image: = Image.new()
		new_image.copy_from(image)
		var new_base_image: = BaseImage.new(new_image)
		new_base_image.blit_offset = new_blit_offset
		new_base_image.color_coordinate_lists = color_coordinate_lists.duplicate(true)
		new_base_image.flip()
		return new_base_image


@abstract class SheetGenerator extends RefCounted:
	var sheet: Image
	var base_image: BaseImage
	var filepath: String

	func _init(_filepath: String, _base_image: BaseImage):
		filepath = _filepath
		base_image = _base_image


	func store_file() -> void :
		sheet.save_png("res://arte/tiles/" + filepath + ".png")


	func create_sheet(frames: Vector2i) -> void :
		sheet = Image.create_empty(frames.x * base_image.size.x, frames.y * base_image.size.y, false, Image.FORMAT_RGBA8)


	@abstract func render_frame(hvframe: Vector2i, tile_colors: Dictionary[String, Color], tile_image: Image, tile_rect: Rect2i) -> void 


class FishSheet extends SheetGenerator:
	func render_frame(hvframe: Vector2i, tile_colors: Dictionary[String, Color], tile_image: Image, tile_rect: Rect2i) -> void :
		var position: = hvframe * base_image.size
		sheet.blit_rect(tile_image, tile_rect, position + base_image.blit_offset)
		sheet.blend_rect(base_image.image, Rect2i(Vector2.ZERO, base_image.size), position)
		RecolorUtil.recolor(sheet, base_image.color_coordinate_lists, tile_colors, position)


class HoleSheet extends SheetGenerator:
	func render_frame(hvframe: Vector2i, tile_colors: Dictionary[String, Color], _tile_image: Image, _tile_rect: Rect2i) -> void :
		if "highlight" not in tile_colors or "part_dark" not in tile_colors:
			return

		var position: = hvframe * base_image.size
		sheet.blit_rect(base_image.image, Rect2i(Vector2.ZERO, base_image.size), position)
		RecolorUtil.recolor(sheet, base_image.color_coordinate_lists, tile_colors, position)
