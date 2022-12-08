(in-package :av-plan)



(defparameter *is-agent-approaching-state* (make-fluent :name :is-agent-approaching :value 0) 
  "is an agent approaching me?")
(defvar *is-agent-approaching-sub* nil "is-agent-approaching ROS subscriber")
;;(defvar *belief-pub* nil "belief ROS publisher")

(defun init-sub ()
(setf *is-agent-approaching-sub* (subscribe (format nil "isAgent_approaching")"std_msgs/Int32"
                              #'is-agent-approaching-cb)))

(defun wait-for-is-agent-approaching (state)
      (wait-for (eq (fl-funcall #'std_msgs-msg:data *is-agent-approaching-state*) state)))

(defun is-agent-approaching-cb (msg)
  (setf (value *is-agent-approaching-state*) msg))

                              


