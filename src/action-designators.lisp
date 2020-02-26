(in-package :aia)
 
(def-fact-group avatar-action-designators (action-grounding)

  (<- (desig:action-grounding ?desig (add-topping ?desig))
    (desig-prop ?desig (:type  :adding-topping))
    (desig-prop ?desig (:from  ?from))
    (desig-prop ?desig (:on    ?on)))

  (<- (desig:action-grounding ?desig (pick-up ?desig))
    (desig-prop ?desig (:type      :picking-up))
    (desig-prop ?desig (:object    ?object))
    (desig-prop ?desig (:with-hand ?with-hand)))

  (<- (desig:action-grounding ?desig (put-down ?desig))
    (desig-prop ?desig (:type      :putting-down))
    (desig-prop ?desig (:from-hand ?from-hand))
    (desig-prop ?desig (:at        ?location)))

  (<- (desig:action-grounding ?desig (pour-over ?desig))
    (desig-prop ?desig (:type   :pouring-over))
    (desig-prop ?desig (:object ?object)))
)


