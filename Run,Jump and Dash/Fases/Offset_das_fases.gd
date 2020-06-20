extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var camera
export var offsetx = 0
export var offsety = 0
export var align = false
export var zoom = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_parent().get_node("Camera2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		if align:
			camera.global_position = $Camera_align.global_position
			camera.align = true
		camera.Stage_Offset.x = offsetx
		camera.Stage_Offset.y = offsety
		camera.set_zoom(Vector2(zoom,zoom))


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		camera.Stage_Offset.x = 0
		camera.Stage_Offset.y = 0
		camera.set_zoom(Vector2(1,1))
		if camera.align:
			camera.align = false
