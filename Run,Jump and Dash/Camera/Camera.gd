extends Camera2D

var velocidade_offset = 10
var player
var deslocamento = Vector2(0,0)
var MAX_OFFSET = 240

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	pass # Replace with function body.


func _process(delta):
	if player.velocity.x > 0:
		deslocamento.x = min(deslocamento.x + velocidade_offset, MAX_OFFSET)
	if player.velocity.x < 0:
		deslocamento.x = max(deslocamento.x - velocidade_offset, -MAX_OFFSET)
	position = lerp(position,player.position + deslocamento, velocidade_offset*delta)
