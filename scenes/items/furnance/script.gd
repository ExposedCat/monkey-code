extends Node2D

@onready var sprite = $AnimatedSprite2D

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if sprite.animation == "cooking":
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:
		var loaded = InventoryManager.player.remove_item("stone", 1)
		if not loaded:
			return
		sprite.play("cooking")
		await get_tree().create_timer(1).timeout
		sprite.play("standing")
		Wallet.player_money.change(10)
