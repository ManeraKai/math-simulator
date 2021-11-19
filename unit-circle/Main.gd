extends Node2D

var C_Controller_pressed: bool = false
var C_Controller_start_position: Vector2
var A_Hide: bool = false


func B():
	return Vector2(
		stepify($Unite_Circle/A_B_C.points[2].x, 0.01),
		stepify($Unite_Circle/A_B_C.points[2].y, 0.01)
	)


func A():
	return Vector2(
		stepify($Unite_Circle/A_B_C.points[1].x, 0.01),
		stepify($Unite_Circle/A_B_C.points[1].y, 0.01)
	)


func C():
	return Vector2(
		stepify($Unite_Circle/A_B_C.points[0].x, 0.01),
		stepify($Unite_Circle/A_B_C.points[0].y, 0.01)
	)

var ctrl_offset


func _ready():
	#adjusting the screen size if the program was running on windows (x86) and centering the window
	if OS.get_name() == 'Windows':
		OS.window_size = Vector2(
			stepify(OS.get_screen_size().x / 1.2, 1), stepify(OS.get_screen_size().y / 1.2, 1)
		)
		OS.center_window()

	$Unite_Circle/C_Controller.connect('button_down', self, '_on_C_Controller_button_down')
	$Unite_Circle/C_Controller.connect('button_up', self, '_on_C_Controller_button_up')

	$A_Hide.connect('pressed', self, '_on_A_Hide_pressed')

	$Restore_Button.connect('pressed', self, '_on_Restore_Button_pressed')

	$FullScreen_Button.connect('pressed', self, '_on_FullScreen_Button_pressed')

	ctrl_offset = $Unite_Circle/C_Controller.rect_size / Vector2(2, 2)
	ctrl_offset = Vector2(round(ctrl_offset.x), round(ctrl_offset.y))

	mouse_position = Vector2(252.5, -252.5)
	TrianglePos()
	AngleText()
	SinCosCal()


var offsety = Vector2(960, 540)


func mouse_pos():
	return get_local_mouse_position() - offsety


func charge(number):
	if number < 0:
		return -1
	elif number == 0:
		return 0
	elif number > 0:
		return 1


func angle_calc(p2, p1, p3):
	var p12 = sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
	var p13 = sqrt(pow(p1.x - p3.x, 2) + pow(p1.y - p3.y, 2))
	var p23 = sqrt(pow(p2.x - p3.x, 2) + pow(p2.y - p3.y, 2))

	if p12 == 0 or p13 == 0 or p23 == 0:
		return 0

	return acos(((pow(p12, 2)) + (pow(p13, 2)) - (pow(p23, 2))) / (2 * p12 * p13)) * 180 / PI


func Angle_Text_Rotator():
	var result: float = 0

	if C().x > A().x:
		result = (angle_calc(A(), C(), B()) / 2 + 135)
	else:
		result = (angle_calc(A(), C(), B()) / 2 + 315) * -1

	if C().y > A().y:
		result = result * -1

	result = result / 360

	$Unite_Circle/A_Text_Director/A_Text_Director_Follow.unit_offset = result


var mouse_position


func TrianglePos():
	var position = Vector2()

	var theAngle = angle_calc(mouse_position, A(), Vector2(540, 0))
	var posy = mouse_position - A()
	var wewe = 357 - sqrt(pow(posy.x, 2) + pow(posy.y, 2))

	position = Vector2(
		mouse_position.x + (abs(cos(theAngle * PI / 180)) * wewe),
		mouse_position.y - (abs(sin(theAngle * PI / 180)) * wewe)
	)

	if mouse_position.x < A().x:
		position.x = mouse_position.x - (abs(cos(theAngle * PI / 180)) * wewe)
	if mouse_position.y > A().y:
		position.y = mouse_position.y + (abs(sin(theAngle * PI / 180)) * wewe)

	$Unite_Circle/C_Controller.rect_position = (position - Vector2(ctrl_offset.x, ctrl_offset.y))
	$Unite_Circle/A_B_C.points[0] = position
	$Unite_Circle/A_B_C.points[3] = C()
	$Unite_Circle/A_B_C.points[2].x = C().x

	var rotation: float = 0
	if C().x > A().x:
		rotation = -angle_calc(C(), A(), B()) + 90
	elif C().x < A().x:
		rotation = angle_calc(C(), A(), B()) - 90

	if C().y > A().y:
		rotation = -rotation + 180

	$Unite_Circle/C_Controller.rect_rotation = rotation

	Angle_Text_Rotator()

	$Unite_Circle/Cutter.polygon[0] = A()
	$Unite_Circle/Cutter.polygon[1] = B()
	$Unite_Circle/Cutter.polygon[2] = C()


