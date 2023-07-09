class_name Character
extends Node2D

# We should have a fancy directory-scanning load process
#   But for the jam just do it all manually ez-pz
static var mc = preload("res://assets/sprites/mc/mc.tres")
static var mc_exp_neutral = preload("res://assets/sprites/mc/mc_exp_neutral.tres")
static var pc = preload("res://assets/sprites/pc/pc.tres")
static var pc_work = preload("res://assets/sprites/pc/pc_work.tres")
static var pc_exp_neutral = preload("res://assets/sprites/pc/pc_exp_neutral.tres")

var body_dictionary: Dictionary = {}
var expression_dictionary: Dictionary = {}

var current_body: String = "pc"
var current_expression: String = "neutral"
var is_flipped: bool = false

func _ready() -> void:
	self.body_dictionary["mc"] = self.mc
	self.body_dictionary["pc"] = self.pc
	self.body_dictionary["pc_work"] = self.pc_work
	
	self.expression_dictionary["mc"] = {}
	self.expression_dictionary["mc"]["neutral"] =  self.mc_exp_neutral
	self.expression_dictionary["pc"] = {}
	self.expression_dictionary["pc_work"] = {}
	self.expression_dictionary["pc"]["neutral"] =  self.pc_exp_neutral
	self.expression_dictionary["pc_work"]["neutral"] =  self.pc_exp_neutral

func change_body(name: String) -> void:
	if name in self.body_dictionary.keys():
		$Body.texture = self.body_dictionary[name]
		self.current_body = name
	else:
		$Body.texture = null
		self.current_body = "null"
	self.adjust_expression()
	
func change_expression(expression: String) -> void:
	if expression in self.expression_dictionary[self.current_body].keys():
		$Expression.texture = self.expression_dictionary[self.current_body][expression]
		self.current_expression = expression
	else:
		$Expression.texture = null
		self.current_expression = "null"
	self.adjust_expression()
	
func change_facing(dir: String) -> void:
	# Left-facing is default
	if dir == "left":
		$Expression.flip_h = false
		$Body.flip_h = false
		self.is_flipped = false
	else:
		$Expression.flip_h = true
		$Body.flip_h = true
		self.is_flipped = true
	self.adjust_expression()

func adjust_expression() -> void:
	# Manually adjust all the graphics here instead of in the art flow or via the editor
	match(self.current_body):
		"pc", "pc_work":
			if self.is_flipped:
				$Expression.position.x = 65
				$Expression.position.y = 90
			else:
				$Expression.position.x = 20
				$Expression.position.y = 90
		"mc":
			if self.is_flipped:
				$Expression.position.x = 85
				$Expression.position.y = 70
			else:
				$Expression.position.x = 40
				$Expression.position.y = 70
