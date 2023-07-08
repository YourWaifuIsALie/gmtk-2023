extends Node2D

var bg_default = Image.load_from_file("res://assets/bg_default.png")
var bg_shop = Image.load_from_file("res://assets/bg_shop.png")
var bg_town = Image.load_from_file("res://assets/bg_town.png")

var time_count: float = 0.0
var dialogue_step: float = 0.05
var target_text: String = ""
var current_text_index: int = 0

func _ready() -> void:
	GlobalSignals.event_begin.connect(_handle_event_begin)
	
	$Background.texture = ImageTexture.create_from_image(bg_shop)
	$TextLeftBox.hide()
	$TextLeftName.hide()
	$TextRightBox.hide()
	$TextRightName.hide()
	$Text.text = ""
	
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
			
			if $Text.text == self.target_text:
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

func _handle_event_begin(event_name: String) -> void:
	# TODO load and handle these correctly
	print("Handle event: %s" % [event_name])
	if event_name == "intro":
		self.draw_text("And here is a [b]bunch[/b] of text that we need to use to [b][i]simulate[/i][/b] some kind of text and hopefully it [i]can fit[/i] about three lines of bold and italics text in.")

func draw_text(text: String, direction: String = "left") -> void:
	$Text.text = ""
	self.target_text = text
	self.current_text_index = 0
	
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
