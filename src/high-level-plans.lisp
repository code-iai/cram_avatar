(in-package :aia)

(defvar *container* "SM_Milk_Jug_0" "Name for the topping container")
(defvar *obj_target* "SM_Waffle_2" "Name for target object")
(defvar *hand* "right" "Hand to be used")

(defvar *container_loc* (make-3d-vector 165 272 86) "Intended location for topping container in x")


;; Running entire scenario
(defun run-pouring-scenario ()

  ( let ((?container-desig (desig:an object (type jug) (name "SM_Milk_Jug_0"))) (?target-desig (desig:an object (type waffle) (name "SM_Waffle_2"))))
    (top-level
      (with-process-modules-running (avatar-navigation avatar-manipulation)
        (exe:perform (desig:an action (type adding-topping) (from ?container-desig) (on ?target-desig))))))
  )
;; Interpreting adding topping action
(defun add-topping (&key ((:from ?from)) ((:on ?on)) &allow-other-keys)

  (let ((?loc_vector *container_loc* ) (?hand *hand*))
    (exe:perform (desig:an action (type picking-up) (object ?from) (with-hand ?hand)))
    (sleep 1)
    (exe:perform (desig:an action (type pouring-over) (object ?on)))
    (sleep 2)
    (exe:perform (desig:an action (type putting-down) (from-hand ?hand) (at ?loc_vector)))))

;; Interpreting picking up action
(defun pick-up (&key ((:object ?object)) ((:with-hand ?with-hand)) &allow-other-keys)
    
    (let ((?target  (desig:desig-prop-value ?object :name)))
      (pm-execute 'avatar-navigation (desig:a motion (type looking) (target ?target)))
      (pm-execute 'avatar-manipulation (desig:a motion (type grasping) (item ?target) (hold t))))
    (sleep 3) 
    ;;  (pm-execute 'avatar-navigation (desig:a motion (type looking) (target "front")))
  )

;; Interpreting putting down action
(defun put-down (&key ((:from-hand ?from-hand)) ((:at ?location)) &allow-other-keys)
  (let ((?in_x (float (cl-transforms:x ?location) 1.0)) 
        (?in_y (float (cl-transforms:y ?location) 1.0)) 
        (?in_z (float (cl-transforms:z ?location) 1.0 )))

    (pm-execute 'avatar-navigation (desig:a motion (type looking) (x_val ?in_x) (y_val ?in_y) (z_val ?in_z)))
    (pm-execute 'avatar-manipulation (desig:a motion (type placing) (from_hand ?from-hand) (x_val ?in_x) (y_val ?in_y) (z_val ?in_z)))
    (sleep 3)
    ;;  (pm-execute 'avatar-navigation (desig:a motion (type looking) (target "front")))
    ))

;; Interpreting pouring action
(defun pour-over (&key ((:object ?object)) &allow-other-keys) 
    
    (let ((?target (desig:desig-prop-value ?object :name)))
      (pm-execute 'avatar-navigation (desig:a motion (type looking) (target ?target)))
      (pm-execute 'avatar-manipulation (desig:a motion (type pouring) (target ?target))))
    (sleep 9)
    ;;  (pm-execute 'avatar-navigation (desig:a motion (type looking) (target "front")))
  )












