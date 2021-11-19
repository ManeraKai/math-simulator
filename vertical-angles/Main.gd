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
	return Vector2(stepify($A_B.points[0].x, 0.01), stepify($A_B.points[0].y, 0.01))


func B():
	return Vector2(stepify($A_B.points[1].x, 0.01), stepify($A_B.points[1].y, 0.01))


func C():
	return Vector2(stepify($D_B_C.points[0].x, 0.01), stepify($D_B_C.points[0].y, 0.01))


func D():
	return Vector2(stepify($D_B_C.points[2].x, 0.01), stepify($D_B_C.points[2].y, 0.01))


func E():
	return Vector2(stepify($A_B.points[2].x, 0.01), stepify($A_B.points[2].y, 0.01))


func A_Controller():
	return Vector2(
		stepify($A_Controller.rect_position.x, 0.01), stepify($A_Controller.rect_position.y, 0.01)
	)


func C_Controller():
	return Vector2(
		stepify($C_Controller.rect_position.x, 0.01), stepify($C_Controller.rect_position.y, 0.01)
	)
	

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


func _ready():
	#adjusting the screen size if the program was running on windows (x86) and centering the window
	if OS.get_name() == 'Windows':
		OS.window_size = Vector2(
			stepify(OS.get_screen_size().x / 1.2, 1), stepify(OS.get_screen_size().y / 1.2, 1)
		)
		OS.center_window()

	#----- Connecting 'Buttons' and 'Controller' -----#	
	$A_Controller.connect('button_down', self, '_on_A_Controller_button_down')
	$A_Controller.connect('button_up', self, '_on_A_Controller_button_up')

	$C_Controller.connect('button_down', self, '_on_C_Controller_button_down')
	$C_Controller.connect('button_up', self, '_on_C_Controller_button_up')

	$A_B_C_Hide.connect('pressed', self, '_on_A_B_C_Hide_pressed')
	$A_B_D_Hide.connect('pressed', self, '_on_A_B_D_Hide_pressed')

	$Restore_Button.connect('pressed', self, '_on_Restore_Button_pressed')
	#--------------------------------------------------------------------------------#

	#----- Centering the pivot to the origin (center of the object) for rotating in a correct way -----#
	$A_Controller.rect_pivot_offset = $A_Controller.rect_size / 2
	$C_Controller.rect_pivot_offset = $C_Controller.rect_size / 2
	#--------------------------------------------------------------------------------#

	#----- Controlling the rotation of the Controller to make like it's tracking the 'B' point or the center of the display -----#
	$C_Controller.rect_rotation = angle_calc(B(), C(), Vector2(0, B().y)) - 90
	#--------------------------------------------------------------------------------#

	#----- Centering the Controller position to the origin point as this feature is not in the inspector tab. -----#
	$A_Controller.rect_position.x = B().x - ($A_Controller.rect_size.x / 2)
	$C_Controller.rect_position = C() - $C_Controller.rect_size / 2

	# $A_B.points[0] = A()
	$A_B.points[0] = (
		A_Controller()
		+ Vector2(round($A_Controller.rect_size.x / 2), round($A_Controller.rect_size.y / 2))
	)
	#--------------------------------------------------------------------------------#

	#----- Aligning the 'Angle_Text's to the left or right based on the 'B' position. B is in the center -----#

	# Aligning 'A_Controller_Text'
	if A().x - B().x < 0:
		# Left
		$A_Controller_Text.rect_position = (
			A_Controller()
			+ $A_Controller.rect_size / 2
			- $A_Controller_Text.rect_size / 2
			- Vector2($A_Controller_Text.rect_size.x * 1.5, 0)
		)
	else:
		# Right
		$A_Controller_Text.rect_position = (
			A_Controller()
			+ $A_Controller.rect_size / 2
			- $A_Controller_Text.rect_size / 2
			+ Vector2($A_Controller_Text.rect_size.x * 1.5, 0)
		)

	# Aligning 'C_Controller_Text'
	if C().x - B().x < 0:
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

	#--------------------------------------------------------------------------------#

	#----- Calculating where the 'Angle_Text' will be placed based on some matrix calculations :) -----#

	#A_B_C_Text
	$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (
		(angle_calc(B(), A(), C()) / 2 + angle_calc(B(), C(), Vector2(C().x, B().y)))
		/ 360
	)

	#--------------------------------------------------------------------------------#

	#----- Changing the 'Angle_Indicator' to be a 'Cirlce' or a 'Square'. If the angle is 90. Then 'Square', if the angle is not 90. Then 'Circle' ----#

	if round(angle_calc(B(), A(), C())) == 90:
		$A_B_C_Square.rotation_degrees = (
			45
			- (angle_calc(B(), A(), C()) / 2 + angle_calc(B(), C(), Vector2(1921, B().y)))
		)
		$A_B_C_Square.visible = true

	else:
		$A_B_C_Square.visible = false

	#--------------------------------------------------------------------------------#

	#----- Storing Everything position for the Restore button -----#

	# Storing the 'z_index'
	A_B_C_Cutter_z_index = $A_B_C_Cutter.z_index
	A_B_D_Cutter_z_index = $A_B_D_Cutter.z_index

	# Storing the 'Points' location.
	A_loc = A()
	C_loc = C()

	# Storing the 'Points_Controllers' location.
	A_Controller_loc = $A_Controller.rect_position
	C_Controller_loc = $C_Controller.rect_position

	# Storing the 'Angle_Text' position.
	A_B_C_unite_offset = $A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset
	A_B_D_unite_offset = $A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset

	#--------------------------------------------------------------------------------#


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

