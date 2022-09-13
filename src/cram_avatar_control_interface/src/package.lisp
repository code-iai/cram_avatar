(defpackage :cram-avatar-control-interface
  (:nicknames :av-con)
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
