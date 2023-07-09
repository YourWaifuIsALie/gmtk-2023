extends Control

const TEXT_SPEED_OPTIONS: Array[String] = ["slow", "normal", "fast", "instant"]

var is_open: bool = false
var text_speed_index: int = 1

func _ready() -> void:
	GlobalSignals.button_options.connect(_toggle_menu)
	
	self.text_speed_index = TEXT_SPEED_OPTIONS.find(GlobalVariables.text_speed)
	
	$Menu/ValueSelector.value_changed.connect(_handle_text_speed_value)
	$Menu/ValueSelector.set_value(self.TEXT_SPEED_OPTIONS[self.text_speed_index])
	$Menu/ValueSelector.value_min = 0
	$Menu/ValueSelector.value_max = len(self.TEXT_SPEED_OPTIONS) - 1
	$Menu/ValueSelector.value = self.text_speed_index
	
	$Menu.hide()

func _handle_text_speed_value(value: int) -> void:
	self.text_speed_index = clampi(value, 0, len(self.TEXT_SPEED_OPTIONS) - 1)
	$Menu/ValueSelector.set_value(self.TEXT_SPEED_OPTIONS[self.text_speed_index])
	
func _toggle_menu() -> void:
	print("Toggle options menu")
	self.is_open = !self.is_open
	if is_open:
		$Menu.show()
	else:
		$Menu.hide()
		var text_speed = self.TEXT_SPEED_OPTIONS[self.text_speed_index]
		GlobalSignals.configured_options.emit(text_speed)
