extends Camera3D

@export var buffer: Vector3 = Vector3(0, 8, 8)
@export var smooth_speed: float = 2.0

var base_position: Vector3

func _enter_tree() -> void:
	SignalHub.new_platform.connect(_on_new_platform)
	
func _ready() -> void:
	base_position = position

func _process(delta: float) -> void:
	position = position.lerp(base_position, smooth_speed * delta)

func _on_new_platform(platform_pos: Vector3) -> void:
	base_position = platform_pos + buffer