var angle: String


func AngleText():
	angle = str(round(angle_calc(C(), A(), B())))
	$Unite_Circle/A_Text_Director/A_Text_Director_Follow/A_Text.text = angle + '°'


func SinCosCal():
	var cosVal = str(stepify((B().x - A().x) / 357, 0.01))
	var sinVal = str(stepify((B().y - C().y) / 357, 0.01))

	if sinVal.length() == 3:
		sinVal += '0'

	if sinVal.length() == 4 && sinVal[0] == '-':
		sinVal += '0'

	if cosVal.length() == 3:
		cosVal += '0'

	if cosVal.length() == 4 && cosVal[0] == '-':
		cosVal += '0'

	match angle:
		'30':
			if cosVal[0] == '-':
				cosVal = '-√3/2'
			else:
				cosVal = '√3/2'
			if sinVal[0] == '-':
				sinVal = '-1/2'
			else:
				sinVal = '1/2'
		'45':
			if cosVal[0] == '-':
				cosVal = '-√2/2'
			else:
				cosVal = '√2/2'
			if sinVal[0] == '-':
				sinVal = '-√2/2'
			else:
				sinVal = '√2/2'
		'60':
			if cosVal[0] == '-':
				cosVal = '-1/2'
			else:
				cosVal = '1/2'

			if sinVal[0] == '-':
				sinVal = '-√3/2'
			else:
				sinVal = '√3/2'

	var sinX: float
	sinX = C().x
	if C().x > A().x:
		sinX += 10
	else:
		sinX -= 10 + $Unite_Circle/Cos.rect_size.x

	var cosY: float
	if C().y < A().y:
		cosY = 40 - $Unite_Circle/Cos.rect_size.y / 2
	else:
		cosY = -40 - $Unite_Circle/Cos.rect_size.y / 2

	$Unite_Circle/Sin.text = 'sin(α) = ' + sinVal
	$Unite_Circle/Sin.rect_position.x = sinX
	$Unite_Circle/Sin.rect_position.y = (C().y - A().y) / 2 - $Unite_Circle/Sin.rect_size.y / 2

	$Unite_Circle/Cos.text = 'cos(α) = ' + cosVal
	$Unite_Circle/Cos.rect_position.x = 0
	$Unite_Circle/Cos.rect_position.x = (B().x - A().x) / 2 - $Unite_Circle/Cos.rect_size.x / 2

	$Unite_Circle/Cos.rect_position.y = cosY


func _process(delta):
	if C_Controller_pressed:
		mouse_position = mouse_pos() - C_Controller_start_position
		TrianglePos()
		AngleText()
		SinCosCal()


func _on_C_Controller_button_down():
	C_Controller_start_position = (mouse_pos() - C())
	C_Controller_pressed = true


func _on_C_Controller_button_up():
	C_Controller_pressed = false


var A_Hide_toggled: bool = true


func _on_A_Hide_pressed():
	A_Hide_toggled = ! A_Hide_toggled
	$Unite_Circle/A_Text_Director/A_Text_Director_Follow/A_Text.visible = A_Hide_toggled
	A_Hide = ! A_Hide_toggled


func _on_Restore_Button_pressed():
	mouse_position = Vector2(252.5, -252.5)
	TrianglePos()
	AngleText()
	SinCosCal()

func _on_FullScreen_Button_pressed():
	var state = OS.window_fullscreen
	OS.window_fullscreen = !state
	$FullScreen_Button.pressed = !state
