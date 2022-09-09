(defsystem cram-avatar-demos
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
	           :cram_avatar_control_interface
	           )

  :components
  ((:module "src"
            :components
            ((:file "package")
	         (:file "year-two-demo" :depends-on ("package"))))))

