(in-package :aia)

;; Process module for motion
(def-process-module avatar-navigation (motion-designator)
  (roslisp:ros-info (avatar-process-modules)
                    "Avatar navigation invoked with motion designator `~a'."
                    motion-designator)
  (destructuring-bind (command motion) (reference motion-designator)
    (ecase command
      (follow
        (let ((cmd (concatenate 'string "follow " (write-to-string (avatar-motion-path  motion)))))
           (call-send-console-command cmd)))
      (move-base
        (let ((x  (avatar-motion-x_val  motion))
              (y  (avatar-motion-y_val  motion))
              (z  (avatar-motion-z_val  motion)))
          (call-move-to x y z)))
      (turn
        (let ((cmd (concatenate 'string "turn to " (write-to-string (avatar-motion-angle motion)))))
           (call-send-console-command cmd)))
      (look-at
        (let ((cmd (concatenate 'string "look to " motion)))
          (call-send-console-command cmd)))
      (look-to
        (let ((x  (avatar-look-motion-x_val  motion))
              (y  (avatar-look-motion-y_val  motion))
              (z  (avatar-look-motion-z_val  motion)))

          (let ((cmd (concatenate 'string "look to "  
            (write-to-string x) " " 
            (write-to-string y) " " 
            (write-to-string z))))
             (call-send-console-command cmd))))
    )))

;; Process modules for hand manipulations
(def-process-module avatar-manipulation (motion-designator)
  (roslisp:ros-info (avatar-process-modules)
                    "Avatar manipulation invoked with motion designator `~a'."
                    motion-designator)
  (destructuring-bind (command motion) (reference motion-designator)
    (ecase command
      (cut
        (let ((cmd "cut"))
           (call-send-console-command cmd)))
      (spoon
        (let ((cmd "spoon"))
           (call-send-console-command cmd)))
      (press
        (let ((cmd (concatenate 'string "press " (avatar-press-motion-button motion))))
          (call-send-console-command cmd)))
      (pour
        (let ((cmd (concatenate 'string "pour over " (avatar-pour-motion-target motion))))
          (call-send-console-command cmd)))
      (close-door
        (let ((cmd (concatenate 'string "close " (avatar-close-motion-door motion))))
          (call-send-console-command cmd)))
      (grasp
        ( let ((hold_str "")
               (objt_str "")
               (item (avatar-grasping-motion-item motion))
               (hold (avatar-grasping-motion-hold motion)))

          (when item (setq objt_str item))
          (when hold (setq hold_str "hold"))

          (let ((cmd (concatenate 'string "grasp " objt_str " " hold_str)))
             (call-send-console-command cmd))))
      (place-on
        ( let ((hand_str "")
               (place_str "")
               (hand (avatar-placing-motion-from_hand motion))
               (place (avatar-placing-motion-place motion)))

          (when hand (setq hand_str hand))
          (when place (setq place_str place))

          (let ((cmd (concatenate 'string "place " hand_str " " place_str)))
             (call-send-console-command cmd))))
      (place-at
        ( let ((hand_str "")
               (x (avatar-placing-motion-x_val motion))
               (y (avatar-placing-motion-y_val motion))
               (z (avatar-placing-motion-z_val motion))
               (hand (avatar-placing-motion-from_hand motion)))

          (when hand (setq hand_str hand))

          (let ((cmd (concatenate 'string "place " hand_str " " 
            (write-to-string x) " " 
            (write-to-string y) " " 
            (write-to-string z))))
             (call-send-console-command cmd))))
    )))

;; Help functions
(defun turn-to (?angle)
  (top-level
    (with-process-modules-running (avatar-navigation)
      (let ((direction (desig:a motion (type moving) (angle ?angle))))
        (pm-execute 'avatar-navigation direction)))))

(defun move-to (?x ?y ?z)
  (top-level
    (with-process-modules-running (avatar-navigation)
      (let ((target (desig:a motion (type moving) (x_val ?x) (y_val ?y) (z_val ?z))))
        (pm-execute 'avatar-navigation target)))))

(defun follow-path (?path)
  (top-level
    (with-process-modules-running (avatar-navigation)
      (let ((target (desig:a motion (type moving) (path ?path))))
        (pm-execute 'avatar-navigation target)))))

(defun look-to (?x ?y ?z)
  (top-level
    (with-process-modules-running (avatar-navigation)
      (let ((target (desig:a motion (type looking) (x_val ?x) (y_val ?y) (z_val ?z))))
         (pm-execute 'avatar-navigation target)))))

(defun look-at (?object)
  (top-level
    (with-process-modules-running (avatar-navigation)
      (let ((target (desig:a motion (type looking) (target ?object))))
         (pm-execute 'avatar-navigation target)))))

(defun reset-look ()
  (top-level
    (with-process-modules-running (avatar-navigation)
      (let ((target (desig:a motion (type looking))))
        (pm-execute 'avatar-navigation target)))))

(defun cut ()
  (top-level
    (with-process-modules-running (avatar-manipulation)
      (let ((target (desig:a motion (type slicing))))
        (pm-execute 'avatar-manipulation target)))))

(defun spoon ()
  (top-level
    (with-process-modules-running (avatar-manipulation)
      (let ((target (desig:a motion (type spooning))))
        (pm-execute 'avatar-manipulation target)))))

(defun press (?button)
  (top-level
    (with-process-modules-running (avatar-manipulation)
      (let ((target (desig:a motion (type pressing) (button ?button))))
        (pm-execute 'avatar-manipulation target)))))

(defun pour-over (?target)
  (top-level
    (with-process-modules-running (avatar-manipulation)
      (let ((trgt (desig:a motion (type pouring) (target ?target))))
        (pm-execute 'avatar-manipulation trgt)))))

(defun close-door (?door)
  (top-level
    (with-process-modules-running (avatar-manipulation)
      (let ((target (desig:a motion (type closing) (door ?door))))
        (pm-execute 'avatar-manipulation target)))))

(defun grasp (&optional ?item)
  ( if ?item
    (top-level
      (with-process-modules-running (avatar-manipulation)
        (let ((target (desig:a motion (type grasping) (item ?item))))
          (pm-execute 'avatar-manipulation target))))
    (top-level
      (with-process-modules-running (avatar-manipulation)
        (let ((target (desig:a motion (type grasping))))
          (pm-execute 'avatar-manipulation target))))))

(defun grasp_and_hold (&optional ?item)
  ( if ?item
    (top-level
      (with-process-modules-running (avatar-manipulation)
        (let ((target (desig:a motion (type grasping) (item ?item) (hold t))))
          (pm-execute 'avatar-manipulation target))))
    (top-level
      (with-process-modules-running (avatar-manipulation)
        (let ((target (desig:a motion (type grasping) (hold t))))
          (pm-execute 'avatar-manipulation target))))))

(defun place-object-on (?place &optional ?hand)
  ( if ?hand
    (top-level
      (with-process-modules-running (avatar-manipulation)
        (let ((target (desig:a motion (type placing) (from_hand ?hand) (place ?place))))
          (pm-execute 'avatar-manipulation target))))
    (top-level
      (with-process-modules-running (avatar-manipulation)
        (let ((target (desig:a motion (type placing) (place ?place))))
          (pm-execute 'avatar-manipulation target))))))

(defun place-object-at (?x ?y ?z &optional ?hand)
  ( if ?hand
    (top-level
      (with-process-modules-running (avatar-manipulation)
        (let ((target (desig:a motion (type placing) (from_hand ?hand) (x_val ?x) (y_val ?y) (z_val ?z))))
          (pm-execute 'avatar-manipulation target))))
    (top-level
      (with-process-modules-running (avatar-manipulation)
        (let ((target (desig:a motion (type placing) (x_val ?x) (y_val ?y) (z_val ?z))))
          (pm-execute 'avatar-manipulation target))))))