var i = 0
func text_rotation():
	

	if C().x > B().x:
		if A().x > B().x:
			if (A().x - E().x) != 0 && (C().x - D().x) != 0:
				if (A().y - E().y) / (A().x - E().x) < (C().y - D().y) / (C().x - D().x):
					print(1)
					$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (
						(180 + (angle_calc(B(), A(), C()) / 2 + angle_calc(B(), Vector2(B().x, 1920), C()) - 90))
						/ 360.0
					)
					$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = (
						(180 + (90 - angle_calc(B(), A(), D()) / 2 + angle_calc(B(), Vector2(B().x, 0), D())))
						/ 360.0
					)
					$D_B_E_Text_Director/D_B_E_Text_Director_Follow.unit_offset = (
						(180 + (180 + angle_calc(B(), A(), C()) / 2 + angle_calc(B(), Vector2(B().x, 1920), C()) - 90))
						/ 360.0
					)
					$C_B_E_Text_Director/C_B_E_Text_Director_Follow.unit_offset = (
						(180 + (270 - angle_calc(B(), A(), D()) / 2 + angle_calc(B(), Vector2(B().x, 0), D())))
						/ 360.0
					)
				else:
					print(2)
					$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (
						(180 + (angle_calc(B(), A(), C()) / -2 + angle_calc(B(), Vector2(B().x, 1920), C()) - 90))
						/ 360.0
					)
					$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = (
						(180 + (90 - angle_calc(B(), A(), D()) / -2 + angle_calc(B(), Vector2(B().x, 0), D())))
						/ 360.0
					)
					$D_B_E_Text_Director/D_B_E_Text_Director_Follow.unit_offset = (
						(180 + (180 + angle_calc(B(), A(), C()) / -2 + angle_calc(B(), Vector2(B().x, 1920), C()) - 90))
						/ 360.0
					)
					$C_B_E_Text_Director/C_B_E_Text_Director_Follow.unit_offset = (
						(180 + (270 - angle_calc(B(), A(), D()) / -2 + angle_calc(B(), Vector2(B().x, 0), D())))
						/ 360.0
					)
		else:
			if (A().x - E().x) != 0 && (C().x - D().x) != 0:
				if (A().y - E().y) / (A().x - E().x) < (C().y - D().y) / (C().x - D().x):
					print(3)
					$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (
						(180 + (angle_calc(B(), A(), C()) / -2 + angle_calc(B(), Vector2(B().x, 1920), C()) - 90))
						/ 360.0
					)
					$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = (
						(180 + (90 - angle_calc(B(), A(), D()) / -2 + angle_calc(B(), Vector2(B().x, 0), D())))
						/ 360.0
					)
					$D_B_E_Text_Director/D_B_E_Text_Director_Follow.unit_offset = (
						(180 + (180 + angle_calc(B(), A(), C()) / -2 + angle_calc(B(), Vector2(B().x, 1920), C()) - 90))
						/ 360.0
					)
					$C_B_E_Text_Director/C_B_E_Text_Director_Follow.unit_offset = (
						(180 + (270 - angle_calc(B(), A(), D()) / -2 + angle_calc(B(), Vector2(B().x, 0), D())))
						/ 360.0
					)
				else:
					print(4)
					$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (
						(angle_calc(B(), A(), C()) / 2 + angle_calc(B(), Vector2(B().x, 1920), C()) - 90)
						/ 360.0
					)
					$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = (
						(90 - angle_calc(B(), A(), D()) / 2 + angle_calc(B(), Vector2(B().x, 0), D()))
						/ 360.0
					)
					$D_B_E_Text_Director/D_B_E_Text_Director_Follow.unit_offset = (
						(180 + angle_calc(B(), A(), C()) / 2 + angle_calc(B(), Vector2(B().x, 1920), C()) - 90)
						/ 360.0
					)
					$C_B_E_Text_Director/C_B_E_Text_Director_Follow.unit_offset = (
						(270 - angle_calc(B(), A(), D()) / 2 + angle_calc(B(), Vector2(B().x, 0), D()))
						/ 360.0
					)
	else:
		if A().x > B().x:
			if (A().x - E().x) != 0 && (C().x - D().x) != 0:
				if (A().y - E().y) / (A().x - E().x) < (C().y - D().y) / (C().x - D().x):
					print(5)
					$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (
						(180 + (angle_calc(B(), A(), C()) / -2 + angle_calc(B(), Vector2(B().x, 0), C()) - 90))
						/ 360.0
					)
					$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = (
						(180 + (90 - angle_calc(B(), A(), D()) / -2 + angle_calc(B(), Vector2(B().x, 1920), D())))
						/ 360.0
					)
					$D_B_E_Text_Director/D_B_E_Text_Director_Follow.unit_offset = (
						(180 + (180 + angle_calc(B(), A(), C()) / -2 + angle_calc(B(), Vector2(B().x, 0), C()) - 90))
						/ 360.0
					)
					$C_B_E_Text_Director/C_B_E_Text_Director_Follow.unit_offset = (
						(180 + (270 - angle_calc(B(), A(), D()) / -2 + angle_calc(B(), Vector2(B().x, 1920), D())))
						/ 360.0
					)
				else:
					print(6)
					$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (
						(180 + (angle_calc(B(), A(), C()) / 2 + angle_calc(B(), Vector2(B().x, 0), C()) - 90))
						/ 360.0
					)
					$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = (
						(180 + (90 - angle_calc(B(), A(), D()) / 2 + angle_calc(B(), Vector2(B().x, 1920), D())))
						/ 360.0
					)
					$D_B_E_Text_Director/D_B_E_Text_Director_Follow.unit_offset = (
						(180 + (180 + angle_calc(B(), A(), C()) / 2 + angle_calc(B(), Vector2(B().x, 0), C()) - 90))
						/ 360.0
					)
					$C_B_E_Text_Director/C_B_E_Text_Director_Follow.unit_offset = (
						(180 + (270 - angle_calc(B(), A(), D()) / 2 + angle_calc(B(), Vector2(B().x, 1920), D())))
						/ 360.0
					)
		else:
			if (A().x - E().x) != 0 && (C().x - D().x) != 0:
				if (A().y - E().y) / (A().x - E().x) < (C().y - D().y) / (C().x - D().x):
					print(7)
					$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (
						(180 + (angle_calc(B(), A(), C()) / 2 + angle_calc(B(), Vector2(B().x, 0), C()) - 90))
						/ 360.0
					)
					$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = (
						(180 + (90 - angle_calc(B(), A(), D()) / 2 + angle_calc(B(), Vector2(B().x, 1920), D())))
						/ 360.0
					)
					$D_B_E_Text_Director/D_B_E_Text_Director_Follow.unit_offset = (
						(180 + (180 + angle_calc(B(), A(), C()) / 2 + angle_calc(B(), Vector2(B().x, 0), C()) - 90))
						/ 360.0
					)
					$C_B_E_Text_Director/C_B_E_Text_Director_Follow.unit_offset = (
						(180 + (270 - angle_calc(B(), A(), D()) / 2 + angle_calc(B(), Vector2(B().x, 1920), D())))
						/ 360.0
					)
				else:
					print(8)
					$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (
						(180 + (angle_calc(B(), A(), C()) / -2 + angle_calc(B(), Vector2(B().x, 0), C()) - 90))
						/ 360.0
					)
					$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = (
						(180 + (90 - angle_calc(B(), A(), D()) / -2 + angle_calc(B(), Vector2(B().x, 1920), D())))
						/ 360.0
					)
					$D_B_E_Text_Director/D_B_E_Text_Director_Follow.unit_offset = (
						(180 + (180 + angle_calc(B(), A(), C()) / -2 + angle_calc(B(), Vector2(B().x, 0), C()) - 90))
						/ 360.0
					)
					$C_B_E_Text_Director/C_B_E_Text_Director_Follow.unit_offset = (
						(180 + (270 - angle_calc(B(), A(), D()) / -2 + angle_calc(B(), Vector2(B().x, 1920), D())))
						/ 360.0
					)


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
	
