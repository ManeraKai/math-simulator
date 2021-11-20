extends Node2D

var A_Controller_pressed: bool = false
var C_Controller_pressed: bool = false

var A_Controller_start_position: Vector2
var C_Controller_start_position: Vector2

var A_Controller_limiter: Vector2
var C_Controller_limiter: Vector2


func A_mouse_loc():
	return A_Controller_start_position + get_local_mouse_position() + $A_Controller.rect_size / 2


func C_mouse_loc():
	return C_Controller_start_position + get_local_mouse_position() + $C_Controller.rect_size / 2


func A_B_difference():
	return $A_B.points[0] - $A_B.points[1]


func angle_calc(p1, p2, p3):
	var p12 = sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
	var p13 = sqrt(pow(p1.x - p3.x, 2) + pow(p1.y - p3.y, 2))
	var p23 = sqrt(pow(p2.x - p3.x, 2) + pow(p2.y - p3.y, 2))

	if p12 == 0 or p13 == 0 or p23 == 0:
		return 0

	return acos(((pow(p12, 2)) + (pow(p13, 2)) - (pow(p23, 2))) / (2 * p12 * p13)) * 180 / PI


var A_B_slope: int = 0
var C_B_slope: int = 0

func A():
	var pos = $A_B.points[0]
	return Vector2(stepify(pos.x, 0.01), stepify(pos.y, 0.01))


func B():
	var pos = $A_B.points[1]
	return Vector2(stepify(pos.x, 0.01), stepify(pos.y, 0.01))


func C():
	var pos = $D_B_C.points[0]
	return Vector2(stepify(pos.x, 0.01), stepify(pos.y, 0.01))


func D():
	var pos = $D_B_C.points[2]
	return Vector2(stepify(pos.x, 0.01), stepify(pos.y, 0.01))


func E():
	var pos = $A_B.points[2]
	return Vector2(stepify(pos.x, 0.01), stepify(pos.y, 0.01))


func A_Controller():
	var pos = $A_Controller.rect_position
	return Vector2(stepify(pos.x, 0.01), stepify(pos.y, 0.01))


func C_Controller():
	var pos = $C_Controller.rect_position
	return Vector2(stepify(pos.x, 0.01), stepify(pos.y, 0.01))
	

var A_B_C_Hide: bool = false
var A_B_D_Hide: bool = false

var A_loc: Vector2
var C_loc: Vector2
var D_loc: Vector2

var A_Controller_loc: Vector2
var C_Controller_loc: Vector2

var A_B_C_unite_offset: float
var A_B_D_unite_offset: float

var A_B_C_Cutter_z_index: int
var A_B_D_Cutter_z_index: int

var screen = Vector2(1920,1080)

