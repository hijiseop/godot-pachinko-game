extends Node

# === 최고 기록 저장 ===
var max_recorded_shot = 0

# 무기 이름 목록 (원하는 이름으로 바꿔도 됨)
var weapon_names = [
	"None",
	"Starter Blade",
	"Sharp Fang",
	"Dragon Slayer",
	"Legendary Cannon",
	"Godhand Blaster",
	"Celestial Destroyer",
	"Ultimate Reaper",
	"Epic Omega Core",
	"Final Eclipse",
	"Hyper Nova"
]

# 현재 무기 레벨 계산 (10,000 발 단위)
func get_weapon_level():
	return min(max_recorded_shot / 10000, 10) as int

# 현재 무기 이름 반환
func get_weapon_name():
	return weapon_names[get_weapon_level()]

# Attack 보너스 반환 (+5 단위, 최대 +50)
func get_attack_bonus():
	return get_weapon_level() * 5

# 확률 보너스 % 반환 (5만 발부터 시작, 1만 발당 1% 추가, 최대 10%)
func get_chance_bonus():
	if max_recorded_shot < 50000:
		return 0.0
	var extra_percent = 0.05 + 0.01 * floor((max_recorded_shot - 50000) / 10000.0)
	return min(extra_percent, 0.10)

# 기록 갱신 시도 (레벨업일 때만 true 반환)
func try_update_record(new_shot_count):
	if new_shot_count > max_recorded_shot:
		var previous_level = get_weapon_level()
		max_recorded_shot = new_shot_count
		if get_weapon_level() > previous_level:
			return true  # 레벨업 했을 때만 true 반환
	return false


# 현재 상태 출력 (디버그 or UI 연결용)
func get_status_text():
	return "Max Shot: %d\nWeapon: %s\nAttack Bonus: +%d\nChance Bonus: %.0f%%" % [
		max_recorded_shot,
		get_weapon_name(),
		get_attack_bonus(),
		get_chance_bonus() * 100.0
	]
