(in-package :av-plan)


(defvar *destination1* "path" "location name for placing the plate")
(defvar *hand* "right" "use right hand")
(defvar *location* (make-3d-vector -289 -103 76) " location for placing the plate")
(defvar *object*)
(setq *object* (desig:an object (type milk) (name "SM_Object")))


(defun logging-scenario()
  (setf cram-tf:*tf-broadcasting-enabled* t)
  ;;(setf ccl::*is-logging-enabled* t)
  (print "Start")
  ;;(ccl::clear-detected-objects)
  ;;(detect-objects)
  (ccl::start-episode)
  (ccl::send-query-1-without-result "has_kinematics_file" "Client" "ID" "'URDF'")
  ;;(ccl::handle-detected-object *plate*)
  ;;(FetchPlace)
  (ccl::stop-episode)
  ;;(setf ccl::*episode-name* nil)
  (print "End"))

;; Task
(defun FetchPlace()
  ( let ((?object-to-fetch *object*)
         (?placing_loc *location*))
    (top-level
      (with-process-modules-running (avatar-navigation avatar-manipulation)
        (exe:perform (desig:an action (type fetching-and-placing) (object ?plate) (at ?location))))
      )
    )
  )

;; High-Level Plan
(defun fetch-and-place (&key ((:object ?object)) ((:at ?location)) &allow-other-keys)
    ( let ((?hand *hand*)  (?place *destination1*))
    (exe:perform (desig:an action (type fetching) (object ?object) (with-hand ?hand)))
    (sleep 4)
    (exe:perform (desig:an action (type transporting) (object ?object) (to ?place)))
    (sleep 6)
    (exe:perform (desig:an action (type placing-at) (at ?location)))
    ;; (sleep 3))
      
      )
  )

;; Fetching Action 

(defun fetch (&key ((:object ?object)) ((:with-hand ?with-hand)) &allow-other-keys)
    (exe:perform (desig:an action (type hand-reaching) (hand ?with-hand) (pos "holding_position")))
  ;;(exe:perform (desig:an action (type grasping) ))
    (exe:perform (desig:an action (type picking-up) (object ?object) (with-hand ?with-hand)))
  ;;(exe:perform (desig:an action (type holding) ))
  
  )

(defun hand-reach (&key ((:hand ?hand)) ((:pos ?pos)) &allow-other-keys)	
    (pm-execute 'avatar-manipulation (desig:a motion (type reaching-w-hand) (hand ?hand) (pos ?pos)))
)
   
 ;; (defun grasp (&key ((:item ?item)) (:hand  ?hand)) &allow-other-keys)
 ;; (pm-execute 'avatar-manipulation (desig:a motion (type grasping) (item ?target) (hand ?with-hand))))

(defun pick-up (&key ((:object ?object)) ((:with-hand ?with-hand)) &allow-other-keys)
  (let ((?target  (desig:desig-prop-value ?object :name)))
   (pm-execute 'avatar-manipulation (desig:a motion (type grasping) (item ?target) (hand ?with-hand) (hold t))))

   )

;; (defun hold (&key ((:hand ?hand)) ((pose ?pos)) &allow-other-keys)
;; (pm-execute 'avatar-manipulation (desig:a motion (type grasping) (item ?target) (hand ?with-hand) (hold t))))
        

;; Transporting Action    

(defun transport (&key ((:object ?object)) ((:to ?location)) &allow-other-keys)
  (exe:perform (desig:an action (type moving-to) (path ?location)))

  )
  
(defun move-to (&key ((:path ?path)) &allow-other-keys)
  (pm-execute 'avatar-navigation (desig:a motion (type moving) (path ?path)))

  )

 ;; Placing Action 

(defun place-at (&key  ((:at ?location)) &allow-other-keys)
  ( let ((?from-hand *hand*))
    (exe:perform (desig:an action (type putting-down) (at ?location)))
    (sleep 4)
   (exe:perform (desig:an action (type releasing) (from-hand ?from-hand))
                 )
  
  )  )
        
(defun put-down (&key ((:at ?location)) &allow-other-keys)
    (let ((?in_x (float (cl-transforms:x ?location) 1.0)) 
        (?in_y (float (cl-transforms:y ?location) 1.0)) 
        (?in_z (float (cl-transforms:z ?location) 1.0 )))
   (pm-execute 'avatar-manipulation (desig:a motion (type placing) (x_val ?in_x) (y_val ?in_y) (z_val ?in_z)))
      )
  
   )

(defun release (&key ((:from_hand ?from-hand)) &allow-other-keys)
   (pm-execute 'avatar-manipulation (desig:a motion (type placing) (from-hand ?from-hand)))

   )








