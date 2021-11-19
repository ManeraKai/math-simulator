extends Node2D

var A_Controller_pressed: bool = false
var B_Controller_pressed: bool = false
var C_Controller_pressed: bool = false

var A_Controller_start_position: Vector2
var B_Controller_start_position: Vector2
var C_Controller_start_position: Vector2

var A_Controller_limiter: Vector2
var B_Controller_limiter: Vector2
var C_Controller_limiter: Vector2

func A_mouse_loc(): return (A_Controller_start_position + get_local_mouse_position() + $A_Controller.rect_size/2)
func B_mouse_loc(): return (B_Controller_start_position + get_local_mouse_position() + $B_Controller.rect_size/2)
func C_mouse_loc(): return (C_Controller_start_position + get_local_mouse_position() + $C_Controller.rect_size/2)

func A_B_difference(): return ($A_B_C.points[0] - $A_B_C.points[1])

func angle_calc(p2, p1, p3):
	
	var p12 = sqrt(pow((p1.x - p2.x),2) + pow((p1.y - p2.y),2))
	var p13 = sqrt(pow((p1.x - p3.x),2) + pow((p1.y - p3.y),2))
	var p23 = sqrt(pow((p2.x - p3.x),2) + pow((p2.y - p3.y),2))

	if (p12 == 0 or p13 == 0 or p23 == 0):
		return 0

	return acos(((pow(p12, 2)) + (pow(p13, 2)) - (pow(p23, 2))) / (2 * p12 * p13)) * 180 / PI

var A_B_slope: int = 0

var C_B_slope: int = 0

func A(): return Vector2(stepify($A_B_C.points[2].x, 0.01), stepify($A_B_C.points[2].y, 0.01))
func B(): return Vector2(stepify($A_B_C.points[1].x, 0.01), stepify($A_B_C.points[1].y, 0.01))
func C(): return Vector2(stepify($A_B_C.points[0].x, 0.01), stepify( $A_B_C.points[0].y, 0.01))
func C2(): return Vector2(stepify($A_B_C.points[3].x, 0.01), stepify( $A_B_C.points[3].y, 0.01))

func A_Controller(): return Vector2(stepify($A_Controller.rect_position.x, 0.01), stepify($A_Controller.rect_position.y, 0.01))
func B_Controller(): return Vector2(stepify($B_Controller.rect_position.x, 0.01), stepify($B_Controller.rect_position.y, 0.01))
func C_Controller(): return Vector2(stepify($C_Controller.rect_position.x, 0.01), stepify($C_Controller.rect_position.y, 0.01))

var A_Hide: bool = false
var B_Hide: bool = false
var C_Hide: bool = false

var A_loc: Vector2
var C_loc: Vector2
var B_loc: Vector2

var A_Controller_loc: Vector2
var C_Controller_loc: Vector2
var B_Controller_loc: Vector2

var A_unite_offset: float
var B_unite_offset: float
var C_unite_offset: float

func Angle_Text_Values():
	var A_error: int = 0
	var B_error: int = 0
	var C_error: int = 0

	if int(round(angle_calc(B(), A(), C()))) % 2 != 0:   A_error = 180 - (round(angle_calc(B(), A(), C())) + round(angle_calc(C(), B(), A())) + round(angle_calc(A(), C(), B())))
	elif int(round(angle_calc(C(), B(), A()))) % 2 != 0: B_error = 180 - (round(angle_calc(B(), A(), C())) + round(angle_calc(C(), B(), A())) + round(angle_calc(A(), C(), B())))
	elif int(round(angle_calc(A(), C(), B()))) % 2 != 0: C_error = 180 - (round(angle_calc(B(), A(), C())) + round(angle_calc(C(), B(), A())) + round(angle_calc(A(), C(), B())))

	$A_Text_Director/A_Text_Director_Follow/A_Text.text = str(round(angle_calc(B(), A(), C())) + A_error)
	$B_Text_Director/B_Text_Director_Follow/B_Text.text = str(round(angle_calc(C(), B(), A())) + B_error)
	$C_Text_Director/C_Text_Director_Follow/C_Text.text = str(round(angle_calc(A(), C(), B())) + C_error)

	$A_Text_Director/A_Text_Director_Follow/A_Text.rect_position = -$A_Text_Director/A_Text_Director_Follow/A_Text.rect_size/2
	$C_Text_Director/C_Text_Director_Follow/C_Text.rect_position = -$C_Text_Director/C_Text_Director_Follow/C_Text.rect_size/2
	$B_Text_Director/B_Text_Director_Follow/B_Text.rect_position = -$B_Text_Director/B_Text_Director_Follow/B_Text.rect_size/2

