(in-package :aia)

(defvar *container* "SM_Milk_Jug_5" "Name for the topping container")
(defvar *obj_target* "SM_Waffle_2" "Name for target object")
(defvar *hand* "right" "Hand to be used")

(defvar *container_loc* (make-3d-vector 165 272 86) "Intended location for topping container in x")


;; Running entire scenario
(defun run-pouring-scenario ()

  ( let ((?container *container*) (?target *obj_target*))
    (top-level
      (with-process-modules-running (avatar-navigation avatar-manipulation)
        (exe:perform (desig:an action (type adding-topping) (from ?container) (on ?target))))))
  )
;; Interpreting adding topping action
(defun add-topping (?from ?on)

  (let ((?loc_vector *container_loc* ) (?hand *hand*))
    (exe:perform (desig:an action (type picking-up) (object ?from) (with-hand ?hand)))
    (sleep 1)
    (exe:perform (desig:an action (type pouring-over) (object ?on)))
    (sleep 2)
    (exe:perform (desig:an action (type putting-down) (from-hand ?hand) (at ?loc_vector)))))

;; Interpreting picking up action
(defun pick-up (?object ?with-hand)
    
    (let ((trgt (desig:a motion (type looking) (target ?object))))
      (pm-execute 'avatar-navigation trgt))
    (let ((target (desig:a motion (type grasping) (item ?object) (hold t))))
      (pm-execute 'avatar-manipulation target))
    (sleep 3)
    (let ((trgt (desig:a motion (type looking) (target "front"))))
      (pm-execute 'avatar-navigation trgt)))

;; Interpreting putting down action
(defun put-down (?from-hand ?location)
  (let ((?in_x (float (cl-transforms:x ?location) 1.0)) 
        (?in_y (float (cl-transforms:y ?location) 1.0)) 
        (?in_z (float (cl-transforms:z ?location) 1.0 )))

    (let ((target (desig:a motion (type looking) (x_val ?in_x) (y_val ?in_y) (z_val ?in_z))))
      (pm-execute 'avatar-navigation target))
    (let ((target (desig:a motion (type placing) (from_hand ?from-hand) (x_val ?in_x) (y_val ?in_y) (z_val ?in_z))))
      (pm-execute 'avatar-manipulation target))
    (sleep 3)
    (let ((trgt (desig:a motion (type looking) (target "front"))))
      (pm-execute 'avatar-navigation trgt))))

;; Interpreting pouring action
(defun pour-over (?object)

    (let ((trgt (desig:a motion (type looking) (target ?object))))
      (pm-execute 'avatar-navigation trgt))
    (let ((trgt (desig:a motion (type pouring) (target ?object))))
      (pm-execute 'avatar-manipulation trgt))
    (sleep 9)
    (let ((trgt (desig:a motion (type looking) (target "front"))))
        (pm-execute 'avatar-navigation trgt)))












