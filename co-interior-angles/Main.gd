extends Node2D

var A_Controller_pressed: bool = false
var B_Controller_pressed: bool = false
var C_Controller_pressed: bool = false
var D_Controller_pressed: bool = false

var A_Controller_start_position: Vector2
var B_Controller_start_position: Vector2
var C_Controller_start_position: Vector2
var D_Controller_start_position: Vector2


func A_mouse_loc():
	return A_Controller_start_position + get_local_mouse_position() + $A_Controller.rect_size / 2


func B_mouse_loc():
	return B_Controller_start_position + get_local_mouse_position() + $B_Controller.rect_size / 2


func C_mouse_loc():
	return C_Controller_start_position + get_local_mouse_position() + $C_Controller.rect_size / 2


func D_mouse_loc():
	return D_Controller_start_position + get_local_mouse_position() + $D_Controller.rect_size / 2


func angle_calc(p2, p1, p3):
	var p12 = sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
	var p13 = sqrt(pow(p1.x - p3.x, 2) + pow(p1.y - p3.y, 2))
	var p23 = sqrt(pow(p2.x - p3.x, 2) + pow(p2.y - p3.y, 2))

	if p12 == 0 or p13 == 0 or p23 == 0:
		return 0

	return acos(((pow(p12, 2)) + (pow(p13, 2)) - (pow(p23, 2))) / (2 * p12 * p13)) * 180 / PI


var A_B_slope: int = 0
var C_B_slope: int = 0


func A():
	return Vector2(stepify($A_B_C_D.points[2].x, 0.01), stepify($A_B_C_D.points[2].y, 0.01))


func B():
	return Vector2(stepify($A_B_C_D.points[1].x, 0.01), stepify($A_B_C_D.points[1].y, 0.01))


func C():
	return Vector2(stepify($A_B_C_D.points[0].x, 0.01), stepify($A_B_C_D.points[0].y, 0.01))


func D():
	return Vector2(stepify($A_B_C_D.points[3].x, 0.01), stepify($A_B_C_D.points[3].y, 0.01))


func A_Controller():
	return Vector2(
		stepify($A_Controller.rect_position.x, 0.01), stepify($A_Controller.rect_position.y, 0.01)
	)


func B_Controller():
	return Vector2(
		stepify($B_Controller.rect_position.x, 0.01), stepify($B_Controller.rect_position.y, 0.01)
	)


func C_Controller():
	return Vector2(
		stepify($C_Controller.rect_position.x, 0.01), stepify($C_Controller.rect_position.y, 0.01)
	)


func D_Controller():
	return Vector2(
		stepify($D_Controller.rect_position.x, 0.01), stepify($D_Controller.rect_position.y, 0.01)
	)


var A_Hide: bool = false
var B_Hide: bool = false

var Is_Parallel: bool = false

var A_loc: Vector2
var B_loc: Vector2
var C_loc: Vector2
var D_loc: Vector2

var A_Controller_loc: Vector2
var B_Controller_loc: Vector2
var C_Controller_loc: Vector2
var D_Controller_loc: Vector2

var A_unite_offset: float
var B_unite_offset: float
var C_unite_offset: float
var D_unite_offset: float


func Angle_Text_Values():
	var a = ''
	var b = ''
	if Is_Parallel:
		a = str(round(angle_calc(B(), A(), D())))
		b = str(180 - int(a))
	else:
		a = str(round(angle_calc(B(), A(), D())))
		b = str(round(angle_calc(C(), B(), A())))
	$A_Text_Director/A_Text_Director_Follow/A_Text.text = a
	$B_Text_Director/B_Text_Director_Follow/B_Text.text = b

	$A_Text_Director/A_Text_Director_Follow/A_Text.rect_position = (
		-$A_Text_Director/A_Text_Director_Follow/A_Text.rect_size
		/ 2
	)
	$B_Text_Director/B_Text_Director_Follow/B_Text.rect_position = (
		-$B_Text_Director/B_Text_Director_Follow/B_Text.rect_size
		/ 2
	)