func _ready():
	#adjusting the screen size if the program was running on windows (x86) and centering the window
	if OS.get_name() == 'Windows':
		OS.window_size = Vector2(
			stepify(OS.get_screen_size().x / 1.2, 1), stepify(OS.get_screen_size().y / 1.2, 1)
		)
		OS.center_window()

	$A_Controller.connect('button_down', self, '_on_A_Controller_button_down')
	$A_Controller.connect('button_up', self, '_on_A_Controller_button_up')

	$C_Controller.connect('button_down', self, '_on_C_Controller_button_down')
	$C_Controller.connect('button_up', self, '_on_C_Controller_button_up')

	$A_B_C_Hide.connect('pressed', self, '_on_A_B_C_Hide_pressed')
	$A_B_D_Hide.connect('pressed', self, '_on_A_B_D_Hide_pressed')

	$Restore_Button.connect('pressed', self, '_on_Restore_Button_pressed')

	$A_Controller.rect_pivot_offset = $A_Controller.rect_size / 2
	$C_Controller.rect_pivot_offset = $C_Controller.rect_size / 2
	
	$E_Controller.rect_rotation = 180
	$C_Controller.rect_rotation = angle_calc(B(), C(), Vector2(0, B().y)) - 90
	$D_Controller.rect_rotation = -90
	
	var aPos = A() - $A_Controller.rect_size / 2
	$A_Controller.rect_position = aPos
	$E_Controller.rect_position = screen - $A_Controller.rect_size - aPos
	var cPos = C() - $C_Controller.rect_size / 2
	$C_Controller.rect_position = cPos
	$D_Controller.rect_position = screen - $C_Controller.rect_size - cPos

	#A()
	var aLinePos = A_Controller() + $A_Controller.rect_size / 2
	$A_B.points[0] = aLinePos
	$A_B.points[2] = screen - aLinePos

	var aTextPos = A_Controller()+ $A_Controller.rect_size / 2- $A_Controller_Text.rect_size / 2
	if A().x - B().x < 0:
		aTextPos -= Vector2($A_Controller_Text.rect_size.x * 1.5, 0)
	else:
		aTextPos += Vector2($A_Controller_Text.rect_size.x * 1.5, 0)
	$A_Controller_Text.rect_position = aTextPos

	var cTextPos = $C_Controller.rect_position + $C_Controller.rect_size / 2 - $C_Controller_Text.rect_size / 2
	if C().x > B().x:
		cTextPos -= Vector2($C_Controller_Text.rect_size.x * 1.5, 0)
	else:
		cTextPos += Vector2($C_Controller_Text.rect_size.x * 1.5, 0)
	$C_Controller_Text.rect_position = cTextPos

	$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (
		(angle_calc(B(), A(), C()) / 2 + angle_calc(B(), C(), Vector2(C().x, B().y)))
		/ 360
	)

	if round(angle_calc(B(), A(), C())) == 90:
		$A_B_C_Square.rotation_degrees = (
			45
			- (angle_calc(B(), A(), C()) / 2 + angle_calc(B(), C(), Vector2(1921, B().y)))
		)
		$A_B_C_Square.visible = true

	else:
		$A_B_C_Square.visible = false


	A_B_C_Cutter_z_index = $A_B_C_Cutter.z_index
	A_B_D_Cutter_z_index = $A_B_D_Cutter.z_index

	A_loc = A()
	C_loc = C()

	A_Controller_loc = $A_Controller.rect_position
	C_Controller_loc = $C_Controller.rect_position

	A_B_C_unite_offset = $A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset
	A_B_D_unite_offset = $A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset

	text_rotation()
	is_90()


func angle_values():
	$A_B_C_Text_Director/A_B_C_Text_Director_Follow/A_B_C_Text.text = str(
		round(angle_calc(B(), A(), C()))
	)

	$A_B_D_Text_Director/A_B_D_Text_Director_Follow/A_B_D_Text.text = str(
		round(angle_calc(B(), A(), D()))
	)

	$D_B_E_Text_Director/D_B_E_Text_Director_Follow/D_B_E_Text.text = str(
		round(angle_calc(B(), E(), D()))
	)

	$C_B_E_Text_Director/C_B_E_Text_Director_Follow/C_B_E_Text.text = str(
		round(angle_calc(B(), E(), C()))
	)

