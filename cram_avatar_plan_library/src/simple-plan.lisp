(in-package :av-plan)

(defvar *path* "spline" "Name of spline to follow")
(defvar *hand* "right" "hand to be used")
(defvar *placing_loc* (make-3d-vector 218 -296 88) " location for placing the product")
(defvar *rot* -90)



;; Top level Task
(defun FetchPlace()
  ( let ((?product-desig (desig:an object (type glass) (name "SM_WhitewineGlass_2")))
         (?location *placing_loc*))
    (top-level
      (with-process-modules-running (avatar-navigation avatar-manipulation)
        (exe:perform (desig:an action (type fetching-and-placing) (object ?product-desig) (at ?location))))
      )
    )
  )

;; High-Level Plan
(defun fetch-and-place (&key ((:object ?object)) ((:at ?location)) &allow-other-keys)
    ( let ((?hand *hand*)  (?path *path*) (?rot *rot*))
    (exe:perform (desig:an action (type fetching) (object ?object) (with-hand ?hand)))
    (sleep 3)
    (exe:perform (desig:an action (type transporting) (object ?object) (to ?path)))
    (sleep 4)
    (exe:perform (desig:an action (type placing-at) (at ?location)))
      )
  )

;; Fetching Action 

(defun fetch (&key ((:object ?object)) ((:with-hand ?with-hand)) &allow-other-keys)
    (exe:perform (desig:an action (type hand-reaching) (hand ?with-hand) (pos "holding_position")))
    (exe:perform (desig:an action (type picking-up) (object ?object) (with-hand ?with-hand)))
  )

(defun hand-reach (&key ((:hand ?hand)) ((:pos ?pos)) &allow-other-keys)	
    (pm-execute 'avatar-manipulation (desig:a motion (type reaching-w-hand) (hand ?hand) (pos ?pos)))
)
   

(defun pick-up (&key ((:object ?object)) ((:with-hand ?with-hand)) &allow-other-keys)
  (let ((?target  (desig:desig-prop-value ?object :name)))
   (pm-execute 'avatar-manipulation (desig:a motion (type grasping) (item ?target) (hand ?with-hand) (hold t))))

   )


;; Transporting Action    

(defun transport (&key ((:object ?object)) ((:to ?location)) &allow-other-keys)
   ( let ((?rot *rot*))
  (exe:perform (desig:an action (type turning-to-angle) (angle ?rot)))
  (sleep 3)
  (exe:perform (desig:an action (type moving-to) (path ?location)))
 ))
 
 (defun turn-to-angle (&key ((:angle ?angle)) &allow-other-keys)	
    (pm-execute 'avatar-navigation (desig:a motion (type moving) (angle ?angle)))
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







