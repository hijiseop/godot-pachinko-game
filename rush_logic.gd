extends Node

func enter_rush(main):
	main.in_rush = true
	main.rush_spins = 145
	main.update_ui()

func exit_rush(main):
	main.in_rush = false
	main.rush_spins = 0
	main.update_ui()

func handle_rush_spin(main):
	main.rush_spins -= 1
	if main.rush_spins <= 0:
		exit_rush(main)
