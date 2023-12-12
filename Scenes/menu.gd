class_name Menu
extends Control

#button
@onready var startButton = $MarginContainer/HBoxContainer/VBoxContainer/startButton as Button
@onready var exitButton = $MarginContainer/HBoxContainer/VBoxContainer/exitButton as Button

@onready var startLevel = preload("res://Scenes/main.tscn") as PackedScene

func _ready():
	startButton.button_down.connect(on_start_pressed)
	exitButton.button_down.connect(on_exit_pressed)


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(startLevel)


func on_exit_pressed() -> void:
	get_tree().quit()
