extends Enemy


func _init():
	next_move = "move_a"

	moves = {
		move_a = {
			damage = {
				0: 1, 
				1: 2, 
				2: 3, 
			}, 
			next = "move_b", 
		}, 
		move_b = {
			poison = {
				0: 1, 
				1: 2, 
				3: 3, 
			}, 
			next = "move_a", 
		}, 
	}


func display_intent():
	if next_move == "move_a":
		add_intent(Intent.ATTACK, {damage = moves.move_a.damage})

	elif next_move == "move_b":
		add_intent(Intent.APPLY_STATUS, {status = TileStatus.POISON, count = moves.move_b.poison})


func move_a():
	anim_player.play("attack")

	await sprite.hit
	deal_damage(player, moves.move_a.damage)

	await anim_player.animation_finished


func move_b():
	var apply_to = tile_board.get_tiles({
		amount = moves.move_b.poison, 
		effect_priority = EFFECT_PRIORITY.STATUS_ONLY, 
	})

	anim_player.play("attack")

	await sprite.hit
	for tile in apply_to:
		tile.add_status(TileStatus.POISON)

	await anim_player.animation_finished
