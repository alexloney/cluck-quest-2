extends Area2D

@export var message: Story.STORY_ITEM

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer/MarginContainer/Label.text = Story.get_story(message)
	connect("area_entered", on_area_entered)
	connect("area_exited", on_area_exited)
	
	call_deferred("center_panel")

func center_panel() -> void:
	var width = $PanelContainer.size.x
	var height = $PanelContainer.size.y
	$PanelContainer.global_position.x = global_position.x - width / 2
	$PanelContainer.global_position.y = global_position.y - height - 10

func on_area_entered(foreign_body: Area2D) -> void:
	$AnimationPlayer.play("fade_in")

func on_area_exited(foreign_body: Area2D) -> void:
	$AnimationPlayer.play("fade_out")
