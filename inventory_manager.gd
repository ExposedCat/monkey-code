extends Node

signal inventory_change(inventory)

var inventory = []

func add_item(item):
	var added = false
	for slot in inventory:
		if slot["amount"] < 10:
			slot["amount"] += 1
			added = true
			break
			
	if not added:
		if inventory.size() == 10:
			return
		inventory.append(item)
	
	inventory_change.emit(inventory)

func remove_item(item):
	inventory.erase(item)
	inventory_change.emit(inventory)

func get_inventory():
	return inventory
