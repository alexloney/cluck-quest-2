extends Camera2D

@export var background_color: Color

var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	RenderingServer.set_default_clear_color(background_color)

func _process(delta: float) -> void:
	aquire_target_position()
	
	global_position = lerp(target_position, global_position, pow(2, -15 * delta))

func aquire_target_position() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		target_position = player.global_position
		