func Controller_Rotator():
	# A() 
	if A().y > B().y and A().y > D().y:
		$A_Controller.rect_rotation = (
			(
				(angle_calc(B(), A(), Vector2(0, A().y)) + angle_calc(D(), A(), Vector2(0, A().y)))
				/ 2
			)
			+ 90
		)
	elif A().y > B().y and ((A().x - B().x) / (A().y - B().y) < (B().x - D().x) / (B().y - D().y)):
		$A_Controller.rect_rotation = (
			(
				(
					angle_calc(B(), A(), Vector2(0, A().y))
					+ angle_calc(D(), A(), Vector2(1920, A().y))
				)
				/ 2
			)
			+ 180
		)
	elif A().y > B().y and ((A().x - B().x) / (A().y - B().y) > (B().x - D().x) / (B().y - D().y)):
		$A_Controller.rect_rotation = (
			(angle_calc(B(), A(), Vector2(0, A().y)) + angle_calc(D(), A(), Vector2(1920, A().y)))
			/ 2
		)
	elif A().y > D().y and ((A().x - D().x) / (A().y - D().y) > (D().x - B().x) / (D().y - B().y)):
		$A_Controller.rect_rotation = (
			(angle_calc(B(), A(), Vector2(1920, A().y)) + angle_calc(D(), A(), Vector2(0, A().y)))
			/ 2
		)
	elif A().y > D().y and ((A().x - D().x) / (A().y - D().y) < (B().x - D().x) / (B().y - D().y)):
		$A_Controller.rect_rotation = (
			(
				(
					angle_calc(B(), A(), Vector2(1920, A().y))
					+ angle_calc(D(), A(), Vector2(0, A().y))
				)
				/ 2
			)
			+ 180
		)
	else:
		$A_Controller.rect_rotation = (
			90
			- (
				(angle_calc(B(), A(), Vector2(0, A().y)) + angle_calc(D(), A(), Vector2(0, A().y)))
				/ 2
			)
		)

	# B()
	if B().y > A().y and B().y > C().y:
		$B_Controller.rect_rotation = (
			(
				(angle_calc(A(), B(), Vector2(0, B().y)) + angle_calc(C(), B(), Vector2(0, B().y)))
				/ 2
			)
			+ 90
		)
	elif B().y > A().y and ((B().x - A().x) / (B().y - A().y) < (A().x - C().x) / (A().y - C().y)):
		$B_Controller.rect_rotation = (
			(
				(
					angle_calc(A(), B(), Vector2(0, B().y))
					+ angle_calc(C(), B(), Vector2(1920, B().y))
				)
				/ 2
			)
			+ 180
		)
	elif B().y > A().y and ((B().x - A().x) / (B().y - A().y) > (A().x - C().x) / (A().y - C().y)):
		$B_Controller.rect_rotation = (
			(angle_calc(A(), B(), Vector2(0, B().y)) + angle_calc(C(), B(), Vector2(1920, B().y)))
			/ 2
		)
	elif B().y > C().y and ((B().x - C().x) / (B().y - C().y) > (C().x - A().x) / (C().y - A().y)):
		$B_Controller.rect_rotation = (
			(angle_calc(A(), B(), Vector2(1920, B().y)) + angle_calc(C(), B(), Vector2(0, B().y)))
			/ 2
		)
	elif B().y > C().y and ((B().x - C().x) / (B().y - C().y) < (A().x - C().x) / (A().y - C().y)):
		$B_Controller.rect_rotation = (
			(
				(
					angle_calc(A(), B(), Vector2(1920, B().y))
					+ angle_calc(C(), B(), Vector2(0, B().y))
				)
				/ 2
			)
			+ 180
		)
	else:
		$B_Controller.rect_rotation = (
			90
			- (
				(angle_calc(A(), B(), Vector2(0, B().y)) + angle_calc(C(), B(), Vector2(0, B().y)))
				/ 2
			)
		)

	# C()
	if C().x > B().x:
		$C_Controller.rect_rotation = angle_calc(C(), B(), Vector2(B().x, 0))
	else:
		$C_Controller.rect_rotation = angle_calc(C(), B(), Vector2(B().x, 0)) * -1

	# D()
	if D().x > A().x:
		$D_Controller.rect_rotation = angle_calc(D(), A(), Vector2(A().x, 0))
	else:
		$D_Controller.rect_rotation = angle_calc(D(), A(), Vector2(A().x, 0)) * -1


