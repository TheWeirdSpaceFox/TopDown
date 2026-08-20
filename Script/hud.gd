extends CanvasLayer
var player
@onready var fade_overlay: ColorRect = $FadeOverlay


@onready var red: TextureProgressBar = $red

func set_player(p) -> void:
	player = p
	if player:
		player.health_change.connect(update_health)
		update_health(player.health)

func update_health(new_health: int) -> void:
	red.value = new_health
	
func fade(to_alpha: float) -> void:
	var tween:= create_tween()
	tween.tween_property(fade_overlay, "modulate:a", to_alpha, 1.5)
	await tween.finished
	
