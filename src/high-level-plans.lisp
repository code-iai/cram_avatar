(in-package :aia)

(defvar *hand* "right" "Hand to be used")

(defvar *container_loc* (make-3d-vector 65 72 86) "Intended location for topping container")
(defvar *plate_loc* (make-3d-vector -70 -55 86) "Intended location for plate")
(defvar *fork_loc* (make-3d-vector -401 -103 78) "Intended location for fork")

(defvar *plate_place*     "kitchen_island"  "Path name to get to the kitchen island")
(defvar *newspaper_place* "table_newspaper" "Path name to get to the table at newspaper place")
(defvar *chair_place*     "table_chair"     "Path name to get to the table and chair place")

(defvar *plate_rot*     180  "Rotation to face the kitchen island")
(defvar *newspaper_rot* -10 "Rotation to face the table at newspaper place")
(defvar *chair_rot*     -90     "Rotation to face the table and chair place")

;; Running Ropha Scenario
(defun run-ropha-scenario ()
  ( let ((?plate-desig (desig:an object (type plate) (name "SM_ClassicPlate16cm_1")))
         (?fork-desig (desig:an object (type cutlery) (name "SM_DinnerFork_0")))
         (?food-desig (desig:an object (type waffle) (name "SM_Waffle_3")))
         (?book-desig (desig:an object (type book) (name "BP_Newspaper_0")))
         (?person "ThirdPersonAvatar_sitting_0"))

    (top-level
      (with-process-modules-running (avatar-navigation avatar-manipulation)
        (exe:perform (desig:an action (type reading-feeding) (person ?person) (book ?book-desig) (food ?food-desig) (on ?plate-desig) (with ?fork-desig)))))
  )
)

;; Running entire scenario
(defun run-pouring-scenario ()

  ( let ((?container-desig (desig:an object (type jug) (name "SM_Milk_Jug_0")))
         (?target-desig (desig:an object (type waffle) (name "SM_Waffle_2"))))

    (top-level
      (with-process-modules-running (avatar-navigation avatar-manipulation)
        (exe:perform (desig:an action (type adding-topping) (from ?container-desig) (on ?target-desig)))))
  )
)

;; Interpreting adding topping action
(defun add-topping (&key ((:from ?from)) ((:on ?on)) &allow-other-keys)

  (let ((?loc_vector *container_loc* ) (?hand *hand*))
    (exe:perform (desig:an action (type picking-up) (object ?from) (with-hand ?hand)))
    (sleep 1)
    (exe:perform (desig:an action (type pouring-over) (object ?on)))
    (sleep 2)
    (exe:perform (desig:an action (type putting-down) (from-hand ?hand) (at ?loc_vector))))
)

