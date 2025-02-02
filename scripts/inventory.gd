extends Node

var inventory: Dictionary = {}

func add_item(item_name: String, amount: int = 1):
	if item_name in inventory:
		inventory[item_name] += amount
	else:
		inventory[item_name] = amount

func remove_item(item_name: String, amount: int = 1):
	if item_name in inventory:
		inventory[item_name] -= amount
		if inventory[item_name] <= 0:
			inventory.erase(item_name)  # Remove if amount reaches 0

func get_items() -> Dictionary:
	return inventory

func has_item(item_name: String) -> bool:
	return item_name in inventory

func get_item_amount(item_name: String) -> int:
	return inventory.get(item_name, 0)
