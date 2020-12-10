(in-package :aia)
 
(def-fact-group avatar-action-designators (action-grounding)

  ;; Add Topping
  (<- (desig:action-grounding ?desig (add-topping ?desig))
    (desig-prop ?desig (:type  :adding-topping))
    (desig-prop ?desig (:from  ?from))
    (desig-prop ?desig (:on    ?on)))

  ;; Pouring
  (<- (desig:action-grounding ?desig (pour-over ?desig))
    (desig-prop ?desig (:type   :pouring-over))
    (desig-prop ?desig (:object ?object)))

  ;; Reading to and feeding caretaker
  (<- (desig:action-grounding ?desig (read-feed ?desig))
    (desig-prop ?desig (:type  :reading-feeding))
    (desig-prop ?desig (:person ?person))
    (desig-prop ?desig (:book   ?book))
    (desig-prop ?desig (:food   ?food))
    (desig-prop ?desig (:on     ?plate))
    (desig-prop ?desig (:with   ?cutlery)))

  ;; Reading book
  (<- (desig:action-grounding ?desig (read-book ?desig))
    (desig-prop ?desig (:type   :reading-book))
    (desig-prop ?desig (:book ?book)))

  ;; Point book
  (<- (desig:action-grounding ?desig (read-page-text ?desig))
    (desig-prop ?desig (:type   :reading-page-text))
    (desig-prop ?desig (:book ?book))
    (desig-prop ?desig (:page ?page)))

  ;; Pass page
  (<- (desig:action-grounding ?desig (pass-one-page ?desig))
    (desig-prop ?desig (:type   :passing-one-page))
    (desig-prop ?desig (:book ?book)))

  ;; Close book
  (<- (desig:action-grounding ?desig (close-book ?desig))
    (desig-prop ?desig (:type   :closing-book))
    (desig-prop ?desig (:book ?book)))

  ;; Feeding Caretaker
  (<- (desig:action-grounding ?desig (feed-caretaker ?desig))
    (desig-prop ?desig (:type   :feeding-caretaker))
    (desig-prop ?desig (:person ?person))
    (desig-prop ?desig (:cutlery ?cutlery))
    (desig-prop ?desig (:food ?food)))

  ;; Feed person
  (<- (desig:action-grounding ?desig (feed-person ?desig))
    (desig-prop ?desig (:type   :feeding-person))
    (desig-prop ?desig (:person ?person)))

  ;; Fork 
  (<- (desig:action-grounding ?desig (fork-piece ?desig))
    (desig-prop ?desig (:type   :forking-piece))
    (desig-prop ?desig (:piece ?piece)))

  ;; Move object
  (<- (desig:action-grounding ?desig (move-object-to ?desig))
    (desig-prop ?desig (:type   :moving-object-to))
    (desig-prop ?desig (:object ?object))
    (desig-prop ?desig (:to ?to)))

  ;; Turn to
  (<- (desig:action-grounding ?desig (turn-to-angle ?desig))
    (desig-prop ?desig (:type   :turning-to-angle))
    (desig-prop ?desig (:angle ?angle)))

  ;; hand-reach
  (<- (desig:action-grounding ?desig (hand-reach ?desig))
    (desig-prop ?desig (:type   :hand-reaching))
    (desig-prop ?desig (:hand ?hand))
    (desig-prop ?desig (:pos ?pos)))

  ;; Path following
  (<- (desig:action-grounding ?desig (move-on-path ?desig))
    (desig-prop ?desig (:type   :moving-on-path))
    (desig-prop ?desig (:path ?path)))

  ;; Grasping
  (<- (desig:action-grounding ?desig (pick-up ?desig))
    (desig-prop ?desig (:type      :picking-up))
    (desig-prop ?desig (:object    ?object))
    (desig-prop ?desig (:with-hand ?with-hand)))

  ;; Placing
  (<- (desig:action-grounding ?desig (put-down ?desig))
    (desig-prop ?desig (:type      :putting-down))
    (desig-prop ?desig (:from-hand ?from-hand))
    (desig-prop ?desig (:at        ?location)))

  ;; Placing
  (<- (desig:action-grounding ?desig (put-down ?desig))
    (desig-prop ?desig (:type      :putting-down))
    (desig-prop ?desig (:at        ?location)))

  ;; Placing-at
  (<- (desig:action-grounding ?desig (place-at ?desig))
    (desig-prop ?desig (:type      :placing-at))
    (desig-prop ?desig (:at        ?location)))

  ;; Releasing
  (<- (desig:action-grounding ?desig (release ?desig))
    (desig-prop ?desig (:type      :releasing))
    (desig-prop ?desig (:from-hand ?from-hand)))

  ;;Fetch-and-place
  (<- (desig:action-grounding ?desig (fetch-and-place ?desig))
    (desig-prop ?desig (:type      :fetching-and-placing))
    (desig-prop ?desig (:object    ?object))
    (desig-prop ?desig (:at        ?location)))

  ;;Fetch
  (<- (desig:action-grounding ?desig (fetch ?desig))
    (desig-prop ?desig (:type      :fetching))
    (desig-prop ?desig (:object    ?object))
    (desig-prop ?desig (:with-hand        ?with-hand)))

  ;;Transporting
  (<- (desig:action-grounding ?desig (transport ?desig))
    (desig-prop ?desig (:type      :transporting))
    (desig-prop ?desig (:object    ?object))
    (desig-prop ?desig (:to        ?location)))

  ;; MovingTo
  (<- (desig:action-grounding ?desig (move-to ?desig))
    (desig-prop ?desig (:type   :moving-to))
    (desig-prop ?desig (:path ?path)))

  )

