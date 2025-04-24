extends CharacterBody2D

@export var speed = 50
@export var hit_cooldown: float = 1000.0
@export var following = false

@onready var navigation = $NavigationAgent2D
@onready var sprite = $AnimatedSprite2D
@onready var jump_sound = $"../Jump"
@onready var player: CharacterBody2D

var last_hit = 0;

var last_action = "standing"
var target: StaticBody2D = null
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
	Bridge.register_event("monkey:follow", set_follow__js)
	Bridge.register_event("monkey:attack", set_attack__js)
	Bridge.register_event("monkey:give", set_give__js)
	Bridge.dispatch_event("monkey:spawned", {
		"id": get_instance_id()
	})

func play_action():
	sprite.play("monkey-%s" % [last_action])

func _ready() -> void:
	play_action()

func set_action(new_action: StringName):
	if last_action != new_action:
		last_action = new_action
		play_action()
		match new_action:
			"moving":
				jump_sound.play()
			"standing":
				jump_sound.stop()

func stand():
	set_action("standing")
	velocity = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if target and not is_instance_valid(target):
		target = null

	if following or target:
		navigation.target_position = target.global_position if target else player.global_position
		if navigation.distance_to_target() > 50:
			set_action("moving")
			var next_position = navigation.get_next_path_position()
			var direction = (next_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
		else:
			if target and Time.get_ticks_msec() - last_hit >= hit_cooldown:
				last_hit = Time.get_ticks_msec()
				velocity = Vector2.ZERO
				target.interact(inventory)
			stand()
	else:
		stand()
