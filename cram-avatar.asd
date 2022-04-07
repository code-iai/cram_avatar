(defsystem cram-avatar
  :depends-on (:roslisp
	       :actionlib_msgs-msg 
	       :actionlib 
	       :geometry_msgs-msg
               :iai_avatar_msgs-msg 
	       :iai_avatar_msgs-srv
               :cl-transforms
	       :cram-language
               :cram-designators 
	       :cram-prolog 
               :cram-process-modules 
	       :cram-language-designator-support
               :cram-executive 
	       :cram-cloud-logger)

  :components
  ((:module "src"
            :components
            ((:file "package")
             (:file "control-avatar" :depends-on ("package"))
	     (:file "year-two-demo" :depends-on ("package" "control-avatar"))
             (:file "motion-designators" :depends-on ("package"))
	     (:file "action-designators" :depends-on ("package"))
             (:file "process-modules" :depends-on ("package"
                                                   "control-avatar"
                                                   "year-two-demo"
                                                   "motion-designators"))
             (:file "shopping" :depends-on ("package"
                                                   "motion-designators"
                                                   "action-designators"
                                                   "process-modules"))
             (:file "qna-action-client" :depends-on ("package"))))))

