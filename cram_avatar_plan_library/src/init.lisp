(in-package :av-plan)



(defun init ()
	"Initialize ROS Communication"
	(start-ros-node
         "cram-client")
	(av-con::init-ros-avatar
      "avatar"))


