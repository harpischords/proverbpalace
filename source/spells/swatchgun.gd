extends Spell


func set_status_tooltips():
	status_tooltips = ["painted",TileStatus.HOLE]


func _use():
	var apply_painted = get_tiles({
		amount = 4, 
		effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE_ALLOW_NONPOSITIVE, 
		exclude_effects = ["proverbpalace:painted",TileStatus.HOLE], 
	})

	if len(apply_painted) == 0:
		_end_use()
		return
	
	var colors := PaintedStatus.Colors.values()
	
	rng.spell.shuffle(colors)
	var i = 0
	for tile in apply_painted:
		tile.add_status("proverbpalace:painted",colors[i])
		tile.animation.play("shake",-1,1.76)
		if i == 0:
			tile.apply_hole(false)
			tile.add_poofcloud(Globals.COLORS.SMOKE,null,false,0.5,true)
		else:
			tile.add_poofcloud(
				PaintedStatus.get_color_value(colors[i]),null,false,.5,true
				
				)
		i += 1
	
	AudioManager.play_sound(
		Sounds.BOOKWORM.MILKWORM_FIREBALL_FINAL
	)
	_post_use()

func add_charge(amount, instant = false, animate_sprite: = true):
	super(amount,instant,animate_sprite)
	if amount != 0 and animate_sprite and not instant:
		
		AudioManager.play_sound(
			Sounds.NEW_COP.GUN_COCK
		)

func is_tile_selectable(tile: Tile) -> bool:
	return true
