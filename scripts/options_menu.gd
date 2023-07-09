extends Control

const TEXT_SPEED_OPTIONS: Array[String] = ["slow", "normal", "fast", "instant"]

var is_open: bool = false
var text_speed_index: int = 1

func _ready() -> void:
	GlobalSignals.button_options.connect(_toggle_menu)
	
	self.text_speed_index = TEXT_SPEED_OPTIONS.find(GlobalVariables.text_speed)
	
	$Menu/TextSpeed.value_changed.connect(_handle_text_speed_value)
	$Menu/TextSpeed.set_value(self.TEXT_SPEED_OPTIONS[self.text_speed_index])
	$Menu/TextSpeed.value_min = 0
	$Menu/TextSpeed.value_max = len(self.TEXT_SPEED_OPTIONS) - 1
	$Menu/TextSpeed.value = self.text_speed_index
	
	$Menu/MusicVolume.value_changed.connect(_handle_music_volume)
	$Menu/TextVolume.value_changed.connect(_handle_text_volume)
	
	$Menu.hide()

func _handle_music_volume(value: int) -> void:
	if value == 0:
		$Menu/MusicVolume.set_value("Off")
	else:
		$Menu/MusicVolume.set_value(str(value))
	GlobalSignals.configured_options.emit(GlobalVariables.text_speed, 
										value, 
										GlobalVariables.text_volume)
											
func _handle_text_volume(value: int) -> void:
	if value == 0:
		$Menu/TextVolume.set_value("Off")
	else:
		$Menu/TextVolume.set_value(str(value))
	GlobalSignals.configured_options.emit(GlobalVariables.text_speed, 
										GlobalVariables.music_volume, 
										value)

func _handle_text_speed_value(value: int) -> void:
	self.text_speed_index = clampi(value, 0, len(self.TEXT_SPEED_OPTIONS) - 1)
	var text_speed = self.TEXT_SPEED_OPTIONS[self.text_speed_index]
	$Menu/TextSpeed.set_value(text_speed)
	GlobalSignals.configured_options.emit(text_speed, 
										GlobalVariables.music_volume, 
										GlobalVariables.text_volume)

func _toggle_menu() -> void:
	self.is_open = !self.is_open
	if is_open:
		$Menu.show()
		GlobalSignals.options_opened.emit()
	else:
		$Menu.hide()
		
		GlobalSignals.options_closed.emit()
