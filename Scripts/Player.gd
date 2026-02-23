extends CharacterBody3D

class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var land_effect: AudioStreamPlayer3D = $LandEffect
@onready var fallen: AudioStreamPlayer3D = $Fallen

var last_landed: float = 0.0

const GRAVITY: float = 20.0
const JUMP_FORCE: float = 15.0
const ROTATION_SPEED: float = 5.0
const MOVE_SPEED: float = 5.0
const LAND_BUFFER: float = 1.0
const FALLEN_OF_TH: float = -20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _enter_tree() -> void:
	SignalHub.spawner_loaded.connect(_on_spawner_loaded)

func _physics_process(delta: float) -> void:
	handle_rotation(delta)
	handle_gravity(delta)
	handle_movement()
	move_and_slide()
	handle_animation()

func handle_rotation(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		rotate_y(ROTATION_SPEED * delta)
	if Input.is_action_pressed("ui_right"):
		rotate_y(-ROTATION_SPEED * delta)
	
func handle_movement() -> void:
	var dir: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		dir = transform.basis.z
	velocity.x = dir.x * MOVE_SPEED
	velocity.z = dir.z * MOVE_SPEED
	
func handle_gravity(delta: float) -> void:
	if is_on_floor():
		velocity.y = JUMP_FORCE
		if position.y > last_landed:
			land_effect.play()
			last_landed = position.y + LAND_BUFFER
	else:
		velocity.y -= GRAVITY * delta

func handle_animation() -> void:
	if velocity.y >= 0:
		animation_player.play("jump")
	else:
		animation_player.play("fall")
		if velocity.y < FALLEN_OF_TH and !fallen.playing:
			fallen.play()
		
func _on_spawner_loaded(y_pos: float) -> void:
	last_landed = y_pos - LAND_BUFFER * 2
