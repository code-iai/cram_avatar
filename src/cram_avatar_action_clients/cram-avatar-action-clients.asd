(defsystem cram-avatar-action-clients
  :depends-on (:roslisp
	           :actionlib_msgs-msg
	           :actionlib
               :iai_avatar_msgs-msg
	           :iai_avatar_msgs-srv)

  :components
  ((:module "src"
            :components
            ((:file "package")
             (:file "qna-action-client" :depends-on ("package"))))))

