extends Control

func _ready():
	pass
	
	

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test.tscn") ##tusa basinca oyun sahnesine geciyor
	 ## ! sahne degisirse degismeli ! 


func _on_options_button_pressed() -> void:
	var optionsscene = load("res://scenes/options.tscn").get_instance_id()
	get_tree().current_scene.add_child(optionsscene) ##tusa basinca ayarlar sahnesine geciyor


func _on_exit_button_pressed() -> void:
	get_tree().quit()
