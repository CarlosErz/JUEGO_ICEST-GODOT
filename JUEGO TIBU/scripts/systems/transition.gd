extends ColorRect

@onready var animation_player = $AnimationPlayer

func transition_to(scene_path: String) -> void:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene_path)
	animation_player.play("fade_out")
