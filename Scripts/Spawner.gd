extends Node

@export var platform_scene: Array[PackedScene]

@onready var platform_island: Platform = $PlatformIsland

const OFFSET_UP: Vector2 = Vector2(2.5, 5.0)
const OFFSET_SIDE: Vector2 = Vector2(1.5, 3.5)

func _ready() -> void:
	SignalHub.emit_spawner_loaded(platform_island.position.y)

func _enter_tree() -> void:
	SignalHub.new_platform.connect(_on_new_platform)

func get_random_offset(offset_range: Vector2) -> float:
	if randf() < 0.5:
		return randf_range(-offset_range.y, -offset_range.x)
	else:
		return randf_range(offset_range.x, offset_range.y)

func spawn_platform(old_platform_pos: Vector3) -> void:
	
	if platform_scene.size() == 0:
		return

	var platform_scene = platform_scene.pick_random()
	var new_platform: Platform = platform_scene.instantiate()
	
	var new_y: float = randf_range(OFFSET_UP.x, OFFSET_UP.y)
	var new_x: float = get_random_offset(OFFSET_SIDE)
	var new_z: float = get_random_offset(OFFSET_SIDE)
	
	new_platform.position = old_platform_pos + Vector3(new_x, new_y, new_z)
	add_child(new_platform)
	#new_platform.new_platform.connect(_on_new_platform)

func _on_new_platform(platform_pos: Vector3) -> void:
	spawn_platform(platform_pos)
