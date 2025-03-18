extends CharacterBody2D
class_name Player

@export_category("Character")
@export var max_health: int
@export var current_health: int
@export var max_speed: int
@export var acceleration: int

@export_category("Equipped")
@export var equipped_material := {"material": null, "max": null, "current": null}

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
@export var blast_jump_state: State

@export var done_cast_state: State

@export var stun_state: State
@export var death_state: State

@onready var spell_mode := "attack"
@onready var has_blast_jumped := false
@onready var can_cast: bool
@onready var aim_direction: Vector2
@onready var friction: int

var direction
var stunned := false
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
	walk_state.fall.connect(state_machine.change_state.bind(fall_state))
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
	fire_spell_state.blast_jump.connect(state_machine.change_state.bind(blast_jump_state))
	fire_spell_state.done.connect(state_machine.change_state.bind(done_cast_state))
	
	fireball_state.done.connect(state_machine.change_state.bind(done_cast_state))
	blast_jump_state.done.connect(state_machine.change_state.bind(done_cast_state))
	
	done_cast_state.idle.connect(state_machine.change_state.bind(idle_state))
	done_cast_state.walk.connect(state_machine.change_state.bind(walk_state))
	done_cast_state.jump.connect(state_machine.change_state.bind(jump_state))
	done_cast_state.fall.connect(state_machine.change_state.bind(fall_state))
	
	stun_state.end_stun.connect(state_machine.change_state.bind(done_cast_state))
	stun_state.die.connect(die)



func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("j"):
		die()
		#MOVEMENT
	
	#gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#horizontal movement
	if not stunned:
		direction = Input.get_axis("left", "right")
		if direction: #if directional input
			velocity.x += direction * acceleration * 0.3
			velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	#Flip player to direction they are moving
	if not stunned:
		if direction < 0:
			$Pivot.scale.x = -1
		if direction > 0:
			$Pivot.scale.x = 1
	
	#friction
	if is_on_floor():
		friction = 5
	
	#jump buffer
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		$JumpBufferTimer.start()
		jump_buffer = true
	
	if friction:
		velocity.x = move_toward(velocity.x, 0, friction)


		#INTERACTION
	
	if Input.is_action_just_pressed("up"):
		var interact_areas = $InteractBox.get_overlapping_areas()
		
		for interact_area in interact_areas:
			if "interact" in interact_area:
				interact_area.interact()

		#DAMAGE
	
	#stun + iframes
	if stunned:
		set_collision_mask_value(3, false)
		set_collision_mask_value(5, false)
	else:
		set_collision_mask_value(3, true)
		set_collision_mask_value(5, true)
	

		#SPELLS
	
	#getting aim direction
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		aim_direction = Input.get_vector("left", "right", "up", "down")
	else:
		if $Pivot.scale.x == -1:
			aim_direction = Vector2(-1, 0)
		else:
			aim_direction = Vector2(1, 0)
	
	#switching material
	if Input.is_action_just_pressed("cycle-spell-left"):
		cycle_spell_left()
	if Input.is_action_just_pressed("cycle-spell-right"):
		cycle_spell_right()
	
	#spell mode switching
	if Input.is_action_just_pressed("switch-mode"):
		var previous_mode = spell_mode
		if previous_mode == "attack":
			spell_mode = "utility"
		elif previous_mode == "utility":
			spell_mode = "attack"
	
	#resetting blast jump
	if is_on_floor() and state_machine.current_state != blast_jump_state:
		has_blast_jumped = false
	
	move_and_slide()

func cycle_spell_right():
	match equipped_material.material:
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
	match equipped_material.material:
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
			equipped_material.material = "fire"
			equipped_material.current = fire_material.current
			equipped_material.max = fire_material.max
		"water":
			equipped_material.material = "water"
			equipped_material.amount = water_material.current
			equipped_material.max = water_material.max
		"lightning":
			equipped_material.material = "lightning"
			equipped_material.current = lightning_material.current
			equipped_material.max = lightning_material.max
		_:
			print("material switch invalid")
	$"..".pass_player_info(self)

func pickup(type, quantity):
	match type:
		
		"fire":
			fire_material.current += quantity
		
		"lightning":
			lightning_material.current += quantity
		
		"water":
			water_material.current += quantity
		
		"satchel":
			fire_material.current = fire_material.max
			lightning_material.current = lightning_material.max
		
		"key":
			GameState.dungeon_key_found = true
			return
			
	if type == equipped_material.material:
		equipped_material.current += quantity
		
	equipped_material.current = clamp(equipped_material.current, 0, equipped_material.max)
	fire_material.current = clamp(fire_material.current, 0, fire_material.max)
	lightning_material.current = clamp(lightning_material.current, 0, lightning_material.max)
	$"..".pass_player_info(self)

func pass_player_info():
	$"..".pass_player_info(self)

func hit(dmg: int, from_direction: int):
	current_health -= dmg
	$"..".pass_player_info(self)
	stun_state.direction = from_direction
	state_machine.change_state(stun_state)

func die():
	$"..".player_dead()

func _on_jump_buffer_timer_timeout() -> void:
	jump_buffer = false

func _on_interact_box_area_entered(area: Area2D) -> void:
	if area is SaveIdol and Input.is_action_just_pressed("up"):
		pass

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		if body.position.x < position.x:
			hit(1, -1)
		elif body.position.x > position.x:
			hit(1, 1)
