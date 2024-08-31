extends CharacterBody2D


const TILE_SIZE = 16
const SPEED = 0.2
var is_moving = false


func _process(_delta: float) -> void:
	move(Input.get_vector("left", "right", "up", "down"))

func move(input_direction: Vector2) -> void:
	# attempt to move if not currently moving and is a valid direction
	if not is_moving \
	and input_direction != Vector2.ZERO \
	and (input_direction.x == 0 || input_direction.y == 0):
		# determine target position
		var target_position = position + input_direction * TILE_SIZE

		# move to new position
		is_moving = true
		var move_tween = create_tween()
		move_tween.tween_property(
			self,
			"position",
			target_position,
			SPEED
			).set_trans(Tween.TRANS_LINEAR)
		move_tween.tween_callback(func(): is_moving = false)
