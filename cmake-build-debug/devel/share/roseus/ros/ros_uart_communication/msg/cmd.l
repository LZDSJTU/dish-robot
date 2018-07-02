;; Auto-generated. Do not edit!


(when (boundp 'ros_uart_communication::cmd)
  (if (not (find-package "ROS_UART_COMMUNICATION"))
    (make-package "ROS_UART_COMMUNICATION"))
  (shadow 'cmd (find-package "ROS_UART_COMMUNICATION")))
(unless (find-package "ROS_UART_COMMUNICATION::CMD")
  (make-package "ROS_UART_COMMUNICATION::CMD"))

(in-package "ROS")
;;//! \htmlinclude cmd.msg.html


(defclass ros_uart_communication::cmd
  :super ros::object
  :slots (_data ))

(defmethod ros_uart_communication::cmd
  (:init
   (&key
    ((:data __data) (make-array 0 :initial-element 0 :element-type :char))
    )
   (send-super :init)
   (setq _data __data)
   self)
  (:data
   (&optional __data)
   (if __data (setq _data __data)) _data)
  (:serialization-length
   ()
   (+
    ;; uint8[] _data
    (* 1    (length _data)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint8[] _data
     (write-long (length _data) s)
     (princ _data s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint8[] _data
   (let ((n (sys::peek buf ptr- :integer))) (incf ptr- 4)
     (setq _data (make-array n :element-type :char))
     (replace _data buf :start2 ptr-) (incf ptr- n))
   ;;
   self)
  )

(setf (get ros_uart_communication::cmd :md5sum-) "f43a8e1b362b75baa741461b46adc7e0")
(setf (get ros_uart_communication::cmd :datatype-) "ros_uart_communication/cmd")
(setf (get ros_uart_communication::cmd :definition-)
      "#save the data which would send to the usart
uint8[] data

")



(provide :ros_uart_communication/cmd "f43a8e1b362b75baa741461b46adc7e0")