func Angle_Text_Rotator():
	# A()
	if A().y > B().y and A().y > D().y:
		$A_Text_Director/A_Text_Director_Follow.unit_offset = (
			(
				(angle_calc(B(), A(), Vector2(0, A().y)) + angle_calc(C(), A(), Vector2(0, A().y)))
				/ 2
			)
			/ 360
		)
	elif A().y > B().y and (A().x - B().x) / (A().y - B().y) < (B().x - D().x) / (B().y - D().y):
		$A_Text_Director/A_Text_Director_Follow.unit_offset = (
			(
				(
					(
						angle_calc(B(), A(), Vector2(0, A().y))
						+ angle_calc(D(), A(), Vector2(1920, A().y))
					)
					/ 2
				)
				+ 90
			)
			/ 360
		)
	elif A().y > B().y and (A().x - B().x) / (A().y - B().y) > (B().x - D().x) / (B().y - D().y):
		$A_Text_Director/A_Text_Director_Follow.unit_offset = (
			(
				(
					(
						angle_calc(B(), A(), Vector2(0, A().y))
						+ angle_calc(D(), A(), Vector2(1920, A().y))
					)
					/ 2
				)
				- 90
			)
			/ 360
		)
	elif A().y > D().y and (A().x - D().x) / (A().y - D().y) > (D().x - B().x) / (D().y - B().y):
		$A_Text_Director/A_Text_Director_Follow.unit_offset = (
			(
				(
					(
						angle_calc(B(), A(), Vector2(1920, A().y))
						+ angle_calc(D(), A(), Vector2(0, A().y))
					)
					/ 2
				)
				- 90
			)
			/ 360
		)
	elif A().y > D().y and (A().x - D().x) / (A().y - D().y) < (B().x - D().x) / (B().y - D().y):
		$A_Text_Director/A_Text_Director_Follow.unit_offset = (
			(
				(
					(
						angle_calc(B(), A(), Vector2(1920, A().y))
						+ angle_calc(D(), A(), Vector2(0, A().y))
					)
					/ 2
				)
				+ 90
			)
			/ 360
		)
	else:
		$A_Text_Director/A_Text_Director_Follow.unit_offset = (
			(-(
				(angle_calc(B(), A(), Vector2(0, A().y)) + angle_calc(D(), A(), Vector2(0, A().y)))
				/ 2
			))
			/ 360
		)

	# B()
	if B().y > A().y and B().y > C().y:
		$B_Text_Director/B_Text_Director_Follow.unit_offset = (
			(
				(angle_calc(A(), B(), Vector2(0, B().y)) + angle_calc(C(), B(), Vector2(0, B().y)))
				/ 2
			)
			/ 360
		)
	elif B().y > A().y and (B().x - A().x) / (B().y - A().y) < (A().x - C().x) / (A().y - C().y):
		$B_Text_Director/B_Text_Director_Follow.unit_offset = (
			(
				(
					(
						angle_calc(A(), B(), Vector2(0, B().y))
						+ angle_calc(C(), B(), Vector2(1920, B().y))
					)
					/ 2
				)
				+ 90
			)
			/ 360
		)
	elif B().y > A().y and (B().x - A().x) / (B().y - A().y) > (A().x - C().x) / (A().y - C().y):
		$B_Text_Director/B_Text_Director_Follow.unit_offset = (
			(
				(
					(
						angle_calc(A(), B(), Vector2(0, B().y))
						+ angle_calc(C(), B(), Vector2(1920, B().y))
					)
					/ 2
				)
				- 90
			)
			/ 360
		)
	elif B().y > C().y and (B().x - C().x) / (B().y - C().y) > (C().x - A().x) / (C().y - A().y):
		$B_Text_Director/B_Text_Director_Follow.unit_offset = (
			(
				(
					(
						angle_calc(A(), B(), Vector2(1920, B().y))
						+ angle_calc(C(), B(), Vector2(0, B().y))
					)
					/ 2
				)
				- 90
			)
			/ 360
		)
	elif B().y > C().y and (B().x - C().x) / (B().y - C().y) < (A().x - C().x) / (A().y - C().y):
		$B_Text_Director/B_Text_Director_Follow.unit_offset = (
			(
				(
					(
						angle_calc(A(), B(), Vector2(1920, B().y))
						+ angle_calc(C(), B(), Vector2(0, B().y))
					)
					/ 2
				)
				+ 90
			)
			/ 360
		)
	else:
		$B_Text_Director/B_Text_Director_Follow.unit_offset = (
			(-(
				(angle_calc(A(), B(), Vector2(0, B().y)) + angle_calc(C(), B(), Vector2(0, B().y)))
				/ 2
			))
			/ 360
		)


