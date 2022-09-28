(in-package :av-accli)

(defvar *qna-action-client* nil)

(defun init-qna-action-client ()
   "Initializes the QnA action client."
   (setf *qna-action-client* ( actionlib:make-action-client
      "/Question"
      "iai_avatar_msgs/QnAAction"))
   (loop until
      (actionlib:wait-for-server *qna-action-client*))  
   (roslisp:ros-info (qna-action-client)
                     "QnA Action Client Created"))

(defun get-qna-action-client ()
   "Returns the current QnA client. If none exists, one is created."
   (when (null *qna-action-client*)
      (init-qna-action-client))
   *qna-action-client*)

(defun make-qna-action-goal (text)
   "Create a QnA action goal with the given text"
   (actionlib:make-action-goal (get-qna-action-client)
                  :question text))

(defun call-qna-action (text)
   "Calls the QnA action to perform the given text"
   (multiple-value-bind (result status)
      (let ((actionlib:*action-server-timeout* 1000.0))
         (actionlib:call-goal
            (get-qna-action-client)
            (make-qna-action-goal text)))
      (roslisp:ros-info (qna-action-client) "QnA Action Finished.")
      (values result status)
      (with-fields (answer)
         (value result)
         answer
      )
   )
)

(defun test-send-question ()
   "A function to test sending questions."
   (call-qna-action "Do you want vanilla toping?"))

