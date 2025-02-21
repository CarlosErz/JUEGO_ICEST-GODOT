extends Label

func animate_and_queue_free():
	$AnimationPlayer.play("Fade_out")
	$AnimationPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))
	print("ANIMACION INICIADA")

func _on_animation_finished(anim_name: String) -> void:
	queue_free()
