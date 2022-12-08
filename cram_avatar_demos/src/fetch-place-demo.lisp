(in-package :av-demos)


(defvar *location* (make-3d-vector -289 -103 76) " location for placing the plate")
(defvar *object*)
(setq *object* (desig:an object (type milk) (name "SM_Object")))


(defun logging-scenario()
  (setf cram-tf:*tf-broadcasting-enabled* t)
  ;;(setf ccl::*is-logging-enabled* t)
  (print "Start")
  ;;(ccl::clear-detected-objects)
  ;;(detect-objects)
  (ccl::start-episode)
  (ccl::send-query-1-without-result "has_kinematics_file" "Client" "ID" "'URDF'")
  ;;(ccl::handle-detected-object *plate*)
  ;;(FetchPlace)
  (ccl::stop-episode)
  ;;(setf ccl::*episode-name* nil)
  (print "End"))

;; Task
(defun FetchPlace()
  (let ((?object-to-fetch *object*)
         (?placing_loc *location*))
    (top-level
      (with-process-modules-running (av-pm::avatar-navigation av-pm::avatar-manipulation)
        (exe:perform (desig:an action (type fetching-and-placing) (object ?object-to-fetch) (at ?placing_loc))))
      )
    )
  )