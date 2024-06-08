class_name Player
extends CharacterBody2D

# Movimento
@export_category("Movement")
@export var speed: float = 3

# Vida
@export_category("Life")
@export var max_health: int = 100
var health: int = max_health


# Sprite
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Combate
@export_category("Sword")
@export var sword_damage: int = 2
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitBoxArea
@onready var healthprogressbar: ProgressBar = $HealthProgressBar

# Morte
@export_category("Death")
@export var death_prefab: PackedScene

# Ritual
@export_category("Ritual")
@export var ritual_damage: int = 1
@export var ritual_interval: float = 10
@export var ritual_scene: PackedScene

var input_vector: Vector2 = Vector2(0, 0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 0.0
var rituals: bool = false


func _ready():
	GameManager.player = self

func _process(delta: float) -> void:
	GameManager.player_position = position
	
	# Processar ataque
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack(1)
	if Input.is_action_just_pressed("Super"):
		attack(2)
	# Ler Input
	read_input()
	
	# Processar animação e rotação do sprite
	if not is_attacking:
		mod_sprite()
	mod_animation()
	
	# Processar o dano
	update_hitbox_detection(delta)
	
	# Ritual
	update_ritual(delta)
	
	# Atualizar Health Bar
	healthprogressbar.max_value = max_health
	healthprogressbar.value = health

func _physics_process(delta: float) -> void:
	
	# Modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.15
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()
	
	
func update_attack_cooldown(delta: float) -> void:
	# Atualiza o temporizador de ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("Idle")

func mod_animation() -> void:
	# Tocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("Run")
			else:
				animation_player.play("Idle")

func mod_sprite() -> void:
	# Girar sprite
	if input_vector.x > 0:
		# desmarcar flip.h do Sprite2D
		sprite.flip_h = false
	elif input_vector.x < 0:
		# marcar flip.h do Sprite2D
		sprite.flip_h = true

func read_input() -> void:
	# Obter o input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Apagar deadzone do input vector	
	var deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.00
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.00
		
	# Atualiza o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func attack(tipo: int):
	if is_attacking:
		return
	
	# ataque 1
	if tipo == 1:
		animation_player.play("attack_side_1")
	if tipo == 2:
		rituals = true
	
	attack_cooldown = 0.6
	
	# Marcar ataque
	is_attacking = true
	
	#Aplicar dano nos inimigos

func deal_damage_to_enemies():
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else: 
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.3:
			
				enemy.damage(sword_damage)

func update_hitbox_detection(delta: float) -> void:
	# Temporizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	# Frequência
	hitbox_cooldown = 0.5
	
	# Detectar inimigos
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)

func damage(amount: int) -> void:
	if !Player: return
	if health <= 0: return
	health -= amount
	
	# Piscar o Player
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	
	
	# Processar morte
	if health <= 0:
		die()

func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	GameManager.on_game_over()
	queue_free()

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	return health

func update_ritual(delta: float):
	if rituals == true:
		# Criar o ritual
		if ritual_cooldown <= 0:
			var ritual = ritual_scene.instantiate()
			ritual.damage_amount = ritual_damage
			add_child(ritual)
		
		ritual_cooldown += delta
		
	if ritual_cooldown < ritual_interval: return
		
	# Resetar o temporizador
	rituals = false
	ritual_cooldown = 0
		
		
		
	
