extends StaticBody2D

var hp: int = 3
var is_invincible = false


func _ready() -> void:
	add_to_group("hittable")


func hit(inventory: InventoryManager.Inventory):
	if not is_invincible:
		$"../Hit".play()
		is_invincible = true
		inventory.add_item("stone", 1)
		hp -= 1
		if hp != 0:
			$Sprite2D.region_rect = Rect2((3 - hp) * 30, 0, 30, 32)
		$"../Effects".play("die" if hp == 0 else "hit")


func _on_animation_finished(animation_name: StringName) -> void:
	match animation_name:
		"hit":
			is_invincible = false
		"die":
			queue_free()
