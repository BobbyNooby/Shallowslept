extends CharacterBody3D

signal setIdleState(idleState : bool)
signal setSprintState(sprintState : bool)
signal setMovementState(movementState : MovementState)
signal setJumpState(jumpState : JumpState)
signal setDashState(dashState : DashState)
signal setMovementDirection(movementDirection : Vector3)
signal setShiftLock(shiftLockState : bool)

@export var movementStates : Dictionary
@export var jumpStates : Dictionary
@export var dashStates : Dictionary
@export var isShiftLocked : bool

@export var SprintWindow : Timer
@export var DodgeCooldown : Timer
var isSprinting  : bool = false
var isIdle : bool = true
var lastKeyPressed : String

var movementDirection : Vector3

func _ready():
	setShiftLock.emit(isShiftLocked)
	setMovementState.emit(movementStates["Idle"])

func _input(event):
	if event.is_action("Movement"):
		movementDirection.x = Input.get_action_strength("Left") - Input.get_action_strength("Right")
		movementDirection.z = Input.get_action_strength("Forward") - Input.get_action_strength("Backward")
		
		if !SprintWindow.is_stopped():
			if Input.is_action_just_pressed(lastKeyPressed):
				isSprinting = true
		if !isSprinting:
			if Input.is_action_just_pressed("Forward"):
				lastKeyPressed = "Forward"
				SprintWindow.start()
			if Input.is_action_just_pressed("Backward"):
				lastKeyPressed = "Backward"
				SprintWindow.start()
			if Input.is_action_just_pressed("Left"):
				lastKeyPressed = "Left"
				SprintWindow.start()
			if Input.is_action_just_pressed("Right"):
				lastKeyPressed = "Right"
				SprintWindow.start()
		
		if isMovementOngoing():
			if isSprinting:
				setMovementState.emit(movementStates["Run"])
			else:
				setMovementState.emit(movementStates["Walk"])
		else:
			setMovementState.emit(movementStates["Idle"])
	
	if event.is_action_pressed("ShiftLock"):
		isShiftLocked = !isShiftLocked
		setShiftLock.emit(isShiftLocked)
		
	if event.is_action_pressed("Dodge"):
		if DodgeCooldown.is_stopped():
			DodgeCooldown.start()
			if is_on_floor():
				setDashState.emit(dashStates["Roll"])
			else:
				setDashState.emit(dashStates["AirDash"])
	
			



func _physics_process(delta):
	
	if isMovementOngoing():
		setMovementDirection.emit(movementDirection)
		isIdle = false
	else:
		isIdle = true
		isSprinting = false
	setIdleState.emit(isIdle)
	setSprintState.emit(isSprinting)
	
		
	if Input.is_action_pressed("Jump"):
		if is_on_floor():
			setJumpState.emit(jumpStates["Jump"])

func isMovementOngoing() -> bool:
	return Input.is_action_pressed("Movement")


