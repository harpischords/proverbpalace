extends TurnEndTriggerEffectData


func register_callbacks(helper: CallbackHelper) -> void :
	helper.add_callback(
		Callbacks.TILE_BOARD_TURN_END.REMOVE,
		trigger_turn_end_effect.bind(true),
		Callbacks.BASE_PRIORITY.FIRST+6
	)
	helper.add_callback(
		Callbacks.TILE_BOARD_TURN_END.REMOVE,
		trigger_turn_end_effect.bind(false),
		Callbacks.BASE_PRIORITY.FIRST+5
	)

func trigger_turn_end_effect(tile_board: TileBoard, only_remove_expired := false) -> void :
	var tiles: = get_active_tiles(tile_board)
	if tiles.is_empty():
		return

	@warning_ignore("redundant_await")
	await trigger_tiles(tiles, only_remove_expired)

	turn_end_triggered = true

	if updates_word_builder:
		Game.word_builder.update_stats()

	await Game.timeout(tile_board.TURN_END_STEP_DELAY)

func trigger_tiles(tiles: Array[Tile], only_remove_expired := false) -> void :
	var expired_glass: Array[Tile] = []
	var damage: int = 0
	for tile in tiles:
		var status: GlassStatus = tile.get_status(ProverbPalace.EFFECTS.GLASS)
		
		if !status.broken:
			continue
		
		if (!only_remove_expired) or status.remaining_turns == 1:
			status.remaining_turns -= 1
			if status.remaining_turns <= 1:
				status.broken_stage = 2
			status.update_overlay()
		else:
			continue
	
		if status.remaining_turns == 0:
			expired_glass.append(tile)
		elif !only_remove_expired:
			tile.animation.play("shake")
			tile.add_poofcloud(tile.get_color())
			tile.update()
			AudioManager.play_sound(
				GlassStatus.SOUNDS.SMASH,1.
			)
			damage += GlassStatus.glass_damage
			await Game.timeout(0.08)
	if damage > 0:
		Game.player.hurt(damage)
	
	await trigger_tiles_remove(expired_glass, Sounds.TILE.COAL_CRUMBLE)
