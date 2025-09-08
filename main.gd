extends Control

@onready var Pachinko = preload("res://pachinko.gd").new()
@onready var RushLogic = preload("res://rush_logic.gd").new()
@onready var Enemy = preload("res://enemy.gd").new()
@onready var AttackLogic = preload("res://attack_logic.gd").new()
@onready var PanicLogic = preload("res://panic_logic.gd").new()
@onready var Epic = preload("res://epic.gd").new()


# === 상태 변수 ===
var enemy_hp = 1000
var ball = 100
var in_rush = false
var rush_spins = 0
var auto_spin = false
var stage = 1
var game_paused = false

# === 확률 설정 ===
const ENTER_PROB = 0.25

func _ready():
	Pachinko.Epic = Epic  # ✅ Pachinko가 Epic을 알도록 연결
	enemy_hp = Enemy.calculate_enemy_hp(stage)
	update_ui()
	var spin_timer = Timer.new()
	spin_timer.name = "SpinTimer"
	spin_timer.wait_time = 1.0
	spin_timer.one_shot = false
	spin_timer.autostart = false
	add_child(spin_timer)
	spin_timer.connect("timeout", Callable(self, "_on_SpinTimer_timeout"))
	$MainLayout/TopArea/PauseLabel.visible = false


func update_ui(show_epic_status := false):
	$MainLayout/TopArea/LeftPanel/LeftContent/EnemyStatsLabel.text = "ENEMY: %d" % enemy_hp
	var mode_text = "RUSH" if in_rush else "NORMAL"
	var rush_count_text = " / RUSH COUNT: %d" % rush_spins if in_rush else ""
	var extra_epic_text = "\n%s" % Epic.get_status_text() if show_epic_status else ""
	$MainLayout/BottomArea/PlayerStatsLabel.text = "STAGE: %d / BALL: %d / MODE: %s%s%s" % [
		stage, ball, mode_text, rush_count_text, extra_epic_text
	]


func _on_SpinButton_pressed():
	if not auto_spin:
		auto_spin = true
		$SpinTimer.start()

func _on_SpinTimer_timeout():
	if game_paused:
		return

	if ball <= 0:
		if enemy_hp > 0:
			start_panic_mode()
		stop_spin()
		return
	ball -= 1

	if in_rush:
		RushLogic.handle_rush_spin(self)

	var base_prob = ENTER_PROB
	var bonus_prob = Epic.get_chance_bonus()
	var actual_prob = 1 - (1 - base_prob) * (1 - bonus_prob)

	if randf() < actual_prob:
		enemy_hp -= 1
		Pachinko.check_win(self)
	update_ui()

	if enemy_hp <= 0:
		finish_stage(true)
		
	


func _on_StopButton_pressed():
	toggle_pause()

func toggle_pause():
	game_paused = !game_paused

	if game_paused:
		$SpinTimer.stop()
		$PanicTimer.stop()
		$MainLayout/TopArea/PauseLabel.visible = true
		$MainLayout/BottomArea/ActionContainer/PauseButton.text = "Resume"
		print("게임 일시정지됨")
	else:
		if auto_spin:
			$SpinTimer.start()
			print("게임 재개됨")
		if not $PanicTimer.is_stopped():
			$PanicTimer.start()
		$MainLayout/TopArea/PauseLabel.visible = false
		$MainLayout/BottomArea/ActionContainer/PauseButton.text = "Pause"

func stop_spin():
	$SpinTimer.stop()

func _on_AttackButton_pressed():
	AttackLogic.handle_attack(self)

func finish_stage(by_spin):
	var should_continue_spin = auto_spin
	stop_spin()
	$PanicTimer.stop()

	# ✅ 보상은 초기 enemy HP 기준
	var base_hp = Enemy.calculate_enemy_hp(stage)
	var reward = int(base_hp * 0.5) if by_spin else int(base_hp * 0.25)
	print("Stage %d Clear! Coin reward: %d" % [stage, reward])

	stage += 1
	var raw_enemy_hp = Enemy.calculate_enemy_hp(stage)
	print("Stage %d Base Enemy HP: %d" % [stage, raw_enemy_hp])

	enemy_hp = raw_enemy_hp - Pachinko.get_overflow_damage()
	if enemy_hp < 0:
		enemy_hp = 0

	print("New Stage %d Enemy HP (after overflow): %d" % [stage, enemy_hp])

	ball += reward
	update_ui()

	if should_continue_spin:
		$SpinTimer.start()
		auto_spin = true

func start_panic_mode():
	PanicLogic.start_panic_mode(self)

func _on_PanicTimer_timeout():
	PanicLogic.handle_panic_timeout(self)