func Circle_Rotation_Position():
	if ! A_Hide:
		if int($A_Text_Director/A_Text_Director_Follow/A_Text.text) != 90:
			$A_Circle.visible = true
			$A_Square.visible = false
			$A_Circle.rotation_degrees = $A_Controller.rect_rotation + 180
		else:
			$A_Circle.visible = false
			$A_Square.visible = true
			$A_Square.position = A()
			$A_Square.rotation_degrees = $A_Controller.rect_rotation + 135
	else:
		$A_Circle.visible = false
		$A_Square.visible = false

	if ! B_Hide:
		if int($B_Text_Director/B_Text_Director_Follow/B_Text.text) != 90:
			$B_Circle.visible = true
			$B_Square.visible = false
			$B_Circle.rotation_degrees = $B_Controller.rect_rotation + 180
		else:
			$B_Circle.visible = false
			$B_Square.visible = true
			$B_Square.position = B()
			$B_Square.rotation_degrees = $B_Controller.rect_rotation + 135
	else:
		$B_Circle.visible = false
		$B_Square.visible = false


func Angle_Text_Alignment():
	if (
		(A().x < B().x and A().x < C().x)
		or (A().x < B().x and A().x < D().x)
		or (A().x < C().x and A().x < D().x)
	):
		# Left
		$A_Controller_Text.rect_position = (
			A_Controller()
			+ $A_Controller.rect_size / 2
			- $A_Controller_Text.rect_size / 2
			- Vector2($A_Controller_Text.rect_size.x * 1.5, 0)
		)
	elif (
		(A().x > B().x and A().x > C().x)
		or (A().x > B().x and A().x > D().x)
		or (A().x > C().x and A().x > D().x)
	):
		# Right
		$A_Controller_Text.rect_position = (
			A_Controller()
			+ $A_Controller.rect_size / 2
			- $A_Controller_Text.rect_size / 2
			+ Vector2($A_Controller_Text.rect_size.x * 1.5, 0)
		)

	if (
		(C().x < B().x and C().x < A().x)
		or (C().x < B().x and C().x < D().x)
		or (C().x < A().x and C().x < D().x)
	):
		# Left
		$C_Controller_Text.rect_position = (
			$C_Controller.rect_position
			+ $C_Controller.rect_size / 2
			- $C_Controller_Text.rect_size / 2
			- Vector2($C_Controller_Text.rect_size.x * 1.5, 0)
		)
	else:
		# Right
		$C_Controller_Text.rect_position = (
			$C_Controller.rect_position
			+ $C_Controller.rect_size / 2
			- $C_Controller_Text.rect_size / 2
			+ Vector2($C_Controller_Text.rect_size.x * 1.5, 0)
		)
	#----- Aligning the 'Angle_Text' to the left or right based on it's position to the 'B' position -----#
	if (
		(B().x < C().x and B().x < A().x)
		or (B().x < C().x and B().x < D().x)
		or (B().x < A().x and B().x < D().x)
	):
		# Left
		$B_Controller_Text.rect_position = (
			$B_Controller.rect_position
			+ $B_Controller.rect_size / 2
			- $B_Controller_Text.rect_size / 2
			- Vector2($B_Controller_Text.rect_size.x * 1.5, 0)
		)
	else:
		# Right
		$B_Controller_Text.rect_position = (
			$B_Controller.rect_position
			+ $B_Controller.rect_size / 2
			- $B_Controller_Text.rect_size / 2
			+ Vector2($B_Controller_Text.rect_size.x * 1.5, 0)
		)

	if (
		(D().x < C().x and D().x < A().x)
		or (D().x < C().x and D().x < B().x)
		or (D().x < A().x and D().x < B().x)
	):
		# Left
		$D_Controller_Text.rect_position = (
			$D_Controller.rect_position
			+ $D_Controller.rect_size / 2
			- $D_Controller_Text.rect_size / 2
			- Vector2($D_Controller_Text.rect_size.x * 1.5, 0)
		)
	else:
		# Right
		$D_Controller_Text.rect_position = (
			$D_Controller.rect_position
			+ $D_Controller.rect_size / 2
			- $D_Controller_Text.rect_size / 2
			+ Vector2($D_Controller_Text.rect_size.x * 1.5, 0)
		)


