extends Node2D

@onready var health_bar: Sprite2D = $Health
@onready var default_width = health_bar.region_rect.size.x
@onready var default_height = health_bar.region_rect.size.y


func update_health(new_health: int) -> void:
	#resize health bar
	var new_width = (new_health / 100.0) * default_width
	health_bar.region_rect = Rect2(1, 1, new_width, default_height)

func remove_die() -> void:
	$HealthUnder.visible = false
	
