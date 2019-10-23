(defsystem cram-avatar
  :depends-on (roslisp cram-language iai_avatar_msgs-srv
               cl-transforms geometry_msgs-msg
               cram-designators cram-prolog
               cram-process-modules cram-language-designator-support)

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
             (:file "high-level-plans" :depends-on ("package"
                                                   "motion-designators"
                                                   "action-designators"
                                                   "process-modules"))))))

