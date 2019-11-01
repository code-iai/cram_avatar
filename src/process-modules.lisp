(in-package :aia)


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
    )))

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

