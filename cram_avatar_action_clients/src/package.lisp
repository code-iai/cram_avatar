(defpackage :cram-avatar-action-clients
  (:nicknames :av-accli)
  (:use :cpl
        :roslisp
        :cl-transforms
        :cram-designators
        :cram-process-modules
        :cram-language-designator-support)
  (:import-from :cram-prolog :def-fact-group :<- :lisp-fun)
  (:export
   :call-qna-action
   :init-sub
   :wait-for-sync-state
   :send-sync-state
   :*sync-state*
   :*sync-sub*
   )
  )
