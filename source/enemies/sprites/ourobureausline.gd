@tool
extends Line2D

@export var reverse_draw_order := false
@export_range(1,60) var desired_distance_end := 30.
@export_range(1,60) var desired_distance_start := 30.
@export_range(0,5) var frame_offset := 0
@onready var head_marker: Marker2D = %HeadMarker


const GATEKEEPER_BOULDER = preload("res://mods/proverbpalace/arte/enemies/gatekeeper_boulder.png")
const FRAME_SIZE := Vector2(84,92)
const H_FRAME := 6
const V_FRAME := 5
const FRAME_COUNT := 30
func draw_boulder_at_point(frame: int, pos: Vector2, outline:=false):
	var source := Rect2(
			FRAME_SIZE*Vector2(
				frame%H_FRAME,
				frame/H_FRAME
			),FRAME_SIZE
		)
	draw_texture_rect_region(
		GATEKEEPER_BOULDER, Rect2(
			pos-FRAME_SIZE/2.,FRAME_SIZE
		),
		source,Color.BLACK if outline else Color.WHITE
	)
func _process(delta: float) -> void:
	queue_redraw()
	
	if !(head_marker.global_position == to_global(points[0])):
		set_point_position(0,to_local(head_marker.global_position))
	push_and_pull_points(1.)

func push_and_pull_points(delta:float) -> void:
	for i in len(points):
		var p = points[i]
		var p_previous = null
		var p_next = null
		if i > 0:
			p_previous = points[i-1]
		if i < len(points)-1:
			p_next = points[i+1]
		
		var momentum := Vector2.ZERO
		
		var t := inverse_lerp(i,0,len(points)-1)
		
		var push_back_percent := 0
		
		var fixed := i == 0
		if fixed:
			continue
		
		var desired_distance = lerp(desired_distance_start,desired_distance_end,t)
		
		if p_next:
			var diff: Vector2 = p_next-p
			var normal := diff.normalized()
			var dist = diff.length()
			var dist_diff = desired_distance - dist
			momentum -= normal*dist_diff*delta*push_back_percent
		if p_previous:
			var diff: Vector2 = p_previous-p
			var normal := diff.normalized()
			var dist = diff.length()
			var dist_diff = desired_distance - dist
			momentum -= (normal*dist_diff*delta)
		set_point_position(i, p + momentum)
	
	head_marker.global_position = to_global(points[0])
func _draw() -> void:
	var iterator = range(len(points)-1,-1,-1) if reverse_draw_order else range(len(points))
	for i in iterator:
		var t := inverse_lerp(0,len(points)-1,i)
		var frame := int(lerp(frame_offset,FRAME_COUNT-1,t))
		for offset in [Vector2.LEFT*2.,Vector2.RIGHT*2.,Vector2.UP*2.,Vector2.DOWN*2.,]:
			draw_boulder_at_point(frame, points[i]+offset,true)
		
	for i in iterator:
		var t := inverse_lerp(0,len(points)-1,i)
		var frame := int(lerp(frame_offset,FRAME_COUNT-1,t))
		
		draw_boulder_at_point(frame, points[i])
