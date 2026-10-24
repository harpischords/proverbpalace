@tool
extends Mod
class_name ProverbPalace


func is_coop_enabled() -> bool:
	return ModLoader.has_mod("co-op")

const EFFECTS: Dictionary[String, String] = {
	PAINTED = "proverbpalace:painted",
	COUNTER = "proverbpalace:counter",
	MUTAGEN = "proverbpalace:mutagen",
	GLASS = "proverbpalace:glass",
}

const SPELLS: Dictionary[String, String] = {
	PDA = "proverbpalace:pda",
	VANILLA_ESSENCE = "proverbpalace:vanilla_essence",
	SD_CARD = "proverbpalace:sd_card",
	BLENDER = "proverbpalace:blender",
	
	PHOTO_ALBUM = "proverbpalace:photo_album",
	
	DATAMOSH = "proverbpalace:datamosh",
	BOOSTER_SHOT = "proverbpalace:booster_shot",
	TOY_CAMERA = "proverbpalace:toy_camera",
	MILK = "proverbpalace:milk",
	ZIPTIES = "proverbpalace:zipties",
	GAYDAR = "proverbpalace:gaydar",
	COLD_CASE = "proverbpalace:cold_case",
	CAT_TAIL = "proverbpalace:cat_tail",
	BLT = "proverbpalace:blt",
	DISSENTER_HOTLINE = "proverbpalace:dissenter_hotline",
	SUBDOMAIN = "proverbpalace:subdomain",
	LCD_TWEEZERS = "proverbpalace:lcd_tweezers",
	DYNAMO = "proverbpalace:dynamo",
	SOFTBOILED = "proverbpalace:softboiled",
	BLOWOUT = "proverbpalace:blowout",
	POCKET_SNAKE = "proverbpalace:pocket_snake",
	HALO = "proverbpalace:halo",
	DISCOMBOBULATOR = "proverbpalace:discombobulator",
	BUBBLE_TAPE = "proverbpalace:bubble_tape",
	UNLIMITED_BACON = "proverbpalace:unlimited_bacon",
	CLIFFHANGER = "proverbpalace:cliffhanger",
	BRASS_KNUCKLES = "proverbpalace:brass_knuckles",
	CHEAP_BEER = "proverbpalace:cheap_beer",
	COLOR_BELT = "proverbpalace:color_belt",
	COUNTER_COUNTER = "proverbpalace:counter_counter",
	SEWING_NEEDLE = "proverbpalace:sewing_needle",
	SWATCHGUN = "proverbpalace:swatchgun",
	BRILLIANT_MIRROR = "proverbpalace:brilliant_mirror",
	
}

const COOP_BLACKLIST := [
	SPELLS.COLOR_BELT,
	SPELLS.COUNTER_COUNTER
]


var BASE_WEIGHT := 4.
var PLAYTESTED_COEFF := .75
var UNPLAYTESTED_COEFF := 1.35
var COOP_BAN_COEFF := 1.
const UNCOMMON_COEFF := .5


var SPELL_CATEGORIES: Dictionary[String, Array] = {
	Globals.SPELL_CATEGORY.SUPPORT: [
		SPELLS.DATAMOSH,
		SPELLS.BOOSTER_SHOT,
		SPELLS.CAT_TAIL,
		SPELLS.DISSENTER_HOTLINE,
		SPELLS.LCD_TWEEZERS,
		SPELLS.DYNAMO,
		SPELLS.POCKET_SNAKE,
		SPELLS.DISCOMBOBULATOR,
		SPELLS.BUBBLE_TAPE,
		SPELLS.UNLIMITED_BACON,
		SPELLS.BRASS_KNUCKLES,
		SPELLS.SEWING_NEEDLE,
	],
	Globals.SPELL_CATEGORY.OFFENSIVE: [
		SPELLS.MILK,
		SPELLS.GAYDAR,
		SPELLS.SUBDOMAIN,
		SPELLS.BLOWOUT,
		SPELLS.HALO,
		SPELLS.CLIFFHANGER,
		SPELLS.CHEAP_BEER,
		SPELLS.COLOR_BELT,
		SPELLS.COUNTER_COUNTER,
		SPELLS.SWATCHGUN,
		SPELLS.BRILLIANT_MIRROR,
	],
	Globals.SPELL_CATEGORY.DEFENSIVE: [
		SPELLS.TOY_CAMERA,
		SPELLS.ZIPTIES,
		SPELLS.BLT,
		SPELLS.COLD_CASE,
		SPELLS.SOFTBOILED,
	],
	
	Globals.SPELL_CATEGORY.DIRECT_DEFENSE: [
		SPELLS.TOY_CAMERA,
		SPELLS.ZIPTIES,
		SPELLS.COLD_CASE,
	],
}



