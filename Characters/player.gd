extends CharacterBody2D


const TILE_SIZE = 16
const SPEED = 0.2
var is_moving = false


func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")

	if not is_moving \
	and direction != Vector2.ZERO \
	and (direction.x == 0 || direction.y == 0):
		# Query the target position if it is walkable
		var space_state = get_world_2d().direct_space_state
		var query_target = PhysicsPointQueryParameters2D.new()
		query_target.position = global_position + direction * TILE_SIZE
		var collision = space_state.intersect_point(query_target)

		if not collision: move(query_target.position)

# move player to target position
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
