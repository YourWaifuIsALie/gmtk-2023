extends Node2D

var bg_default = preload("res://assets/bg_default.png")
var bg_shop = preload("res://assets/bg_shop.png")
var bg_town = preload("res://assets/bg_town.png")

var bg_dictionary: Dictionary = {}  ## name: String -> ImageTexture

var events_dictionary: Dictionary = {} ## title: String -> event JSON

var time_count: float = 0.0
var dialogue_step: float = 0.05
var target_text: String = ""
var current_event_title: String = ""
var current_page_type: String = ""
var current_page_index: int = 0
var current_page: Dictionary = {}
var current_event: Array = []
var current_pages: Array = []
var current_text_index: int = 0
var current_speaker: String = ""
var current_speaking_side: String = "left"
var current_flag_results: Dictionary = {}

var character_nodes: Array = []
var choice_nodes: Array = []

var character_previous_positions: Dictionary = {}

var is_finished_talking: bool = false

func _ready() -> void:
	GlobalSignals.event_begin.connect(_handle_event_begin)
	GlobalSignals.event_load.connect(_handle_event_load)
	GlobalSignals.event_choice.connect(_handle_event_choice)
	GlobalSignals.configured_global_variables.connect(_handle_global_variables)
	GlobalSignals.click_empty.connect(_handle_click_empty)
	
	self.bg_dictionary["bg_default"] = ImageTexture.create_from_image(self.bg_default.get_image())
	self.bg_dictionary["bg_shop"] = ImageTexture.create_from_image(self.bg_shop.get_image())
	self.bg_dictionary["bg_town"] = ImageTexture.create_from_image(self.bg_town.get_image())
	
	var dir = DirAccess.open("res://events")
	for filename in dir.get_files():
		var file = FileAccess.open("res://events/" + filename, FileAccess.READ)
		if file:
			var data = JSON.parse_string(file.get_as_text())
			self.events_dictionary[data[0]["title"]] = data
			print("Loaded: %s" % [filename])
		else:
			print("No file: %s" % [filename])
	
	$Background.texture = self.bg_dictionary["bg_town"]
	$TextLeftBox.hide()
	$TextRightBox.hide()
	$Text.text = ""
	
	# Could iterate over child nodes and match but whatever
#	self.character_nodes.append($CharacterFarLeft)
#	self.character_nodes.append($CharacterLeft)
#	self.character_nodes.append($CharacterRight)
#	self.character_nodes.append($CharacterFarRight)
	self.character_nodes.append($FarLeftPath/FarLeftFollower/CharacterFarLeft)
	self.character_nodes.append($LeftPath/LeftFollower/CharacterLeft)
	self.character_nodes.append($RightPath/RightFollower/CharacterRight)
	self.character_nodes.append($FarRightPath/FarRightFollower/CharacterFarRight)
	for node in self.character_nodes:
		node.hide()
		
	self.choice_nodes.append($Option1)
	self.choice_nodes.append($Option2)
	self.choice_nodes.append($Option3)
	for node in self.choice_nodes:
		node.hide()
	
	self.change_speed(GlobalVariables.text_speed)

	# Testing exit animations
#	var tween = create_tween()
#	tween.tween_property($Path2D/PathFollow2D, "progress_ratio", 1.0, 1.0)
#	tween.tween_callback($Path2D/PathFollow2D.set_progress_ratio.bind(0.0))
#	tween.tween_callback($Path2D/PathFollow2D.set_progress_ratio.bind(1.0))
#	tween.tween_property($Path2D/PathFollow2D, "progress_ratio", 0.0, 1.0)

func _process(delta: float) -> void:
	if self.dialogue_step == 0.0:
		self.time_count = 0.0
		if $Text.text != self.target_text:
			$Text.text = self.target_text
	else:
		time_count += delta
		if time_count > self.dialogue_step:
			time_count -= self.dialogue_step
			
			if not self.is_finished_talking and $Text.text == self.target_text:
				self.is_finished_talking = true
				GlobalSignals.audio_stop_talk.emit()
				return
			elif self.is_finished_talking:
				return
				
			var char = self.target_text[self.current_text_index]
			# Read one whole symbol
			#   This will cause slow-down (since only a symbol and no char is loaded)
			#   but is quicker to implement than proper multi-symbol reading
			if char in ["[", "]"]:
				var jump_symbol = 0
				if self.target_text[self.current_text_index + 1] == "/":
					jump_symbol = 4
				else:
					jump_symbol = 3
				char = self.target_text.substr(self.current_text_index, jump_symbol)
				self.current_text_index += jump_symbol - 1
			$Text.text += char
			self.current_text_index += 1

