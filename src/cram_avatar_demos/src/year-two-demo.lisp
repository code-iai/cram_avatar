(in-package :av-demos)

(def-cram-function run-year-two-demo ()
  "Sends velocity commands until `goal' is reached."
  (unwind-protect
	; Move to bowl
        (call-send-console-command "follow spline1")
	(sleep 3.5)
	; Rotate towards bowl
	(call-send-console-command "turn to -180")
	(sleep 1.5)
	(call-send-console-command "grasp SM_BigBowl_2 hold")
	(sleep 3)
	; Move to microwave
	(call-send-console-command "follow spline2")
	(sleep 1.1)
	; Rotate towards microwave
	(call-send-console-command "turn to -20")
	(sleep 1.3)
	(call-send-console-command "press open")
	(sleep 4)
	(call-send-console-command "place left microwave")
	(sleep 3.5)
	(call-send-console-command "close microwave")
	(sleep 3.5)
	(call-send-console-command "press start")
	(sleep 3.7)
	(call-send-console-command "press open")
	(sleep 3.7)
	(call-send-console-command "grasp SM_BigBowl_2 hold")
	(sleep 3.5)
	(call-send-console-command "close microwave")
	(sleep 3.5)
	; Move to table next to lady
	(call-send-console-command "follow spline3")
	(sleep 4)
	; Rotate towards table
	(call-send-console-command "turn to -90")
	(sleep 2)
	(call-send-console-command "place right table")
	(sleep 3)
	; Move back
	(call-send-console-command "follow spline4")
	(sleep 6)
	(call-send-console-command "turn to 90")))

