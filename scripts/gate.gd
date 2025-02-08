extends StaticBody2D

var y_pos := 0

func _ready() -> void:
	y_pos = position.y
	print(y_pos)
