//
// Created by luyifan on 18-4-8.
//

#include <ros_uart_communication/SerialNode.h>
#include <stdio.h>
#include <string.h>
#include <sstream>
#include <boost/bind.hpp>
#include <geometry_msgs/Twist.h>

using namespace SerialNode;
using namespace boost;
Serial::Serial(ros::NodeHandle nh)
:nh(nh){
//    nh.param("serial_port", serial_port_, string("/dev/ttyUSB0"));
//    nh.param("buad_rate", baud_rate_, 921600);
//    115200
//    SerialParams serial_params(serial_port_, baud_rate_);
    SerialParams serial_params;

    position_sub = nh.subscribe("/order", 1000, &Serial::dataCallback, this);

    main_serial = make_shared<SerialPort>();
    main_serial->setSerialParams(serial_params);
    main_serial->setCallbackFunc(bind(&Serial::serialCall,this,_1,_2));
    main_serial->startThread();
}

Serial::~Serial() {nh.shutdown();}

void Serial::dumpBuffer(const char *buffer, int elements) {
    int j;
    printf(" [");
    for(j = 0; j < elements; j++){
        if(j > 0)
            printf(" ");
        printf("0x%02X", (unsigned int)(buffer[j]&0x0ff));
    }
    printf("]\n");
}

void Serial::serialCall(ByteVector current_data, int id) {
    ros::Publisher &serial_pub = pub_[id];
    std::cout<<"enter serialcall"<<std::endl;
    stringstream recv_name;
    if(!serial_pub){
        recv_name<<"/velocityFeedback";
        serial_pub = nh.advertise<geometry_msgs::Twist>(recv_name.str(), 100);
    }

    double vel_x, vel_y, vel_angle;
    if(current_data[3]==7){
        vel_x = -1.0 * (double)(current_data[0]) / 100.0;
        vel_y = -1.0 * (double)(current_data[1]) / 100.0;
        vel_angle = -1.0 * (double)(current_data[2]) / 100.0;
    }
    if(current_data[3]==6){
        vel_x = -1.0 * (double)(current_data[0]) / 100.0;
        vel_y = -1.0 * (double)(current_data[1]) / 100.0;
        vel_angle = (double)(current_data[2]) / 100.0;
    }
    if(current_data[3]==5){
        vel_x = -1.0 * (double)(current_data[0]) / 100.0;
        vel_y =  (double)(current_data[1]) / 100.0;
        vel_angle = -1.0 * (double)(current_data[2]) / 100.0;
    }
    if(current_data[3]==4){
        vel_x = -1.0 * (double)(current_data[0]) / 100.0;
        vel_y = (double)(current_data[1]) / 100.0;
        vel_angle = (double)(current_data[2]) / 100.0;
    }
    if(current_data[3]==3){
        vel_x = (double)(current_data[0]) / 100.0;
        vel_y = -1.0 * (double)(current_data[1]) / 100.0;
        vel_angle = -1.0 * (double)(current_data[2]) / 100.0;
    }
    if(current_data[3]==2){
        vel_x = (double)(current_data[0]) / 100.0;
        vel_y = -1.0 * (double)(current_data[1]) / 100.0;
        vel_angle = (double)(current_data[2]) / 100.0;
    }
    if(current_data[3]==1){
        vel_x = (double)(current_data[0]) / 100.0;
        vel_y = (double)(current_data[1]) / 100.0;
        vel_angle = -1.0 * (double)(current_data[2]) / 100.0;
    }
    if(current_data[3]==0){
        vel_x = (double)(current_data[0]) / 100.0;
        vel_y = (double)(current_data[1]) / 100.0;
        vel_angle = (double)(current_data[2]) / 100.0;
    }

    geometry_msgs::Twist pub_data;
    pub_data.linear.x = vel_x;
    pub_data.linear.y = vel_y;
    pub_data.angular.z = vel_angle;

    serial_pub.publish(pub_data);
}

void Serial::dataCallback(const ros_uart_communication::cmd::ConstPtr &ptr) {
    ByteVector current_data;
    size_t data_len = ptr->data.size();
    current_data.resize(data_len+1, 0);

    uint32_t check_sum = 0;

    for(size_t i = 0; i < data_len; i++){
        if(i>=2) check_sum += ptr->data[i];
        current_data[i] = ptr->data[i];
    }
    current_data[data_len] = (uint8_t)(check_sum%256); //set the last position as the checksum
    cout<<"Sending to MCU: ";
    for(size_t i = 0; i < current_data.size(); i++){
        cout<<(int)(current_data[i])<<"  ";
    }
    cout<<endl;
    main_serial->writeRaw(current_data);
}
