(in-package :av-plan)



(defun init ()
	"Initialize ROS Communication"
	(start-ros-node
         "cram-client")
	(init-ros-avatar
      "avatar"))


