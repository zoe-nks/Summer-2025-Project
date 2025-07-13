extends CanvasLayer

@onready var cursor_image = $cursorimage

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hides default system cursor

func _process(_delta):
	cursor_image.position = get_viewport().get_mouse_position()