func _process(__data__):
	if A_Controller_pressed:
		#----- Making some if statements with a 'Controller_limiter'. So, when a thing that unwanted happens, that limitter value will take out that unwanted data from the given mouse_position values and then send it. -----#

		# Positioning the 'Controller'.
		$A_Controller.set_position(A_Controller_start_position + get_local_mouse_position())

		# $E_Controller.set_position(
		# 	Vector2(
		# 		1920 - (A_Controller_start_position.x + get_local_mouse_position().x) - $E_Controller.rect_size.x, 
		# 		1080 - (A_Controller_start_position.y + get_local_mouse_position().y) - $E_Controller.rect_size.y
		# 	))

		# Rotating the Controller so it will track the 'B' point or the bottom center of the display.

		if (A().y < B().y):
			$A_Controller.rect_rotation = angle_calc(B(), A(), Vector2(0, B().y)) - 90
			# $E_Controller.rect_rotation = angle_calc(B(), A(), Vector2(0, B().y)) - 270
		else:
			$A_Controller.rect_rotation = angle_calc(B(), A(), Vector2(1920, B().y)) +90
			# $E_Controller.rect_rotation = angle_calc(B(), A(), Vector2(1920, B().y)) + 270

		#--------------------------------------------------------------------------------#

		# Positioning the 'A' point from the 'Conroller' position data
		# A() = 
		$A_B.points[0] = (
			A_Controller()
			+ Vector2(round($A_Controller.rect_size.x / 2), round($A_Controller.rect_size.y / 2))
		)
		$A_B.points[2] = (Vector2(
			1920 - (A_Controller().x + round($A_Controller.rect_size.x / 2)),
			1080 - (A_Controller().y + round($A_Controller.rect_size.y / 2))
		))

		#----- Aligning the 'Angle_Text' to the left or right based on it's position to the 'B' position -----#
		if A_B_difference().x < 0:
			# Left
			$A_Controller_Text.rect_position = (
				A_Controller()
				+ $A_Controller.rect_size / 2
				- $A_Controller_Text.rect_size / 2
				- Vector2($A_Controller_Text.rect_size.x * 1.5, 0)
			)
			$E_Controller_Text.rect_position = (
				Vector2(1920,1080) - A_Controller()
				- $A_Controller.rect_size / 2
				- $A_Controller_Text.rect_size / 2
				+ Vector2($E_Controller_Text.rect_size.x * 1.5, 0)
			)
		else:
			# Right
			$A_Controller_Text.rect_position = (
				A_Controller()
				+ $A_Controller.rect_size / 2
				- $A_Controller_Text.rect_size / 2
				+ Vector2($A_Controller_Text.rect_size.x * 1.5, 0)
			)
			$E_Controller_Text.rect_position = (
				Vector2(1920,1080) - A_Controller()
				- $A_Controller.rect_size / 2
				- $A_Controller_Text.rect_size / 2
				- Vector2($E_Controller_Text.rect_size.x * 1.5, 0)
			)
		#-----------------------------------------------------------------------------------------------------#


		angle_values()
		text_rotation()

		#----- Positioning the Cutter points. The cutter is for cutting the 'Angle_Indicator_Circle'.

		$A_B_C_Cutter.polygon[0] = A()
		$A_B_D_Cutter.polygon[1] = A()
		$A_B_D_Cutter.polygon[0] = Vector2((C().x + A().x) / 2, (C().y + A().y) / 2 - 500)

		#--------------------------------------------------------------------------------#
		is_90()
		#----- If the Hide Buttons are pressed -----#
		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false

		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			# $A_B_D_Square.visible = false
		#-------------------------------------------#

	if C_Controller_pressed:
		#----- Positioning and Rotating the Controller -----#
		$C_Controller.set_position(C_Controller_start_position + get_local_mouse_position())
		

		# Rotating the Controller so it will track the 'B' point or the bottom center of the display.
		
		# $D_Controller.set_position(
		# 	Vector2(
		# 		1920 - (C_Controller_start_position.x + get_local_mouse_position().x) - $D_Controller.rect_size.x,
		# 		1080 - (C_Controller_start_position.y + get_local_mouse_position().y) - $D_Controller.rect_size.y
		# 	))

		if (C().y < B().y):
			$C_Controller.rect_rotation = angle_calc(B(), C(), Vector2(0, B().y)) - 90
			# $D_Controller.rect_rotation = angle_calc(B(), C(), Vector2(0, B().y)) - 270
		else:
			$C_Controller.rect_rotation = angle_calc(B(), C(), Vector2(1920, B().y)) + 90
			# $D_Controller.rect_rotation = angle_calc(B(), C(), Vector2(1920, B().y)) + 270
	
		#---------------------------------------------------#

		# Positioning the 'A' point from the 'Conroller' position data
		# C() = 
		

		$D_B_C.points[0] = (
			$C_Controller.rect_position
			+ Vector2(round($C_Controller.rect_size.x / 2), round($C_Controller.rect_size.y / 2))
		)
		$D_B_C.points[2] = (Vector2(1920,1080) - $D_B_C.points[0])


		#----- Aligning the 'Angle_Text' to the left or right based on it's position to the 'B' position -----#
		if C().x - B().x < 0:
			# Left
			$C_Controller_Text.rect_position = (
				$C_Controller.rect_position
				+ $C_Controller.rect_size / 2
				- $C_Controller_Text.rect_size / 2
				- Vector2($C_Controller_Text.rect_size.x * 1.5, 0)
			)
			$D_Controller_Text.rect_position = (
				Vector2(1920,1080) - $C_Controller.rect_position
				- $C_Controller.rect_size / 2
				- $C_Controller_Text.rect_size / 2
				+ Vector2($C_Controller_Text.rect_size.x * 1.5, 0)
			)
		else:
			# Right
			$C_Controller_Text.rect_position = (
				$C_Controller.rect_position
				+ $C_Controller.rect_size / 2
				- $C_Controller_Text.rect_size / 2
				+ Vector2($C_Controller_Text.rect_size.x * 1.5, 0)
			)
			$D_Controller_Text.rect_position = (
			Vector2(1920,1080) - 	$C_Controller.rect_position
				- $C_Controller.rect_size / 2
				- $C_Controller_Text.rect_size / 2
				- Vector2($C_Controller_Text.rect_size.x * 1.5, 0)
			)
		#-----------------------------------------------------------------------------------------------------#

		angle_values()
		text_rotation()

		#----- Positioning the Cutter points. The cutter is for cutting the 'Angle_Indicator_Circle'.

		$A_B_D_Cutter.polygon[3] = C()
		$A_B_D_Cutter.polygon[0] = Vector2((C().x + A().x) / 2, (C().y + A().y) / 2 - 500)

		#--------------------------------------------------------------------------------#

		is_90()

		#----- If the Hide Buttons are pressed -----#
		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false

		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			# $A_B_D_Square.visible = false
		#-------------------------------------------#


