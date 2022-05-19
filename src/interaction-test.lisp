(in-package :aia)

(defun talking()
  (top-level
   (with-process-modules-running (avatar-communication)
     (exe:perform (desig:an action (type speaking)))))
  )

;; (defun speak ()
;;   (pm-execute 'avatar-manipulation (desig:a motion (type slicing))))


(defun speak (&key ((:receiver ?agent)) &allow-other-keys)
   (pm-execute 'avatar-communication (desig:a motion (type telling) (receiver ?agent)))

   )
