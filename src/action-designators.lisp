(in-package :aia)
 
(def-fact-group avatar-action-designators (action-grounding)

  (<- (desig:action-grounding ?desig (add-topping ?from ?on))
    (desig-prop ?desig (:type  :adding-topping))
    (desig-prop ?desig (:from  ?from))
    (desig-prop ?desig (:on    ?on)))

  (<- (desig:action-grounding ?desig (pick-up ?object ?with-hand))
    (desig-prop ?desig (:type      :picking-up))
    (desig-prop ?desig (:object    ?object))
    (desig-prop ?desig (:with-hand ?with-hand)))

  (<- (desig:action-grounding ?desig (put-down ?from-hand ?location))
    (desig-prop ?desig (:type      :putting-down))
    (desig-prop ?desig (:from-hand ?from-hand))
    (desig-prop ?desig (:at        ?location)))

  (<- (desig:action-grounding ?desig (pour-over ?object))
    (desig-prop ?desig (:type   :pouring-over))
    (desig-prop ?desig (:object ?object)))
)