func Controller_Rotator():
	# A() 
	if A().y > B().y and A().y > C().y:
		$A_Controller.rect_rotation = (( angle_calc( B(), A(), Vector2(0, A().y) ) + angle_calc( C(), A(), Vector2(0, A().y) ) ) /2) + 90
	
	elif A().y > B().y and ( (A().x - B().x) / (A().y - B().y) < (B().x - C().x) / (B().y - C().y) ):
		$A_Controller.rect_rotation = (( angle_calc( B(), A(), Vector2(0, A().y) ) + angle_calc( C(), A(), Vector2(1920, A().y) ) ) /2) + 180
	elif A().y > B().y and ( (A().x - B().x) / (A().y - B().y) > (B().x - C().x) / (B().y - C().y) ):
		$A_Controller.rect_rotation = (( angle_calc( B(), A(), Vector2(0, A().y) ) + angle_calc( C(), A(), Vector2(1920, A().y) ) ) /2)
	
	elif A().y > C().y and ( (A().x - C().x) / (A().y - C().y) > (C().x - B().x) / (C().y - B().y) ):
		$A_Controller.rect_rotation = (( angle_calc( B(), A(), Vector2(1920, A().y) ) + angle_calc( C(), A(), Vector2(0, A().y) ) ) /2)
	elif A().y > C().y and ( (A().x - C().x) / (A().y - C().y) < (B().x - C().x) / (B().y - C().y) ):
		$A_Controller.rect_rotation = (( angle_calc( B(), A(), Vector2(1920, A().y) ) + angle_calc( C(), A(), Vector2(0, A().y) ) ) /2) + 180
	
	else:
		$A_Controller.rect_rotation = 90 - (( angle_calc( B(), A(), Vector2(0, A().y) ) + angle_calc( C(), A(), Vector2(0, A().y) ) ) /2)
	
	# B()
	if B().y > A().y and B().y > C().y:
		$B_Controller.rect_rotation = (( angle_calc( A(), B(), Vector2(0, B().y) ) + angle_calc( C(), B(), Vector2(0, B().y) ) ) /2) + 90
	
	elif B().y > A().y and ( (B().x - A().x) / (B().y - A().y) < (A().x - C().x) / (A().y - C().y) ):
		$B_Controller.rect_rotation = (( angle_calc( A(), B(), Vector2(0, B().y) ) + angle_calc( C(), B(), Vector2(1920, B().y) ) ) /2) + 180
	elif B().y > A().y and ( (B().x - A().x) / (B().y - A().y) > (A().x - C().x) / (A().y - C().y) ):
		$B_Controller.rect_rotation = (( angle_calc( A(), B(), Vector2(0, B().y) ) + angle_calc( C(), B(), Vector2(1920, B().y) ) ) /2)
	
	elif B().y > C().y and ( (B().x - C().x) / (B().y - C().y) > (C().x - A().x) / (C().y - A().y) ):
		$B_Controller.rect_rotation = (( angle_calc( A(), B(), Vector2(1920, B().y) ) + angle_calc( C(), B(), Vector2(0, B().y) ) ) /2)
	elif B().y > C().y and ( (B().x - C().x) / (B().y - C().y) < (A().x - C().x) / (A().y - C().y) ):
		$B_Controller.rect_rotation = (( angle_calc( A(), B(), Vector2(1920, B().y) ) + angle_calc( C(), B(), Vector2(0, B().y) ) ) /2) + 180
	
	else:
		$B_Controller.rect_rotation = 90 - (( angle_calc( A(), B(), Vector2(0, B().y) ) + angle_calc( C(), B(), Vector2(0, B().y) ) ) /2)
	
	# C()
	if C().y > A().y and C().y > B().y:
		$C_Controller.rect_rotation = (( angle_calc( A(), C(), Vector2(0, C().y) ) + angle_calc( B(), C(), Vector2(0, C().y) ) ) /2) + 90
	
	elif C().y > A().y and ( (C().x - A().x) / (C().y - A().y) < (A().x - B().x) / (A().y - B().y) ):
		$C_Controller.rect_rotation = (( angle_calc( A(), C(), Vector2(0, C().y) ) + angle_calc( B(), C(), Vector2(1920, C().y) ) ) /2) + 180
	elif C().y > A().y and ( (C().x - A().x) / (C().y - A().y) > (A().x - B().x) / (A().y - B().y) ):
		$C_Controller.rect_rotation = (( angle_calc( A(), C(), Vector2(0, C().y) ) + angle_calc( B(), C(), Vector2(1920, C().y) ) ) /2)
	
	elif C().y > B().y and ( (C().x - B().x) / (C().y - B().y) > (B().x - A().x) / (B().y - A().y) ):
		$C_Controller.rect_rotation = (( angle_calc( A(), C(), Vector2(1920, C().y) ) + angle_calc( B(), C(), Vector2(0, C().y) ) ) /2)
	elif C().y > B().y and ( (C().x - B().x) / (C().y - B().y) < (A().x - B().x) / (A().y - B().y) ):
		$C_Controller.rect_rotation = (( angle_calc( A(), C(), Vector2(1920, C().y) ) + angle_calc( B(), C(), Vector2(0, C().y) ) ) /2) + 180
	
	else:
		$C_Controller.rect_rotation = 90 - (( angle_calc( A(), C(), Vector2(0, C().y) ) + angle_calc( B(), C(), Vector2(0, C().y) ) ) /2)

