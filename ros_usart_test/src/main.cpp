//
// Created by luyifan on 18-4-9.
//
#include <ros/ros.h>
#include <ros_uart_communication/cmd.h>
#include <iostream>
#include "geometry_msgs/Twist.h"

ros::Publisher pub;

int data_len = 4;

void cmdCallback(const geometry_msgs::Twist cmd_vel){
    uint8_t vel_x = (uint8_t)(100 * fabs(cmd_vel.linear.x));
    uint8_t vel_y = (uint8_t)(100 * fabs(cmd_vel.linear.y));
    uint8_t vel_angle = (uint8_t)(100 * fabs(cmd_vel.angular.z));

    ros_uart_communication::cmd cmd_msg;
    cmd_msg.data.resize(10, 0);
    uint8_t *data_ptr = cmd_msg.data.data();

    // head
    data_ptr[0] = data_ptr[1] = 0xff;
    data_ptr[2] = 0x02;
    data_ptr[3] = (uint8_t)(data_len>>8);
    data_ptr[4] = (uint8_t)(data_len & 0xff);
    // vel_x
    data_ptr[5] = vel_x;
    data_ptr[6] = vel_y;
    data_ptr[7] = vel_angle;
    data_ptr[8] = 0x00;
    if(cmd_vel.linear.x < 0){
        data_ptr[8] += 4;
    }
    if(cmd_vel.linear.y < 0){
        data_ptr[8] += 2;
    }
    if(cmd_vel.angular.z < 0){
        data_ptr[8] += 1;
    }

//    data_ptr[9] = data_ptr[8]+data_ptr[7]+data_ptr[6]+data_ptr[5]+data_ptr[4]+data_ptr[3]+data_ptr[2];

    data_ptr[9] = 0x00;

    //协议转换完成
    pub.publish(cmd_msg);

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