func register_callbacks(helper: CallbackHelper) -> void:
	helper.add_callback(Callbacks.REGISTER_SPELLS.MOD_INIT,_register_spells,0)
	helper.add_callback(Callbacks.REGISTER_EFFECTS.BASE,_register_effects,0)
	helper.add_callback(Callbacks.TILE_GET_VALUE.EARLY,_tile_get_value_early,0)

func _tile_get_value_early():
	pass

func _register_effects():
	EffectRegistry.register(self,(EFFECTS.values()))

func _register_spells():
	
	
	SpellRegistry.register(self, (SPELLS.values()))
	SpellRegistry.add_spells_to_categories(SPELL_CATEGORIES)
	
	var do_playtest_weights = FileAccess.file_exists("res://mods/proverbpalace/BOOST_SPELL_WEIGHTS.yes")
	if !do_playtest_weights:
		BASE_WEIGHT = 1.
		PLAYTESTED_COEFF = 1.
		UNPLAYTESTED_COEFF = 1.
	if is_coop_enabled():
		COOP_BAN_COEFF = 0.
	
	print_debug("PROVERB PALACE: FILLING SPELL POOL%s"%
		" USING PLAYTEST WEIGHTS" if do_playtest_weights else ""
	)
	
	var SPELL_POOL: Dictionary[String, float] = {
		SPELLS.TOY_CAMERA: BASE_WEIGHT,
		SPELLS.DATAMOSH: BASE_WEIGHT,
		SPELLS.CAT_TAIL: BASE_WEIGHT,
		SPELLS.GAYDAR: BASE_WEIGHT,
		SPELLS.BOOSTER_SHOT: BASE_WEIGHT,
		SPELLS.MILK: BASE_WEIGHT, #UNKILLED
		SPELLS.ZIPTIES: BASE_WEIGHT,
		SPELLS.COLD_CASE: BASE_WEIGHT,
		SPELLS.BLT: BASE_WEIGHT*UNCOMMON_COEFF,
		SPELLS.DISSENTER_HOTLINE: BASE_WEIGHT,
		SPELLS.SUBDOMAIN: BASE_WEIGHT,
		SPELLS.LCD_TWEEZERS: BASE_WEIGHT,
		SPELLS.DYNAMO: BASE_WEIGHT,
		SPELLS.BLOWOUT: BASE_WEIGHT,
		SPELLS.POCKET_SNAKE: BASE_WEIGHT,
		SPELLS.HALO: BASE_WEIGHT,
		SPELLS.SOFTBOILED: BASE_WEIGHT,
		SPELLS.SD_CARD: 0.,
		SPELLS.VANILLA_ESSENCE: 0.,
		SPELLS.PDA: 0.,
		SPELLS.PHOTO_ALBUM: 0.,
		SPELLS.BLENDER: 0.,
		SPELLS.BUBBLE_TAPE: 0.,
		SPELLS.DISCOMBOBULATOR: BASE_WEIGHT,
		SPELLS.UNLIMITED_BACON: BASE_WEIGHT,
		SPELLS.CLIFFHANGER: BASE_WEIGHT,
		SPELLS.BRASS_KNUCKLES: BASE_WEIGHT,
		SPELLS.CHEAP_BEER: BASE_WEIGHT,
		SPELLS.COLOR_BELT: BASE_WEIGHT*UNPLAYTESTED_COEFF*COOP_BAN_COEFF,
		SPELLS.COUNTER_COUNTER: BASE_WEIGHT*UNPLAYTESTED_COEFF*COOP_BAN_COEFF,
		SPELLS.SEWING_NEEDLE: BASE_WEIGHT*UNPLAYTESTED_COEFF,
		SPELLS.SWATCHGUN: BASE_WEIGHT*UNPLAYTESTED_COEFF*0.,
		SPELLS.BRILLIANT_MIRROR: BASE_WEIGHT*UNPLAYTESTED_COEFF*0.,
	}
	
	SpellRegistry.add_spells_to_pool(SPELL_POOL)

