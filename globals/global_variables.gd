## Loaded via autoload for global signal access 
extends Node

var DISPLAY_NAMES: Dictionary = {"mc": "Vee",
								"pc": "You",
								"thought": "",
								"trendy": "Eyy",
								"athletic": "Bee",
								"smart": "Sea",
								"manager": "Manager",
								"": ""}
								
var SPEAKER_TYPES: Dictionary = {"mc": "mid",
								"pc": "high",
								"thought": "",
								"trendy": "high",
								"athletic": "mid",
								"smart": "high",
								"manager": "mid",
								"": ""}
								
var SPEAKER_PITCHES: Dictionary = {"mc": 1.00,
									"pc": 1.00,
									"thought": 0.00,
									"trendy": 1.10,
									"athletic": 0.95,
									"smart": 1.05,
									"manager": 1.10,
									"": 0.00}

var text_speed: String = "normal"
var music_volume: int = 3
var text_volume: int = 3

var flags = {}

func _ready() -> void:
	GlobalSignals.configured_options.connect(_handle_options)
	
func _handle_options(text_speed: String, music_volume: int, text_volume: int) -> void:
	self.text_speed = text_speed
	self.music_volume = music_volume
	self.text_volume = text_volume
	GlobalSignals.configured_global_variables.emit()
