# 🎮 Godot Pachinko-Style Auto Battle Game

A 2D auto-battle game inspired by pachinko mechanics, built with **Godot Engine 4.x**.  
This project demonstrates stage progression, rush mode probabilities, and a fully automated battle system.

---

## 🕹️ Features
- **Auto Battle System**: Battles progress automatically without player input.  
- **Stage Progression**: Difficulty increases each stage, with a boss every 10 stages.  
- **Weapon Evolution**: Weapons upgrade every 10,000 shots.  
- **Pachinko Rush System**:  
  - Separate normal / rush probabilities  
  - Multi-round sequences (2R, 10R)  
  - Rush mode persistence and support spins  

---

## 📂 Project Structure
```plaintext
godot-pachinko-game/
 ├─ project.godot          # Godot project settings
 ├─ main/
 │   ├─ MainUI.tscn        # Main UI scene
 │   ├─ main.gd            # Root script
 │   ├─ attack_logic.gd    # Attack mechanics
 │   ├─ enemy.gd           # Enemy logic
 │   ├─ rush_logic.gd      # Rush system
 │   ├─ panic_logic.gd     # Panic timer & mode
 │   ├─ pachinko.gd        # Pachinko probability logic
 │   └─ epic.gd            # Epic system logic
 ├─ scenes/
 │   └─ Enemy.tscn         # Enemy scene
 ├─ scripts/
 │   └─ Control.gd         # Shared UI control
 ├─ README.md
 ├─ LICENSE
 └─ .gitignore

## 📊 Main UI Layout
```plaintext
MainUI
 ├─ PanicTimer
 ├─ SpinTimer
 ├─ MainLayout
 │   ├─ TopArea
 │   │   ├─ LeftPanel
 │   │   │   └─ LeftContent
 │   │   │       ├─ EnemyStatsLabel
 │   │   │       ├─ EnemyHealthCol
 │   │   │       ├─ EnemyDisplay
 │   │   │       └─ PlayerDisplay
 │   │   ├─ RightPanel
 │   │   └─ PauseLabel
 │   ├─ BottomArea
 │   │   └─ PlayerStatsLabel
 │   └─ ActionContainer
 │       ├─ AttackButton
 │       ├─ SpinButton
 │       └─ PauseButton

