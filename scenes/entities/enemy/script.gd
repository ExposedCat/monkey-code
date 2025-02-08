extends CharacterBody2D

@onready var navigation = $NavigationAgent2D
@onready var player: CharacterBody2D

@export var speed = 50
@export var following = false
@export var target: StaticBody2D = null

var inventory = InventoryManager.Inventory.new()

var set_follow__js = JavaScriptBridge.create_callback(set_follow)
func set_follow(args):
	if get_instance_id() == args[0]:
		following = args[1]
		
var set_attack__js = JavaScriptBridge.create_callback(set_attack)
func set_attack(args):
	if get_instance_id() == args[0]:
		var instance = instance_from_id(args[1])
		if instance:
			target = instance.get_child(0)
		
var set_give__js = JavaScriptBridge.create_callback(set_give)
func set_give(args):
	if get_instance_id() == args[0]:
		if player.global_position.distance_to(global_position) <= 50:
			var type = args[1]
			var amount = args[2]
			if inventory.has_item(type, amount):
				var fits = InventoryManager.player.add_item(type, amount)
				if fits:
					inventory.remove_item(type, amount)

func _enter_tree() -> void:
	player = get_node("../../Player")
	Bridge.register_event("enemy:follow", set_follow__js)
	Bridge.register_event("enemy:attack", set_attack__js)
	Bridge.register_event("enemy:give", set_give__js)
	Bridge.dispatch_event("enemy:spawned", {
		"id": get_instance_id()
	})

func _physics_process(_delta: float) -> void:
	if target != null and not is_instance_valid(target):
		target = null
	
	var stand = func():
		$AnimatedSprite2D.play("standing")
		velocity = Vector2.ZERO

	if following or target != null:
		if target:
			following = false
		navigation.target_position = player.global_position if following else target.global_position
		if navigation.distance_to_target() > 50:
			$AnimatedSprite2D.play("moving")
			var next_position = navigation.get_next_path_position()
			var direction = (next_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
		else:
			if target:
				if target.has_method("hit"):
					target.hit(inventory)
				else:
					target = null
			stand.call()
	else:
		stand.call()
