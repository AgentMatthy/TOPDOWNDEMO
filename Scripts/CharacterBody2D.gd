extends CharacterBody2D

var movespeed = 80
var bulletspeed = 1500
var bullet = preload("res://Scenes/BULLET.tscn")
var bullet_cooldown = 0
var default_bullet_cooldown = 20
var recoil = 400
var direction = Vector2(0, 0)
var speed = 10

var dash_cooldown = 0
var dash_charge = 0
var default_dash_charge = 16
var default_dash_cooldown = 80
var dash_speed = 3000

var dash_cooldown_q = 0
var dash_charge_q = 0
var default_dash_cooldown_q = 50
var dash_q_mp = 0.4

#-PRELOADS-------------
@onready var particleShoot = %ShootParticle

#health
var health = 100

#GUI
@export var GUI: Node

@onready var muzzle = $Muzzle

func _process(delta):
	var target = get_global_mouse_position()
	var new_transform = self.transform.looking_at(target)
	self.transform  = self.transform.interpolate_with(new_transform, speed * delta)

	move_and_slide()

func _physics_process(delta):
	update_health() #update health
	direction = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		velocity.y -= 1 * movespeed
		direction.y += -1
	if Input.is_action_pressed("down"):
		velocity.y += 1 * movespeed
		direction.y += 1
	if Input.is_action_pressed("right"):
		velocity.x += 1 * movespeed
		direction.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1 * movespeed
		direction.x += -1
	#Mouse smoothing

		
	velocity = velocity * 0.91

	if bullet_cooldown > 0:
		bullet_cooldown -= 1
	if dash_cooldown > 0:
		dash_cooldown -= 1
	if dash_cooldown_q > 0:
		dash_cooldown_q -= 1
	if dash_cooldown == 1:
		$"SFX-Dash-R".play()
	if dash_charge > 1:
		velocity = velocity * 0.8
		dash_charge -= 1
	if dash_charge == 1:
		dash_charge = 0
		dash()
		
	if Input.is_action_just_pressed("shift"):
		if dash_cooldown == 0:
			dash_charge = default_dash_charge
			dash_cooldown = default_dash_cooldown
			$"SFX-Dash".play()
			
	if Input.is_action_just_pressed("space"):
		if dash_cooldown_q == 0:
			dash_cooldown_q = default_dash_cooldown_q
			dash_q()
			
		
	if Input.is_action_pressed("lclick"):
		if bullet_cooldown == 0:
			fire()
			bullet_cooldown = default_bullet_cooldown
	
	

		
func dash():
	velocity += direction * dash_speed
	
func dash_q():
	velocity += direction * dash_speed * dash_q_mp
	

func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = muzzle.global_position
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_central_impulse(Vector2(bulletspeed,0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child",bullet_instance)
	velocity += Vector2(recoil, 0).rotated(rotation) * -1
	$"SFX-Shoot".play()
	particleShoot.emitting


func die():
	get_tree().reload_current_scene()

func _on_area_2d_body_entered(body):
	if "Enemy" in body.name:
		die()	

#HealthBar
func update_health():
	var healthBar = GUI.get_node("Control").get_node("healthBar")
	healthBar.value = health
