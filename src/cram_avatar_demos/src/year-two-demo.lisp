(in-package :av-demos)

(def-cram-function run-year-two-demo ()
  "Sends velocity commands until `goal' is reached."
  (unwind-protect
	; Move to bowl
        (av-con::call-send-console-command "follow spline1")
	(sleep 3.5)
	; Rotate towards bowl
	(av-con::call-send-console-command "turn to -180")
	(sleep 1.5)
	(av-con::call-send-console-command "grasp SM_BigBowl_2 hold")
	(sleep 3)
	; Move to microwave
	(av-con::call-send-console-command "follow spline2")
	(sleep 1.1)
	; Rotate towards microwave
	(av-con::call-send-console-command "turn to -20")
	(sleep 1.3)
	(av-con::call-send-console-command "press open")
	(sleep 4)
	(av-con::call-send-console-command "place left microwave")
	(sleep 3.5)
	(av-con::call-send-console-command "close microwave")
	(sleep 3.5)
	(av-con::call-send-console-command "press start")
	(sleep 3.7)
	(av-con::call-send-console-command "press open")
	(sleep 3.7)
	(av-con::call-send-console-command "grasp SM_BigBowl_2 hold")
	(sleep 3.5)
	(av-con::call-send-console-command "close microwave")
	(sleep 3.5)
	; Move to table next to lady
	(av-con::call-send-console-command "follow spline3")
	(sleep 4)
	; Rotate towards table
	(av-con::call-send-console-command "turn to -90")
	(sleep 2)
	(av-con::call-send-console-command "place right table")
	(sleep 3)
	; Move back
	(av-con::call-send-console-command "follow spline4")
	(sleep 6)
	(av-con::call-send-console-command "turn to 90")))

