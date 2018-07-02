;; Auto-generated. Do not edit!


(when (boundp 'ros_uart_communication::feedback)
  (if (not (find-package "ROS_UART_COMMUNICATION"))
    (make-package "ROS_UART_COMMUNICATION"))
  (shadow 'feedback (find-package "ROS_UART_COMMUNICATION")))
(unless (find-package "ROS_UART_COMMUNICATION::FEEDBACK")
  (make-package "ROS_UART_COMMUNICATION::FEEDBACK"))

(in-package "ROS")
;;//! \htmlinclude feedback.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass ros_uart_communication::feedback
  :super ros::object
  :slots (_header _id _data ))

(defmethod ros_uart_communication::feedback
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:id __id) 0)
    ((:data __data) (make-array 0 :initial-element 0 :element-type :char))
    )
   (send-super :init)
   (setq _header __header)
   (setq _id (round __id))
   (setq _data __data)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:id
   (&optional __id)
   (if __id (setq _id __id)) _id)
  (:data
   (&optional __data)
   (if __data (setq _data __data)) _data)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; int32 _id
    4
    ;; uint8[] _data
    (* 1    (length _data)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; int32 _id
       (write-long _id s)
     ;; uint8[] _data
     (write-long (length _data) s)
     (princ _data s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; int32 _id
     (setq _id (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint8[] _data
   (let ((n (sys::peek buf ptr- :integer))) (incf ptr- 4)
     (setq _data (make-array n :element-type :char))
     (replace _data buf :start2 ptr-) (incf ptr- n))
   ;;
   self)
  )

(setf (get ros_uart_communication::feedback :md5sum-) "4b544d6e7db02fab7046a6d22993f0e9")
(setf (get ros_uart_communication::feedback :datatype-) "ros_uart_communication/feedback")
(setf (get ros_uart_communication::feedback :definition-)
      "Header header
int32 id
uint8[] data

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
# 0: no frame
# 1: global frame
string frame_id

")



(provide :ros_uart_communication/feedback "4b544d6e7db02fab7046a6d22993f0e9")