func _ready():
	#adjusting the screen size if the program was running on windows (x86) and centering the window
	if OS.get_name() == 'Windows':
		OS.window_size = Vector2(
			stepify(OS.get_screen_size().x / 1.2, 1), stepify(OS.get_screen_size().y / 1.2, 1)
		)
		OS.center_window()

	#-------------------- Connecting 'Button's and 'Controller's --------------------#
	$A_Controller.connect('button_down', self, '_on_A_Controller_button_down')
	$A_Controller.connect('button_up', self, '_on_A_Controller_button_up')

	$B_Controller.connect('button_down', self, '_on_B_Controller_button_down')
	$B_Controller.connect('button_up', self, '_on_B_Controller_button_up')

	$C_Controller.connect('button_down', self, '_on_C_Controller_button_down')
	$C_Controller.connect('button_up', self, '_on_C_Controller_button_up')

	$D_Controller.connect('button_down', self, '_on_D_Controller_button_down')
	$D_Controller.connect('button_up', self, '_on_D_Controller_button_up')

	$A_Hide.connect('pressed', self, '_on_A_Hide_pressed')
	$B_Hide.connect('pressed', self, '_on_B_Hide_pressed')

	$Is_Parallel.connect('pressed', self, '_on_Parallel_pressed')

	$Restore_Button.connect('pressed', self, '_on_Restore_Button_pressed')
	#--------------------------------------------------------------------------------#

	#----- Centering the pivot to the origin (center of the object) for rotating in a correct way -----#
	$A_Controller.rect_pivot_offset = $A_Controller.rect_size / 2
	$B_Controller.rect_pivot_offset = $B_Controller.rect_size / 2
	$C_Controller.rect_pivot_offset = $C_Controller.rect_size / 2
	$D_Controller.rect_pivot_offset = $D_Controller.rect_size / 2
	#--------------------------------------------------------------------------------#

	#----- Centering the Controller position to the origin point as this feature is not in the inspector tab. -----#
	$A_Controller.rect_position = A() - $A_Controller.rect_size / 2
	$B_Controller.rect_position = B() - $B_Controller.rect_size / 2
	$C_Controller.rect_position = C() - $C_Controller.rect_size / 2
	$D_Controller.rect_position = D() - $D_Controller.rect_size / 2
	#--------------------------------------------------------------------------------#

	Angle_Text_Alignment()

	$A_Circle.position = A()
	$B_Circle.position = B()

	$Cutter.polygon[0] = A()
	$Cutter.polygon[1] = B()
	$Cutter.polygon[2] = C()
	$Cutter.polygon[3] = D()

	#----- Positioning the 'Text_Director' -----#
	$A_Text_Director.position = A()
	$B_Text_Director.position = B()
	#-------------------------------------------#

	Angle_Text_Values()
	Controller_Rotator()
	Angle_Text_Rotator()
	Circle_Rotation_Position()

	#----- Storing Everything position for the Restore button -----#
	A_loc = A()
	B_loc = B()
	C_loc = C()
	D_loc = D()

	A_Controller_loc = $A_Controller.rect_position
	B_Controller_loc = $B_Controller.rect_position
	C_Controller_loc = $C_Controller.rect_position
	D_Controller_loc = $D_Controller.rect_position
	#--------------------------------------------------------------#