;; Interpreting pouring action
(defun pour-over (&key ((:object ?object)) &allow-other-keys) 
    
    (let ((?target (desig:desig-prop-value ?object :name)))
      (pm-execute 'avatar-navigation (desig:a motion (type 
ing) (target ?target)))
      (pm-execute 'avatar-manipulation (desig:a motion (type pouring) (target ?target))))
    (sleep 9)
    ;;  (pm-execute 'avatar-navigation (desig:a motion (type looking) (target "front")))
)

;; Interpreting reading to and feeding person action
(defun read-feed (&key ((:person ?person)) ((:book ?book)) ((:food ?food)) ((:on ?plate)) ((:with ?cutlery)) &allow-other-keys)
    (let ((?place_1 *plate_place*) (?place_2 *newspaper_place*) (?place_3 *chair_place*)
          (?rot_2 *newspaper_rot*) (?rot_3 *chair_rot*))

      ;; Moving plate to kitchen island
      (exe:perform (desig:an action (type moving-object-to) (object ?plate) (to ?place_1)))

      ;; Inform step is done
      (send-sync-state 1)

      ;; Go read news paper
      (exe:perform (desig:an action (type moving-on-path) (path ?place_2)))
      (sleep 4)
      (exe:perform (desig:an action (type turning-to-angle) (angle ?rot_2)))
      (sleep 2)
      (call-send-console-command "sit")
      (sleep 2)
      (pm-execute 'avatar-navigation (desig:a motion (type looking) (target ?person)))
      (sleep 4)
      (exe:perform (desig:an action (type reading-book) (book ?book)))

      ;; Wait for step 2
      (wait-for (eq (fl-funcall #'std_msgs-msg:data *sync-state*) 2))

      ;; Feed caretaker
      ;;(exe:perform (desig:an action (type moving-on-path) (path ?place_3)))
      ;;(sleep 2)
      ;;(exe:perform (desig:an action (type turning-to-angle) (angle ?rot_3)))
      ;;(sleep 1)
      (exe:perform (desig:an action (type feeding-caretaker) (person ?person) (cutlery ?cutlery) (food ?food)))
    )
)

;; Interpreting read book action
(defun read-book (&key ((:book ?book)) &allow-other-keys)
    (exe:perform (desig:an action (type reading-page-text) (book ?book) (page "right")))
    (sleep 385)
    (exe:perform (desig:an action (type passing-one-page) (book ?book)))
    (sleep 5)
    (exe:perform (desig:an action (type reading-page-text) (book ?book) (page "left")))
    (sleep 385)
    (exe:perform (desig:an action (type reading-page-text) (book ?book) (page "right")))
    (sleep 385)
    (exe:perform (desig:an action (type closing-book) (book ?book)))
    (sleep 6)
)

;; Interpreting read line action
(defun read-page-text (&key ((:book ?book)) ((:page ?page)) &allow-other-keys)
    (let ((?target (desig:desig-prop-value ?book :name)))
      (pm-execute 'avatar-manipulation (desig:a motion (type reading-page) (book ?target) (page ?page)))
    )
)

;; Interpreting pass page action
(defun pass-one-page (&key ((:book ?book)) &allow-other-keys)
    (let ((?target (desig:desig-prop-value ?book :name)))
      (pm-execute 'avatar-manipulation (desig:a motion (type passing-page) (book ?target) (last nil)))
    )
)

;;Interpreting close book action
(defun close-book (&key ((:book ?book)) &allow-other-keys)
    (let ((?target (desig:desig-prop-value ?book :name)))
      (pm-execute 'avatar-manipulation (desig:a motion (type passing-page) (book ?target) (last t)))
    )
)

;; Interpreting feeding caretaker
(defun feed-caretaker (&key ((:person ?person)) ((:cutlery ?cutlery)) ((:food ?food)) &allow-other-keys)
  (let ((?loc_vector *fork_loc* ) (?hand *hand*))
    (exe:perform (desig:an action (type picking-up) (object ?cutlery) (with-hand ?hand)))
    (sleep 3)
    (exe:perform (desig:an action (type forking-piece) (piece ?food)))
    (sleep 3)
    (exe:perform (desig:an action (type feeding-person) (person ?person)))
    (sleep 4)
;;    (exe:perform (desig:an action (type forking-piece) (piece ?food)))
;;    (sleep 3)
;;    (exe:perform (desig:an action (type feeding-person) (person ?person)))
;;    (sleep 3)
;;    (exe:perform (desig:an action (type forking-piece) (piece ?food)))
;;    (sleep 3)
;;    (exe:perform (desig:an action (type feeding-person) (person ?person)))
;;    (sleep 3)
    (exe:perform (desig:an action (type putting-down) (from-hand ?hand) (at ?loc_vector)))
    (sleep 3)
  )
)

;; Interpreting feeding person
(defun feed-person (&key ((:person ?person)) &allow-other-keys)
    (pm-execute 'avatar-manipulation (desig:a motion (type feeding) (target ?person)))
)

;; Interpreting fork action
(defun fork-piece (&key ((:piece ?piece)) &allow-other-keys)
    (let ((?target (desig:desig-prop-value ?piece :name)))
      (pm-execute 'avatar-manipulation (desig:a motion (type forking) (target ?target)))
    )
)

;; Interpreting moving object action
(defun move-object-to (&key ((:object ?object)) ((:to ?to)) &allow-other-keys)
  (let ((?loc_vec *plate_loc* ) (?hand *hand*) (?rot_1 *plate_rot*))
    (exe:perform (desig:an action (type picking-up) (object ?object) (with-hand ?hand)))
    (sleep 4)
    (exe:perform (desig:an action (type moving-on-path) (path ?to)))
    (sleep 3)
    ;;(exe:perform (desig:an action (type turning-to-angle) (angle ?rot_1)))
    ;;(sleep 1)
    (exe:perform (desig:an action (type putting-down) (from-hand ?hand) (at ?loc_vec)))
    (sleep 3)
  )
)

;; Interpreting turning to action
(defun turn-to-angle (&key ((:angle ?angle)) &allow-other-keys)	
    (pm-execute 'avatar-navigation (desig:a motion (type moving) (angle ?angle)))
)

;; Interpreting path following action
(defun move-on-path (&key ((:path ?path)) &allow-other-keys)
    (pm-execute 'avatar-navigation (desig:a motion (type moving) (path ?path)))
)

;; Interpreting picking up action
(defun pick-up (&key ((:object ?object)) ((:with-hand ?with-hand)) &allow-other-keys)
    
    (let ((?target  (desig:desig-prop-value ?object :name)))
      (pm-execute 'avatar-manipulation (desig:a motion (type grasping) (item ?target) (hand ?with-hand) (hold t))))
)

;; Interpreting putting down action
(defun put-down (&key ((:from-hand ?from-hand)) ((:at ?location)) &allow-other-keys)
  (let ((?in_x (float (cl-transforms:x ?location) 1.0)) 
        (?in_y (float (cl-transforms:y ?location) 1.0)) 
        (?in_z (float (cl-transforms:z ?location) 1.0 )))

    (pm-execute 'avatar-manipulation (desig:a motion (type placing) (from_hand ?from-hand) (x_val ?in_x) (y_val ?in_y) (z_val ?in_z)))
  )
)









