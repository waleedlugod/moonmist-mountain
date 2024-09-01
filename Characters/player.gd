extends CharacterBody2D


const TILE_SIZE = 16
const SPEED = 0.2
var is_moving = false
var is_sliding = false
var facing = Vector2()


func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if is_sliding: direction = facing

	# Attempt to move in direction
	if not is_moving \
	and direction != Vector2.ZERO \
	and (direction.x == 0 || direction.y == 0):
		# Face target direction
		facing = direction

		# Get the interactable objects at the target position
		var space_state = get_world_2d().direct_space_state
		var query_target = PhysicsPointQueryParameters2D.new()
		query_target.position = global_position + direction * TILE_SIZE
		var collisions = space_state.intersect_point(query_target)

		# Determine if player will slide, be blocked by wall, or can freely
		# move
		var is_can_move = true
		is_sliding = false
		for collision in collisions:
			if collision["collider"].name == "Middleground":
				is_can_move = false
				break
			elif collision["collider"].name == "Background": is_sliding = true

		if is_can_move: move(query_target.position)

# Move player to target position
func move(target_position: Vector2) -> void:
	is_moving = true
	var move_tween = create_tween()
	move_tween.tween_property(
		self,
		"position",
		target_position,
		SPEED
		).set_trans(Tween.TRANS_LINEAR)
	move_tween.tween_callback(func(): is_moving = false)
