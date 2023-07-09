extends Node

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSignals.click_empty.emit()
