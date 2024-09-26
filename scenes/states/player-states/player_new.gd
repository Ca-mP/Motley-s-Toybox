extends CharacterBody2D

@export_category("Character")
@export var max_health: int
@export var current_health: int
@export var material_equipped: String
@export var max_speed: int
@export var acceleration: int

@export_category("Fire")
@export var fire_material := {"unlocked": true, "max": 20, "current": 20}

@export_category("Lightning")
@export var lightning_material := {"unlocked": true, "max": 20, "current": 20}

@export_category("Water")
@export var water_material := {"unlocked": true, "max": 20, "current": 20}

@export_category("States")
@export var state_machine: StateMachine
@export var idle_state: State
@export var walk_state: State
@export var jump_state: State
@export var fall_state: State
@export var land_state: State
@export var cast_state: State

@export var fire_spell_state: State
@export var lightning_spell_state: State
@export var water_spell_state: State
@export var fireball_state: State

@export var done_cast_state: State

@onready var spell_mode := "attack"
@onready var can_cast: bool
@onready var aim_direction: Vector2
@onready var friction: int
@onready var material_equipped_amount: int
@onready var material_equipped_max: int

var direction
var jump_buffer: bool
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	#connecting states
	idle_state.walk.connect(state_machine.change_state.bind(walk_state))
	idle_state.jump.connect(state_machine.change_state.bind(jump_state))
	idle_state.cast.connect(state_machine.change_state.bind(cast_state))
	
	walk_state.idle.connect(state_machine.change_state.bind(idle_state))
	walk_state.jump.connect(state_machine.change_state.bind(jump_state))
	walk_state.cast.connect(state_machine.change_state.bind(cast_state))
	
	jump_state.fall.connect(state_machine.change_state.bind(fall_state))
	jump_state.cast.connect(state_machine.change_state.bind(cast_state))
	
	fall_state.land.connect(state_machine.change_state.bind(land_state))
	fall_state.cast.connect(state_machine.change_state.bind(cast_state))
	
	land_state.idle.connect(state_machine.change_state.bind(idle_state))
	land_state.walk.connect(state_machine.change_state.bind(walk_state))
	land_state.jump.connect(state_machine.change_state.bind(jump_state))
	land_state.fall.connect(state_machine.change_state.bind(fall_state))
	land_state.cast.connect(state_machine.change_state.bind(cast_state))
	
	cast_state.fire_spell.connect(state_machine.change_state.bind(fire_spell_state))
	cast_state.lightning_spell.connect(state_machine.change_state.bind(lightning_spell_state))
	cast_state.water_spell.connect(state_machine.change_state.bind(water_spell_state))
	
	fire_spell_state.fireball.connect(state_machine.change_state.bind(fireball_state))
	
	fireball_state.done.connect(state_machine.change_state.bind(done_cast_state))
	
	done_cast_state.idle.connect(state_machine.change_state.bind(idle_state))
	done_cast_state.walk.connect(state_machine.change_state.bind(walk_state))
	done_cast_state.jump.connect(state_machine.change_state.bind(jump_state))
	done_cast_state.fall.connect(state_machine.change_state.bind(fall_state))
	
	#setting these
	switch_material("fire")

func _physics_process(delta: float) -> void:
	
	#gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	#movement
	direction = Input.get_axis("left", "right")
	if direction: #if directional input
		velocity.x += direction * acceleration * 0.3
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	#Flip player to direction they are moving
	if direction < 0:
		$Sprite2D.flip_h = true
	if direction > 0:
		$Sprite2D.flip_h = false
	
	#friction
	if is_on_floor():
		friction = 5
	else:
		friction = 10
	
	#jump buffer
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		$JumpBufferTimer.start()
		jump_buffer = true
	
	if friction:
		velocity.x = move_toward(velocity.x, 0, friction)
	
	#getting aim direction
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		aim_direction = Input.get_vector("left", "right", "up", "down")
	else:
		if $Sprite2D.flip_h == true:
			aim_direction = Vector2(-1, 0)
		else:
			aim_direction = Vector2(1, 0)
	
	#spell mode switching
	#if Input.is_action_just_pressed("switch-mode"):
		#if spell_mode == "attack":
			#spell_mode == "utility"
		#elif spell_mode == "utility":
			#spell_mode == "attack"

	move_and_slide()

func cycle_spell_right():
	match material_equipped:
		"fire":
			if lightning_material.unlocked:
				switch_material("lightning")
			elif water_material.unlocked:
				switch_material("water")
				
		"lightning":
			if water_material.unlocked:
				switch_material("water")
			elif fire_material.unlocked:
				switch_material("fire")
				
		"water":
			if fire_material.unlocked:
				switch_material("fire")
			elif lightning_material.unlocked:
				switch_material("lightning")

func cycle_spell_left():
	match material_equipped:
		"fire":
			if water_material.unlocked:
				switch_material("water")
			elif lightning_material.unlocked:
				switch_material("lightning")
		
		"lightning":
			if fire_material.unlocked:
				switch_material("fire")
			elif water_material.unlocked:
				switch_material("water")
		
		"water":
			if lightning_material.unlocked:
				switch_material("lightning")
			elif fire_material.unlocked:
				switch_material("fire")

func switch_material(player_material):
	match player_material:
		"fire":
			material_equipped = "fire"
			material_equipped_amount = fire_material.current
			material_equipped_max = fire_material.max
		"water":
			material_equipped = "water"
			material_equipped_amount = water_material.current
			material_equipped_max = water_material.max
		"lightning":
			material_equipped = "lightning"
			material_equipped_amount = lightning_material.current
			material_equipped_max = lightning_material.max

func pass_player_info():
	pass

func _on_jump_buffer_timer_timeout() -> void:
	jump_buffer = false
