extends Node2D

var A_Controller_pressed: bool = false
var C_Controller_pressed: bool = false
var D_Controller_pressed: bool = false

var A_Controller_start_position: Vector2
var C_Controller_start_position: Vector2
var D_Controller_start_position: Vector2

var A_Controller_limiter: Vector2
var C_Controller_limiter: Vector2
var D_Controller_limiter: Vector2

func A_mouse_loc():
	return (A_Controller_start_position + get_local_mouse_position() + $A_Controller.rect_size/2)

func C_mouse_loc():
	return (C_Controller_start_position + get_local_mouse_position() + $C_Controller.rect_size/2)

func D_mouse_loc():
	return (D_Controller_start_position + get_local_mouse_position() + $D_Controller.rect_size/2)

func A_B_difference():
	return ($A_B.points[0] - $A_B.points[1])


func angle_calc(p1, p2, p3):
	
	var p12 = sqrt(pow((p1.x - p2.x),2) + pow((p1.y - p2.y),2))
	var p13 = sqrt(pow((p1.x - p3.x),2) + pow((p1.y - p3.y),2))
	var p23 = sqrt(pow((p2.x - p3.x),2) + pow((p2.y - p3.y),2))

	if (p12 == 0 or p13 == 0 or p23 == 0):
		return 0

	return (acos(((pow(p12, 2)) + (pow(p13, 2)) - (pow(p23, 2))) / (2 * p12 * p13)) * 180 / PI)

var A_B_slope: int = 0

var C_B_slope: int = 0

func A():
	return Vector2(stepify($A_B.points[0].x, 0.01), stepify($A_B.points[0].y, 0.01) )

func B():
	return Vector2(stepify($A_B.points[1].x, 0.01), stepify($A_B.points[1].y, 0.01) )

func C():
	return Vector2(stepify( $D_B_C.points[0].x, 0.01), stepify( $D_B_C.points[0].y, 0.01) )

func D():
	return Vector2(stepify( $D_B_C.points[2].x, 0.01), stepify( $D_B_C.points[2].y, 0.01) )

func A_Controller():
	return Vector2(stepify($A_Controller.rect_position.x, 0.01), stepify($A_Controller.rect_position.y, 0.01) )

func C_Controller():
	return Vector2(stepify($C_Controller.rect_position.x, 0.01), stepify($C_Controller.rect_position.y, 0.01) )

func D_Controller():
	return Vector2(stepify($D_Controller.rect_position.x, 0.01), stepify($D_Controller.rect_position.y, 0.01) )

var A_B_C_Hide: bool = false
var A_B_D_Hide: bool = false

var A_loc: Vector2
var C_loc: Vector2
var D_loc: Vector2

var A_Controller_loc: Vector2
var C_Controller_loc: Vector2
var D_Controller_loc: Vector2

var A_B_C_unite_offset: float
var A_B_D_unite_offset: float

var A_B_C_Cutter_z_index: int
var A_B_C_Cutter2_z_index: int
var A_B_D_Cutter_z_index: int

