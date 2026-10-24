extends "res://source/ui/intents/intent.gd"
class_name ProverbPalaceCustomIntent

const COUNTER_INTENT = 9054823042389
const GLASS_INTENT = 698452945823
const COUNTER_INTENT_TEXTURE = preload("res://mods/proverbpalace/arte/intents/counter_intent.png")
const GLASS_INTENT_TEXTURE = preload("res://mods/proverbpalace/arte/intents/glass_intent.png")
const INTENTS = preload("res://arte/ui/intents.png")

func update_sprite():
	(sprite).hframes = 1
	(sprite).vframes = 1
	if intent == COUNTER_INTENT:
		sprite.texture = COUNTER_INTENT_TEXTURE
	elif intent == GLASS_INTENT:
		sprite.texture = GLASS_INTENT_TEXTURE
	else:
		(sprite).hframes = 8
		(sprite).vframes = 9
		sprite.texture = INTENTS
		super()

func get_key() -> String:
	if intent == COUNTER_INTENT:
		return "counter"
	if intent == GLASS_INTENT:
		return "glass"
	return super()