#static func _static_init():
	#print("trying my best")
	#Sounds.register_sounds(
		#{
			#DIMORPH={
				#SOUNDS = [
					#preload("res://mods/proverbpalace/overrides/sounds/dimorph/dimorph_flinch.wav"),
					#preload("res://mods/proverbpalace/overrides/sounds/dimorph/dimorph_flinch_parry.wav"),
					#preload("res://mods/proverbpalace/overrides/sounds/dimorph/dimorph_growl.wav"),
					#preload("res://mods/proverbpalace/overrides/sounds/dimorph/dimorph_gunkshot.wav"),
					#preload("res://mods/proverbpalace/overrides/sounds/dimorph/dimorph_xscissor_1.wav"),
					#preload("res://mods/proverbpalace/overrides/sounds/dimorph/dimorph_xscissor_2.wav"),
				#]
			#}
		#},
		#Sounds.SOUND_CONSTANTS,
		#Sounds.SOUND_GROUPS,
	#)
	#


var modified_resources: Array[Resource]

func modify_resources() -> void:
	var headline_intro: AudioStreamOggVorbis = load("res://music/headline_intro.ogg")
	headline_intro.bpm = 303
	
	var headline_loop: AudioStreamOggVorbis = load("res://music/headline_loop.ogg")
	headline_loop.bpm = 303
	modified_resources.append_array([headline_intro,headline_loop])
	
	modified_resources.make_read_only()
	
	
func _ready() -> void:
	#CustomIntent.custom_status_intent_icons["mutagen"]=preload("uid://dukxvsrifradw")
	#update_remove_other_enemies()
	var do_playtest_weights = FileAccess.file_exists("res://mods/proverbpalace/BOOST_SPELL_WEIGHTS.yes")
	print_debug("Yay loaded Proverb Palace. Playtest weights file %sdetected"%("not " if !do_playtest_weights else ""))
	#if "dimorph" not in EnemyLoader.enemy_pools[0][0]:
		#EnemyLoader.add_enemy("dimorph",2,3,"res://mods/proverbpalace/arte/dimorph/miniface_dimorph.png")
	modify_resources()
	
	
	await Game.main_scene_loaded
	
	_initialize_managers()
	Game.main.game_state_updated.connect(_game_state_updated)

static var tile_manager: ProverbPalaceTileManager
static var gamestate_manager: ProverbPalaceGamestateManager

func _initialize_managers() -> void:
	tile_manager = ProverbPalaceTileManager.new()
	gamestate_manager = ProverbPalaceGamestateManager.new()
	add_child(tile_manager)
	add_child(gamestate_manager)
	
	get_tree().node_added.connect(tile_manager._on_node_added)
	get_tree().node_added.connect(gamestate_manager._on_node_added)

func _game_state_updated():
	for player_spell: PlayerSpell in Game.player.spell_container.player_spells:
		if player_spell.spell == null:
			var a := Spell.create("proverbpalace:datamosh", Game.main.rng.spell) as Datamosh
			player_spell.set_spell(
				a
			)
			a._first_spawn(false)
			push_error(
				"DATAMOSH IS REPLACING A NULL SPELL!\n%s"%Datamosh.DEBUG_PRINT_PIC
			)
			if Game.player.id == Globals.CHARACTERS.JUBILIST:
				a.secret_id = Globals.SPELLS.GIFT_PUZZLE
	pass

func get_options_save_data() -> Dictionary:
	return {}


func get_run_save_data() -> Dictionary:
	var discombobulator_spell_record: Dictionary[int, Dictionary] = {}
	var i := 0
	for spell in Game.spell_container.get_spells():
		if len(spell.charge_character) > 0:
			discombobulator_spell_record[i] = {
				spell = spell.id,
				character = spell.charge_character
			}
			i += 1
	return {
		discombobulator_spell_record = discombobulator_spell_record
	}

