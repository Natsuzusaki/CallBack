extends Area2D

@export_multiline var base_text: String
@export_multiline var existing_code: String
@export_multiline var header: String

@onready var player: CharacterBody2D = null
@onready var camera: Camera2D = null
@onready var label: Label = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var code_edit: CodeEdit = $Control/Panel/MarginContainer/VBoxContainer/CodeEdit
@onready var pop_up_animation: AnimationPlayer = $"PopUp Animation"
@onready var control: Control = $Control

const TEMP_SCRIPT_PATH = "user://temp_script.gd"

var restart_text := false
var button_pressed := false

func _ready() -> void:
	if not player:
		player = get_tree().get_current_scene().find_child("Player")
	if not camera:
		camera = get_tree().get_current_scene().find_child("Camera")
	label.text = header
	code_edit.placeholder_text = base_text

func _on_button_pressed() -> void: #must pass value through signals and create a text instance
	var user_code = code_edit.text
	if user_code.contains('print(') or user_code.ends_with(')'):
		execute_code(user_code)
	elif user_code == "":
		label.text = "Nothing to print!"
		restart_text = true
	else:
		label.text = 'Error: must have \n->print("")<-'
		code_edit.text = ""
		restart_text = true

func execute_code(user_code: String) -> void:
	var script := GDScript.new()
	var formatted_code = auto_indentation(user_code)
	var full_script = """
extends Node
%s

func run():
%s
""" % [header, formatted_code]
	print(full_script)
	script.set_source_code(full_script)
	var error = script.reload()
	if error == OK:
		var instance = script.new()
		add_child(instance)
		if instance.has_method("run"):
			instance.run()
			instance.queue_free()
	else:
		print("Error in script execution")

func auto_indentation(user_code: String) -> String:
	var indented_lines = []
	var lines = user_code.split("\n")
	var indentation_level = 1
	
	for line in lines:
		var stripped = line.strip_edges()
		if stripped.begins_with("else") or stripped.begins_with("elif") or stripped.begins_with("if") or stripped.begins_with("for") or stripped.begins_with("while"):
			indentation_level = max(1, indentation_level -1)
		indented_lines.append("\t".repeat(indentation_level) + stripped)
		if stripped.ends_with(":"):
			indentation_level += 1
	return "\n".join(indented_lines)

func _on_exit_pressed() -> void:
	camera.back()
	button_pressed = true
	pop_up_animation.play("pop_down")
	await pop_up_animation.animation_finished
	control.hide()

func _on_body_entered(body: Node2D) -> void:
	label.text = header
	if not button_pressed:
		control.show()
		pop_up_animation.play("pop_up")
func _on_body_exited(body: Node2D) -> void:
	if not button_pressed:
		pop_up_animation.play("pop_down")
	else:
		control.show()
		button_pressed = false

func _on_code_edit_focus_entered() -> void:
	player.stay = true
	camera.console = self
	camera.interact = true
	camera.stay()
func _on_code_edit_focus_exited() -> void:
	player.stay = false

func _on_code_edit_lines_edited_from(from_line: int, to_line: int) -> void:
	if restart_text:
		label.text = header
		restart_text = false
