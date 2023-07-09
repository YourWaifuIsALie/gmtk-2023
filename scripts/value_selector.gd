extends Control

signal value_changed(new_value: int)

@export var default_value_text: String = "Value"
@export var field_text: String = "Field:"
@export var value_max: int = 5
@export var value_min: int = 0
@export var value_default: int = 3
@export var is_dummy: bool = false

var value: int = 0

func _ready() -> void:
	$Up.pressed.connect(_handle_up)
	$Down.pressed.connect(_handle_down)
	
	$Label.text = self.default_value_text
	$Name.text = "[right]" + self.field_text + "[/right]"
	
	self.value = self.value_default

func set_value(value: String) -> void:
	$Label.text = "[center]" + value + "[/center]"

func _handle_up() -> void:
	self.value = clampi(self.value + 1, self.value_min, self.value_max)
	if self.is_dummy:
		self.set_value(str(self.value))
	else:
		self.value_changed.emit(self.value)
	
func _handle_down() -> void:
	self.value = clampi(self.value - 1, self.value_min, self.value_max)
	if self.is_dummy:
		self.set_value(str(self.value))
	else:
		self.value_changed.emit(self.value)
