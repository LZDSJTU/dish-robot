; Auto-generated. Do not edit!


(cl:in-package ros_uart_communication-msg)


;//! \htmlinclude cmd.msg.html

(cl:defclass <cmd> (roslisp-msg-protocol:ros-message)
  ((data
    :reader data
    :initarg :data
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 0 :element-type 'cl:fixnum :initial-element 0)))
)

(cl:defclass cmd (<cmd>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <cmd>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'cmd)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name ros_uart_communication-msg:<cmd> is deprecated: use ros_uart_communication-msg:cmd instead.")))

(cl:ensure-generic-function 'data-val :lambda-list '(m))
(cl:defmethod data-val ((m <cmd>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ros_uart_communication-msg:data-val is deprecated.  Use ros_uart_communication-msg:data instead.")
  (data m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <cmd>) ostream)
  "Serializes a message object of type '<cmd>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'data))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream))
   (cl:slot-value msg 'data))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <cmd>) istream)
  "Deserializes a message object of type '<cmd>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'data) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'data)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<cmd>)))
  "Returns string type for a message object of type '<cmd>"
  "ros_uart_communication/cmd")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'cmd)))
  "Returns string type for a message object of type 'cmd"
  "ros_uart_communication/cmd")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<cmd>)))
  "Returns md5sum for a message object of type '<cmd>"
  "f43a8e1b362b75baa741461b46adc7e0")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'cmd)))
  "Returns md5sum for a message object of type 'cmd"
  "f43a8e1b362b75baa741461b46adc7e0")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<cmd>)))
  "Returns full string definition for message of type '<cmd>"
  (cl:format cl:nil "#save the data which would send to the usart~%uint8[] data~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'cmd)))
  "Returns full string definition for message of type 'cmd"
  (cl:format cl:nil "#save the data which would send to the usart~%uint8[] data~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <cmd>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'data) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 1)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <cmd>))
  "Converts a ROS message object to a list"
  (cl:list 'cmd
    (cl:cons ':data (data msg))
))
