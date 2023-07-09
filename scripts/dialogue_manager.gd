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

var character_nodes: Array = []

var is_finished_talking: bool = false

func _ready() -> void:
	GlobalSignals.event_begin.connect(_handle_event_begin)
	GlobalSignals.event_load.connect(_handle_event_load)
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
	$TextLeftName.hide()
	$TextRightBox.hide()
	$TextRightName.hide()
	$Text.text = ""
	
	# Could iterate over child nodes and match but whatever
	self.character_nodes.append($CharacterFarLeft)
	self.character_nodes.append($CharacterLeft)
	self.character_nodes.append($CharacterRight)
	self.character_nodes.append($CharacterFarRight)
	for node in self.character_nodes:
		node.hide()
	
	self.change_speed(GlobalVariables.text_speed)

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
	
func _continue_event() -> void:
	self.current_page_index += 1
	self.current_page = self.current_pages[self.current_page_index]
	self.current_page_type = self.current_pages[self.current_page_index]["type"]
	
	if "speaker" in self.current_page.keys():
		self.current_speaker = self.current_page["speaker"]
	else:
		self.current_speaker = ""
		
	if "background" in self.current_page:
		self._change_background(self.current_page["background"])
		
	if "actors" in self.current_page:
		self._change_actors(self.current_page["actors"])
	
	var speaker_type = GlobalVariables.SPEAKER_TYPES[self.current_speaker]
	var speaker_pitch = GlobalVariables.SPEAKER_PITCHES[self.current_speaker]
	
	var length = 0
	if self.dialogue_step == 0.0:
		length = len(self.current_page["text"])
	
	self.draw_text(self.current_page["text"])
	GlobalSignals.audio_start_talk.emit(speaker_type, speaker_pitch, length)

func _handle_click_empty() -> void:
	if self.current_page_type == "text":
		self._continue_event()

func _change_background(name: String) -> void:
	$Background.texture = self.bg_dictionary[name]

func _change_actors(actors: Array) -> void:
	for node in self.character_nodes:
		node.hide()
		
	for actor in actors:
		for actor_name in actor.keys(): # Should only be one name
			var pos = actor[actor_name]["pos"]
			var dir = actor[actor_name]["dir"]
			var emote = actor[actor_name]["emote"]
			
			var character_node: Character
			match(pos):
				"left":
					character_node = $CharacterLeft
				"fleft":
					character_node = $CharacterFarLeft
				"right":
					character_node = $CharacterRight
				"fright":
					character_node = $CharacterFarRight
			character_node.change_body(actor_name)
			character_node.change_expression(emote)
			character_node.change_facing(dir)
			character_node.show()
			
			if actor_name == self.current_speaker:
				match(pos):
					"left", "fleft":
						self.current_speaking_side = "left"
					"right", "fright":
						self.current_speaking_side = "right"
		

func draw_text(text: String, speaker: String = "", direction: String = "") -> void:
	$Text.text = ""
	self.target_text = text
	self.current_text_index = 0
	self.is_finished_talking = false
	
	if speaker == "":
		speaker = self.current_speaker
	
	if direction == "":
		direction = self.current_speaking_side
	
	$TextLeftName.text = "[center]" + GlobalVariables.DISPLAY_NAMES[speaker] + "[/center]"
	$TextRightName.text = "[center]" + GlobalVariables.DISPLAY_NAMES[speaker] + "[/center]"
	
	if direction == "left":
		$TextLeftBox.show()
		$TextLeftName.show()
		$TextRightBox.hide()
		$TextRightName.hide()
	else:
		$TextLeftBox.hide()
		$TextLeftName.hide()
		$TextRightBox.show()
		$TextRightName.show()
