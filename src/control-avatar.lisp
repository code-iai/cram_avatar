(in-package :aia)

(defvar *avatar-pose* (make-fluent :name :avatar-pose) "current pose of avatar")
(defvar *pose-sub* nil "pose ROS subscriber")

(defvar *csl-command-srv* nil "name of ROS service for sending console commands")
(defvar *command-srv* nil "name of ROS service for sending commands")
(defvar *move-to-srv* nil "name of ROS service for moving to a location")

(defun init-ros-avatar (name)
  "Binds services. `name specifies the name of the turtle."

  (setf *csl-command-srv* (concatenate 'string "/" name "/send_console_command"))
  (setf *command-srv* (concatenate 'string "/" name "/send_command"))
  (setf *move-to-srv* (concatenate 'string "/" name "/move_to"))
  (setf *pose-sub* (subscribe (format nil "~a/Pose" name)"geometry_msgs/Pose"
                              #'pose-cb))
  (setf *cmd-vel-pub* (advertise (format nil "/twistmsg")
                                 "geometry_msgs/Twist")))

(defun pose-cb (msg)
  "Callback for pose values. Called by the pose topic subscriber."
  (setf (value *avatar-pose*) msg))

(defun call-send-command (comm)
  "Function to call the Send Command service."
  (call-service *command-srv* 'iai_avatar_msgs-srv:Command
                :command comm))

(defun call-send-console-command (comm)
  "Function to call the Send Console Command service."
  (call-service *csl-command-srv* 'iai_avatar_msgs-srv:Command
                :command comm))

(defun call-move-to (x y z)
  "Function to call MoveTo service."
  (call-service *move-to-srv* 'iai_avatar_msgs-srv:MoveTo
                :position (roslisp:make-message
                            'geometry_msgs-msg:point :x x :y y :z z)))


