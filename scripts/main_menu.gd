extends Control


func _ready() -> void:
	GlobalSignals.button_play.connect(_begin_game)

	GlobalSignals.audio_start_music.emit("happy")

func _begin_game() -> void:
	GlobalSignals.transition_start.emit()
	await GlobalSignals.transition_wait
	self.hide()
	GlobalSignals.transition_finish.emit()
	GlobalSignals.scene_switch.emit("character_creator")
