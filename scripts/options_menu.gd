extends Control

var is_open: bool = false

func _ready() -> void:
	GlobalSignals.button_options.connect(_toggle_menu)
	
	$Menu.hide()

func _toggle_menu() -> void:
	self.is_open = !self.is_open
	if is_open:
		$Menu.show()
	else:
		$Menu.hide()
