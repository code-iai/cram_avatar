(defsystem cram-avatar-action-designators
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
	           :iai_avatar_msgs-srv)

  :components
  ((:module "src"
            :components
            ((:file "package")
	         (:file "action-designators" :depends-on ("package"))))))

