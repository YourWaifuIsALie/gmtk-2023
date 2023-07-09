extends Control


func _ready() -> void:
	GlobalSignals.button_confirm.connect(_begin_game)
	GlobalSignals.scene_switch.connect(_switch_scene)
	
	self.hide()

func _switch_scene(name: String) -> void:
	if name == "character_creator":
		self.show()

func _begin_game() -> void:
	if $LineEdit.text != "":
		GlobalVariables.DISPLAY_NAMES["mc"] = $LineEdit.text
	else:
		$LineEdit.text = GlobalVariables.DISPLAY_NAMES["mc"]
	GlobalSignals.transition_start.emit()
	await GlobalSignals.transition_wait
	self.hide()
	GlobalSignals.transition_finish.emit()
	GlobalSignals.event_load.emit("test")
	await GlobalSignals.transition_wait
	GlobalSignals.event_begin.emit("test")
