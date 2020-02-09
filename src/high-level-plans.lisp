(in-package :aia)

(defvar *topping* "SM_Milch" "Name for the topping container")
(defvar *target* "SM_Steak_2" "Name for target object")
(defvar *hand* "right" "Hand to be used")

(defvar *topping_loc* (make-3d-vector 45 45 45) "Intended location for topping container in x")

(defvar *target_loc* (make-3d-vector 45 45 45) "Intended location of target in x")


;; Running entire scenario
(defun run-pouring-scenario ()
  (top-level
    (with-process-modules-running (avatar-navigation avatar-manipulation)
      (exe:perform (desig:an action (type adding-topping) (from *topping*) (on *target*))))))

;; Running adding topping action
(defun add-topping (?from ?on)
  (let ((?loc_vector *topping_loc* ) (?hand *hand*))
    (exe:perform (desig:an action (type picking-up) (object ?from) (with-hand ?hand)))

    (sleep 5)
    (exe:perform (desig:an action (type pouring-over) (object ?on)))

    (sleep 10)
    (exe:perform (desig:an action (type putting-down) (from-hand ?hand) (at ?loc_vector)))
  )
)

;; Running picking up action
(defun pick-up (?object ?with-hand)
  (let (
    (?in_x (float (cl-transforms:x *topping_loc*) 1.0)) 
    (?in_y (float (cl-transforms:y *topping_loc*) 1.0)) 
    (?in_z (float (cl-transforms:z *topping_loc*) 1.0)))
    
    (let ((target (desig:a motion (type looking) (x_val ?in_x) (y_val ?in_y) (z_val ?in_z))))
         (pm-execute 'avatar-navigation target))

    (let ((target (desig:a motion (type grasping) (item ?object) (hold t))))
          (pm-execute 'avatar-manipulation target))

    (sleep 3)
    (let ((target (desig:a motion (type looking))))
        (pm-execute 'avatar-navigation target))
  )
 
)

;; Running putting down action
(defun put-down (?from-hand ?location)

  (let (
    (?in_x (float (cl-transforms:x ?location) 1.0)) 
    (?in_y (float (cl-transforms:y ?location) 1.0)) 
    (?in_z (float (cl-transforms:z ?location) 1.0)))
    
    ;; look to
    (let ((target (desig:a motion (type looking) (x_val ?in_x) (y_val ?in_y) (z_val ?in_z))))
         (pm-execute 'avatar-navigation target))

    (let ((target (desig:a motion (type placing) (from_hand ?from-hand) (x_val ?in_x) (y_val ?in_y) (z_val ?in_z))))
          (pm-execute 'avatar-manipulation target))

    (sleep 3)
    (let ((target (desig:a motion (type looking))))
        (pm-execute 'avatar-navigation target))

  )
)

;; Running pouring action
(defun pour-over (?object)

  (let (
    (?in_x (float (cl-transforms:x *target_loc*) 1.0)) 
    (?in_y (float (cl-transforms:y *target_loc*) 1.0)) 
    (?in_z (float (cl-transforms:z *target_loc*) 1.0 )))

    ;; look to
    (let ((target (desig:a motion (type looking) (x_val ?in_x) (y_val ?in_y) (z_val ?in_z))))
         (pm-execute 'avatar-navigation target))

    ;; pour
    (let ((trgt (desig:a motion (type pouring) (target ?object))))
        (pm-execute 'avatar-manipulation trgt))

    (sleep 3)
    (let ((target (desig:a motion (type looking))))
        (pm-execute 'avatar-navigation target))

  )
)












