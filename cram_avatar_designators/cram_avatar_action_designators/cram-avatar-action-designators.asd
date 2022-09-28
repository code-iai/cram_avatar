(defsystem cram-avatar-action-designators
  :depends-on (:roslisp
   	       :cram-language
               :cram-designators 
   	        :cram-prolog
   	        :cram-language-designator-support
   	           )
  
  :components
  ((:module "src"
            :components
            ((:file "package")
	         (:file "action-designators" :depends-on ("package"))))))