func Angle_Text_Rotator():

	# A()
	if A().y > B().y and A().y > C().y:
		$A_Text_Director/A_Text_Director_Follow.unit_offset = (( angle_calc( B(), A(), Vector2(0, A().y) ) + angle_calc( C(), A(), Vector2(0, A().y) ) ) /2)/360
	
	elif A().y > B().y and (A().x - B().x) / (A().y - B().y) < (B().x - C().x) / (B().y - C().y) :
		$A_Text_Director/A_Text_Director_Follow.unit_offset = ((( angle_calc( B(), A(), Vector2(0, A().y) ) + angle_calc( C(), A(), Vector2(1920, A().y) ) ) /2) + 90) / 360
	elif A().y > B().y and (A().x - B().x) / (A().y - B().y) > (B().x - C().x) / (B().y - C().y):
		$A_Text_Director/A_Text_Director_Follow.unit_offset = (( angle_calc( B(), A(), Vector2(0, A().y) ) + angle_calc( C(), A(), Vector2(1920, A().y) ) ) /2 - 90) / 360
	
	elif A().y > C().y and (A().x - C().x) / (A().y - C().y) > (C().x - B().x) / (C().y - B().y):
		$A_Text_Director/A_Text_Director_Follow.unit_offset = (( angle_calc( B(), A(), Vector2(1920, A().y) ) + angle_calc( C(), A(), Vector2(0, A().y) ) ) /2 - 90) / 360
	elif A().y > C().y and (A().x - C().x) / (A().y - C().y) < (B().x - C().x) / (B().y - C().y):
		$A_Text_Director/A_Text_Director_Follow.unit_offset = ((( angle_calc( B(), A(), Vector2(1920, A().y) ) + angle_calc( C(), A(), Vector2(0, A().y) ) ) /2) + 90) / 360
	
	else:
		$A_Text_Director/A_Text_Director_Follow.unit_offset = (-(( angle_calc( B(), A(), Vector2(0, A().y) ) + angle_calc( C(), A(), Vector2(0, A().y) ) ) /2)) / 360
	
	# B()
	if B().y > A().y and B().y > C().y:
		$B_Text_Director/B_Text_Director_Follow.unit_offset = ((( angle_calc( A(), B(), Vector2(0, B().y) ) + angle_calc( C(), B(), Vector2(0, B().y) ) ) /2))/360
	
	elif B().y > A().y and (B().x - A().x) / (B().y - A().y) < (A().x - C().x) / (A().y - C().y):
		$B_Text_Director/B_Text_Director_Follow.unit_offset = ((( angle_calc( A(), B(), Vector2(0, B().y) ) + angle_calc( C(), B(), Vector2(1920, B().y) ) ) /2) + 90) / 360
	elif B().y > A().y and (B().x - A().x) / (B().y - A().y) > (A().x - C().x) / (A().y - C().y):
		$B_Text_Director/B_Text_Director_Follow.unit_offset = (( angle_calc( A(), B(), Vector2(0, B().y) ) + angle_calc( C(), B(), Vector2(1920, B().y) ) ) /2 - 90) / 360
	
	elif B().y > C().y and (B().x - C().x) / (B().y - C().y) > (C().x - A().x) / (C().y - A().y):
		$B_Text_Director/B_Text_Director_Follow.unit_offset = (( angle_calc( A(), B(), Vector2(1920, B().y) ) + angle_calc( C(), B(), Vector2(0, B().y) ) ) /2 - 90) / 360
	elif B().y > C().y and (B().x - C().x) / (B().y - C().y) < (A().x - C().x) / (A().y - C().y):
		$B_Text_Director/B_Text_Director_Follow.unit_offset = ((( angle_calc( A(), B(), Vector2(1920, B().y) ) + angle_calc( C(), B(), Vector2(0, B().y) ) ) /2) + 90) / 360
	
	else:
		$B_Text_Director/B_Text_Director_Follow.unit_offset = (-(( angle_calc( A(), B(), Vector2(0, B().y) ) + angle_calc( C(), B(), Vector2(0, B().y) ) ) /2)) / 360
	
	# C()
	if C().y > B().y and C().y > A().y:
		$C_Text_Director/C_Text_Director_Follow.unit_offset = ((( angle_calc( B(), C(), Vector2(0, C().y) ) + angle_calc( A(), C(), Vector2(0, C().y) ) ) /2))/360
	
	elif C().y > B().y and (C().x - B().x) / (C().y - B().y) < (B().x - A().x) / (B().y - A().y):
		$C_Text_Director/C_Text_Director_Follow.unit_offset = ((( angle_calc( B(), C(), Vector2(0, C().y) ) + angle_calc( A(), C(), Vector2(1920, C().y) ) ) /2) + 90) / 360
	elif C().y > B().y and (C().x - B().x) / (C().y - B().y) > (B().x - A().x) / (B().y - A().y):
		$C_Text_Director/C_Text_Director_Follow.unit_offset = (( angle_calc( B(), C(), Vector2(0, C().y) ) + angle_calc( A(), C(), Vector2(1920, C().y) ) ) /2 - 90) / 360
	
	elif C().y > A().y and (C().x - A().x) / (C().y - A().y) > (A().x - B().x) / (A().y - B().y):
		$C_Text_Director/C_Text_Director_Follow.unit_offset = (( angle_calc( B(), C(), Vector2(1920, C().y) ) + angle_calc( A(), C(), Vector2(0, C().y) ) ) /2 - 90) / 360
	elif C().y > A().y and (C().x - A().x) / (C().y - A().y) < (B().x - A().x) / (B().y - A().y):
		$C_Text_Director/C_Text_Director_Follow.unit_offset = ((( angle_calc( B(), C(), Vector2(1920, C().y) ) + angle_calc( A(), C(), Vector2(0, C().y) ) ) /2) + 90) / 360
	
	else:
		$C_Text_Director/C_Text_Director_Follow.unit_offset = (-(( angle_calc( B(), C(), Vector2(0, C().y) ) + angle_calc( A(), C(), Vector2(0, C().y) ) ) /2)) / 360

