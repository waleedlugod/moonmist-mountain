extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D

const TILE_SIZE = 16
const SPEED = 0.2
var is_moving = false
var is_sliding = false
var facing = Vector2()


func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if is_sliding: direction = facing

	# Attempt to move in direction if not currently moving and direction
	# is in cardinal directions
	if not is_moving:
		if direction != Vector2.ZERO \
		and (direction.x == 0 || direction.y == 0):
			attempt_move(direction)
		else:
			animated_sprite.play("%s_idle" % facing_to_string())

# Determine behavior of movement attempt
func attempt_move(direction: Vector2) -> void:
	# Face target direction
	facing = direction

	# Get the colliding objects at the target position
	var space_state = get_world_2d().direct_space_state
	var query_target = PhysicsPointQueryParameters2D.new()
	query_target.position = global_position + direction * TILE_SIZE
	var collisions = space_state.intersect_point(query_target)

	# Determine if player will slide, be blocked by wall, or can freely move
	# Initial behavior set for free movement
	var is_walkable = true
	is_sliding = false
	for collision in collisions:
		match collision["collider"].name:
			"StaticWalls":
				is_walkable = false
				is_sliding = false
			"Ice":
				is_walkable = true
				is_sliding = true

	if is_walkable: move(query_target.position)

# Move player to target position
func move(target_position: Vector2) -> void:
	is_moving = true

	# Tween to new position
	var move_tween = create_tween()
	move_tween.tween_property(
		self,
		"position",
		target_position,
		SPEED
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
		_: return ""
