extends Node

func start_panic_mode(main):
	main.get_node("PanicTimer").start()

func handle_panic_timeout(main):
	print("타임오버! 실패")
	main.get_tree().paused = true
