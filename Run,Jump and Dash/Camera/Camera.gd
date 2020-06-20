extends Camera2D

var velocidade_offset = 10
var player
var deslocamento = Vector2(0,0)
var MAX_OFFSET = 240
var Stage_Offset = Vector2(0,0)
var align = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	pass # Replace with function body.


func _process(delta):
	if player.velocity.x > 0:
		deslocamento.x = min(deslocamento.x + velocidade_offset, MAX_OFFSET)
	if player.velocity.x < 0:
		deslocamento.x = max(deslocamento.x - velocidade_offset, -MAX_OFFSET)
	if !align:
		position = lerp(position,player.position + deslocamento + Stage_Offset, velocidade_offset*delta)
	PlayerInfo.camera_position = self.global_position