func Circle_Rotation_Position():
	
	if !A_Hide:
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
	
	if !B_Hide:
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


	if !C_Hide:
		if int($C_Text_Director/C_Text_Director_Follow/C_Text.text) != 90:
			$C_Circle.visible = true
			$C_Square.visible = false
			$C_Circle.rotation_degrees = $C_Controller.rect_rotation + 180
		else:
			$C_Circle.visible = false
			$C_Square.visible = true
			$C_Square.position = C()
			$C_Square.rotation_degrees = $C_Controller.rect_rotation + 135
	else:
		$C_Circle.visible = false
		$C_Square.visible = false

func _ready():

	#adjusting the screen size if the program was running on windows (x86) and centering the window
	if (OS.get_name() == 'Windows'):
		OS.window_size = Vector2( stepify(OS.get_screen_size().x / 1.2, 1), stepify(OS.get_screen_size().y / 1.2, 1))
		OS.center_window()

	#----- Connecting 'Button's and 'Controller's -----#
	$A_Controller.connect('button_down', self, '_on_A_Controller_button_down')
	$A_Controller.connect('button_up', self, '_on_A_Controller_button_up')

	$B_Controller.connect('button_down', self, '_on_B_Controller_button_down')
	$B_Controller.connect('button_up', self, '_on_B_Controller_button_up')
	
	$C_Controller.connect('button_down', self, '_on_C_Controller_button_down')
	$C_Controller.connect('button_up', self, '_on_C_Controller_button_up')

	$A_Hide.connect('pressed', self, '_on_A_Hide_pressed')
	$B_Hide.connect('pressed', self, '_on_B_Hide_pressed')
	$C_Hide.connect('pressed', self, '_on_C_Hide_pressed')
	
	$Restore_Button.connect('pressed', self, '_on_Restore_Button_pressed')
	#--------------------------------------------------------------------------------#

	#----- Centering the pivot to the origin (center of the object) for rotating in a correct way -----#
	$A_Controller.rect_pivot_offset = $A_Controller.rect_size/2
	$B_Controller.rect_pivot_offset = $B_Controller.rect_size/2
	$C_Controller.rect_pivot_offset = $C_Controller.rect_size/2
	#--------------------------------------------------------------------------------#
	
	#----- Centering the Controller position to the origin point as this feature is not in the inspector tab. -----#
	#$A_Controller.rect_position.x = OS.get_screen_size().x/2 - ($A_Controller.rect_size.x/2)
	$B_Controller.rect_position = B() - $B_Controller.rect_size/2
	$C_Controller.rect_position = C() - $C_Controller.rect_size/2
	
	# $A_B_C.points[2] = A()
	$A_B_C.points[2] = A_Controller() + Vector2(round($A_Controller.rect_size.x/2), round($A_Controller.rect_size.y/2))
	#--------------------------------------------------------------------------------#

	#----- Aligning the 'Angle_Text's to the left or right based on the 'B' position. B is in the center -----#

	# Aligning 'A_Controller_Text'
	if A().x > OS.get_screen_size().x/2:
		# Right
		$A_Controller_Text.rect_position = A_Controller() + $A_Controller.rect_size/2 - $A_Controller_Text.rect_size/2 + Vector2($A_Controller_Text.rect_size.x*1.5, 0)
	else:
		# Left
		$A_Controller_Text.rect_position = A_Controller() + $A_Controller.rect_size/2 - $A_Controller_Text.rect_size/2 - Vector2($A_Controller_Text.rect_size.x*1.5, 0)

	# Aligning 'C_Controller_Text'
	if C().x > OS.get_screen_size().x/2:
		# Right
		$C_Controller_Text.rect_position = $C_Controller.rect_position + $C_Controller.rect_size/2 - $C_Controller_Text.rect_size/2 + Vector2($C_Controller_Text.rect_size.x*1.5, 0)
	else:
		# Left
		$C_Controller_Text.rect_position = $C_Controller.rect_position + $C_Controller.rect_size/2 - $C_Controller_Text.rect_size/2 - Vector2($C_Controller_Text.rect_size.x*1.5, 0)

	# Aligning 'B_Controller_Text'
	if B().x > OS.get_screen_size().x/2:
		# Here to the right.
		$B_Controller_Text.rect_position = B_Controller() + $B_Controller.rect_size/2 - $B_Controller_Text.rect_size/2 + Vector2($B_Controller_Text.rect_size.x*1.5, 0)
	else:
		# Here to the left.
		$B_Controller_Text.rect_position = B_Controller() + $B_Controller.rect_size/2 - $B_Controller_Text.rect_size/2 - Vector2($B_Controller_Text.rect_size.x*1.5, 0)
	#--------------------------------------------------------------------------------#

	$A_Circle.position = A()
	$B_Circle.position = B()
	$C_Circle.position = C()

	$Cutter.polygon[0] = A()
	$Cutter.polygon[1] = B()
	$Cutter.polygon[2] = C()

	#----- Positioning the 'Text_Director' -----#
	$A_Text_Director.position = A()
	$B_Text_Director.position = B()
	$C_Text_Director.position = C()
	#-------------------------------------------------#

	#----- Changing the 'Angle_Text' values -----#
	Angle_Text_Values()
	#--------------------------------------------#

	Controller_Rotator()
	Angle_Text_Rotator()

	Circle_Rotation_Position()

	#----- Storing Everything position for the Restore button -----#

	# Storing the 'Points' location.
	A_loc = A()
	B_loc = B()
	C_loc = C()
	
	# Storing the 'Points_Controllers' location.
	A_Controller_loc = $A_Controller.rect_position
	B_Controller_loc = $B_Controller.rect_position
	C_Controller_loc = $C_Controller.rect_position

