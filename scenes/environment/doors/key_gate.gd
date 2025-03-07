extends Gate

func _ready() -> void:
	#if door hasn't been unlocked, locked
	if GameState.key_gate_unlocked == false:
		locked()
	else: #if door has been unlocked, open
		opened()

func open():
	animator.play("open")
	collision_shape.set_deferred("disabled", true)

func opened():
	animator.play("opened")
	collision_shape.set_deferred("disabled", true)

func close():
	animator.play("close")

func closed():
	animator.play("closed")

func locked():
	animator.play("locked")
	collision_shape.set_deferred("disabled", false)

func unlock():
	animator.play("unlock")

func _on_unlock_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and GameState.dungeon_key_found:
		unlock()
		GameState.key_gate_unlocked = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "unlock":
		open()