func text_rotation():
	var bac = angle_calc(B(), A(), C())
	var bad = angle_calc(B(), A(), D())
	var bbc = angle_calc(B(), Vector2(B().x, 0), C())
	var bbd = angle_calc(B(), Vector2(B().x, 1920), D())
	
	var abcPos = 45 / 360.0
	var abdPos = 135 / 360.0
	var dbePos = 225 / 360.0
	var cbePos = 315 / 360.0
	
	if C().x > B().x:
		var a = angle_calc(B(), Vector2(B().x, 1920), C()) - 90
		var d = angle_calc(B(), Vector2(B().x, 0), D())
		if A().x > B().x:
			if A().x != E().x && C().x != D().x:
				if (A().y - E().y) / (A().x - E().x) < (C().y - D().y) / (C().x - D().x):
					abcPos = (180 + bac / 2 + a) / 360.0
					abdPos = (270 - bad / 2 + d) / 360.0
					dbePos = (360 + bac / 2 + a) / 360.0
					cbePos = (90  - bad / 2 + d) / 360.0
				else:
					abcPos = (180 - bac / 2 + a) / 360.0
					abdPos = (270 + bad / 2 + d) / 360.0
					dbePos = (360 - bac / 2 + a) / 360.0
					cbePos = (90  + bad / 2 + d) / 360.0
		else:
			if A().x != E().x && C().x != D().x:
				if (A().y - E().y) / (A().x - E().x) < (C().y - D().y) / (C().x - D().x):
					abcPos = (180 - bac / 2 + a) / 360.0
					abdPos = (270 + bad / 2 + d) / 360.0
					dbePos = (360 - bac / 2 + a) / 360.0
					cbePos = (90  + bad / 2 + d) / 360.0
				else:
					abcPos = (bac / 2 + a) / 360.0
					abdPos = (90  - bad / 2 + d) / 360.0
					dbePos = (180 + bac / 2 + a) / 360.0
					cbePos = (270 - bad / 2 + d) / 360.0
	else:
		if A().x > B().x:
			if A().x != E().x && C().x != D().x:
				if (A().y - E().y) / (A().x - E().x) < (C().y - D().y) / (C().x - D().x):
					abcPos = (180 - bac / 2 + bbc - 90)/ 360.0
					abdPos = (270 + bad / 2 + bbd)/ 360.0
					dbePos = (360 - bac / 2 + bbc - 90)/ 360.0
					cbePos = (90 + bad / 2 + bbd)/ 360.0
				else:
					abcPos = (180 + bac / 2 + bbc - 90)/ 360.0
					abdPos = (270 - bad / 2 + bbd)/ 360.0
					dbePos = (360 + bac / 2 + bbc - 90)/ 360.0
					cbePos = (90 - bad / 2 + bbd)/ 360.0
		else:
			if A().x != E().x && C().x != D().x:
				if (A().y - E().y) / (A().x - E().x) < (C().y - D().y) / (C().x - D().x):
					abcPos = (180 + bac / 2 + bbc - 90)/ 360.0
					abdPos = (270 - bad / 2 + bbd)/ 360.0
					dbePos = (360 + bac / 2 + bbc - 90)/ 360.0
					cbePos = (90 - bad / 2 + bbd)/ 360.0
				else:
					abcPos = (180 - bac / 2 + bbc - 90)/ 360.0
					abdPos = (270 + bad / 2 + bbd)/ 360.0
					dbePos = (360 - bac / 2 + bbc - 90)/ 360.0
					cbePos = (90 + bad / 2 + bbd)/ 360.0

	$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = abcPos
	$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = abdPos
	$D_B_E_Text_Director/D_B_E_Text_Director_Follow.unit_offset = dbePos
	$C_B_E_Text_Director/C_B_E_Text_Director_Follow.unit_offset = cbePos

func is_90():
	if round(angle_calc(B(), A(), C())) == 90:
		if A().y < B().y:
			$A_B_C_Square.rotation_degrees = (
				(-angle_calc(B(), A(), Vector2(1920, B().y)))
			)
		else:
			$A_B_C_Square.rotation_degrees = (
			(+angle_calc(B(), A(), Vector2(1920, B().y)))
			)
		$A_B_C_Square.visible = true
		$A_B_C_Circle.visible = false
	else:
		$A_B_C_Square.visible = false
		$A_B_C_Circle.visible = true
	
func A_calc():
	var ctrlPos = A_Controller_start_position + get_local_mouse_position()
	$A_Controller.set_position(ctrlPos)
	$E_Controller.set_position(Vector2(1920,1080) - $A_Controller.rect_size- ctrlPos)

	if A().y < B().y:
		var rot = angle_calc(B(), A(), Vector2(0, B().y)) - 90
		$A_Controller.rect_rotation = rot
		$E_Controller.rect_rotation = rot + 180
	else:
		var rot =angle_calc(B(), A(), Vector2(1920, B().y)) +90
		$A_Controller.rect_rotation = rot
		$E_Controller.rect_rotation = rot + 180

	var linePos = A_Controller() + $A_Controller.rect_size / 2
	$A_B.points[0] = linePos
	$A_B.points[2] = Vector2(1920,1080) - linePos

	var aPos =  A_Controller() + $A_Controller.rect_size / 2 - $A_Controller_Text.rect_size / 2
	var aPosVal = Vector2($A_Controller_Text.rect_size.x * 1.5, 0)
	if A().x < B().x:
		aPos -= aPosVal
	else:
		aPos += aPosVal
	$A_Controller_Text.rect_position = aPos
	$E_Controller_Text.rect_position = screen - aPos

	$A_B_C_Cutter.polygon[0] = A()
	$A_B_D_Cutter.polygon[1] = A()
	$A_B_D_Cutter.polygon[0] = Vector2((C().x + A().x) / 2, (C().y + A().y) / 2 - 500)

