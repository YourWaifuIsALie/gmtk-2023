## Loaded via autoload for global signal access 
extends Node

var DISPLAY_NAMES: Dictionary = {"mc": "Vee",
								"pc": "You",
								"pc_thought": "",
								"trendy": "Eyy",
								"athletic": "Bee",
								"smart": "Sea",
								"": ""}
								
var SPEAKER_TYPES: Dictionary = {"mc": "mid",
								"pc": "high",
								"pc_thought": "",
								"trendy": "high",
								"athletic": "mid",
								"smart": "high",
								"": ""}
								
var SPEAKER_PITCHES: Dictionary = {"mc": 1.00,
									"pc": 1.00,
									"pc_thought": 0.00,
									"trendy": 1.10,
									"athletic": 0.95,
									"smart": 1.05,
									"": 0.00}

var text_speed: String = "fast"

func _ready() -> void:
	GlobalSignals.configured_options.connect(_handle_options)
	
func _handle_options(text_speed: String) -> void:
	self.text_speed = text_speed
	GlobalSignals.configured_global_variables.emit()
