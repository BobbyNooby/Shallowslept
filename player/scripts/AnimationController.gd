extends Node


@export var animationTree : AnimationTree
@export var player : CharacterBody3D

var tween : Tween


func onSetJumpState(jumpState : JumpState):
	animationTree.set("parameters/JumpOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func onSetDashState(dashState : DashState):
	if dashState.name == "Roll":
		animationTree.set("parameters/RollOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	elif dashState.name == "AirDash":
		animationTree.set("parameters/AirDashOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func onSetMovementState(movementState : MovementState):

	if tween:
		tween.kill()
	
	tween = create_tween()
	if movementState.name == "Idle":
		tween.tween_property(animationTree, "parameters/IdleMoveBlend/blend_amount", 0, 0.1)
		tween.tween_property(animationTree, "parameters/WalkRunBlend/blend_amount", 0, 0.1)
	else:
		tween.tween_property(animationTree, "parameters/IdleMoveBlend/blend_amount", 1, 0.1)
		if movementState.name == "Run":
			tween.tween_property(animationTree, "parameters/WalkRunBlend/blend_amount", 1, 0.1)
		else:
			tween.tween_property(animationTree, "parameters/WalkRunBlend/blend_amount", 0, 0.1)