func C_calc():
	var pos = C_Controller_start_position + get_local_mouse_position()
	$C_Controller.set_position(pos)
	$D_Controller.set_position(screen- $C_Controller.rect_size - pos)
	if C().y < B().y:
		var rot = angle_calc(B(), C(), Vector2(0, B().y)) - 90
		$C_Controller.rect_rotation = rot
		$D_Controller.rect_rotation = rot + 180
	else:
		var rot = angle_calc(B(), C(), Vector2(1920, B().y)) + 90
		$C_Controller.rect_rotation = rot
		$D_Controller.rect_rotation = rot + 180


	# C()
	var cLinePos = (
		$C_Controller.rect_position
		+ Vector2(round($C_Controller.rect_size.x / 2), round($C_Controller.rect_size.y / 2))
	)
	$D_B_C.points[0] = cLinePos
	$D_B_C.points[2] = screen - cLinePos

	var cCtrlPos = $C_Controller.rect_position+ $C_Controller.rect_size / 2- $C_Controller_Text.rect_size / 2
	var dCtrlPos = Vector2(1920,1080) + cCtrlPos
	var ctrlVal = Vector2($C_Controller_Text.rect_size.x * 1.5, 0)
	if C().x > B().x:
		cCtrlPos -= ctrlVal
		dCtrlPos += ctrlVal
	else:
		cCtrlPos += ctrlVal
		dCtrlPos -= ctrlVal
	$C_Controller_Text.rect_position = cCtrlPos
	$D_Controller_Text.rect_position = dCtrlPos

	$A_B_D_Cutter.polygon[3] = C()
	$A_B_D_Cutter.polygon[0] = Vector2((C().x + A().x) / 2, (C().y + A().y) / 2 - 500)
	
func _process(__data__):
	if A_Controller_pressed:
		A_calc()
		angle_values()
		text_rotation()
		is_90()
		
	if C_Controller_pressed:
		C_calc()
		angle_values()
		text_rotation()
		is_90()
		

func _on_A_Controller_button_down():
	A_Controller_start_position = $A_Controller.rect_position - get_local_mouse_position()
	A_Controller_pressed = true


func _on_A_Controller_button_up():
	A_Controller_pressed = false


func _on_C_Controller_button_down():
	C_Controller_start_position = $C_Controller.rect_position - get_local_mouse_position()
	C_Controller_pressed = true


func _on_C_Controller_button_up():
	C_Controller_pressed = false


var A_B_C_Hide_toggled: bool = true


func _on_A_B_C_Hide_pressed():
	if A_B_C_Hide_toggled:
		A_B_C_Hide_toggled = false
		$A_B_C_Text_Director/A_B_C_Text_Director_Follow/A_B_C_Text.visible = false
		A_B_C_Hide = true

		if round(angle_calc(B(), A(), C())) == 90:
			$A_B_C_Square.rotation_degrees = (
				45
				- (angle_calc(B(), A(), C()) / 2 + angle_calc(B(), C(), Vector2(1921, B().y)))
			)
			$A_B_C_Square.visible = true
		else:
			$A_B_C_Square.visible = false

		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false

		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			# $A_B_D_Square.visible = false

		return

	if ! A_B_C_Hide_toggled:
		A_B_C_Hide_toggled = true
		$A_B_C_Text_Director/A_B_C_Text_Director_Follow/A_B_C_Text.visible = true
		A_B_C_Hide = false

		if round(angle_calc(B(), A(), C())) == 90:
			$A_B_C_Square.rotation_degrees = (
				45
				- (angle_calc(B(), A(), C()) / 2 + angle_calc(B(), C(), Vector2(1921, B().y)))
			)
			$A_B_C_Square.visible = true
		else:
			$A_B_C_Square.visible = false

		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false

		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			# $A_B_D_Square.visible = false

		return


