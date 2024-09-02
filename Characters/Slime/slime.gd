extends "res://Characters/Player/player.gd"


@onready var timer = $Timer

const DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var direction = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if is_sliding: direction = facing

	# If not currently moving
	if not is_moving:
		# If move direction is not idle and not diagonal
		if direction != Vector2.ZERO and (direction.x == 0 || direction.y == 0):
			attempt_move(direction)
			direction = Vector2.ZERO
		# Play idle animation
		else: animated_sprite.play("%s_idle" % facing_to_string())

func _on_timer_timeout():
	direction = DIRECTIONS[randi() % DIRECTIONS.size()]
