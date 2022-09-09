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
  hand
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

(defstruct avatar-fork-motion
  "Represents a forking motion"
  target
)

(defstruct avatar-feed-motion
  "Represents a feeding motion"
  target
)

(defstruct avatar-read-page-motion
  "Represents a pointing motion for reading"
  book
  page
)

(defstruct avatar-pass-page-motion
  "Represents a passing page motion"
  book
  last
)

(defstruct avatar-close-motion
  "Represents a closing motion"
  door
)

(defstruct avatar-hand-reach-motion
  "Represents a hand reaching motion"
  hand
  pos
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

  ;; forking
  (<- (desig:motion-grounding ?desig (fork ?motion))
    (desig-prop ?desig (:type :forking))
    (desig-prop ?desig (:target ?target))
    (lisp-fun make-avatar-fork-motion :target ?target ?motion))

  ;; feeding
  (<- (desig:motion-grounding ?desig (feed ?motion))
    (desig-prop ?desig (:type :feeding))
    (desig-prop ?desig (:target ?target))
    (lisp-fun make-avatar-feed-motion :target ?target ?motion))

  ;; reading page
  (<- (desig:motion-grounding ?desig (read-page ?motion))
    (desig-prop ?desig (:type :reading-page))
    (desig-prop ?desig (:book ?book))
    (desig-prop ?desig (:page ?page))
    (lisp-fun make-avatar-read-page-motion :book ?book :page ?page ?motion))

  ;; passing page
  (<- (desig:motion-grounding ?desig (pass-page ?motion))
    (desig-prop ?desig (:type :passing-page))
    (desig-prop ?desig (:book ?book))
    (desig-prop ?desig (:last ?last))
    (lisp-fun make-avatar-pass-page-motion :book ?book :last ?last ?motion))

  ;; closing door
  (<- (desig:motion-grounding ?desig (close-door ?motion))
    (desig-prop ?desig (:type :closing))
    (desig-prop ?desig (:door ?door))
    (lisp-fun make-avatar-close-motion :door ?door ?motion))

  ;; hand reach
  (<- (desig:motion-grounding ?desig (reach-w-hand ?motion))
    (desig-prop ?desig (:type :reaching-w-hand))
    (desig-prop ?desig (:hand ?hand))
    (desig-prop ?desig (:pos ?pos))
    (lisp-fun make-avatar-hand-reach-motion :hand ?hand :pos ?pos ?motion))

  ;; grasping given object and hold
  (<- (desig:motion-grounding ?desig (grasp ?motion))
    (desig-prop ?desig (:type :grasping))
    (desig-prop ?desig (:item ?item))
    (desig-prop ?desig (:hand ?hand))
    (desig-prop ?desig (:hold ?hold))
    (lisp-fun make-avatar-grasping-motion :item ?item :hand ?hand :hold ?hold ?motion))

  ;; grasping given object 
  (<- (desig:motion-grounding ?desig (grasp ?motion))
    (desig-prop ?desig (:type :grasping))
    (desig-prop ?desig (:item ?item))
    (desig-prop ?desig (:hand ?hand))
    (lisp-fun make-avatar-grasping-motion :item ?item :hand ?hand ?motion))

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


