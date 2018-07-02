
(cl:in-package :asdf)

(defsystem "ros_uart_communication-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "cmd" :depends-on ("_package_cmd"))
    (:file "_package_cmd" :depends-on ("_package"))
    (:file "feedback" :depends-on ("_package_feedback"))
    (:file "_package_feedback" :depends-on ("_package"))
  ))