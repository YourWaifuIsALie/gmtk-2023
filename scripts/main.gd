extends Node3D


func _init() -> void:
	print("Main Init")

func _ready() -> void:
	$CSGBox3D/AnimationPlayer.play("spin")
	print("Main Ready")

func _process(delta: float) -> void:
	pass
