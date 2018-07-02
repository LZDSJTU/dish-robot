; Auto-generated. Do not edit!


(cl:in-package ros_uart_communication-msg)


;//! \htmlinclude feedback.msg.html

(cl:defclass <feedback> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (id
    :reader id
    :initarg :id
    :type cl:integer
    :initform 0)
   (data
    :reader data
    :initarg :data
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 0 :element-type 'cl:fixnum :initial-element 0)))
)

(cl:defclass feedback (<feedback>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <feedback>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'feedback)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name ros_uart_communication-msg:<feedback> is deprecated: use ros_uart_communication-msg:feedback instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <feedback>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ros_uart_communication-msg:header-val is deprecated.  Use ros_uart_communication-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'id-val :lambda-list '(m))
(cl:defmethod id-val ((m <feedback>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ros_uart_communication-msg:id-val is deprecated.  Use ros_uart_communication-msg:id instead.")
  (id m))

(cl:ensure-generic-function 'data-val :lambda-list '(m))
(cl:defmethod data-val ((m <feedback>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ros_uart_communication-msg:data-val is deprecated.  Use ros_uart_communication-msg:data instead.")
  (data m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <feedback>) ostream)
  "Serializes a message object of type '<feedback>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let* ((signed (cl:slot-value msg 'id)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'data))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream))
   (cl:slot-value msg 'data))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <feedback>) istream)
  "Deserializes a message object of type '<feedback>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'id) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
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
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<feedback>)))
  "Returns string type for a message object of type '<feedback>"
  "ros_uart_communication/feedback")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'feedback)))
  "Returns string type for a message object of type 'feedback"
  "ros_uart_communication/feedback")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<feedback>)))
  "Returns md5sum for a message object of type '<feedback>"
  "4b544d6e7db02fab7046a6d22993f0e9")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'feedback)))
  "Returns md5sum for a message object of type 'feedback"
  "4b544d6e7db02fab7046a6d22993f0e9")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<feedback>)))
  "Returns full string definition for message of type '<feedback>"
  (cl:format cl:nil "Header header~%int32 id~%uint8[] data~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'feedback)))
  "Returns full string definition for message of type 'feedback"
  (cl:format cl:nil "Header header~%int32 id~%uint8[] data~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <feedback>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'data) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 1)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <feedback>))
  "Converts a ROS message object to a list"
  (cl:list 'feedback
    (cl:cons ':header (header msg))
    (cl:cons ':id (id msg))
    (cl:cons ':data (data msg))
))
