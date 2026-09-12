extends StaticBody2D

var state = "whole" # "whole", "breaking", "broke"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var drop_point: Marker2D = $Marker2D
const STONE_DROP_SCENE = preload("res://Scene/drop_rock.tscn")

var health: int = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("rock")

func take_damage(amount: int = 1, _source_pos: Vector2 = Vector2.ZERO) -> void:
	health -= amount
	
	if health == 2:
		animated_sprite_2d.play("breaking")
	elif health <= 0:
		spawn_drop()
		queue_free()
		
func spawn_drop() -> void:
	if STONE_DROP_SCENE:
		var drop = STONE_DROP_SCENE.instantiate()
		drop.global_position = drop_point.global_position
		
		# pop/bounce out when spawned
		var random_offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
		drop.global_position += random_offset
		
		# Add drop to the current main level (parent of the rock)
		get_parent().add_child(drop)
