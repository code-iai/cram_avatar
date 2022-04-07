(in-package :aia)

(defvar *ShoppingBasket*)
(setq *ShoppingBasket* (desig:an object (type shoppingbasket) (name "SM_ShoppingBasket_2")))
(defvar *product*)
(setq *product* (desig:an object (type product) (name "SM_CAN")))

(defvar *shoppingbasket_place* "shoppingbasket_place")

(defvar *hand* "right" "Hand to be used")




;; Task
(defun Shopping()
  ( let ((?product *product*))
    (top-level
      (with-process-modules-running (avatar-navigation avatar-manipulation)
        (exe:perform (desig:an action (type shopping) (product ?product))))
      )
    )
  )

;; High-Level Plan
(defun shop (&key ((:product ?product)) &allow-other-keys)
    ( let ((?to *shoppingbasket_place*) (?hand *hand*) (?object *ShoppingBasket*))
    
    ;;(exe:perform (desig:an action (type moving-on-path) (path ?to)))
    (exe:perform (desig:an action (type fetching) (object ?object) (with-hand ?hand)))     
      
  ))
  
  ;; Interpreting path following action
(defun move-on-path (&key ((:path ?path)) &allow-other-keys)
    (pm-execute 'avatar-navigation (desig:a motion (type moving) (path ?path)))
)

;; Fetching Action 

(defun fetch (&key ((:object ?object)) ((:with-hand ?with-hand)) &allow-other-keys)
    ;;(exe:perform (desig:an action (type hand-reaching) (hand ?with-hand) (pos "holding_position")))
      ;;(sleep 2)
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








