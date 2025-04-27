extends Control

func _ready():
	pass
	
	

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test.tscn") 
	##tusa basinca oyun sahnesine geciyor
	## ! sahne degisirse degismeli ! 


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn") 
##tusa basinca ayarlar sahnesine geciyor

func _on_exit_button_pressed() -> void:
	get_tree().quit()
