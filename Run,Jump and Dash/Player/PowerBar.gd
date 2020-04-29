extends Control


onready var power_bar = $PowerBar
onready var under_power_bar = $UnderPowerBar
onready var update_tween = $Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_power_updated(power, amount):
	power_bar.value = power
	update_tween.interpolate_property(under_power_bar, "value", under_power_bar.value, power, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()

func _on_max_power_updated(max_power):
	under_power_bar.max_value = max_power
	power_bar.max_value = max_power
