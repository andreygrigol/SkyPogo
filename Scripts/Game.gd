extends Node


func _on_floor_body_entered(body: Node3D) -> void:
	if body is Player:
		get_tree().call_deferred("reload_current_scene")
