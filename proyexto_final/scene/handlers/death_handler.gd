class_name DeathHandler
extends Node2D

@export var parent : Node = null


func death()-> void:
	parent.queue_free()
