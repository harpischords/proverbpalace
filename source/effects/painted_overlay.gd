@tool
extends Node2D
class_name PaintedOverlay
@onready var sprite: Sprite2D = $Sprite

@export var color : PaintedStatus.Colors :
	set(v):
		color = v
		if !is_node_ready():
			await ready
		sprite.modulate = PaintedStatus.get_color_value(v)