func change_speed(value: String) -> void:
	if value == "normal":
		self.dialogue_step = 0.02
	elif value == "fast":
		self.dialogue_step = 0.001
	elif value == "slow":
		self.dialogue_step = 0.04
	elif value == "instant":
		self.dialogue_step = 0.0

func _handle_global_variables() -> void:
	self.change_speed(GlobalVariables.text_speed)

func _handle_event_choice(value: String) -> void:
	# Update flags
	var adjustments = self.current_flag_results[value]
	for flag_name in adjustments.keys():
		var current_value = GlobalVariables.flags.get(flag_name, 0) + adjustments[flag_name]
		GlobalVariables.flags[flag_name] = current_value
	
	self._continue_event()

func _handle_event_load(event_name: String) -> void:
	if event_name in self.events_dictionary.keys():
		self._load_event(event_name)
	else:
		print("Illegal load: %s" % [event_name])

func _handle_event_begin(event_name: String) -> void:
	if event_name in self.events_dictionary.keys():
		if self.current_event_title != event_name:
			self._load_event(event_name)
		self._continue_event()
	else:
		self.current_event_title = "illegal_event_name"
		self.draw_text("[b][i]Lorem Ipsum Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit... There is no one who loves pain.[/i][/b]")

func _load_event(event_name: String) -> void:
	var event = self.events_dictionary[event_name]
	var title = event[0]["title"]
	var reqs = ""
	if "reqs" in event[0].keys():
		reqs = event[0]["reqs"]
	
	var pages = []
	for i in range(0, len(event)):
		pages.append(event[i])
		
	self.current_event = event
	self.current_event_title = title
	self.current_pages = pages
	
	self.current_page_index = 0
	self.current_page = pages[0]
	self.current_page_type = "none"
	
	# Preload background before scene transition
	if "background" in pages[1]:
		self._change_background(pages[1]["background"])
		
	# Preload characters
	if "actors" in pages[1]:
		self._change_actors(pages[1]["actors"])

func _end_event() -> void:
	# Choose first event with filled requirements
	for event_name in self.current_page["branches"]:
		var is_event_valid = true
		var first_page = self.events_dictionary[event_name][0]
		var reqs = first_page.get("reqs", [])
		for req_dict in reqs:
			for flag_name in req_dict.keys():
				var base = GlobalVariables.flags.get(flag_name, 0)
				var op = req_dict[flag_name][0]
				var value = req_dict[flag_name][1]
#				print("%s %s %s" % [base, op, value])
				# Test if it fails
				match(op):
					">":
						if base <= value:
							is_event_valid = false
					">=":
						if base < value:
							is_event_valid = false
					"==":
						if base != value:
							is_event_valid = false
					"<":
						if base >= value:
							is_event_valid = false
					"<=":
						if base > value:
							is_event_valid = false
					"!=":
						if base == value:
							is_event_valid = false
#				print(is_event_valid)
		if is_event_valid:
			self._next_event(event_name)
			return
			
	# Nothing is valid, missed a safe default
	self._next_event("broken")

func _next_event(name: String) -> void:
	# TODO transition?
	self._load_event(name)
	self._continue_event()

func _continue_event() -> void:
	self.current_page_index += 1
	self.current_page = self.current_pages[self.current_page_index]
	self.current_page_type = self.current_pages[self.current_page_index]["type"]
	
	if self.current_page_type == "next":
		self._end_event()
	
	if "speaker" in self.current_page.keys():
		self.current_speaker = self.current_page["speaker"]
	else:
		self.current_speaker = ""
		
	var speaker_type = GlobalVariables.SPEAKER_TYPES[self.current_speaker]
	var speaker_pitch = GlobalVariables.SPEAKER_PITCHES[self.current_speaker]
		
	if "background" in self.current_page:
		self._change_background(self.current_page["background"])
		
	if "actors" in self.current_page:
		self._change_actors(self.current_page["actors"])
	
	if "music" in self.current_page:
		self._change_music(self.current_page["music"])
		
	if "choices" in self.current_page:
		self._change_choices(self.current_page["choices"])
		if "flags" in self.current_page:
			self.current_flag_results = self.current_page["flags"]
		else:
			self.current_flag_results = {}
	else:
		for node in self.choice_nodes:
			node.hide()
	
	if "text" in self.current_page:
		var length = 0
		if self.dialogue_step == 0.0:
			length = len(self.current_page["text"])
		
		self.draw_text(self.current_page["text"])
		GlobalSignals.audio_start_talk.emit(speaker_type, speaker_pitch, length)
	else:
		$TextLeftBox.hide()
		$TextRightBox.hide()
		$Text.text = ""

