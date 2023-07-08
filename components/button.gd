extends BaseButton

@export var signal_target: String = "unset"

func _ready() -> void:
	self.pressed.connect(self._button_pressed)

func _button_pressed() -> void:
	print(signal_target)
	GlobalSignals.emit(signal_target)