func _process(__data__):

	if (A_Controller_pressed):
		# Positioning the 'Controller'.
		$A_Controller.set_position(A_Controller_start_position + get_local_mouse_position() - A_Controller_limiter)

		# Positioning the 'A' point from the 'Conroller' position data
		$A_B_C.points[2] = A_Controller() + Vector2( round($A_Controller.rect_size.x/2), round($A_Controller.rect_size.y/2) )
		
		#----- Aligning the 'Angle_Text' to the left or right based on it's position to the 'B' position -----#
		if (A().x < B().x and A().x < C().x):
			# Left
			$A_Controller_Text.rect_position = A_Controller() + $A_Controller.rect_size/2 - $A_Controller_Text.rect_size/2 - Vector2($A_Controller_Text.rect_size.x*1.5, 0)
		else:
			# Right
			$A_Controller_Text.rect_position = A_Controller() + $A_Controller.rect_size/2 - $A_Controller_Text.rect_size/2 + Vector2($A_Controller_Text.rect_size.x*1.5, 0)
		#-----------------------------------------------------------------------------------------------------#

		#----- Positioning the 'Text_Director' -----#
		$A_Text_Director.position = A()

		# Changing the 'Angle_Text' values
		Angle_Text_Values()

		Angle_Text_Rotator()
		Controller_Rotator()

		$A_Circle.position = A()
		
		Circle_Rotation_Position()

		$Cutter.polygon[0] = A()

	if (C_Controller_pressed):
		#----- Positioning and Rotating the Controller -----#
		$C_Controller.set_position(C_Controller_start_position + get_local_mouse_position() - C_Controller_limiter)

		# Positioning the 'C' point from the 'Conroller' position data
		$A_B_C.points[0] = $C_Controller.rect_position + Vector2( round($C_Controller.rect_size.x/2), round($C_Controller.rect_size.y/2) )
		$A_B_C.points[3] = C()
		
		#----- Aligning the 'Angle_Text' to the left or right based on it's position to the 'B' position -----#
		if (C().x < B().x and C().x < A().x):
			# Left
			$C_Controller_Text.rect_position = $C_Controller.rect_position + $C_Controller.rect_size/2 - $C_Controller_Text.rect_size/2 - Vector2($C_Controller_Text.rect_size.x*1.5, 0)
		else:
			# Right
			$C_Controller_Text.rect_position = $C_Controller.rect_position + $C_Controller.rect_size/2 - $C_Controller_Text.rect_size/2 + Vector2($C_Controller_Text.rect_size.x*1.5, 0)
		#-----------------------------------------------------------------------------------------------------#

		# Positioning the 'Angle_Director'
		$C_Text_Director.position = C()

		# Changing the 'Angle_Text' values
		Angle_Text_Values()

		# Rotating the Controller so it will track the other two points
		Angle_Text_Rotator()
		Controller_Rotator()

		$C_Circle.position = C()

		Circle_Rotation_Position()

		$Cutter.polygon[2] = C()
		
	if (B_Controller_pressed):
		# Positioning the 'Controller'.
		$B_Controller.set_position(B_Controller_start_position + get_local_mouse_position() - B_Controller_limiter)
		
		# Positioning the 'B' point from the 'Conroller' position data
		$A_B_C.points[1] = $B_Controller.rect_position + Vector2( round($B_Controller.rect_size.x/2), round($B_Controller.rect_size.y/2) )
		
		# Aligning the 'Angle_Text' to the left or right based on it's position to the 'B' position
		if (B().x < A().x and B().x < C().x):
			# Left
			$B_Controller_Text.rect_position = $B_Controller.rect_position + $B_Controller.rect_size/2 - $B_Controller_Text.rect_size/2 - Vector2($B_Controller_Text.rect_size.x*1.5, 0)
		else:
			# Right
			$B_Controller_Text.rect_position = $B_Controller.rect_position + $B_Controller.rect_size/2 - $B_Controller_Text.rect_size/2 + Vector2($B_Controller_Text.rect_size.x*1.5, 0)
		#--------------------------------------------------------------------------------#
		
		$B_Text_Director.position = B()

		# Changing the 'Angle_Text' values
		Angle_Text_Values()
		# Rotating the Controller so it will track the other two points
		Angle_Text_Rotator()
		Controller_Rotator()

		$B_Circle.position = B()

		Circle_Rotation_Position()

		$Cutter.polygon[1] = B()


