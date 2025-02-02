extends Control

var box_scene = preload("res://scenes/world/generated/inventory_item.tscn")

func _ready() -> void:
	update(InventoryManager.get_inventory())
	InventoryManager.inventory_change.connect(update)
	
func update(inventory) -> void:
	for child in get_children():
		if child.is_in_group("inventory_box"):
			child.queue_free()
			
	position.x = (get_viewport_rect().size.x - 500) / 2
	for i in range(0, 10):
		var box = box_scene.instantiate()
		
		var node: Control = box.get_child(0)
		node.position.x = i * 50
		
		if inventory.size() > i:
			var item = inventory[i]
			var item_sprite: Sprite2D = node.get_child(0).get_child(1)
			item_sprite.texture = load("res://assets/ui/%s-icon.png" % [item["type"]])
			
			var label: Label = node.get_child(1).get_child(0)
			label.text = "%s" % [item["amount"]]
		
		add_child(box)
		
