extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var take_damage_sound: AudioStreamPlayer2D = $TakeDamage
@onready var health_bar: Node2D = $HealthBar


const SPEED = 150.0

var is_alive:bool = true
var target = null
var health: int = 100
const KNOCKBACK_FORCE: int = 200

			
			
func _physics_process(delta: float) -> void:
	if is_alive and target:
		_attack(delta)

func _attack(delta: float) -> void:
	var direction = (target.position - position).normalized()
	position += direction * SPEED * delta
	
	if animated_sprite_2d.is_playing() and animated_sprite_2d.animation.begins_with("hurt"):
		return
	play_animation("walk", direction)
	
func take_damage(damage: int, attacker_position: Vector2) -> void:
	health -= damage
	health_bar.update_health(health)
	if health <= 0:
		_die(attacker_position)
	else:
		play_animation("hurt", -attacker_position)
		take_damage_sound.play()
		#Knockback
		var knockback_direction = (position - attacker_position).normalized()
		var target_position = position + knockback_direction * KNOCKBACK_FORCE
	
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position", target_position, 0.5)
	
func _die(position) -> void:
	is_alive = false
	health_bar.remove_die()
	play_animation("death", -position)
	
	take_damage_sound.pitch_scale = 0.5
	take_damage_sound.play()
	
	#Disable Collision
	$CollisionShape2D.set_deferred("disabled", true)
	$Sight/CollisionShape2D.set_deferred("disabled", true)
	
	
	
func play_animation(prefix: String, direction) -> void:
		if direction.x > 0 && direction.x > direction.y:
			animated_sprite_2d.play(prefix + "_right")
		elif direction.x < 0 && direction.x < direction.y:
			animated_sprite_2d.play(prefix + "_left")
		elif direction.y < 0 && direction.y < direction.x:
			animated_sprite_2d.play(prefix + "_up")
		elif direction.y > 0:
			animated_sprite_2d.play(prefix + "_down")

func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body
		
func _on_sight_body_exited(body: Node2D) -> void:
	if body.name == "Player" and is_alive:
		target = null
		animated_sprite_2d.play("idle")