#----- A_Controller -----#
func _on_A_Controller_button_down():
	A_Controller_start_position = $A_Controller.rect_position - get_local_mouse_position()
	A_Controller_pressed = true

func _on_A_Controller_button_up():
	A_Controller_pressed = false
#------------------------#

#----- B_Controller -----#
func _on_B_Controller_button_down():
	B_Controller_start_position = $B_Controller.rect_position - get_local_mouse_position()
	B_Controller_pressed = true

func _on_B_Controller_button_up():
	B_Controller_pressed = false
#-----------------------#

#----- C_Controller -----#
func _on_C_Controller_button_down():
	C_Controller_start_position = $C_Controller.rect_position - get_local_mouse_position()
	C_Controller_pressed = true

func _on_C_Controller_button_up():
	C_Controller_pressed = false
#------------------------#

#----- Hide_Buttons -----#

var A_Hide_toggled: bool = true

# Function for the 'A_B_C_Hide' button.
func _on_A_Hide_pressed():
	A_Hide_toggled = !A_Hide_toggled
	$A_Text_Director/A_Text_Director_Follow/A_Text.visible = A_Hide_toggled
	A_Hide = !A_Hide_toggled
	Circle_Rotation_Position()

var B_Hide_toggled: bool = true
		
# Function for the 'B_Hide' button.
func _on_B_Hide_pressed():
	B_Hide_toggled = !B_Hide_toggled
	$B_Text_Director/B_Text_Director_Follow/B_Text.visible = B_Hide_toggled
	B_Hide = !B_Hide_toggled
	Circle_Rotation_Position()

