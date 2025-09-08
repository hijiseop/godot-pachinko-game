extends Node

func handle_attack(main):
	if main.enemy_hp <= 0:
		return

	if not main.get_node("PanicTimer").is_stopped():
		var bonus_damage = 1 + main.Epic.get_attack_bonus()
		main.enemy_hp -= bonus_damage
		print("ATTACK DAMAGE:", bonus_damage)
		main.update_ui()
		if main.enemy_hp <= 0:
			main.finish_stage(false)
