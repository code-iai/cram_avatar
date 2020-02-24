(in-package :aia)
 
(defstruct avatar-motion
  "Represents a motion."
  x_val y_val z_val
  path
  angle)

(defstruct avatar-look-motion
  "Represents a motion."
  x_val y_val z_val)
 
;; for each kind of motion, check for and extract the necessary info
(def-fact-group avatar-motion-designators (motion-grounding)
 
  ;; path following
  (<- (desig:motion-grounding ?desig (follow ?motion))
    (desig-prop ?desig (:type :moving))
    (desig-prop ?desig (:path ?path))
    (lisp-fun make-avatar-motion :path ?path ?motion))

  ;; move to
  (<- (desig:motion-grounding ?desig (move-base ?motion))
    (desig-prop ?desig (:type :moving))
    (desig-prop ?desig (:x_val ?x_val))
    (desig-prop ?desig (:y_val ?y_val))
    (desig-prop ?desig (:z_val ?z_val))
    (lisp-fun make-avatar-motion :x_val ?x_val :y_val ?y_val :z_val ?z_val ?motion))
 
  ;; turn
  (<- (desig:motion-grounding ?desig (turn ?motion))
    (desig-prop ?desig (:type :moving))
    (desig-prop ?desig (:angle ?angle))
    (lisp-fun make-avatar-motion :angle ?angle ?motion))

  ;; look to
  (<- (desig:motion-grounding ?desig (look-to ?motion))
    (desig-prop ?desig (:type :looking))
    (desig-prop ?desig (:x_val ?x_val))
    (desig-prop ?desig (:y_val ?y_val))
    (desig-prop ?desig (:z_val ?z_val))
    (lisp-fun make-avatar-look-motion :x_val ?x_val :y_val ?y_val :z_val ?z_val ?motion))

  ;; look at
  (<- (desig:motion-grounding ?desig (look-at ?target))
    (desig-prop ?desig (:type   :looking))
    (desig-prop ?desig (:target ?target))))

(defstruct avatar-grasping-motion
  "Represents a grasping motion"
  item
  hold
)

(defstruct avatar-placing-motion
  "Represents a placing motion"
  x_val y_val z_val
  from_hand
  place
)

(defstruct avatar-press-motion
  "Represents a pressing motion"
  button
)

(defstruct avatar-pour-motion
  "Represents a pouring motion"
  target
)

(defstruct avatar-close-motion
  "Represents a closing motion"
  door
)


;; for hand manipulation motions
(def-fact-group avatar-manipulation-motion-designators (motion-grounding)
  
  ;; slicing
  (<- (desig:motion-grounding ?desig (cut nil))
    (desig-prop ?desig (:type :slicing)))
 
  ;; spooning
  (<- (desig:motion-grounding ?desig (spoon nil))
    (desig-prop ?desig (:type :spooning)))

  ;; pressing button
  (<- (desig:motion-grounding ?desig (press ?motion))
    (desig-prop ?desig (:type :pressing))
    (desig-prop ?desig (:button ?button))
    (lisp-fun make-avatar-press-motion :button ?button ?motion))

  ;; pouring
  (<- (desig:motion-grounding ?desig (pour ?motion))
    (desig-prop ?desig (:type :pouring))
    (desig-prop ?desig (:target ?target))
    (lisp-fun make-avatar-pour-motion :target ?target ?motion))

  ;; closing door
  (<- (desig:motion-grounding ?desig (close-door ?motion))
    (desig-prop ?desig (:type :closing))
    (desig-prop ?desig (:door ?door))
    (lisp-fun make-avatar-close-motion :door ?door ?motion))

  ;; grasping given object and hold
  (<- (desig:motion-grounding ?desig (grasp ?motion))
    (desig-prop ?desig (:type :grasping))
    (desig-prop ?desig (:item ?item))
    (desig-prop ?desig (:hold ?hold))
    (lisp-fun make-avatar-grasping-motion :item ?item :hold ?hold ?motion)  )

  ;; grasping given object 
  (<- (desig:motion-grounding ?desig (grasp ?motion))
    (desig-prop ?desig (:type :grasping))
    (desig-prop ?desig (:item ?item))
    (lisp-fun make-avatar-grasping-motion :item ?item ?motion))

  ;; grasping and hold
  (<- (desig:motion-grounding ?desig (grasp ?motion))
    (desig-prop ?desig (:type :grasping))
    (desig-prop ?desig (:hold ?hold))
    (lisp-fun make-avatar-grasping-motion :hold ?hold ?motion))

  ;; grasping
  (<- (desig:motion-grounding ?desig (grasp ?motion))
    (desig-prop ?desig (:type :grasping))
    (lisp-fun make-avatar-grasping-motion ?motion))

  ;; placing from given hand at given location
  (<- (desig:motion-grounding ?desig (place-at ?motion))
    (desig-prop ?desig (:type :placing))
    (desig-prop ?desig (:from_hand ?from_hand))
    (desig-prop ?desig (:x_val ?x_val))
    (desig-prop ?desig (:y_val ?y_val))
    (desig-prop ?desig (:z_val ?z_val))
    (lisp-fun make-avatar-placing-motion :from_hand ?from_hand :x_val ?x_val :y_val ?y_val :z_val ?z_val ?motion))

  ;; placing at given location
  (<- (desig:motion-grounding ?desig (place-at ?motion))
    (desig-prop ?desig (:type :placing))
    (desig-prop ?desig (:x_val ?x_val))
    (desig-prop ?desig (:y_val ?y_val))
    (desig-prop ?desig (:z_val ?z_val))
    (lisp-fun make-avatar-placing-motion :x_val ?x_val :y_val ?y_val :z_val ?z_val ?motion))

  ;; placing from given hand on given surface
  (<- (desig:motion-grounding ?desig (place-on ?motion))
    (desig-prop ?desig (:type :placing))
    (desig-prop ?desig (:from_hand ?from_hand))
    (desig-prop ?desig (:place ?place))
    (lisp-fun make-avatar-placing-motion :from_hand ?from_hand :place ?place ?motion))

  ;; placing on given surface
  (<- (desig:motion-grounding ?desig (place-on ?motion))
    (desig-prop ?desig (:type :placing))
    (desig-prop ?desig (:place ?place))
    (lisp-fun make-avatar-placing-motion :place ?place ?motion))

  ;; placing from given hand
  (<- (desig:motion-grounding ?desig (place-on ?motion))
    (desig-prop ?desig (:type :placing))
    (desig-prop ?desig (:from_hand ?from_hand))
    (lisp-fun make-avatar-placing-motion :from_hand ?from_hand ?motion))
  
  ;; placing 
  (<- (desig:motion-grounding ?desig (place-on ?motion))
    (desig-prop ?desig (:type :placing))
    (lisp-fun make-avatar-placing-motion ?motion))

)


