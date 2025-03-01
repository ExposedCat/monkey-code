extends StaticBody2D

var hp: int = 3
var is_dead = false

var final_punch = preload("res://assets/audio/stone-crash.mp3")
var punches = [
	preload("res://assets/audio/stone-punch-1.mp3"),
	preload("res://assets/audio/stone-punch-2.mp3"),
	preload("res://assets/audio/stone-punch-3.mp3")
]

func _ready() -> void:
	add_to_group("hittable")


func interact(inventory: InventoryManager.Inventory):
	if not is_dead:
		hp -= 1
		is_dead = hp == 0
		
		inventory.add_item("stone", 1)
		
		if not is_dead:
			$Sprite2D.region_rect = Rect2((3 - hp) * 30, 0, 30, 32)
		$"../Hit".stream = final_punch if is_dead else punches.pick_random()
		$"../Hit".play()
		$"../Effects".play("die" if is_dead else "hit")


func _on_animation_finished(animation_name: StringName) -> void:
	if animation_name == "die":
			queue_free()
