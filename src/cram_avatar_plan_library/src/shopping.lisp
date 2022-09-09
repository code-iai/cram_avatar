(in-package :aia)

(defvar *ShoppingBasket*)
(setq *ShoppingBasket* (desig:an object (type shoppingbasket) (name "SM_ShoppingBasket_2")))

(defvar *Glass*)
(setq *Glass* (desig:an object (type glass) (name "SM_WhitewineGlass_2")))

(defvar *product*)
(setq *product* (desig:an object (type product) (name "SM_CAN")))

(defvar *spline* "spline")

(defvar *hand* "right" "Hand to be used")



;; Task
(defun ToShop()
  ( let ((?product *ShoppingBasket*))
    (top-level
      (with-process-modules-running (avatar-navigation avatar-manipulation)
        (exe:perform (desig:an action (type shopping) (product ?product))))
      )
    )
  )

;; High-Level Plan
(defun shop (&key ((:product ?product)) &allow-other-keys)
    ( let ((?to *spline*) (?hand *hand*)) 
      (exe:perform (desig:an action (type fetching) (object ?product) (with-hand ?hand)))
      (sleep 3)
      (exe:perform (desig:an action (type moving-on-path) (path ?to)))      
  ))
  
  ;; Interpreting path following action
(defun move-on-path (&key ((:path ?path)) &allow-other-keys)
    (pm-execute 'avatar-navigation (desig:a motion (type moving) (path ?path)))
)

;; Fetching Action 

(defun fetch (&key ((:object ?object)) ((:with-hand ?with-hand)) &allow-other-keys)
    (exe:perform (desig:an action (type picking-up) (object ?object) (with-hand ?with-hand))) 
  )


(defun pick-up (&key ((:object ?object)) ((:with-hand ?with-hand)) &allow-other-keys)
  (let ((?target  (desig:desig-prop-value ?object :name)))
   (pm-execute 'avatar-manipulation (desig:a motion (type grasping) (item ?target) (hand ?with-hand) (hold t))))

   )