func load_run_save_data(data: Dictionary) -> void :
	if data.discombobulator_spell_record:
		await get_tree().process_frame
		var spells: Array[Spell] = Game.spell_container.get_spells()
		for spell_slot in data.discombobulator_spell_record:
			var spell: Spell = spells[spell_slot]
			if spell.spell_data.charge_category == Globals.CHARGE_CATEGORIES.AUTO:
				if data.discombobulator_spell_record[spell_slot].spell == spell.id:
					var new_data = SpellData.new()
					new_data.id = spell.spell_data.id
					new_data.mod = spell.spell_data.mod
					new_data.load_data()
					new_data.load_script()
					new_data.charge_category = Globals.CHARGE_CATEGORIES.COMMON
					spell.spell_data = new_data
					spell.charge_container.update_charge_character(false)
					spell.charge_character = data.discombobulator_spell_record[spell_slot].character

func get_save_data() -> Dictionary:
	return {}

#func get_spell_pool(category: String = "") -> Dictionary[String, float]:
	#var do_playtest_weights = FileAccess.file_exists("res://mods/proverbpalace/BOOST_SPELL_WEIGHTS.yes")
	#
	#if !do_playtest_weights:
		#BASE_WEIGHT = 1.
		#PLAYTESTED_COEFF = 1.
		#UNPLAYTESTED_COEFF = 1.
	#if is_coop_enabled():
		#COOP_BAN_COEFF = 0.
	#
	#print_debug("PROVERB PALACE: FILLING SPELL POOL%s"%
		#" USING PLAYTEST WEIGHTS" if do_playtest_weights else ""
	#)
	#
	#var SPELL_POOL: Dictionary[String, float] = {
		#SPELLS.TOY_CAMERA: BASE_WEIGHT,
		#SPELLS.DATAMOSH: BASE_WEIGHT,
		#SPELLS.CAT_TAIL: BASE_WEIGHT,
		#SPELLS.GAYDAR: BASE_WEIGHT,
		#SPELLS.BOOSTER_SHOT: BASE_WEIGHT,
		#SPELLS.MILK: BASE_WEIGHT, #UNKILLED
		#SPELLS.ZIPTIES: BASE_WEIGHT,
		#SPELLS.COLD_CASE: BASE_WEIGHT,
		#SPELLS.BLT: BASE_WEIGHT*UNCOMMON_COEFF,
		#SPELLS.DISSENTER_HOTLINE: BASE_WEIGHT,
		#SPELLS.SUBDOMAIN: BASE_WEIGHT,
		#SPELLS.LCD_TWEEZERS: BASE_WEIGHT,
		#SPELLS.DYNAMO: BASE_WEIGHT,
		#SPELLS.BLOWOUT: BASE_WEIGHT,
		#SPELLS.POCKET_SNAKE: BASE_WEIGHT,
		#SPELLS.HALO: BASE_WEIGHT,
		#SPELLS.SOFTBOILED: BASE_WEIGHT,
		#SPELLS.SD_CARD: 0.,
		#SPELLS.VANILLA_ESSENCE: 0.,
		#SPELLS.PDA: 0.,
		#SPELLS.PHOTO_ALBUM: 0.,
		#SPELLS.BLENDER: 0.,
		#SPELLS.BUBBLE_TAPE: 0.,
		#SPELLS.DISCOMBOBULATOR: BASE_WEIGHT,
		#SPELLS.UNLIMITED_BACON: BASE_WEIGHT,
		#SPELLS.CLIFFHANGER: BASE_WEIGHT,
		#SPELLS.BRASS_KNUCKLES: BASE_WEIGHT,
		#SPELLS.CHEAP_BEER: BASE_WEIGHT,
		#SPELLS.COLOR_BELT: BASE_WEIGHT*UNPLAYTESTED_COEFF*COOP_BAN_COEFF,
		#SPELLS.COUNTER_COUNTER: BASE_WEIGHT*UNPLAYTESTED_COEFF*COOP_BAN_COEFF,
		#SPELLS.SEWING_NEEDLE: BASE_WEIGHT*UNPLAYTESTED_COEFF,
		#SPELLS.SWATCHGUN: BASE_WEIGHT*UNPLAYTESTED_COEFF*0.,
	#}
	#
	#var category_pool: Array = SPELL_CATEGORIES.get(category, [])
	#var pool := SpellData.get_filtered_spell_pool(SPELL_POOL, category_pool)
	#return namespace_dictionary_ids(pool)
