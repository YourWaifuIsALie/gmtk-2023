extends Control

@export var talk_effects_high: Array[AudioStreamWAV] = []
@export var talk_effects_mid: Array[AudioStreamWAV] = []
@export var music_array: Array[AudioStreamMP3] = []

var music_index_dictionary: Dictionary = {"awkward": 0,
											"colorless": 1,
											"happy": 2,
											"depressed": 3,
											"neutral": 4}

var music_names: Dictionary = {"awkward": "Awkward Meeting",
								"colorless": "Colorless Aura",
								"happy": "Devonshire Waltz Allegretto",
								"depressed": "Sad Trio",
								"neutral": "Study And Relax"}
								
var music_adjustment: Dictionary = {"neutral": -3.0,
									"colorless": -3.0,
									"depressed": 6.0}

var is_talking: bool = false
var is_instant: bool = false
var is_in_menu: bool = false
var previous_effect_buffer: Array = []
var current_effect_index: int = 0
var current_talk_effect: String = "mid"
var current_pitch: float = 1.0
var talk_count: int = 0
var talk_count_max: int = 10
var music_tween: Tween

var music_volume: float = -10.0
var text_volume: float = 5.0

func _ready() -> void:
	GlobalSignals.audio_start_talk.connect(self._handle_start_talk)
	GlobalSignals.audio_stop_talk.connect(self._handle_stop_talk)
	GlobalSignals.audio_start_music.connect(self._handle_start_music)
	GlobalSignals.audio_stop_music.connect(self._handle_stop_music)
	GlobalSignals.options_opened.connect(self._handle_menu_opened)
	GlobalSignals.options_closed.connect(self._handle_menu_closed)
	GlobalSignals.configured_global_variables.connect(self._handle_global_variables)
	
	$TalkPlayer.finished.connect(self._handle_end_talk_effect)
	
	self._handle_global_variables()
	self._update_volume()
	

func _update_volume() -> void:
	var adjust = 0.0
	if self.is_in_menu:
		adjust = -3.0
	$MusicPlayer.volume_db = self.music_volume + adjust
	$TalkPlayer.volume_db = self.text_volume + adjust
	print("Music Volume: %s" % $MusicPlayer.volume_db)
	print("Text Volume: %s" % $TalkPlayer.volume_db)

func _handle_menu_opened() -> void:
	self.is_in_menu = true
	self._update_volume()

func _handle_menu_closed() -> void:
	self.is_in_menu = false
	self._update_volume()

func _handle_global_variables() -> void:
	if GlobalVariables.text_speed == "instant":
		self.is_instant = true
	else:
		self.is_instant = false
	match(GlobalVariables.music_volume):
		0:
			self.music_volume = -50.0
		1:
			self.music_volume = -20.0
		2:
			self.music_volume = -15.0
		3:
			self.music_volume = -10.0
		4:
			self.music_volume = -5.0
		5:
			self.music_volume = 0.0
	match(GlobalVariables.text_volume):
		0:
			self.text_volume = -50.0
		1:
			self.text_volume = -5.0
		2:
			self.text_volume = 0.0
		3:
			self.text_volume = 5.0
		4:
			self.text_volume = 10.0
		5:
			self.text_volume = 15.0
	self._update_volume()

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
		
	$TalkPlayer.stream = talk_effects[new_index]
	$TalkPlayer.pitch_scale = self.current_pitch
	$TalkPlayer.play()

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
	
func _handle_start_music(name: String) -> void:
	var adjustment = self.music_adjustment.get(name, 0.0)
	var next_music = self.music_array[self.music_index_dictionary[name]]
	$MusicName.text = "Playing: [i]" + self.music_names[name]
	if $MusicPlayer.playing:
		self._handle_stop_music()
		self.music_tween.tween_callback($MusicName.set_text.bind("Playing: [i]" + self.music_names[name]))
		self.music_tween.tween_callback($MusicPlayer.set_stream.bind(next_music))
		self.music_tween.tween_callback($MusicPlayer.set_volume_db.bind(self.music_volume + adjustment))
		self.music_tween.tween_callback($MusicPlayer.play)
	else:
		$MusicPlayer.set_stream(next_music)
		$MusicPlayer.play()

func _handle_stop_music() -> void:
	self.music_tween = create_tween()
	self.music_tween.tween_property($MusicPlayer, "volume_db", -50.0, 1.0)
	self.music_tween.tween_callback($MusicPlayer.stop)
	self.music_tween.tween_callback($MusicName.set_text.bind(""))
	
