extends CharacterBody2D

@export_category("Character")
@export var max_speed: int
@export var acceleration: int
@export var jump_velocity: int
@export var max_health: int
@export var current_health: int
@export var material_equipped: String

@export_category("Fire")
@export var fire_unlocked: bool
@export var max_fire_materials: int
@export var current_fire_materials: int

@export_category("Lightning")
@export var lightning_unlocked: bool
@export var max_lightning_materials: int
@export var current_lightning_materials: int

@export_category("Water")
@export var water_unlocked: bool
@export var max_water_materials: int
@export var current_water_materials: int

@onready var state_machine = $AnimationTree

var spell_mode := "attack" #determines what material does when used, can be attack or utility

var direction: float
var aim_direction: Vector2
var can_jump := true
var casting := false

@onready var material_equipped_amount: int
var material_equipped_max: int
var can_fireball := true

var friction: float

var fireball_scene = preload("res://scenes/projectiles/fireball/fireball.tscn")

func _ready() -> void:
	switch_material("fire")

func _physics_process(delta: float) -> void:
	#friction
	if is_on_floor():
		friction = 5
	else:
		friction = 10
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.

	if is_on_floor():
		can_jump = true
		
	if Input.is_action_pressed("jump") and can_jump:
		velocity.y = -jump_velocity
		if not $Timers/JumpTimer.time_left:
			$Timers/JumpTimer.start()
		
	if Input.is_action_just_released("jump"):
		velocity.y /= 3
		can_jump = false

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	if direction: #if directional input
		velocity.x += direction * acceleration * 0.3
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	#get aim direction
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		aim_direction = Input.get_vector("left", "right", "up", "down")
	else:
		if $Sprite2D.flip_h == true:
			aim_direction = Vector2(-1, 0)
		else:
			aim_direction = Vector2(1, 0)
	
	#switching spell mode
	if Input.is_action_just_pressed("switch-mode"):
		if spell_mode == "attack":
			spell_mode = "utility"
		if spell_mode == "utility":
			spell_mode = "attack"

	#switching materials
	if Input.is_action_just_pressed("cycle-spell-right"):
		match material_equipped:
			"fire":
				if lightning_unlocked:
					switch_material("lightning")
				elif water_unlocked:
					switch_material("water")
					
			"lightning":
				if water_unlocked:
					switch_material("water")
				elif fire_unlocked:
					switch_material("fire")
					
			"water":
				if fire_unlocked:
					switch_material("fire")
				elif lightning_unlocked:
					switch_material("lightning")
			
			
			
	if Input.is_action_just_pressed("cycle-spell-left"):
		match material_equipped:
			"fire":
				if water_unlocked:
					switch_material("water")
				elif lightning_unlocked:
					switch_material("lightning")
			
			"lightning":
				if fire_unlocked:
					switch_material("fire")
				elif water_unlocked:
					switch_material("water")
			
			"water":
				if lightning_unlocked:
					switch_material("lightning")
				elif fire_unlocked:
					switch_material("fire")
		
	#casting spells
	if Input.is_action_just_pressed("spell"):
		match spell_mode:
			"attack":
				match material_equipped:
					"fire":
						fireball()
					
					"lightning":
						lightning_bolt()
					
					"water":
						water_attack()
				
			"utility":
				pass
		
	
	#Flip player to direction they are moving
	if direction < 0:
		$Sprite2D.flip_h = true
	if direction > 0:
		$Sprite2D.flip_h = false
	
	#friction
	if friction:
		velocity.x = move_toward(velocity.x, 0, friction)
	move_and_slide()
	set_conditions()

func set_conditions():
	if casting:
		state_machine.set("parameters/conditions/casting", true)
	else:
		state_machine.set("parameters/conditions/casting", false)
	
	if direction == 0 and velocity == Vector2.ZERO:
		state_machine.set("parameters/conditions/idle", true)
	else:
		state_machine.set("parameters/conditions/idle", false)
	
	if !is_on_floor() and !casting:
		state_machine.set("parameters/conditions/jumping", true)
	else:
		state_machine.set("parameters/conditions/jumping", false)
	
	if is_on_floor():
		state_machine.set("parameters/conditions/landing", true)
	else:
		state_machine.set("parameters/conditions/landing", false)
	
	if is_on_floor() and velocity.x and !casting:
		state_machine.set("parameters/conditions/walking", true)
	else:
		state_machine.set("parameters/conditions/walking", false)
	

func hit(dmg):
	current_health -= dmg
	$"..".pass_player_info()

func pickup(type, quantity):

	match type:
		
		"fire":
			current_fire_materials += quantity
		
		"lightning":
			current_lightning_materials += quantity
		
		"water":
			current_water_materials += quantity
		
		"satchel":
			current_fire_materials = max_fire_materials
			current_lightning_materials = max_lightning_materials
	
	if type == material_equipped:
		material_equipped_amount += quantity
		
	material_equipped_amount = clamp(material_equipped_amount, 0, material_equipped_max)
	current_fire_materials = clamp(current_fire_materials, 0, max_fire_materials)
	current_lightning_materials = clamp(current_lightning_materials, 0, max_lightning_materials)
	$"..".pass_player_info()

func switch_material(player_material):
	match player_material:
		"fire":
			material_equipped = "fire"
			material_equipped_amount = current_fire_materials
			material_equipped_max = max_fire_materials
		"water":
			material_equipped = "water"
			material_equipped_amount = current_water_materials
			material_equipped_max = max_water_materials
		"lightning":
			material_equipped = "lightning"
			material_equipped_amount = current_lightning_materials
			material_equipped_max = max_lightning_materials
	$"..".pass_player_info()

func fireball():
	if current_fire_materials > 0 and can_fireball:
		var fireball_instance = fireball_scene.instantiate()
		
		fireball_instance.direction = aim_direction
		
		self.add_child(fireball_instance)
		fireball_instance.go_to_root()
		
		current_fire_materials -= 1
		material_equipped_amount -= 1
		can_fireball = false
		casting = true
		$Timers/FireballTimer.start()
		$"..".pass_player_info()


func lightning_bolt():
	pass

func water_attack():
	pass

func _on_fireball_timer_timeout() -> void:
	can_fireball = true
	casting = false

func _on_jump_timer_timeout() -> void:
	can_jump = false