var A_B_D_Hide_toggled: bool = true


func _on_A_B_D_Hide_pressed():
	if A_B_D_Hide_toggled:
		A_B_D_Hide_toggled = false
		$A_B_D_Text_Director/A_B_D_Text_Director_Follow/A_B_D_Text.visible = false
		A_B_D_Hide = true

		if round(angle_calc(B(), A(), C())) == 90:
			$A_B_C_Square.rotation_degrees = (
				45
				- (angle_calc(B(), A(), C()) / 2 + angle_calc(B(), C(), Vector2(1921, B().y)))
			)
			$A_B_C_Square.visible = true
		else:
			$A_B_C_Square.visible = false

		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false

		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			# $A_B_D_Square.visible = false

		return

	if ! A_B_D_Hide_toggled:
		A_B_D_Hide_toggled = true
		$A_B_D_Text_Director/A_B_D_Text_Director_Follow/A_B_D_Text.visible = true
		A_B_D_Hide = false

		if round(angle_calc(B(), A(), C())) == 90:
			$A_B_C_Square.rotation_degrees = (
				45
				- (angle_calc(B(), A(), C()) / 2 + angle_calc(B(), C(), Vector2(1921, B().y)))
			)
			$A_B_C_Square.visible = true
		else:
			$A_B_C_Square.visible = false

		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false

		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			# $A_B_D_Square.visible = false

		return

func _on_Restore_Button_pressed():

	$A_B.points[0] = A_loc
	$A_B.points[2] = Vector2(1920,1080) - A_loc
	$D_B_C.points[0] = C_loc
	$D_B_C.points[2] = Vector2(1920,1080) - C_loc


	$A_Controller.rect_position = A_Controller_loc
	$E_Controller.rect_position = screen - $A_Controller.rect_size -  A_Controller_loc
	$C_Controller.rect_position = C_loc - $C_Controller.rect_size / 2
	$D_Controller.rect_position = screen - $C_Controller.rect_size - (C_loc - $C_Controller.rect_size / 2)

	
	$A_Controller.rect_rotation = 0
	$E_Controller.rect_rotation = 180

	$C_Controller.rect_rotation = 90
	$D_Controller.rect_rotation = 270

	$A_Controller_Text.rect_position = (
		A_Controller_loc
		+ $A_Controller.rect_size / 2
		- $A_Controller_Text.rect_size / 2
		+ Vector2($A_Controller_Text.rect_size.x * 1.5, 0)
	)

	$C_Controller_Text.rect_position = (
		$C_Controller.rect_position
		+ $C_Controller.rect_size / 2
		- $C_Controller_Text.rect_size / 2
		+ Vector2($C_Controller_Text.rect_size.x * 1.5, 0)
	)

	$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = A_B_C_unite_offset
	$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = A_B_D_unite_offset

	$A_B_C_Text_Director/A_B_C_Text_Director_Follow/A_B_C_Text.text = '90'
	$A_B_D_Text_Director/A_B_D_Text_Director_Follow/A_B_D_Text.text = '90'

	$A_B_C_Text_Director/A_B_C_Text_Director_Follow/A_B_C_Text.visible = true
	$A_B_D_Text_Director/A_B_D_Text_Director_Follow/A_B_D_Text.visible = true

	$A_B_C_Cutter.polygon[0] = A_loc
	$A_B_C_Cutter.polygon[2] = D_loc
	$A_B_C_Cutter.polygon[1] = Vector2(D_loc.x, A_loc.y)

	$A_B_D_Cutter.polygon[1] = A_loc
	$A_B_D_Cutter.polygon[3] = C_loc
	$A_B_D_Cutter.polygon[0] = Vector2(C_loc.x, A_loc.y)

	$A_B_C_Cutter.z_index = A_B_C_Cutter_z_index
	$A_B_D_Cutter.z_index = A_B_D_Cutter_z_index

	$A_B_C_Square.rotation_degrees = 0
	$A_B_C_Square.visible = true
	$A_B_C_Circle.visible = false
	
	angle_values()
	text_rotation()
	is_90()