var A_D_difference = Vector2()
var B_C_difference = Vector2()


func _process(__data__):
	# if A_Controller_pressed:
	# 	# if Is_Parallel:
	# 	# 	$D_Controller.set_position(
	# 	# 		A_Controller_start_position + get_local_mouse_position() - (A() - D())
	# 	# 	)
	# 	# 	$A_B_C_D.points[3] = (
	# 	# 		$D_Controller.rect_position
	# 	# 		+ Vector2(
	# 	# 			round($D_Controller.rect_size.x / 2), round($D_Controller.rect_size.y / 2)
	# 	# 		)
	# 	# 	)

	# 	# 	$C_Controller.set_position(
	# 	# 		D() - Vector2(0, abs(A().y - B().y) * -1) - $C_Controller.rect_size / 2
	# 	# 	)
	# 	# 	$A_B_C_D.points[0] = (
	# 	# 		$C_Controller.rect_position
	# 	# 		+ Vector2(
	# 	# 			round($C_Controller.rect_size.x / 2), round($C_Controller.rect_size.y / 2)
	# 	# 		)
	# 	# 	)

	# 	# Positioning the 'Controller'.
	# 	$A_Controller.set_position(A_Controller_start_position + get_local_mouse_position())

	# 	# Positioning the 'A' point from the 'Conroller' position data
	# 	$A_B_C_D.points[2] = (
	# 		$A_Controller.rect_position
	# 		+ Vector2(round($A_Controller.rect_size.x / 2), round($A_Controller.rect_size.y / 2))
	# 	)

	# 	Angle_Text_Alignment()
	# 	$A_Text_Director.position = A()
	# 	Angle_Text_Values()
	# 	Angle_Text_Rotator()
	# 	Controller_Rotator()
	# 	$A_Circle.position = A()
	# 	Circle_Rotation_Position()

	# 	$Cutter.polygon[0] = A()
	# 	# if Is_Parallel:
	# 	# 	$Cutter.polygon[3] = D()
	# 	# 	$Cutter.polygon[2] = C()

	# if B_Controller_pressed:
	# 	# if Is_Parallel:
	# 	# 	$C_Controller.set_position(
	# 	# 		B_Controller_start_position + get_local_mouse_position() - (B() - C())
	# 	# 	)
	# 	# 	$A_B_C_D.points[0] = (
	# 	# 		$C_Controller.rect_position
	# 	# 		+ Vector2(
	# 	# 			round($C_Controller.rect_size.x / 2), round($C_Controller.rect_size.y / 2)
	# 	# 		)
	# 	# 	)

	# 	# 	$D_Controller.set_position(
	# 	# 		C() - Vector2(0, abs(B().y - A().y)) - $D_Controller.rect_size / 2
	# 	# 	)
	# 	# 	$A_B_C_D.points[3] = (
	# 	# 		$D_Controller.rect_position
	# 	# 		+ Vector2(
	# 	# 			round($D_Controller.rect_size.x / 2), round($D_Controller.rect_size.y / 2)
	# 	# 		)
	# 	# 	)

	# 	# Positioning the 'Controller'.
	# 	$B_Controller.set_position(B_Controller_start_position + get_local_mouse_position())

	# 	# Positioning the 'B' point from the 'Conroller' position data
	# 	$A_B_C_D.points[1] = (
	# 		$B_Controller.rect_position
	# 		+ Vector2(round($B_Controller.rect_size.x / 2), round($B_Controller.rect_size.y / 2))
	# 	)

	# 	Angle_Text_Alignment()

	# 	$B_Text_Director.position = B()

	# 	Angle_Text_Values()
	# 	Angle_Text_Rotator()
	# 	Controller_Rotator()
	# 	$B_Circle.position = B()
	# 	Circle_Rotation_Position()

	# 	$Cutter.polygon[1] = B()
	# 	# if Is_Parallel:
	# 	# 	$Cutter.polygon[3] = D()
	# 	# 	$Cutter.polygon[2] = C()

	if C_Controller_pressed:
		#----- Positioning and Rotating the Controller -----#
		var C_limiter
		var error_margin = 2
		if (
			A().x - error_margin
			> (
				C_Controller_start_position.x
				+ get_local_mouse_position().x
				+ $C_Controller.rect_size.x / 2
			)
		):
			C_limiter = Vector2(
				(
					C_Controller_start_position.x
					+ get_local_mouse_position().x
					- (A().x - error_margin)
					+ ($C_Controller.rect_size.y / 2)
				),
				0
			)
		else:
			C_limiter = Vector2(0, 0)

		if Is_Parallel:
			$D_Controller.set_position(
				(
					C_Controller_start_position
					+ get_local_mouse_position()
					- C_limiter
					- Vector2(0, abs(A().y - B().y))
				)
			)
			$A_B_C_D.points[3] = (
				$D_Controller.rect_position
				+ Vector2(
					round($D_Controller.rect_size.x / 2), round($D_Controller.rect_size.y / 2)
				)
			)

		$C_Controller.set_position(
			C_Controller_start_position + get_local_mouse_position() - C_limiter
		)

		# Positioning the 'C' point from the 'Conroller' position data
		$A_B_C_D.points[0] = (
			$C_Controller.rect_position
			+ Vector2(round($C_Controller.rect_size.x / 2), round($C_Controller.rect_size.y / 2))
		)

		Angle_Text_Alignment()
		Angle_Text_Values()
		Angle_Text_Rotator()
		Controller_Rotator()
		Circle_Rotation_Position()

		$Cutter.polygon[2] = C()
		if Is_Parallel:
			$Cutter.polygon[3] = D()

	if D_Controller_pressed:
		var D_limiter
		var error_margin = 2
		if (
			A().x - error_margin
			> (
				D_Controller_start_position.x
				+ get_local_mouse_position().x
				+ $D_Controller.rect_size.x / 2
			)
		):
			D_limiter = Vector2(
				(
					D_Controller_start_position.x
					+ get_local_mouse_position().x
					- (A().x - error_margin)
					+ ($D_Controller.rect_size.y / 2)
				),
				0
			)
		else:
			D_limiter = Vector2(0, 0)

		if Is_Parallel:
			$C_Controller.set_position(
				(
					D_Controller_start_position
					+ get_local_mouse_position()
					- D_limiter
					- Vector2(0, abs(A().y - B().y) * -1)
				)
			)
			$A_B_C_D.points[0] = (
				$C_Controller.rect_position
				+ Vector2(
					round($C_Controller.rect_size.x / 2), round($C_Controller.rect_size.y / 2)
				)
			)

		$D_Controller.set_position(
			D_Controller_start_position + get_local_mouse_position() - D_limiter
		)

		# Positioning the 'D' point from the 'Conroller' position data
		$A_B_C_D.points[3] = (
			$D_Controller.rect_position
			+ Vector2(round($D_Controller.rect_size.x / 2), round($D_Controller.rect_size.y / 2))
		)

		Angle_Text_Alignment()
		Angle_Text_Values()
		Angle_Text_Rotator()
		Controller_Rotator()
		Circle_Rotation_Position()

		$Cutter.polygon[3] = D()
		if Is_Parallel:
			$Cutter.polygon[2] = C()


