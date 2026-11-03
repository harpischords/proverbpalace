extends Enemy

func _init():
	id = "gatekeeper"
	next_move = "ambiance"
	moves = {
		coagulate = {
			damage = 3,
			pairs = {
				0: 2,
				1: 3,
				2: 4,
				3: 5,
			},
			next = "ambiance",
		},
		ambiance = {
			next = "coagulate",
		},
	}
