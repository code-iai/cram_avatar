(in-package :av-plan)3

;;(defparameter paths-list (list  "Door_to_Sony" "Sony_to_Nikon" "Nikon_to_Canon" "NONE" "NONE" "NONE" "Canon_to_Nikon" "NONE" "NONE" "NONE" "NONE"))
;;(defparameter paths-list (list "NONE" "NONE" "ServiceCounter_to_Canon" "NONE" "NONE" "NONE" "Canon_to_Nikon" "NONE" "NONE" "NONE" 
;;                               "Door_to_Sony" "Sony_to_Nikon" "Nikon_to_Canon" "NONE" "NONE" "NONE" "Canon_to_Nikon" "NONE" "NONE" "NONE" "NONE"))

(defparameter paths-list (list "NONE" "Door_to_Sony" ;;0
                               "NONE" "Sony_to_Nikon" ;;1
                               "ServiceCounter_to_Canon" "Nikon_to_Canon" ;;2
                               "NONE" "NONE" ;;3
                               "NONE" "NONE" ;;4
                               "NONE" "NONE" ;;5
                               "Canon_to_Nikon" "Canon_to_Nikon" ;;6
                               "NONE" "NONE" ;;7
                               "NONE" "NONE" ;;8
                               "NONE" "NONE" ;;9
                               "NONE" "NONE" ;;10
                               ))

(defparameter agents-list (list "shopkeeper1" "customer1" ;;0
                                "shopkeeper1" "customer1" ;;1
                                "shopkeeper1" "customer1" ;;2
                                "shopkeeper1" "customer1" ;;3
                                "shopkeeper1" "customer1" ;;4
                                "shopkeeper1" "customer1" ;;5
                                "shopkeeper1" "customer1" ;;6
                                "shopkeeper1" "customer1" ;;7
                                "shopkeeper1" "customer1" ;;8
                                "shopkeeper1" "customer1" ;;9
                                "shopkeeper1" "customer1" ;;10

))

(defparameter keywords-list (list "NONE" "NONE" ;;0
                                "Q_goodafternoon_help" "Q_colors_model" ;;1
                                "black_camera" "light" ;;2
                                "Q_sort_pictures" "family vacation_uh_good lighting_example_motion" ;;3
                                "family" "yes" ;;4
                                "lightweightcamera_variousviews_presets_look" "Q_cost" ;;5
                                "presetmode_greatpicture_exposure_snow_beach_time" "NONE" ;;6
                                "rightvalue_photographs_price" "Q_megapixels" ;;7
                                "megapixels" "thanks_help" ;;8
                                "Q_anythingelse_today_help" "all_thankyou" ;;9
                                "good afternoon_thanks_time" "NONE" ;;10

))
(defvar *path* nil "path to follow")
(defvar ?path  nil "path to follow")

(defvar *agent* nil "path to follow")
(defvar ?agent nil "path to follow")

(defvar *keywords* nil "words to say")

(defun logging-trial()
  (setf cram-tf:*tf-broadcasting-enabled* t)
  (setf ccl::*is-logging-enabled* t)
  (print "Start")
  ;;(ccl::clear-detected-objects)
  ;;(detect-objects)
  (ccl::start-episode)
  (ccl::send-query-1-without-result "has_kinematics_file" "Client" "ID" "'URDF'")
  ;;(ccl::handle-detected-object *plate*)
  (Trial132)
  (ccl::stop-episode)
  (setf ccl::*episode-name* nil)
  (print "End"))

;; Task
(defun Trial132()
  (setf ?path *path*)
  (setf ?agent *agent*)
  (setf ?keywords *keywords*)
  
  (top-level
   (with-process-modules-running (avatar-navigation avatar-communication)
                                 (mapcar
                                  (lambda
                                  
                                   ;; (sleep 4)
                                    ;;(itt)
                                    (it)
                                    
                                    (print "1.Path to follow , operating agent, and words to say:")
                                    (print ?path)
                                    (print ?agent)
                                    (print ?keywords)
                                   
                                    (setf ?agent (nth it agents-list))
                                    (setf ?path (nth it paths-list))
                                    (setf ?keywords (nth it keywords-list))
                                    (init-ros-avatar ?agent)

                                    (print "2. Path to follow , operating agent, and words to say:")
                                    (print ?path)
                                    (print ?agent)
                                    (print ?keywords)
                                      
                                    (exe:perform (desig:an action (type imagining) (motion ?path) (communication ?keywords)))
                                    (sleep 8)
                                    
                                    (print "3.Path to follow , operating agent, and words to say:")
                                    (setf ?path *path*)
                                    (setf ?agent *agent*)
                                    (setf ?keywords *keywords*)
                                    (print ?path)
                                    (print ?agent)
                                    (print ?keywords)
                                    )
                                    
                                  ;;'(0 1)
                                  '(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21))
                                 )))

(defun imagine (&key ((:motion ?path)) ((:communication ?keywords)) &allow-other-keys)
  (exe:perform (desig:an action (type moving-to) (path ?path)))
   (sleep 8)
  (exe:perform (desig:an action (type telling) (keywords ?keywords)))
  )

  (defun move-to (&key ((:path ?path)) &allow-other-keys)
  
  (pm-execute 'avatar-navigation (desig:a motion (type moving) (path ?path)))
  )

    (defun tell (&key ((:keywords ?keywords)) &allow-other-keys)
  
   (pm-execute 'avatar-communication (desig:a motion (type speaking) (keywords ?keywords)))
  )
  

 ;; (loop for it in 'paths-list
  ;;     do((setf *path* (nth it paths-list))



