extends CanvasLayer


# Called when the node enters the scene tree for the first time.
var is_open = false

func _ready():
	close()



func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if is_open:
			close()
		else: 
			open()

func open():
	visible = true 
	is_open = true 


func close():
	visible = false 
	is_open = false 


	


func _on_button_pressed() -> void:
	close()



func _on_leave_b_pressed() -> void:
		get_tree().quit()
