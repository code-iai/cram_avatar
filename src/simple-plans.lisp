(in-package :aia)

(defun pose-msg->transform (msg)
  (with-fields(position orientation) msg
    (cl-transforms:make-transform
     (with-fields(x y z) position
       (cl-transforms:make-3d-vector x y z))
     (with-fields(x y z w) orientation
       (cl-transforms:make-quaternion x y z w)))))


(defun relative-angle-to (goal pose-msg)
  (let ((diff-pose (cl-transforms:transform-point
                     (cl-transforms:transform-inv
                       (pose-msg->transform pose-msg))
                     goal)))
    (atan
      (cl-transforms:y diff-pose)
      (cl-transforms:x diff-pose))))
 
(defun calculate-angular-cmd (goal)
     (relative-angle-to goal (value *avatar-pose*)))


(def-cram-function move-to (goal &optional (distance-threshold 0.1))
  "Sends velocity commands until `goal' is reached."
 (let ((reached-fl (< (fl-funcall #'cl-transforms:v-dist
                                   (fl-funcall
                                    #'cl-transforms:translation
                                    (fl-funcall
                                     #'pose-msg->transform
                                     *avatar-pose*))
                                   goal)
                       distance-threshold)))
    (unwind-protect
         (pursue
           (wait-for reached-fl)
           (loop do
             (send-vel-cmd
               0 0 0 0 0
               (calculate-angular-cmd goal))
             (wait-duration 0.1)))
      (send-vel-cmd 0 0 0 0 0 0))))

    
