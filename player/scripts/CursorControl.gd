extends Node2D

@onready var normalMouseCursor = $NormalCursor
@onready var shiftLockCursor = $MouseLockCursor

var mousePosition = Vector2.ZERO
var lastMousePosition = Vector2.ZERO
var isShiftLocked = false
var isRightClickPressed = false

func _ready():
	print("Woko")

		


func _process(delta):
	mousePosition = get_viewport().get_mouse_position()
	
	if Input.is_action_just_pressed("ShiftLock"):
		isShiftLocked = !isShiftLocked

	if !isShiftLocked:
		if Input.is_action_pressed("RightClick"):
			if !isRightClickPressed:
				isRightClickPressed = true
				lastMousePosition = mousePosition
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			$".".transform.origin = lastMousePosition
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			if isRightClickPressed:
				Input.warp_mouse(lastMousePosition)
				isRightClickPressed = false
				
			
			
			$".".transform.origin = mousePosition
			
			
	else:
		$".".transform.origin = get_viewport_rect().size / 2
		
		
		
	if isShiftLocked:
		if !shiftLockCursor.visible:
			shiftLockCursor.visible = true
			normalMouseCursor.visible = false
	else:
		if !normalMouseCursor.visible:
			shiftLockCursor.visible = false
			normalMouseCursor.visible = true
			
	


