extends EnemyProjectile

func _ready() -> void:
	super()
	$AnimationPlayer.play("default")
