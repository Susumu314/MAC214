extends Control


onready var power_bar = $PowerBar
onready var update_tween = $Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_power_updated(power):
	if (power < power_bar.value):
		update_tween.interpolate_property(power_bar, "value", power_bar.value, power, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		update_tween.start()
	else:
		power_bar.value = power

func _on_max_power_updated(max_power):
	power_bar.max_value = max_power
