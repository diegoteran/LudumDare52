extends "res://pickups/pickup.gd"

func collect():
	# TODO Fix this when we have mosquitos or dashing
	ResearchManager.scorpion_tails += 1
	.collect()
