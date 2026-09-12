extends Area2D

@export var item_name: String = "Stone"
@export var amount: int = 1
@export var move_speed: float = 400.0
@export var magnet_acceleration: float = 12.0

var target_player: CharacterBody2D = null
var is_being_pulled: bool = false

@onready var magnet_area: Area2D = $MagnetArea

func _ready() -> void:
	# Connect collision signals via code or Node tab
	body_entered.connect(_on_pickup_touch)
	magnet_area.body_entered.connect(_on_magnet_area_body_entered)
	
	# Initial bounce pop animation when spawned
	pop_out_animation()

func _physics_process(delta: float) -> void:
	# If the player is in range, move toward them
	if is_being_pulled and is_instance_valid(target_player):
		# Smoothly accelerate toward the player's position
		global_position = global_position.lerp(
			target_player.global_position, 
			magnet_acceleration * delta
		)
		
func pop_out_animation() -> void:
	var random_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var drop_target = global_position + (random_dir * 30.0)
	
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", drop_target, 0.25)

# Called when the player enters the larger MagnetArea
func _on_magnet_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "Player":
		target_player = body
		is_being_pulled = true

# Called when the player touches the smaller PickupArea (center)
func _on_pickup_touch(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "Player":
		collect_item(body)

func collect_item(player: Node2D) -> void:
	# Option A: Send item to a global Inventory/Stats Manager
	if Engine.has_singleton("InventoryManager"):
		# InventoryManager.add_item(item_name, amount)
		pass
	
	# Option B: Call a method directly on the player
	if player.has_method("add_resource"):
		player.add_resource(item_name, amount)
		
	print("Picked up %d x %s!" % [amount, item_name])
	
	# Play sound / particles here before freeing if desired
	queue_free()
