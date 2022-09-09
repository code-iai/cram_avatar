(defsystem cram-avatar-control-interface
  :depends-on (:roslisp
               :iai_avatar_msgs-msg
	           :iai_avatar_msgs-srv)

  :components
  ((:module "src"
            :components
            ((:file "package")
             (:file "control-avatar" :depends-on ("package"))))))

