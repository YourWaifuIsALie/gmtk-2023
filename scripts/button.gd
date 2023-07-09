extends BaseButton

@export var signal_target: String = "unset"
@export var text: String = "Play"

var signal_value: String = ""

func _ready() -> void:
	$Label.text = "[center][b]" + self.text
	self.pressed.connect(self._button_pressed)

func _button_pressed() -> void:
	if self.signal_value != "":
		GlobalSignals.emit(signal_target, self.signal_value)
	else:
		GlobalSignals.emit(signal_target)

func change_text(text: String) -> void:
	self.text = text
	$Label.text = "[center][b]" + self.text
