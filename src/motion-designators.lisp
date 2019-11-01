(in-package :aia)
 
(defstruct avatar-motion
  "Represents a motion."
  x_val y_val z_val
  path
  angle)
 
(def-fact-group avatar3-motion-designators (motion-grounding)
  ;; for each kind of motion, check for and extract the necessary info
 
  ;; path following
  (<- (desig:motion-grounding ?desig (follow ?motion))
    (desig-prop ?desig (:type :moving))
    (desig-prop ?desig (:path ?path))
    (lisp-fun make-avatar3-motion :path ?path ?motion))

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
    (lisp-fun make-avatar-motion :angle ?angle ?motion)))