var C_Hide_toggled: bool = true
		
# Function for the 'B_Hide' button.
func _on_C_Hide_pressed():
	C_Hide_toggled = !C_Hide_toggled
	$C_Text_Director/C_Text_Director_Follow/C_Text.visible = C_Hide_toggled
	C_Hide = !C_Hide_toggled
	Circle_Rotation_Position()

#--------------------------------------------------------------------------------#
#-----'Restore_Button' to reset everything using the properties that were stored early in the _ready function. -----#
func _on_Restore_Button_pressed():
	
	#----- Controllers -----#
	$A_Controller.rect_position = A_Controller_loc
	$B_Controller.rect_position = B_Controller_loc
	$C_Controller.rect_position = C_Controller_loc
	#-----------------------#

	#----- Points -----#
	$A_B_C.points[2] = A_loc
	$A_B_C.points[1] = B_loc
	$A_B_C.points[0] = C_loc
	$A_B_C.points[3] = C_loc

	#----- Cutters -----#
	$Cutter.polygon[0] = A()
	$Cutter.polygon[1] = B()
	$Cutter.polygon[2] = C()
	#-------------------#

	$A_Text_Director.position = A_loc
	$B_Text_Director.position = B_loc
	$C_Text_Director.position = C_loc

	$A_Circle.position = A_loc
	$B_Circle.position = B_loc
	$C_Circle.position = C_loc
	
	Angle_Text_Rotator()
	Angle_Text_Values()
	Controller_Rotator()

	#----- Aligning the 'Angle_Text' to the left or right based on it's position to the 'B' position -----#
	if (A().x < B().x and A().x < C().x):
		# Left
		$A_Controller_Text.rect_position = A_Controller() + $A_Controller.rect_size/2 - $A_Controller_Text.rect_size/2 - Vector2($A_Controller_Text.rect_size.x*1.5, 0)
	else:
		# Right
		$A_Controller_Text.rect_position = A_Controller() + $A_Controller.rect_size/2 - $A_Controller_Text.rect_size/2 + Vector2($A_Controller_Text.rect_size.x*1.5, 0)
	#-----------------------------------------------------------------------------------------------------#

	# Aligning 'B_Controller_Text'
	if (B().x > OS.get_screen_size().x/2):
		# Here to the right.
		$B_Controller_Text.rect_position = B_Controller() + $B_Controller.rect_size/2 - $B_Controller_Text.rect_size/2 + Vector2($B_Controller_Text.rect_size.x*1.5, 0)
	else:
		# Here to the left.
		$B_Controller_Text.rect_position = B_Controller() + $B_Controller.rect_size/2 - $B_Controller_Text.rect_size/2 - Vector2($B_Controller_Text.rect_size.x*1.5, 0)

	#----- Aligning the 'Angle_Text' to the left or right based on it's position to the 'B' position -----#
	if (C().x < B().x and C().x < A().x):
		# Left
		$C_Controller_Text.rect_position = $C_Controller.rect_position + $C_Controller.rect_size/2 - $C_Controller_Text.rect_size/2 - Vector2($C_Controller_Text.rect_size.x*1.5, 0)
	else:
		# Right
		$C_Controller_Text.rect_position = $C_Controller.rect_position + $C_Controller.rect_size/2 - $C_Controller_Text.rect_size/2 + Vector2($C_Controller_Text.rect_size.x*1.5, 0)
	#-----------------------------------------------------------------------------------------------------#

	#----- Hide Buttons -----#
	$A_Hide.pressed = false
	A_Hide_toggled = false
	_on_A_Hide_pressed()

	$B_Hide.pressed = false
	B_Hide_toggled = false
	_on_B_Hide_pressed()

	$C_Hide.pressed = false
	C_Hide_toggled = false
	_on_C_Hide_pressed()
	#------------------------#	
