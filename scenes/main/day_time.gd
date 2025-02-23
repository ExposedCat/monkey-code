extends Node

const MIN_LIGHT = 0.3
const DAY_LENGTH = 60 * 1_000

var time_offset = 0

func _ready() -> void:
	time_offset = DAY_LENGTH - Time.get_ticks_msec()

func get_time() -> float:
	var period = 2 * DAY_LENGTH
	var mod = (Time.get_ticks_msec() + time_offset) % period
	return mod if mod <= DAY_LENGTH else period - mod

func _process(_delta: float) -> void:
	var light_value = clamp(get_time() / float(DAY_LENGTH), MIN_LIGHT, 1.0)
	$Light.color = Color(light_value, light_value, light_value)