#----- A_Controller -----#


func _on_A_Controller_button_down():
	A_Controller_start_position = $A_Controller.rect_position - get_local_mouse_position()
	A_Controller_pressed = true


func _on_A_Controller_button_up():
	A_Controller_pressed = false


#------------------------#

#----- C_Controller -----#


func _on_C_Controller_button_down():
	C_Controller_start_position = $C_Controller.rect_position - get_local_mouse_position()
	C_Controller_pressed = true


func _on_C_Controller_button_up():
	C_Controller_pressed = false


#------------------------#

#----- Hide_Buttons -----#

var A_B_C_Hide_toggled: bool = true


# Function for the 'A_B_C_Hide' button.
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


# Function for 'A_B_D_Hide' button
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


#--------------------------------------------------------------------------------#


#-----'Restore_Button' to reset everything using the properties that were stored early in the _ready function. -----#
func _on_Restore_Button_pressed():
	#----- Points -----#
	$A_B.points[0] = A_loc
	$D_B_C.points[0] = C_loc
	#------------------#

	#----- Controllers -----#
	$A_Controller.rect_position = A_Controller_loc
	$C_Controller.rect_position = C_loc - $C_Controller.rect_size / 2

	$A_Controller.rect_rotation = angle_calc(B(), A_loc, Vector2(0, B().y)) - 90
	$C_Controller.rect_rotation = angle_calc(B(), C_loc, Vector2(0, B().y)) - 90
	#-----------------------#

	#----- Controller_Text -----#
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
	#---------------------------#

	#----- Angle_Text -----#
	$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = A_B_C_unite_offset
	$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = A_B_D_unite_offset

	$A_B_C_Text_Director/A_B_C_Text_Director_Follow/A_B_C_Text.text = '90'
	$A_B_D_Text_Director/A_B_D_Text_Director_Follow/A_B_D_Text.text = '90'

	$A_B_C_Text_Director/A_B_C_Text_Director_Follow/A_B_C_Text.visible = true
	$A_B_D_Text_Director/A_B_D_Text_Director_Follow/A_B_D_Text.visible = true
	#----------------------#

	#----- Cutters -----#
	$A_B_C_Cutter.polygon[0] = A_loc
	$A_B_C_Cutter.polygon[2] = D_loc
	$A_B_C_Cutter.polygon[1] = Vector2(D_loc.x, A_loc.y)

	$A_B_D_Cutter.polygon[1] = A_loc
	$A_B_D_Cutter.polygon[3] = C_loc
	$A_B_D_Cutter.polygon[0] = Vector2(C_loc.x, A_loc.y)

	$A_B_C_Cutter.z_index = A_B_C_Cutter_z_index
	$A_B_D_Cutter.z_index = A_B_D_Cutter_z_index
	#-------------------#

	#----- Squares -----#
	$A_B_C_Square.rotation_degrees = (
		45
		- (angle_calc(B(), A_loc, C_loc) / 2 + angle_calc(B(), C_loc, Vector2(1921, B().y)))
	)
	# $A_B_D_Square.rotation_degrees = (
	# 	225
	# 	- (angle_calc(B(), A_loc, D_loc) / 2 + angle_calc(B(), D_loc, Vector2(1921, B().y)))
	# )
	$A_B_C_Square.visible = true
	# $A_B_D_Square.visible = true
	#------------------#

	#----- Circles -----#
	$A_B_C_Circle.visible = false
	#-------------------#

	#----- Hide_Buttons -----#
	A_B_C_Hide_toggled = false
	_on_A_B_C_Hide_pressed()
	$A_B_C_Hide.pressed = false

	A_B_D_Hide_toggled = false
	_on_A_B_D_Hide_pressed()
	$A_B_D_Hide.pressed = false
	#------------------------#

#--------------------------------------------------------------------------------#
