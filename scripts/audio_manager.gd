extends Node

var CLICK_001 = preload("uid://bdugxb5nn6stv")
const IMPACT_TIN_MEDIUM_002 = preload("uid://on6w512jtuyx")
const BACK001 = preload("uid://sxyn40l607sh")
const BONG_001 = preload("uid://cgg7ak4iwbe2k")
const CLICK_002 = preload("uid://d1l1dpcv832dr")
const bgm_military = preload("uid://b2bu3157al3op")
var music_player

func _ready() -> void:
	var music_bus_index = AudioServer.get_bus_index("Music")
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	
	# 2. Ajusta os volumes em Decibéis (dB)
	# Diminui a música (experimente valores entre -6.0 e -15.0 até ficar confortável)
	AudioServer.set_bus_volume_db(music_bus_index, -3.0)
	
	# Aumenta o SFX levemente (valores positivos aumentam o ganho original)
	AudioServer.set_bus_volume_db(sfx_bus_index, 8.0)
	
	# --- Seu código antigo de inicialização da música continua aqui baixo ---
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	music_player.stream = bgm_military
	music_player.play()

func play_vfx(stream : AudioStream) -> void :
	if stream == null : return
	
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	
	fx_player.bus = "SFX" 
	
	add_child(fx_player)
	fx_player.play()
	
	# Quando o som terminar de tocar, o próprio nó se deleta para não encher a memória
	fx_player.finished.connect(func(): fx_player.queue_free())
	
