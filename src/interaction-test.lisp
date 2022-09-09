(in-package :aia)

(defvar *customer*)
(setq *customer* (desig:an agent (type human) (name "pia") (role "customer")))

(defun talking()
  (top-level
   (with-process-modules-running (avatar-communication)
     (exe:perform (desig:an action (type speaking)))))
  )

;; (defun speak ()
;;   (pm-execute 'avatar-manipulation (desig:a motion (type slicing))))


(defun speak (&key ((:receiver ?agent)) &allow-other-keys)
  (let ((?agent *customer*))
  (pm-execute 'avatar-communication (desig:a motion (type telling) (receiver ?agent))))

   )
