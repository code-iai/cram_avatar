(in-package :aia)

(defvar *belief-state* (make-fluent :name :belief-state :value 0) "current belief state of avatar")
(defvar *belief-sub* nil "belief ROS subscriber")
;;(defvar *belief-pub* nil "belief ROS publisher")

(defvar *sync-state* (make-fluent :name :sync-state :value 0) "current sync state between robot and avatar")
(defvar *sync-sub* nil "sync ROS subscriber")
(defvar *sync-pub* nil "sync ROS publisher")

(defvar *avatar-pose* (make-fluent :name :avatar-pose) "current pose of avatar")
(defvar *pose-sub* nil "pose ROS subscriber")

(defvar *csl-command-srv* nil "name of ROS service for sending console commands")
(defvar *command-srv* nil "name of ROS service for sending commands")
(defvar *move-to-srv* nil "name of ROS service for moving to a location")
(defvar *semantic-cam-srv* nil "name of ROS service for calling Semantic Camera")

(defun init-ros-avatar (name)
  "Binds services. `name specifies the name of the turtle."

  (setf *csl-command-srv* (concatenate 'string "/" name "/send_console_command"))
  (setf *command-srv* (concatenate 'string "/" name "/send_command"))
  (setf *move-to-srv* (concatenate 'string "/" name "/move_to"))
  (setf *semantic-cam-srv* (concatenate 'string "/" name "/semantic_camera"))
  (setf *pose-sub* (subscribe (format nil "~a/Pose" name)"geometry_msgs/Pose"
                              #'pose-cb))
  (init-sub)
  (setf *sync-pub* (advertise (format nil "avatar_robot/Sync")"std_msgs/Int32"))
  (setf *belief-sub* (subscribe (format nil "~a/Belief" name)"std_msgs/Int32"
                              #'belief-cb))
)

(defun init-sub ()
  (setf *sync-sub* (subscribe (format nil "avatar_robot/Sync")"std_msgs/Int32"
                              #'sync-cb)))


(defun wait-for-belief-state (state)
      (wait-for (eq (fl-funcall #'std_msgs-msg:data *belief-state*) state)))

;;(defun get-belief-state (state)
  ;;(publish *belief-pub* (make-message "std_msgs/Int32" :data state)))

(defun belief-cb (msg)
  (setf (value *belief-state*) msg))

                              
(defun wait-for-sync-state (state)
      (wait-for (eq (fl-funcall #'std_msgs-msg:data *sync-state*) state)))

(defun send-sync-state (state)
  "Function to send sync state"
  (publish *sync-pub* (make-message "std_msgs/Int32" :data state)))

(defun sync-cb (msg)
  "Callback for sync values. Called by the sync topic subscriber."
  (setf (value *sync-state*) msg))


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

(defun call-semantic-camera-service ()
  "Function to call the semantic camera service."
  (call-service *semantic-cam-srv* 'iai_avatar_msgs-srv:SemanticCamera))
