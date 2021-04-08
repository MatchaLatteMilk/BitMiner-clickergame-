extends KinematicBody2D

onready var label = $Label
var velocity = Vector2.ZERO

func _process(delta):
	velocity.y -= 3
	velocity = move_and_slide(velocity)

func _on_Timer_timeout():
	self.queue_free()
