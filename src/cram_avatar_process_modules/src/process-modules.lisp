(in-package :av-pm)

(def-process-module avatar-communication (motion-designator)
  (roslisp:ros-info (av-modes::avatar-process-modules)
                    "Avatar manipulation invoked with motion designator `~a'."
                    motion-designator)
  (destructuring-bind (command motion) (reference motion-designator)
    (ecase command
      (tell
        (let ((cmd "tell"))
          (format t  "tell-test"))))))

;; ;; Process module for communication
;; (def-process-module avatar-communication (motion-designator)
;;   (roslisp:ros-info (av-modes::avatar-process-modules)
;;                     "Avatar communication invoked with motion designator `~a'."
;;                     motion-designator)
;;   (destructuring-bind (command motion) (reference motion-designator)
;;     (ecase command
;;       (tell
;;        (let ((cmd "tell"))
;;          (format t  "tell-test")))
;;       )))





;; Process module for navigation
(def-process-module avatar-navigation (motion-designator)
  (roslisp:ros-info (av-modes::avatar-process-modules)
                    "Avatar navigation invoked with motion designator `~a'."
                    motion-designator)
  (destructuring-bind (command motion) (reference motion-designator)
    (ecase command
      (follow
        (let ((cmd (concatenate 'string "follow " (write-to-string (av-modes::avatar-motion-path  motion)))))
           (av-con::call-send-console-command cmd)))
      (move-base
        (let ((x  (av-modes::avatar-motion-x_val  motion))
              (y  (av-modes::avatar-motion-y_val  motion))
              (z  (av-modes::avatar-motion-z_val  motion)))
          (av-con::call-move-to x y z)))
      (turn
        (let ((cmd (concatenate 'string "turn to " (write-to-string (av-modes::avatar-motion-angle motion)))))
           (av-con::call-send-console-command cmd)))
      (look-at
        (let ((cmd (concatenate 'string "look to " motion)))
          (av-con::call-send-console-command cmd)))
      (look-to
        (let ((x  (av-modes::avatar-look-motion-x_val  motion))
              (y  (av-modes::avatar-look-motion-y_val  motion))
              (z  (av-modes::avatar-look-motion-z_val  motion)))

          (let ((cmd (concatenate 'string "look to "  
            (write-to-string x) " " 
            (write-to-string y) " " 
            (write-to-string z))))
            (av-con::call-send-console-command cmd))))
    ;; (tell
      ;; (let ((cmd "tell"))
        ;; (format t  "tell-test")))
    )))

;; Process modules for hand manipulations
(def-process-module avatar-manipulation (motion-designator)
  (roslisp:ros-info (av-modes::avatar-process-modules)
                    "Avatar manipulation invoked with motion designator `~a'."
                    motion-designator)
  (destructuring-bind (command motion) (reference motion-designator)
    (ecase command
      (cut
        (let ((cmd "cut"))
          (format t  "tell-test")))
      (spoon
        (let ((cmd "spoon"))
          (av-con::call-send-console-command cmd)))
      (press
        (let ((cmd (concatenate 'string "press " (av-modes::avatar-press-motion-button motion))))
          (av-con::call-send-console-command cmd)))
      (pour
        (let ((cmd (concatenate 'string "pour over " (av-modes::avatar-pour-motion-target motion))))
          (av-con::call-send-console-command cmd)))
      (fork
        (let ((cmd (concatenate 'string "fork " (av-modes::avatar-fork-motion-target motion))))
          (av-con::call-send-console-command cmd)))
      (feed
        (let ((cmd (concatenate 'string "feed " (av-modes::avatar-feed-motion-target motion))))
          (av-con::call-send-console-command cmd)))
      (read-page
        (let ((cmd (concatenate 'string "read " 
		(av-modes::avatar-read-page-motion-page motion) " "
		(av-modes::avatar-read-page-motion-book motion))))
          (av-con::call-send-console-command cmd)))
      (pass-page
        ( let ((cmd_str "pass page ")
	       (book (av-modes::avatar-pass-page-motion-book motion))
               (last (av-modes::avatar-pass-page-motion-last motion)))

          (when last (setq cmd_str "close book "))

          (let ((cmd (concatenate 'string cmd_str book)))
             (av-con::call-send-console-command cmd))))
      (close-door
        (let ((cmd (concatenate 'string "close " (av-modes::avatar-close-motion-door motion))))
          (av-con::call-send-console-command cmd)))
      (reach-w-hand
        (let ((cmd (concatenate 'string (av-modes::avatar-hand-reach-motion-hand motion)
					" hand reach "
					(av-modes::avatar-hand-reach-motion-pos motion))))
           (av-con::call-send-console-command cmd)))
      (grasp
        ( let ((hold_str "")
               (item (av-modes::avatar-grasping-motion-item motion))
               (hand (av-modes::avatar-grasping-motion-hand motion))
               (hold (av-modes::avatar-grasping-motion-hold motion)))

          (when hold (setq hold_str "hold"))

          (let ((cmd (concatenate 'string "grasp " hand " " item " " hold_str)))
             (av-con::call-send-console-command cmd))))
      (place-on
        ( let ((hand_str "")
               (place_str "")
               (hand (av-modes::avatar-placing-motion-from_hand motion))
               (place (av-modes::avatar-placing-motion-place motion)))

          (when hand (setq hand_str hand))
          (when place (setq place_str place))

          (let ((cmd (concatenate 'string "place " hand_str " " place_str)))
             (av-con::call-send-console-command cmd))))
      (place-at
        ( let ((hand_str "")
               (x (av-modes::avatar-placing-motion-x_val motion))
               (y (av-modes::avatar-placing-motion-y_val motion))
               (z (av-modes::avatar-placing-motion-z_val motion))
               (hand (av-modes::avatar-placing-motion-from_hand motion)))

          (when hand (setq hand_str hand))

          (let ((cmd (concatenate 'string "place " hand_str " " 
            (write-to-string x) " " 
            (write-to-string y) " " 
            (write-to-string z))))
             (av-con::call-send-console-command cmd))))
    )))

;; Help functions
(defun turn-to (?angle)
  (top-level
    (with-process-modules-running (av-modes::avatar-navigation)
      (let ((direction (desig:a motion (type moving) (angle ?angle))))
        (pm-execute 'avatar-navigation direction)))))

(defun move-to (?x ?y ?z)
  (top-level
    (with-process-modules-running (av-modes::avatar-navigation)
      (let ((target (desig:a motion (type moving) (x_val ?x) (y_val ?y) (z_val ?z))))
        (pm-execute 'avatar-navigation target)))))

(defun follow-path (?path)
  (top-level
    (with-process-modules-running (av-modes::avatar-navigation)
      (let ((target (desig:a motion (type moving) (path ?path))))
        (pm-execute 'avatar-navigation target)))))

(defun look-to (?x ?y ?z)
  (top-level
    (with-process-modules-running (av-modes::avatar-navigation)
      (let ((target (desig:a motion (type looking) (x_val ?x) (y_val ?y) (z_val ?z))))
         (pm-execute 'avatar-navigation target)))))

(defun look-at (?object)
  (top-level
    (with-process-modules-running (av-modes::avatar-navigation)
      (let ((target (desig:a motion (type looking) (target ?object))))
         (pm-execute 'avatar-navigation target)))))

(defun reset-look ()
  (top-level
    (with-process-modules-running (av-modes::avatar-navigation)
      (let ((target (desig:a motion (type looking))))
        (pm-execute 'avatar-navigation target)))))

(defun reach-with-hand (?hand ?pos)
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((target (desig:a motion (type reaching-w-hand) (hand ?hand) (pos ?pos))))
        (pm-execute 'avatar-manipulation target)))))

(defun cut ()
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((target (desig:a motion (type slicing))))
        (pm-execute 'avatar-manipulation target)))))

(defun spoon ()
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((target (desig:a motion (type spooning))))
        (pm-execute 'avatar-manipulation target)))))

(defun press (?button)
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((target (desig:a motion (type pressing) (button ?button))))
        (pm-execute 'avatar-manipulation target)))))

(defun pour-over (?target)
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((trgt (desig:a motion (type pouring) (target ?target))))
        (pm-execute 'avatar-manipulation trgt)))))

(defun fork (?target)
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((trgt (desig:a motion (type forking) (target ?target))))
        (pm-execute 'avatar-manipulation trgt)))))

(defun feed-person (?target)
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((trgt (desig:a motion (type feeding) (target ?target))))
        (pm-execute 'avatar-manipulation trgt)))))

(defun read-book (?book ?page)
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((trgt (desig:a motion (type reading-book) (book ?book) (page ?page))))
        (pm-execute 'avatar-manipulation trgt)))))

(defun close-book (?book)
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((trgt (desig:a motion (type passing-page) (book ?book) (last t))))
        (pm-execute 'avatar-manipulation trgt)))))

(defun pass-page (?book)
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((trgt (desig:a motion (type passing-page) (book ?book) (last nil))))
        (pm-execute 'avatar-manipulation trgt)))))

(defun close-door (?door)
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((target (desig:a motion (type closing) (door ?door))))
        (pm-execute 'avatar-manipulation target)))))

(defun grasp (?item ?hand)
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((target (desig:a motion (type grasping) (item ?item) (hand ?hand))))
        (pm-execute 'avatar-manipulation target)))))

(defun grasp_and_hold (?item ?hand)
  (top-level
    (with-process-modules-running (av-modes::avatar-manipulation)
      (let ((target (desig:a motion (type grasping) (item ?item) (hand ?hand) (hold t))))
        (pm-execute 'avatar-manipulation target)))))

(defun place-object-on (?place &optional ?hand)
  ( if ?hand
    (top-level
      (with-process-modules-running (av-modes::avatar-manipulation)
        (let ((target (desig:a motion (type placing) (from_hand ?hand) (place ?place))))
          (pm-execute 'avatar-manipulation target))))
    (top-level
      (with-process-modules-running (av-modes::avatar-manipulation)
        (let ((target (desig:a motion (type placing) (place ?place))))
          (pm-execute 'avatar-manipulation target))))))

(defun place-object-at (?x ?y ?z &optional ?hand)
  ( if ?hand
    (top-level
      (with-process-modules-running (av-modes::avatar-manipulation)
        (let ((target (desig:a motion (type placing) (from_hand ?hand) (x_val ?x) (y_val ?y) (z_val ?z))))
          (pm-execute 'avatar-manipulation target))))
    (top-level
      (with-process-modules-running (av-modes::avatar-manipulation)
        (let ((target (desig:a motion (type placing) (x_val ?x) (y_val ?y) (z_val ?z))))
          (pm-execute 'avatar-manipulation target))))))

