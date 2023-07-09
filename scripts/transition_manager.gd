extends Control


func _ready() -> void:
	GlobalSignals.transition_start.connect(self._start_transition)
	GlobalSignals.transition_finish.connect(self._finish_transition)
	$FadeBlack/AnimationPlayer.animation_finished.connect(_wait_transition)
	$FadeBlack/AnimationPlayer.play("FadeIn")

func _start_transition() -> void:
	$FadeBlack.mouse_filter = MOUSE_FILTER_STOP
	$FadeBlack/AnimationPlayer.play("FadeOut")

func _wait_transition(anim_name: String) -> void:
	GlobalSignals.transition_wait.emit()

func _finish_transition() -> void:
	$FadeBlack.mouse_filter = MOUSE_FILTER_IGNORE
	$FadeBlack/AnimationPlayer.play("FadeIn")
	
	

