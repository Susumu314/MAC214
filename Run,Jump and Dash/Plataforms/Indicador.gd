extends Sprite

const MARGIN = Vector2(24, 24)
var plataforma
var camera_position
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	plataforma = self.get_parent()

func _process(delta):
	if plataforma.is_offscreen():
		camera_position = PlayerInfo.camera_position
		self.global_position.x = camera_position.x + clamp(plataforma.global_position.x - camera_position.x, -screen_size.x/2 + MARGIN.x, screen_size.x/2 - MARGIN.x)
		self.global_position.y = camera_position.y + clamp(plataforma.global_position.y - camera_position.y, -screen_size.y/2 + MARGIN.y, screen_size.y/2 - MARGIN.y)
		self.show()
	else:
	  self.hide()
