extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var swing_sword: AudioStreamPlayer2D = $SwingSword
@onready var hitbox: Area2D = $Hitbox
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D

var SPEED = 300.0
var last_direction: Vector2 = Vector2.RIGHT
var is_attcking: bool = false
var hitbox_offset: Vector2

func _ready() -> void:
	#Initialise hitbox offset
	hitbox_offset = hitbox.position

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("attack") and not is_attcking:
		attack()
		
	# Skip movement if attacking
	if is_attcking:
		velocity = Vector2.ZERO
		return
		
	process_movement()
	process_animation()
	move_and_slide()

#------------------------------------------------------------------------------
# Animation And Movement
#------------------------------------------------------------------------------
func process_movement() -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left","right","up","down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
		update_hitbox_offset()
	else:
		velocity = Vector2.ZERO
			
	velocity = direction * SPEED
	
func process_animation() -> void:
	if is_attcking:
		return
	if velocity != Vector2.ZERO and Input.is_action_pressed("run"):
		SPEED = 600
		play_animation("run", last_direction)
	elif velocity != Vector2.ZERO:
		SPEED = 300
		play_animation("walk", last_direction)
	else:
		play_animation("idle", last_direction)

func play_animation(prefix: String, dir: Vector2) -> void:
		if dir.x > 0:
			animated_sprite_2d.play(prefix + "_right")
		elif dir.x < 0:
			animated_sprite_2d.play(prefix + "_left")
		elif dir.y < 0:
			animated_sprite_2d.play(prefix + "_up")
		elif dir.y > 0:
			animated_sprite_2d.play(prefix + "_down")
			
#------------------------------------------------------------------------------
# Attacking
#------------------------------------------------------------------------------

func attack() -> void:
	is_attcking = true
	# add more sounds either randomize or order one after the other
	swing_sword.play()
	play_animation("attack", last_direction)


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_attcking:
		is_attcking = false

#------------------------------------------------------------------------------
# Hitbox
#------------------------------------------------------------------------------

func update_hitbox_offset() -> void:
	
	match last_direction:
		Vector2.LEFT: 
			hitbox.position = Vector2(-54,-1.5)
			collision_shape_2d.position = Vector2 (-32, 10)
		Vector2.RIGHT:
			hitbox.position = Vector2(-54,-1.5)
			collision_shape_2d.position = Vector2 (140, 10)
		Vector2.UP: 
			hitbox.position = Vector2(57, -99)
			collision_shape_2d.position = Vector2 (-49.5, 33.5)
		Vector2.DOWN:
			hitbox.position = Vector2(57, -99)
			collision_shape_2d.position = Vector2 (-70, 160)
