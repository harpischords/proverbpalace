@tool
extends Marker2D


@export var approach_dist := 10.

@export var curve_scale := Vector2(10.,5.)
@export var curve_scale_secondary := Vector2(1.,.5)
@export var curve_looping_anim := true
@onready var hit_marker: Marker2D = $"../../HitMarker"
@onready var battle_unit_sprite: BattleUnitSprite = $"../.."

func _process(delta: float) -> void:
	if curve_looping_anim:
		parametric_curve_t += delta
	hit_marker.position = battle_unit_sprite.to_local(global_position)
func get_parametric_curve(t: float) -> Vector2:
	t /= PI/2.
	return (Vector2(
		cos(t),
		sin(2.*t)
	)*curve_scale).rotated(t/9.)*curve_scale_secondary

@export var parametric_curve_t: float :
	set(v):
		parametric_curve_t = v
		position = position.move_toward(get_parametric_curve(v),approach_dist)