func _ready():

	#adjusting the screen size if the program was running on windows (x86) and centering the window
	if (OS.get_name() == 'Windows'):
		OS.window_size = Vector2( stepify(OS.get_screen_size().x / 1.2, 1), stepify(OS.get_screen_size().y / 1.2, 1))
		OS.center_window()

	#----- Connecting 'Buttons' and 'Controller' -----#	
	$A_Controller.connect('button_down', self, '_on_A_Controller_button_down')
	$A_Controller.connect('button_up', self, '_on_A_Controller_button_up')
	
	$C_Controller.connect('button_down', self, '_on_C_Controller_button_down')
	$C_Controller.connect('button_up', self, '_on_C_Controller_button_up')

	$D_Controller.connect('button_down', self, '_on_D_Controller_button_down')
	$D_Controller.connect('button_up', self, '_on_D_Controller_button_up')

	$A_B_C_Hide.connect('pressed', self, '_on_A_B_C_Hide_pressed')
	$A_B_D_Hide.connect('pressed', self, '_on_A_B_D_Hide_pressed')
	
	$Restore_Button.connect('pressed', self, '_on_Restore_Button_pressed')
	#--------------------------------------------------------------------------------#

	#----- Centering the pivot to the origin (center of the object) for rotating in a correct way -----#
	$A_Controller.rect_pivot_offset = $A_Controller.rect_size/2
	$C_Controller.rect_pivot_offset = $C_Controller.rect_size/2
	$D_Controller.rect_pivot_offset = $D_Controller.rect_size/2
	#--------------------------------------------------------------------------------#

	#----- Controlling the rotation of the Controller to make like it's tracking the 'B' point or the center of the display -----#
	$C_Controller.rect_rotation = angle_calc( B(), C(), Vector2(0, B().y)) - 90
	$D_Controller.rect_rotation = angle_calc(B(), D(), Vector2(0, B().y)) - 90
	#--------------------------------------------------------------------------------#


	#----- Centering the Controller position to the origin point as this feature is not in the inspector tab. -----#
	$A_Controller.rect_position.x = B().x - ($A_Controller.rect_size.x/2)
	$C_Controller.rect_position = C() - $C_Controller.rect_size/2
	$D_Controller.rect_position = D() - $D_Controller.rect_size/2

	# $A_B.points[0] = A()
	$A_B.points[0] = A_Controller() + Vector2( round($A_Controller.rect_size.x/2), round($A_Controller.rect_size.y/2) )
	#--------------------------------------------------------------------------------#

	#----- Aligning the 'Angle_Text's to the left or right based on the 'B' position. B is in the center -----#

	# Aligning 'A_Controller_Text'
	if (A().x - B().x < 0):
		# Left
		$A_Controller_Text.rect_position = A_Controller() + $A_Controller.rect_size/2 - $A_Controller_Text.rect_size/2 - Vector2($A_Controller_Text.rect_size.x*1.5, 0)
	else:
		# Right
		$A_Controller_Text.rect_position = A_Controller() + $A_Controller.rect_size/2 - $A_Controller_Text.rect_size/2 + Vector2($A_Controller_Text.rect_size.x*1.5, 0)

	# Aligning 'C_Controller_Text'
	if (C().x - B().x < 0):
		# Left
		$C_Controller_Text.rect_position = $C_Controller.rect_position + $C_Controller.rect_size/2 - $C_Controller_Text.rect_size/2 - Vector2($C_Controller_Text.rect_size.x*1.5, 0)
	else:
		# Right
		$C_Controller_Text.rect_position = $C_Controller.rect_position + $C_Controller.rect_size/2 - $C_Controller_Text.rect_size/2 + Vector2($C_Controller_Text.rect_size.x*1.5, 0)

	# Aligning 'D_Controller_Text'
	if (D().x - B().x < 0):
		# Here to the left.
		$D_Controller_Text.rect_position = D_Controller() + $D_Controller.rect_size/2 - $D_Controller_Text.rect_size/2 - Vector2($D_Controller_Text.rect_size.x*1.5, 0)
	else:
		# Here to the right.
		$D_Controller_Text.rect_position = D_Controller() + $D_Controller.rect_size/2 - $D_Controller_Text.rect_size/2 + Vector2($D_Controller_Text.rect_size.x*1.5, 0)
	
	#--------------------------------------------------------------------------------#
	
	#----- Calculating where the 'Angle_Text' will be placed based on some matrix calculations :) -----#
	
	#A_B_C_Text
	$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (angle_calc(B(), A(), C())/2 + angle_calc(B(), C(), Vector2(C().x, B().y)))/360

	#A_B_D_Text
	$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = .5 - (angle_calc(B(), A(), D())/2 + angle_calc(B(), D(), Vector2(D().x, B().y)))/360
	
	#--------------------------------------------------------------------------------#

	#----- Changing the 'Angle_Indicator' to be a 'Cirlce' or a 'Square'. If the angle is 90. Then 'Square', if the angle is not 90. Then 'Circle' ----#

	if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) != 90):
		$A_B_C_Circle.visible = true
	else:
		$A_B_C_Circle.visible = false
	
	if (round(angle_calc(B(), A(), C())) == 90 and round(angle_calc(B(), A(), D())) != 90):
		$A_B_D_Cutter.z_index = -1
		$A_B_C_Circle.visible = true
	else:
		$A_B_D_Cutter.z_index = -4
	
	if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) == 90):
		$A_B_C_Cutter.z_index = -1
		$A_B_C_Circle.visible = true
	else:
		$A_B_C_Cutter.z_index = -2
	
	if (round(angle_calc(B(), A(), C())) == 90):
		$A_B_C_Square.rotation_degrees =  45 - (angle_calc( B(), A(), C() ) / 2 + angle_calc( B(), C(), Vector2(1921, B().y) ) )
		$A_B_C_Square.visible = true

		$A_B_C_Circle2.visible = false
	else:
		$A_B_C_Square.visible = false
		$A_B_C_Circle2.visible = true
	
	if (round(angle_calc(B(), A(), D())) == 90):
		$A_B_C_Square2.rotation_degrees =   225 - (angle_calc( B(), A(), D() ) / 2 + angle_calc( B(), D(), Vector2(1921, B().y) ) )
		$A_B_C_Square2.visible = true
	else:
		$A_B_C_Square2.visible = false
	
	#--------------------------------------------------------------------------------#

	#----- Storing Everything position for the Restore button -----#

	# Storing the 'z_index'
	A_B_C_Cutter_z_index = $A_B_C_Cutter.z_index
	A_B_C_Cutter2_z_index = $A_B_C_Cutter2.z_index
	A_B_D_Cutter_z_index = $A_B_D_Cutter.z_index

	# Storing the 'Points' location.
	A_loc = A()
	C_loc = C()
	D_loc = D()
	
	# Storing the 'Points_Controllers' location.
	A_Controller_loc = $A_Controller.rect_position
	C_Controller_loc = $C_Controller.rect_position
	D_Controller_loc = $D_Controller.rect_position
	
	# Storing the 'Angle_Text' position.
	A_B_C_unite_offset = $A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset
	A_B_D_unite_offset = $A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset

	#--------------------------------------------------------------------------------#

