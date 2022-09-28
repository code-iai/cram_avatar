(defsystem cram-avatar-motion-designators
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
             (:file "motion-designators" :depends-on ("package"))))))

