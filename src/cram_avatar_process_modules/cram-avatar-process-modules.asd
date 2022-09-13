(defsystem cram-avatar-process-modules
  :depends-on (:roslisp
	           :actionlib_msgs-msg
	           :actionlib
	           :geometry_msgs-msg
               :cl-transforms
	           :cram-language
               :cram-designators 
	           :cram-prolog
               :cram-process-modules 
	           :cram-language-designator-support
               :cram-executive 
	           :cram-cloud-logger
               :iai_avatar_msgs-msg
	           :iai_avatar_msgs-srv
	           :cram-avatar-action-designators
	           :cram-avatar-motion-designators
	           :cram-avatar-control-interface
	           :cram-avatar-demos)

  :components
  ((:module "src"
            :components
            ((:file "package")
             (:file "process-modules" :depends-on ("package"))
             ))))