func _process(__data__):
	
	

	if (A_Controller_pressed):
		
		#----- Checking that equations are not equal to 0 to prevent problems. -----#
		
		var safe1: bool
		var safe2: bool
		
		if (C().y - B().y != 0 and (A_mouse_loc().y - B().y) != 0 and (C().y - B().y) != 0 and (C().y - B().y) * (B().y - A_mouse_loc().y) != 0): safe1 = true
		else: safe1 = false
		
		if (D().y - B().y != 0 and (A_mouse_loc().y - B().y) != 0 and (D().y - B().y) != 0 and (D().y - B().y) * (B().y - A_mouse_loc().y) != 0): safe2 = true
		else: safe2 = false

		#--------------------------------------------------------------------------------#


		#----- Making some if statements with a 'Controller_limiter'. So, when a thing that unwanted happens, that limitter value will take out that unwanted data from the given mouse_position values and then send it. -----#
		
		# Preventing 'A' from getting under 'B'
		if (A_mouse_loc().y > B().y - 1):
			A_Controller_limiter.x = 0
			A_Controller_limiter.y = A_mouse_loc().y - B().y + 1
		
		# if the slope of the 'A' to the 'B' is interfering with the slope of the 'C' to the 'B'. It means that if the 'A' line is interfering with the 'C' line.
		elif (safe1 and (C().x - B().x) / ( C().y - B().y) > (A_mouse_loc().x - B().x) / (A_mouse_loc().y - B().y) and (B().y - C().y > 0) ):
				A_Controller_limiter.x = A_mouse_loc().x - ( B().x - ( (C().x - B().x) / (C().y - B().y) ) * (B().y - A_mouse_loc().y) )
				A_Controller_limiter.y = 0

		# if the slope of the 'A' to the 'B' is interfering with the slope of the 'D' to the 'B'.
		elif (safe2 and (D().x - B().x) / ( D().y - B().y) < (A_mouse_loc().x - B().x) / (A_mouse_loc().y - B().y) and (B().y - D().y > 0) ):
				A_Controller_limiter.x = A_mouse_loc().x - ( B().x - ( (D().x - B().x) / (D().y - B().y) ) * (B().y - A_mouse_loc().y) )
				A_Controller_limiter.y = 0

		# No Unwanted data found
		else: A_Controller_limiter = Vector2(0,0)

		# Positioning the 'Controller'.
		$A_Controller.set_position(A_Controller_start_position + get_local_mouse_position() - A_Controller_limiter)
		
		# Rotating the Controller so it will track the 'B' point or the bottom center of the display.
		$A_Controller.rect_rotation = angle_calc(B(), A(), Vector2(0, B().y)) - 90

		#--------------------------------------------------------------------------------#
		

		# Positioning the 'A' point from the 'Conroller' position data
		# A() = 
		$A_B.points[0] = A_Controller() + Vector2( round($A_Controller.rect_size.x/2), round($A_Controller.rect_size.y/2) )
		
		#----- Aligning the 'Angle_Text' to the left or right based on it's position to the 'B' position -----#
		if (A_B_difference().x < 0):
			# Left
			$A_Controller_Text.rect_position = A_Controller() + $A_Controller.rect_size/2 - $A_Controller_Text.rect_size/2 - Vector2($A_Controller_Text.rect_size.x*1.5, 0)
		else:
			# Right
			$A_Controller_Text.rect_position = A_Controller() + $A_Controller.rect_size/2 - $A_Controller_Text.rect_size/2 + Vector2($A_Controller_Text.rect_size.x*1.5, 0)
		#-----------------------------------------------------------------------------------------------------#


		#----- Changing the 'Angle_Text' values -----#

		$A_B_C_Text_Director/A_B_C_Text_Director_Follow/A_B_C_Text.text = str(round(angle_calc(B(), A(), C())))
		$A_B_D_Text_Director/A_B_D_Text_Director_Follow/A_B_D_Text.text = str(round(angle_calc(B(), A(), D())))

		#--------------------------------------------------------------------------------#


		#----- Calculating where the 'Angle_Text' will be placed based on some matrix calculations :) -----#

		$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (angle_calc(B(), A(), C())/2 + angle_calc(B(), C(), Vector2(1921, B().y)))/360
		$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = .5 - (angle_calc(B(), A(), D())/2 + angle_calc(B(), D(), Vector2(0, B().y)))/360
		
		#--------------------------------------------------------------------------------#


		#----- Positioning the Cutter points. The cutter is for cutting the 'Angle_Indicator_Circle'.

		$A_B_C_Cutter.polygon[0] = A()
		$A_B_C_Cutter.polygon[1] = Vector2( (D().x + A().x)/2, (D().y + A().y)/2 - 500)
		$A_B_D_Cutter.polygon[1] = A()
		$A_B_D_Cutter.polygon[0] = Vector2( (C().x + A().x)/2, (C().y + A().y)/2 - 500)
		
		#--------------------------------------------------------------------------------#

		
		#----- Changing the 'Angle_Indicator' to be a 'Cirlce' or a 'Square'. If the angle is 90. Then 'Square', if the angle is not 90. Then 'Circle' ----#

		# C()
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Circle.visible = false

		if (round(angle_calc(B(), A(), C())) == 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_D_Cutter.z_index = -4

		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Cutter.z_index = -2
		
		# D()
		if (round(angle_calc(B(), A(), C())) == 90):
			$A_B_C_Square.rotation_degrees =  45 - (angle_calc( B(), A(), C() ) / 2 + angle_calc( B(), C(), Vector2(1921, B().y) ) )
			$A_B_C_Square.visible = true
			$A_B_C_Circle2.visible = false
		else:
			$A_B_C_Square.visible = false
			$A_B_C_Circle2.visible = true

		if (round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Square2.rotation_degrees =   225 - (angle_calc( B(), A(), D() ) / 2 + angle_calc( B(), D(), Vector2(1921, B().y) ) )
			$A_B_C_Square2.visible = true
		else:
			$A_B_C_Square2.visible = false

		#--------------------------------------------------------------------------------#

		#----- If the Hide Buttons are pressed -----#
		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false
		
		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Square2.visible = false
		#-------------------------------------------#


	if (C_Controller_pressed):

		#----- Checking that equations are not equal to 0 to prevent problems. -----#
		var safe1:bool
		var safe2:bool

		if ( (A().y - B().y) != 0 and (C_mouse_loc().y - B().y) != 0 and (A().y - B().y) <= 0 and (A().y - B().y) * (B().y - C_mouse_loc().y) != 0): safe1 = true
		else: safe2 = false

		if (A().y - B().y != 0 or (C_mouse_loc().y - B().y) != 0 or (A().y - B().y) != 0): safe2 = true
		else: safe2 = false
		#--------------------------------------------------------------------------------#

		#----- Making some if statements with a 'Controller_limiter'. So, when a thing that unwanted happens, that limitter value will take out that unwanted data from the given mouse_position values and then send it. -----#

		# Preventing 'C' from getting under 'B'
		if (C_mouse_loc().y > B().y - 1):
			C_Controller_limiter.y = C_mouse_loc().y - B().y + 1
		
		# if the slope of the 'C' to the 'B' is interfering with the slope of the 'A' to the 'B'. It means that if the 'C' line is interfering with the 'A' line.
		elif (safe1):
			if (A().x - B().x) / ( A().y - B().y) < (C_mouse_loc().x - B().x) / (C_mouse_loc().y - B().y):
				C_Controller_limiter.x = C_mouse_loc().x - ( B().x - ( (A().x - B().x) / (A().y - B().y) ) * (B().y - C_mouse_loc().y) )
			else:C_Controller_limiter = Vector2(0,0)

		# if the slope of the 'A' to the 'B' is interfering with the slope of the 'D' to the 'B'.
		elif (safe2):
			if ( A().y - B().y >= 0):
				if (A().x - B().x > 0):
					C_Controller_limiter.y = C_mouse_loc().y - A().y
				else: C_Controller_limiter = Vector2(0,0)
			else: C_Controller_limiter = Vector2(0,0)

		# No unwanted data is found.
		else: C_Controller_limiter = Vector2(0,0)

		#--------------------------------------------------------------------------------#
			
		#----- Positioning and Rotating the Controller -----#
		$C_Controller.set_position(C_Controller_start_position + get_local_mouse_position() - C_Controller_limiter)
		
		# Rotating the Controller so it will track the 'B' point or the bottom center of the display.
		$C_Controller.rect_rotation = angle_calc(B(), C(), Vector2(0, B().y)) - 90
		#---------------------------------------------------#

		# Positioning the 'A' point from the 'Conroller' position data
		# C() = 
		$D_B_C.points[0] = $C_Controller.rect_position + Vector2( round($C_Controller.rect_size.x/2), round($C_Controller.rect_size.y/2) )
		
		#----- Aligning the 'Angle_Text' to the left or right based on it's position to the 'B' position -----#
		if (C().x - B().x < 0):
			# Left
			$C_Controller_Text.rect_position = $C_Controller.rect_position + $C_Controller.rect_size/2 - $C_Controller_Text.rect_size/2 - Vector2($C_Controller_Text.rect_size.x*1.5, 0)
		else:
			# Right
			$C_Controller_Text.rect_position = $C_Controller.rect_position + $C_Controller.rect_size/2 - $C_Controller_Text.rect_size/2 + Vector2($C_Controller_Text.rect_size.x*1.5, 0)
		#-----------------------------------------------------------------------------------------------------#

		#----- Changing the 'Angle_Text' values -----#

		$A_B_C_Text_Director/A_B_C_Text_Director_Follow/A_B_C_Text.text = str(round(angle_calc(B(), A(), C())))
		$A_B_C_Text_Director/A_B_C_Text_Director_Follow.unit_offset = (angle_calc( B(), A(), C() ) / 2 + angle_calc( B(), C(), Vector2(1921, B().y) ) )/360

		#--------------------------------------------------------------------------------#

		#----- Positioning the Cutter points. The cutter is for cutting the 'Angle_Indicator_Circle'.

		$A_B_D_Cutter.polygon[3] = C()
		$A_B_D_Cutter.polygon[0] = Vector2( (C().x + A().x)/2, (C().y + A().y)/2 - 500)

		$A_B_C_Cutter2.polygon[0] = C()
		
		#--------------------------------------------------------------------------------#

		#----- Changing the 'Angle_Indicator' to be a 'Cirlce' or a 'Square'. If the angle is 90. Then 'Square', if the angle is not 90. Then 'Circle' ----#

		# C()
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Circle.visible = false
		
		if (round(angle_calc(B(), A(), C())) == 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_D_Cutter.z_index = -4
		
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Cutter.z_index = -2
		
		if (round(angle_calc(B(), A(), C())) == 90):
			$A_B_C_Square.rotation_degrees =  45 - (angle_calc( B(), A(), C() ) / 2 + angle_calc( B(), C(), Vector2(1921, B().y) ) )
			$A_B_C_Square.visible = true
			$A_B_C_Circle2.visible = false
		else:
			$A_B_C_Square.visible = false
			$A_B_C_Circle2.visible = true

		#--------------------------------------------------------------------------------#

		#----- If the Hide Buttons are pressed -----#
		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false
			
		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Square2.visible = false
		#-------------------------------------------#
		
	if (D_Controller_pressed):
		
		#----- Checking that equations are not equal to 0 to prevent problems. -----#
		var safe1: bool
		var safe2: bool

		if (A().y - B().y != 0 and (D_mouse_loc().y - B().y) != 0 and (A().y - B().y) <= 0 and (A().y - B().y) * (B().y - D_mouse_loc().y) != 0):
			safe1 = true
		else:
			safe1 = false

		if (A().y - B().y != 0 or (D_mouse_loc().y - B().y) != 0 or (A().y - B().y) != 0):
			safe2 = true
		else:
			safe2 = false
		#--------------------------------------------------------------------------------#

		#----- Making some if statements with a 'Controller_limiter'. So, when a thing that unwanted happens, that limitter value will take out that unwanted data from the given mouse_position values and then send it. -----#
		
		# Preventing 'D' from getting under 'B'
		if (D_mouse_loc().y > B().y - 1):
			D_Controller_limiter.y = D_mouse_loc().y - B().y + 1
		
		# if the slope of the 'D' to the 'B' is interfering with the slope of the 'A' to the 'B'. It means that if the 'D' line is interfering with the 'A' line.
		elif (safe1):
			if (A().x - B().x) / ( A().y - B().y) > (D_mouse_loc().x - B().x) / (D_mouse_loc().y - B().y):
				D_Controller_limiter.x = D_mouse_loc().x - ( B().x - ( (A().x - B().x) / (A().y - B().y) ) * (B().y - D_mouse_loc().y) )
			else: D_Controller_limiter = Vector2(0,0)
		# if the slope of the 'A' to the 'B' is interfering with the slope of the 'D' to the 'B'.
		elif (safe2):
			if (A().y - B().y >= 0):
				if (B().x - A().x > 0):
					D_Controller_limiter.y = D_mouse_loc().y - A().y
				else: D_Controller_limiter = Vector2(0,0)
			else: D_Controller_limiter = Vector2(0,0)
		# No unwanted data is found.
		else: D_Controller_limiter = Vector2(0,0)

		# Positioning the 'Controller'.
		$D_Controller.set_position(D_Controller_start_position + get_local_mouse_position() - D_Controller_limiter)

		# Rotating the Controller so it will track the 'B' point or the bottom center of the display.
		$D_Controller.rect_rotation = angle_calc(B(), D(), Vector2(0, B().y)) - 90
		
		# Positioning the 'A' point from the 'Conroller' position data
		# D() = 
		$D_B_C.points[2] = $D_Controller.rect_position + Vector2( round($D_Controller.rect_size.x/2), round($D_Controller.rect_size.y/2) )
		
		# Aligning the 'Angle_Text' to the left or right based on it's position to the 'B' position
		if (D().x - B().x < 0):
			# Left
			$D_Controller_Text.rect_position = $D_Controller.rect_position + $D_Controller.rect_size/2 - $D_Controller_Text.rect_size/2 - Vector2($D_Controller_Text.rect_size.x*1.5, 0)
		else:
			# Right
			$D_Controller_Text.rect_position = $D_Controller.rect_position + $D_Controller.rect_size/2 - $D_Controller_Text.rect_size/2 + Vector2($D_Controller_Text.rect_size.x*1.5, 0)

		#--------------------------------------------------------------------------------#

		#----- Changing the 'Angle_Text' values -----#
		$A_B_D_Text_Director/A_B_D_Text_Director_Follow/A_B_D_Text.text = str(round(angle_calc(B(), A(), D())))
		
		$A_B_D_Text_Director/A_B_D_Text_Director_Follow.unit_offset = .5 - (angle_calc(B(), A(), D())/2 + angle_calc(B(), D(), Vector2(0, B().y)))/360
		#--------------------------------------------------------------------------------#

		#----- Positioning the Cutter points. The cutter is for cutting the 'Angle_Indicator_Circle'.
		$A_B_C_Cutter.polygon[2] = D()
		$A_B_C_Cutter.polygon[1] = Vector2( (D().x + A().x)/2, (D().y + A().y)/2 - 500)

		$A_B_C_Cutter2.polygon[2] = D()
		#--------------------------------------------------------------------------------#
		
		#----- Changing the 'Angle_Indicator' to be a 'Cirlce' or a 'Square'. If the angle is 90. Then 'Square', if the angle is not 90. Then 'Circle' ----#

		# D()
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Circle.visible = false
		
		if (round(angle_calc(B(), A(), C())) == 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_D_Cutter.z_index = -4
		
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Cutter.z_index = -2
		
		if (round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Square2.rotation_degrees = 225 - (angle_calc( B(), A(), D() ) / 2 + angle_calc( B(), D(), Vector2(1921, B().y) ) )
			$A_B_C_Square2.visible = true
		else:
			$A_B_C_Square2.visible = false
		
		#--------------------------------------------------------------------------------#

		#----- If the Hide Buttons are pressed -----#
		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false
			
		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Square2.visible = false
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

#----- D_Controller -----#

func _on_D_Controller_button_down():
	D_Controller_start_position = $D_Controller.rect_position - get_local_mouse_position()
	D_Controller_pressed = true

func _on_D_Controller_button_up():
	D_Controller_pressed = false

#-----------------------#

#----- Hide_Buttons -----#

var A_B_C_Hide_toggled: bool = true

# Function for the 'A_B_C_Hide' button.
func _on_A_B_C_Hide_pressed():

	if A_B_C_Hide_toggled:
		A_B_C_Hide_toggled = false
		$A_B_C_Text_Director/A_B_C_Text_Director_Follow/A_B_C_Text.visible = false
		A_B_C_Hide = true
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Circle.visible = false
		
		if (round(angle_calc(B(), A(), C())) == 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_D_Cutter.z_index = -4
			
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Cutter.z_index = -2
		
		if (round(angle_calc(B(), A(), C())) == 90):
			$A_B_C_Square.rotation_degrees =  45 - (angle_calc( B(), A(), C() ) / 2 + angle_calc( B(), C(), Vector2(1921, B().y) ) )
			$A_B_C_Square.visible = true
			$A_B_C_Circle2.visible = false
		else:
			$A_B_C_Square.visible = false
			$A_B_C_Circle2.visible = true
			
		if (round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Square2.rotation_degrees =   225 - (angle_calc( B(), A(), D() ) / 2 + angle_calc( B(), D(), Vector2(1921, B().y) ) )
			$A_B_C_Square2.visible = true
		else:
			$A_B_C_Square2.visible = false
		
		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false
			
		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Square2.visible = false
			
		return
	
	if !A_B_C_Hide_toggled:
		A_B_C_Hide_toggled = true
		$A_B_C_Text_Director/A_B_C_Text_Director_Follow/A_B_C_Text.visible = true
		A_B_C_Hide = false
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Circle.visible = false
		
		if (round(angle_calc(B(), A(), C())) == 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_D_Cutter.z_index = -4
			
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Cutter.z_index = -2
		
		if (round(angle_calc(B(), A(), C())) == 90):
			$A_B_C_Square.rotation_degrees =  45 - (angle_calc( B(), A(), C() ) / 2 + angle_calc( B(), C(), Vector2(1921, B().y) ) )
			$A_B_C_Square.visible = true
			$A_B_C_Circle2.visible = false
		else:
			$A_B_C_Square.visible = false
			$A_B_C_Circle2.visible = true
			
		if (round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Square2.rotation_degrees =   225 - (angle_calc( B(), A(), D() ) / 2 + angle_calc( B(), D(), Vector2(1921, B().y) ) )
			$A_B_C_Square2.visible = true
		else:
			$A_B_C_Square2.visible = false
			
		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false
			
		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Square2.visible = false
		
		return

var A_B_D_Hide_toggled:bool = true

# Function for 'A_B_D_Hide' button
func _on_A_B_D_Hide_pressed():
	
	if A_B_D_Hide_toggled:
		A_B_D_Hide_toggled = false
		$A_B_D_Text_Director/A_B_D_Text_Director_Follow/A_B_D_Text.visible = false
		A_B_D_Hide = true
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Circle.visible = false
		
		if (round(angle_calc(B(), A(), C())) == 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_D_Cutter.z_index = -4
			
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Cutter.z_index = -2
		
		if (round(angle_calc(B(), A(), C())) == 90):
			$A_B_C_Square.rotation_degrees =  45 - (angle_calc( B(), A(), C() ) / 2 + angle_calc( B(), C(), Vector2(1921, B().y) ) )
			$A_B_C_Square.visible = true
			$A_B_C_Circle2.visible = false
		else:
			$A_B_C_Square.visible = false
			$A_B_C_Circle2.visible = true
			
		if (round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Square2.rotation_degrees =   225 - (angle_calc( B(), A(), D() ) / 2 + angle_calc( B(), D(), Vector2(1921, B().y) ) )
			$A_B_C_Square2.visible = true
		else:
			$A_B_C_Square2.visible = false
		
		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false
			
		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Square2.visible = false
			
		return
	
	if !A_B_D_Hide_toggled:
		A_B_D_Hide_toggled = true
		$A_B_D_Text_Director/A_B_D_Text_Director_Follow/A_B_D_Text.visible = true
		A_B_D_Hide = false
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Circle.visible = false
		
		if (round(angle_calc(B(), A(), C())) == 90 and round(angle_calc(B(), A(), D())) != 90):
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_D_Cutter.z_index = -4
			
		if (round(angle_calc(B(), A(), C())) != 90 and round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Circle.visible = true
		else:
			$A_B_C_Cutter.z_index = -2
		
		if (round(angle_calc(B(), A(), C())) == 90):
			$A_B_C_Square.rotation_degrees =  45 - (angle_calc( B(), A(), C() ) / 2 + angle_calc( B(), C(), Vector2(1921, B().y) ) )
			$A_B_C_Square.visible = true
			$A_B_C_Circle2.visible = false
		else:
			$A_B_C_Square.visible = false
			$A_B_C_Circle2.visible = true

		if (round(angle_calc(B(), A(), D())) == 90):
			$A_B_C_Square2.rotation_degrees =   225 - (angle_calc( B(), A(), D() ) / 2 + angle_calc( B(), D(), Vector2(1921, B().y) ) )
			$A_B_C_Square2.visible = true
		else:
			$A_B_C_Square2.visible = false
		
		if A_B_C_Hide:
			$A_B_D_Cutter.z_index = -1
			$A_B_C_Square.visible = false
			
		if A_B_D_Hide:
			$A_B_C_Cutter.z_index = -1
			$A_B_C_Square2.visible = false

		return

#--------------------------------------------------------------------------------#


#-----'Restore_Button' to reset everything using the properties that were stored early in the _ready function. -----#
func _on_Restore_Button_pressed():
	
	#----- Points -----#
	$A_B.points[0] = A_loc
	$D_B_C.points[0] = C_loc
	$D_B_C.points[2] = D_loc
	#------------------#
	
	#----- Controllers -----#
	$A_Controller.rect_position = A_Controller_loc
	$C_Controller.rect_position = C_loc - $C_Controller.rect_size/2
	$D_Controller.rect_position = D_loc - $D_Controller.rect_size/2

	$A_Controller.rect_rotation = angle_calc(B(), A_loc, Vector2(0, B().y)) - 90
	$C_Controller.rect_rotation = angle_calc(B(), C_loc, Vector2(0, B().y)) - 90	
	$D_Controller.rect_rotation = angle_calc(B(), D_loc, Vector2(0, B().y)) - 90
	#-----------------------#
	
	#----- Controller_Text -----#
	$A_Controller_Text.rect_position = A_Controller_loc + $A_Controller.rect_size/2 - $A_Controller_Text.rect_size/2 + Vector2($A_Controller_Text.rect_size.x*1.5, 0)
	$C_Controller_Text.rect_position = $C_Controller.rect_position + $C_Controller.rect_size/2 - $C_Controller_Text.rect_size/2 + Vector2($C_Controller_Text.rect_size.x*1.5, 0)
	$D_Controller_Text.rect_position = D_Controller_loc + $D_Controller.rect_size/2 - $D_Controller_Text.rect_size/2 - Vector2($D_Controller_Text.rect_size.x*1.5, 0)
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

	$A_B_C_Cutter2.polygon[0] = C_loc
	$A_B_C_Cutter2.polygon[2] = D_loc

	$A_B_C_Cutter.z_index = A_B_C_Cutter_z_index
	$A_B_C_Cutter2.z_index = A_B_C_Cutter2_z_index
	$A_B_D_Cutter.z_index = A_B_D_Cutter_z_index
	#-------------------#

	#----- Squares -----#
	$A_B_C_Square.rotation_degrees =  45 - (angle_calc( B(), A_loc, C_loc ) / 2 + angle_calc( B(), C_loc, Vector2(1921, B().y) ) )
	$A_B_C_Square2.rotation_degrees =   225 - (angle_calc( B(), A_loc, D_loc ) / 2 + angle_calc( B(), D_loc, Vector2(1921, B().y) ) )
	$A_B_C_Square.visible = true
	$A_B_C_Square2.visible = true
	#------------------#

	#----- Circles -----#
	$A_B_C_Circle.visible = false
	$A_B_C_Circle2.visible = false
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
