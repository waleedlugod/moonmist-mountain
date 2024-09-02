extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D

const TILE_SIZE = 16
var speed = 0.2
var is_moving = false
var is_sliding = false
var facing = Vector2()


func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if is_sliding: direction = facing

	# If not currently moving
	if not is_moving:
		# If move direction is not idle and not diagonal
		if direction != Vector2.ZERO and (direction.x == 0 || direction.y == 0):
			attempt_move(direction)
		# Play idle animation
		else: animated_sprite.play("%s_idle" % facing_to_string())

# Determine behavior of movement attempt
func attempt_move(direction: Vector2) -> void:
	# Face target direction
	facing = direction

	# Create ray cast at target position
	var space_state = get_world_2d().direct_space_state
	var global_target_position = global_position + facing * TILE_SIZE
	var query = PhysicsRayQueryParameters2D.create(
		global_position, global_target_position
		)
	query.set_hit_from_inside(true)

	# Get all colliding objects at target position
	var collisions = []
	var collisions_exceptions = []
	while true:
		var collision = space_state.intersect_ray(query)
		if not collision: break
		if collision["collider"].name != name: collisions.append(collision)
		collisions_exceptions.append(collision["rid"])
		query.set_exclude(collisions_exceptions)


	# Determine if player will slide, be blocked by wall, or can freely move
	# Initial behavior (free movement)
	var is_walkable = true
	is_sliding = false
	speed = 0.2
	animated_sprite.set_speed_scale(1)
	for collision in collisions:
		match collision["collider"].name:
			"Objects", "Slime", "Player":
				is_walkable = false
				is_sliding = false
				break
			# Wet ground (sliding)
			"Background" when collision.position != global_position:
				is_sliding = true
			"Plants":
				speed = 0.8
				animated_sprite.set_speed_scale(0.5)


	if is_walkable: move(global_target_position)
	else: animated_sprite.play("%s_idle" % facing_to_string())

# Move player to target position
func move(global_target_position: Vector2) -> void:
	is_moving = true

	# Tween to new position
	var move_tween = create_tween()
	move_tween.tween_property(
		self,
		"global_position",
		global_target_position,
		speed,
		).set_trans(Tween.TRANS_LINEAR)
	move_tween.tween_callback(func(): is_moving = false)

	# Play walk animation
	var walk_animation = "%s_walk" % facing_to_string()
	if animated_sprite.animation != walk_animation:
		animated_sprite.play(walk_animation)

# Convert facing Vector2 to string usable for setting animation
func facing_to_string() -> String:
	match facing:
		Vector2.UP: return "up"
		Vector2.DOWN: return "down"
		Vector2.LEFT: return "left"
		Vector2.RIGHT: return "right"
		_: return "down"
