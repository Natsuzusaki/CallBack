extends Area2D

@export_multiline var base_text: String
@export_multiline var existing_code: String
@export_multiline var fixed_var: String

@onready var player: CharacterBody2D = null
@onready var camera: Camera2D = null
@onready var label: Label = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var code_edit: CodeEdit = $Control/Panel/MarginContainer/VBoxContainer/CodeEdit
@onready var pop_up_animation: AnimationPlayer = $"PopUp Animation"
@onready var control: Control = $Control
@onready var text_validator: Node2D = $TextValidator

var valid := false 
var restart_text := false
var button_pressed := false
var value = null

signal print_value()

func _ready() -> void:
	if not player:
		player = get_tree().get_current_scene().find_child("Player")
	if not camera:
		camera = get_tree().get_current_scene().find_child("Camera")
	label.text = fixed_var
	code_edit.placeholder_text = base_text

#WAS my greatest dissapointments, but now i love it!
func execute_code(user_code: String) -> void:
	var script = GDScript.new()
	var formatted_code = text_validator.auto_indentation(user_code)
	var full_script = """
extends Node
%s

var console: Node
func _init(real_console):
	console = real_console

func custom_print(message):
	if console:
		console.value = message
	else:
		print('Error! something is wrong')

func run():
%s
""" % [fixed_var, formatted_code]
	print(full_script) #debug
	if formatted_code.is_empty():
		return
	script.set_source_code(full_script)
	var error = script.reload()
	if error != OK:
		label.text = "Script Error! \n IDK where tho 😋"
	else:
		var instance = script.new(self)
		add_child(instance)
		if instance.has_method("run"):
			instance.call("run")
			instance.queue_free()
		if not value and not value == 0:
			value = null
		else:
			emit_signal("print_value", value)

#Terminal Interactions
func _on_button_pressed() -> void:
	player.stay = true
	var user_code = code_edit.text
	if user_code.is_empty():
		label.text = "Nothing to print!"
	else:
		execute_code(user_code)
func _on_exit_pressed() -> void:
	player.stay = false
	camera.back()
	button_pressed = true
	pop_up_animation.play("pop_down")
	await pop_up_animation.animation_finished
	control.hide()
func _on_body_entered(body: Node2D) -> void:
	label.text = fixed_var
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
	label.text = fixed_var
	player.stay = true
	camera.console = self
	camera.interact = true
	camera.stay()
func _on_code_edit_focus_exited() -> void:
	player.stay = false
func _on_code_edit_lines_edited_from(from_line: int, to_line: int) -> void:
	if restart_text:
		label.text = fixed_var
		restart_text = false
