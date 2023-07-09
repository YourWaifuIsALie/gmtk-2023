extends Control


func _ready() -> void:
	GlobalSignals.button_play.connect(_begin_game)


func _process(delta: float) -> void:
	pass

func _begin_game() -> void:
	# TODO character creator first
	GlobalSignals.transition_start.emit()
	await GlobalSignals.transition_wait
	self.hide()
	GlobalSignals.transition_finish.emit()
	GlobalSignals.event_load.emit("test")
	await GlobalSignals.transition_wait
	GlobalSignals.event_begin.emit("test")
