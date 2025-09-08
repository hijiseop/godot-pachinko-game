extends Node

func calculate_enemy_hp(stage_num):
	var base_hp = 100
	if stage_num <= 30:
		base_hp += (stage_num - 1) * 5
	elif stage_num <= 70:
		base_hp = 250 + pow(stage_num - 30, 1.5) * 3
	else:
		base_hp = 700 + pow(stage_num - 70, 2) * 2

	if stage_num % 10 == 0:
		base_hp *= 2

	return int(base_hp)