# #----- A_Controller -----#
# func _on_A_Controller_button_down():
# 	A_D_difference = A() - D()
# 	A_Controller_start_position = $A_Controller.rect_position - get_local_mouse_position()
# 	A_Controller_pressed = true

# func _on_A_Controller_button_up():
# 	A_Controller_pressed = false

# #------------------------#

# #----- B_Controller -----#
# func _on_B_Controller_button_down():
# 	B_C_difference = B() - C()
# 	B_Controller_start_position = $B_Controller.rect_position - get_local_mouse_position()
# 	B_Controller_pressed = true

# func _on_B_Controller_button_up():
# 	B_Controller_pressed = false

# #-----------------------#


#----- C_Controller -----#
func _on_C_Controller_button_down():
	C_Controller_start_position = $C_Controller.rect_position - get_local_mouse_position()
	C_Controller_pressed = true


func _on_C_Controller_button_up():
	C_Controller_pressed = false


#------------------------#


#----- D_Controller -----#
func _on_D_Controller_button_down():
	D_Controller_start_position = $D_Controller.rect_position - get_local_mouse_position()
	D_Controller_pressed = true


func _on_D_Controller_button_up():
	D_Controller_pressed = false


#------------------------#

#----- Hide_Buttons -----#

# Function for the 'A_B_C_D_Hide' button.
var A_Hide_toggled: bool = true


