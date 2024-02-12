extends Node



@export var player : CharacterBody3D
@export var Step1 : AudioStreamPlayer
@export var Step2 : AudioStreamPlayer
@export var Jump : AudioStreamPlayer
@export var AirDash : AudioStreamPlayer
@export var Roll : AudioStreamPlayer
@export var runStepDelay : Timer
@export var walkStepDelay : Timer

var isSprinting : bool
var isDodging : bool

func _physics_process(delta):
	if Input.is_action_pressed("Movement"):
		if !isDodging:
			if player.is_on_floor():
				var stepDelayType : Timer
				if isSprinting:
					stepDelayType = runStepDelay 
				else:
					stepDelayType = walkStepDelay
			
				if stepDelayType.is_stopped():
					var randomSound = randf()
					if randomSound < 0.5:
						Step1.play()
					else:
						Step2.play()
					stepDelayType.start()
	
	
			
func onSetSprintState(sprintState : bool):
	isSprinting = sprintState

func onSetDodgingState(dodgeState : bool):
	isDodging = dodgeState

func onSetJumpState(jumpState : JumpState):
	Jump.play()

func onSetDashState(dashState : DashState):
	if dashState.name == "Roll":
		Roll.play()
	elif dashState.name == "AirDash":
		AirDash.play()
	
	