func _handle_click_empty() -> void:
	if self.current_page_type == "text":
		self._continue_event()

func _change_choices(choices: Dictionary) -> void:
	var count = 0
	for choice_name in choices.keys():
		var display_text = choices[choice_name]
		self.choice_nodes[count].signal_value = choice_name
		self.choice_nodes[count].change_text(display_text)
		self.choice_nodes[count].show()
		count += 1
		
func _change_background(name: String) -> void:
	$Background.texture = self.bg_dictionary[name]

func _change_music(name: String) -> void:
	if name == "":
		GlobalSignals.audio_stop_music.emit()
	else:
		GlobalSignals.audio_start_music.emit(name)

func _change_actors(actors: Array) -> void:
	var current_positions = {}
	var is_speaker_present = false
	
	for node in self.character_nodes:
		node.hide()
		
	for actor in actors:
		for actor_name in actor.keys(): # Should only be one name
			var pos = actor[actor_name]["pos"]
			var dir = actor[actor_name]["dir"]
			var emote = actor[actor_name]["emote"]
			
			var character_node: Character
			match(pos):
				"fleft":
					character_node = self.character_nodes[0]
				"left":
					character_node = self.character_nodes[1]
				"right":
					character_node = self.character_nodes[2]
				"fright":
					character_node = self.character_nodes[3]
			character_node.change_body(actor_name)
			character_node.change_expression(emote)
			character_node.change_facing(dir)
			character_node.show()
			current_positions[actor_name] = character_node
			
			if actor_name == self.current_speaker:
				match(pos):
					"left", "fleft":
						self.current_speaking_side = "left"
						is_speaker_present = true
					"right", "fright":
						self.current_speaking_side = "right"
						is_speaker_present = true
						
	# Actors entering the scene
	for actor_name in current_positions.keys():
		if actor_name not in self.character_previous_positions.keys():
			var follower = current_positions[actor_name].get_parent()
			follower.progress_ratio = 1.0
			create_tween().tween_property(follower, "progress_ratio", 0.0, 1.0)
	
	# Actors leaving the scene
	# Check if the speaker left as well
	for actor_name in self.character_previous_positions.keys():
		if actor_name not in current_positions.keys():
			self.character_previous_positions[actor_name].show()
			var follower = self.character_previous_positions[actor_name].get_parent()
			create_tween().tween_property(follower, "progress_ratio", 1.0, 1.0)
		if !is_speaker_present:
			if actor_name == self.current_speaker:
				if self.character_previous_positions[actor_name] == self.character_nodes[0] \
					or self.character_previous_positions[actor_name] == self.character_nodes[1]:
						self.current_speaking_side = "left"
				if self.character_previous_positions[actor_name] == self.character_nodes[2] \
					or self.character_previous_positions[actor_name] == self.character_nodes[3]:
						self.current_speaking_side = "right"
						
	self.character_previous_positions = current_positions

func draw_text(text: String, speaker: String = "", direction: String = "") -> void:
	$Text.text = ""
	self.target_text = text
	self.current_text_index = 0
	self.is_finished_talking = false
	
	if speaker == "":
		speaker = self.current_speaker
	
	if direction == "":
		direction = self.current_speaking_side
	
	$TextLeftBox/TextLeftName.text = "[center]" + GlobalVariables.DISPLAY_NAMES[speaker] + "[/center]"
	$TextRightBox/TextRightName.text = "[center]" + GlobalVariables.DISPLAY_NAMES[speaker] + "[/center]"
	
	if direction == "left":
		$TextLeftBox.show()
		$TextRightBox.hide()
	else:
		$TextLeftBox.hide()
		$TextRightBox.show()

