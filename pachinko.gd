extends Node

const WIN_PROB_NORMAL = 1.0 / 349.9
const WIN_PROB_RUSH = 1.0 / 99.9
const RUSH_ENTRY_PROB = 0.55
const RUSH_CONTINUE_PROB = 0.77

var rush_continue_count = 0
var overflow_damage = 0
var current_rush_shot = 0  # ⭐ 러쉬 중 누적 발사량

@export var Epic = null  # 인스펙터 연결 or 코드 연결용

func get_overflow_damage():
	return max(0, overflow_damage)

func check_win(main):
	var win_chance = WIN_PROB_RUSH if main.in_rush else WIN_PROB_NORMAL
	if randf() < win_chance:
		apply_round_win(main)

func apply_round_win(main):
	var is_10r = randf() < 0.5
	var damage = 1500 if is_10r else 300
	var gain = damage

	main.enemy_hp -= damage
	main.ball += gain

	# 오버플로 데미지 기록
	var expected_hp = main.Enemy.calculate_enemy_hp(main.stage)
	overflow_damage = min(abs(main.enemy_hp), expected_hp) if main.enemy_hp < 0 else 0

	# ⭐ 러쉬 중 누적 발사량 기록
	if main.in_rush:
		current_rush_shot += damage

	# 러쉬 처리
	if not main.in_rush:
		if randf() < RUSH_ENTRY_PROB:
			main.in_rush = true
			main.rush_spins = 145
			rush_continue_count = 0
			current_rush_shot = damage  # ⭐ 러쉬 시작 시 초기화 후 첫 데미지 누적
			print("RUSH START!")
	else:
		if randf() >= RUSH_CONTINUE_PROB:
			# ⭐ 러쉬 종료 시 최고 기록 반영 시도
			if Epic.try_update_record(current_rush_shot):
				print("🚨 NEW EPIC WEAPON ACQUIRED! 🚨")
				print(Epic.get_status_text())
			main.in_rush = false
			main.rush_spins = 0
			rush_continue_count = 0
			current_rush_shot = 0
			print("RUSH END")
		else:
			main.rush_spins = 145
			rush_continue_count += 1
			var msg = "RUSH CONTINUE!" if rush_continue_count == 1 else "RUSH CONTINUE! X %d!" % rush_continue_count
			print(msg)

	main.update_ui()
