//
// Created by luyifan on 18-4-9.
//
#include <ros/ros.h>
#include <ros_uart_communication/cmd.h>
#include <iostream>
#include "geometry_msgs/Twist.h"

ros::Publisher pub;

int data_len = 13;

void cmdCallback(const geometry_msgs::Twist cmd_vel){
    float vel_x = cmd_vel.linear.x;
    float vel_y = cmd_vel.linear.y;
    float vel_angle = cmd_vel.angular.z;
    uint8_t* vel_x_char = (uint8_t*)&vel_x;
    uint8_t* vel_y_char = (uint8_t*)&vel_y;
    uint8_t* vel_angle_char = (uint8_t*)&vel_angle;

    ros_uart_communication::cmd cmd_msg;
    cmd_msg.data.resize(18, 0);
    uint8_t *data_ptr = cmd_msg.data.data();

    // head
    data_ptr[0] = data_ptr[1] = 0xff;
    data_ptr[2] = 0x02;
    data_ptr[3] = (uint8_t)(data_len>>8);
    data_ptr[4] = (uint8_t)(data_len & 0xff);
    // vel_x
    data_ptr[5] = vel_x_char[0];
    data_ptr[6] = vel_x_char[1];
    data_ptr[7] = vel_x_char[2];
    data_ptr[8] = vel_x_char[3];
    // vel_y
    data_ptr[9] = vel_y_char[0];
    data_ptr[10] = vel_y_char[1];
    data_ptr[11] = vel_y_char[2];
    data_ptr[12] = vel_y_char[3];
    // vel_angle
    data_ptr[13] = vel_angle_char[0];
    data_ptr[14] = vel_angle_char[1];
    data_ptr[15] = vel_angle_char[2];
    data_ptr[16] = vel_angle_char[3];
    // dish_flag
    data_ptr[17] = 0x01;
    // check_sum
//    data_ptr[18] = 0x00;
//    for( int j = 0; j < 16; j++) {
//        data_ptr[18] += data_ptr[j + 2];
//    }
//    data_ptr[2] = (uint8_t)(data_len & 0xff);
//    // vel_x
//    data_ptr[3] = vel_x_char[0];
//    data_ptr[4] = vel_x_char[1];
//    data_ptr[5] = vel_x_char[2];
//    data_ptr[6] = vel_x_char[3];
//    // vel_y
//    data_ptr[7] = vel_y_char[0];
//    data_ptr[8] = vel_y_char[1];
//    data_ptr[9] = vel_y_char[2];
//    data_ptr[10] = vel_y_char[3];
//    // vel_angle
//    data_ptr[11] = vel_angle_char[0];
//    data_ptr[12] = vel_angle_char[1];
//    data_ptr[13] = vel_angle_char[2];
//    data_ptr[14] = vel_angle_char[3];
//    // dish_flag
//    data_ptr[15] = 0x01;
//    // check_sum
//    data_ptr[16] = 0x00;
//    for( int j = 0; j < data_len; j++) {
//        data_ptr[16] += data_ptr[j + 3];
//    }

    //协议转换完成
    pub.publish(cmd_msg);

//    float *xx = (float*)vel_x_char;
//    std::cout<<"transfer vel_x: "<<*xx<<std::endl;
//    float *yy = (float*)vel_y_char;
//    std::cout<<"transfer vel_y: "<<*yy<<std::endl;
//    float *zz = (float*)vel_angle_char;
//    std::cout<<"transfer vel_angle: "<<*zz<<std::endl;
    std::cout<<"cmd sent!!"<<std::endl;
}

int main(int argc , char **argv){
    ros::init(argc , argv , "serial_test");
    ros::NodeHandle nh;
    ros::Subscriber sub_cmd = nh.subscribe("/mobile_base/mobile_base_controller/cmd_vel",5,cmdCallback);
    pub = nh.advertise<ros_uart_communication::cmd>("/order", 1000);

    std::cout<<"ready to send cmd!!"<<std::endl;
    ros::spin();
    return 0;
}