func _on_A_Hide_pressed():
	A_Hide_toggled = ! A_Hide_toggled
	$A_Text_Director/A_Text_Director_Follow/A_Text.visible = A_Hide_toggled
	A_Hide = ! A_Hide_toggled
	Circle_Rotation_Position()


# Function for the 'B_Hide' button.
var B_Hide_toggled: bool = true


func _on_B_Hide_pressed():
	B_Hide_toggled = ! B_Hide_toggled
	$B_Text_Director/B_Text_Director_Follow/B_Text.visible = B_Hide_toggled
	B_Hide = ! B_Hide_toggled
	Circle_Rotation_Position()


func _on_Parallel_pressed():
	Is_Parallel = ! Is_Parallel


#--------------------------------------------------------------------------------#
#-----'Restore_Button' to reset everything using the properties that were stored early in the _ready function. -----#
func _on_Restore_Button_pressed():
	#----- Controllers -----#
	$A_Controller.rect_position = A_Controller_loc
	$B_Controller.rect_position = B_Controller_loc
	$C_Controller.rect_position = C_Controller_loc
	$D_Controller.rect_position = D_Controller_loc
	#-----------------------#

	#----- Points -----#
	$A_B_C_D.points[2] = A_loc
	$A_B_C_D.points[1] = B_loc
	$A_B_C_D.points[0] = C_loc
	$A_B_C_D.points[3] = D_loc

	#----- Cutters -----#
	$Cutter.polygon[0] = A()
	$Cutter.polygon[1] = B()
	$Cutter.polygon[2] = C()
	$Cutter.polygon[3] = D()
	#-------------------#

	$A_Text_Director.position = A_loc
	$B_Text_Director.position = B_loc

	# $A_Circle.position = A_loc
	# $B_Circle.position = B_loc

	Angle_Text_Rotator()
	Angle_Text_Values()
	Controller_Rotator()

	Angle_Text_Alignment()

	#----- Hide Buttons -----#
	$A_Hide.pressed = false
	A_Hide_toggled = false
	_on_A_Hide_pressed()

	$B_Hide.pressed = false
	B_Hide_toggled = false
	_on_B_Hide_pressed()
	#------------------------#
	$Is_Parallel.pressed = false
	Is_Parallel = false
