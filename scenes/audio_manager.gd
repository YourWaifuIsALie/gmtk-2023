extends Control

@export var talk_effects_high: Array[AudioStreamWAV] = []
@export var talk_effects_mid: Array[AudioStreamWAV] = []

var is_talking: bool = false
var is_instant: bool = false
var previous_effect_buffer: Array = []
var current_effect_index: int = 0
var current_talk_effect: String = "mid"
var current_pitch: float = 1.0
var talk_count: int = 0
var talk_count_max: int = 10

func _ready() -> void:
	GlobalSignals.audio_start_talk.connect(self._handle_start_talk)
	GlobalSignals.audio_stop_talk.connect(self._handle_stop_talk)
	GlobalSignals.configured_global_variables.connect(_handle_global_variables)
	
	$AudioStreamPlayer.finished.connect(self._handle_end_talk_effect)
	
	self._handle_global_variables()

func _handle_global_variables() -> void:
	if GlobalVariables.text_speed == "instant":
		self.is_instant = true
	else:
		self.is_instant = false

func _handle_end_talk_effect() -> void:
	self.talk_count += 1
	if self.is_instant and self.talk_count >= self.talk_count_max:
		self.is_talking = false
	
	if self.is_talking:
		self._play_random_talk_effect()

func _play_random_talk_effect() -> void:
	var talk_effects
	match(self.current_talk_effect):
		"high":
			talk_effects = self.talk_effects_high
		"mid":
			talk_effects = self.talk_effects_mid
		"": # No audio
			self.is_talking = false
			self.talk_count = self.talk_count_max
			return
	
	# Don't repeat sounds
	var new_index = randi() % len(talk_effects)
	while new_index in self.previous_effect_buffer:
		new_index = randi() % len(talk_effects)
	self.previous_effect_buffer.append(new_index)
	if len(self.previous_effect_buffer) > 10:
		self.previous_effect_buffer.pop_front()
		
	$AudioStreamPlayer.stream = talk_effects[new_index]
	$AudioStreamPlayer.pitch_scale = self.current_pitch
	$AudioStreamPlayer.play()

func _handle_start_talk(type: String, pitch: float, length: int = 0) -> void:
	# For instant effects, play length dictated by text length
	if length != 0:
		self.talk_count_max = clampi(length/5, 1, length)
	
	self.current_talk_effect = type
	self.current_pitch = pitch
	self.previous_effect_buffer = []
	self.is_talking = true
	self.talk_count = 0
	self._play_random_talk_effect()
	
func _handle_stop_talk() -> void:
	self.is_talking = false
	self.talk_count = self.talk_count_max
