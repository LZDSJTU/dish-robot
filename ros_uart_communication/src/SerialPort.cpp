//
// Created by luyifan on 18-4-8.
//

#include <ros_uart_communication/SerialPort.h>
#include <vector>
#include <boost/make_shared.hpp>

using namespace std;
using namespace boost;

namespace serial{
    SerialPort::SerialPort() {
        cout<<"SerialPort Object created!"<<endl;

        m_state = WAITING_FF;

        m_tempBuf.resize(1024, 0);
    }

    SerialPort::~SerialPort() {
        m_pios->stop();
        m_thread.join();
    }

    void SerialPort::start_a_read() {
//        cout<<"SerialPort::start_a_read called !!"<<endl;

        mutex::scoped_lock(m_serialMutex);

        //启动一次异步读
        m_pSerial->async_read_some(buffer(m_tempBuf), boost::bind(&SerialPort::readHandler,
                                                                  this,
                                                                  placeholders::error,
                                                                  placeholders::bytes_transferred
        ));

    }

    void SerialPort::start_a_write() {
        mutex::scoped_lock lock(m_serialMutex);
        cout<<"start a write!"<<endl;

        // 启动一次异步写
        async_write(*m_pSerial, buffer(*(m_writeQueue.front())),
                    bind(&SerialPort::writeHandler, this, placeholders::error));
    }

    void SerialPort::mainRun() {
        cout << "SerialPort mainThread STARTED!" << endl;

        // 初始化工作状态
        m_state = WAITING_FF;

        // 设置Header存储区的大小为4字节
        m_currentHeader.resize(3, 0);

        // 启动一次异步读
        start_a_read();

        // 开始跑io_service::run()
        m_pios->run();

        cout << "SerialPort mainThread EXITED!" << endl;
    }

    void SerialPort::readHandler(const system::error_code &ec, size_t bytesTransferred) {
//        cout<<"readhandler!!!"<<endl;
//        cout<<"bytesTransferred: \t"<<bytesTransferred<<endl;

        if(ec){
            //TODO: 报错
            cout<<"SerialPort read error!!"<<endl;
            return;
        }
//        for (size_t i = 0; i < bytesTransferred; i++) {
//            cout<<(int)(m_tempBuf.at(i))<<" ";
//        }
//        cout<<endl;

        /*处理每个字节*/
        for (size_t i = 0; i < bytesTransferred; i++) {
            /*拿出一个新的字节*/
            uint8_t byte = m_tempBuf.at(i);
//            cout<<m_tempBuf.at(i)<<" ";

            /*状态机*/
            switch (m_state){
                case WAITING_FF:/*如果新读到的字节是0xFF, 则转移状态至WAITING_FF2*/
                    if(byte == (uint8_t)0xFF){
                        m_state = WAITING_FF2;
                        // 启动超时定时器
                        m_ptimer.reset(new deadline_timer(*m_pios,
                                                          posix_time::milliseconds(40)));
                        m_ptimer->async_wait(bind(
                                &SerialPort::timeoutHandler,
                                this,
                                placeholders::error));
                    }
                    break;
                case WAITING_FF2:/*如果新读到的字节是0xFF, 则转移状态至READING_HEAD, 否则回到WAITING_FF*/
                    if(byte == (uint8_t)0xFF){
                        m_HeaderBytesRead = 0;
                        m_state = READING_HEAD;
                    } else{
                        m_state = WAITING_FF;
                    }

                    break;
                case READING_HEAD:
                    // 将新字节存入m_currentHeader
                    m_currentHeader[m_HeaderBytesRead] = byte;
                    m_HeaderBytesRead++;

                    if (HEADER_LEN == m_HeaderBytesRead)	// 如果3个字节都已经读出
                    {
                        /*读出数据报文的长度, 并将m_currentData的大小重设为该长度*/
                        uint16_t dataLen =
                                ((uint16_t)(m_currentHeader[1]) << 8) + m_currentHeader[2];
                        if (dataLen>0&&dataLen<18)
                        {
                            m_currentData.resize(dataLen, 0);
                            m_DataBytesRead = 0;
                            m_state = READING_DATA;
                        }
                        else {
                            m_state = WAITING_FF;
                        }
                    }

                    break;
                case READING_DATA:
                    /*将新字节存入m_currentData*/
                    m_currentData[m_DataBytesRead++] = byte ;
                    if(m_currentData.size() == m_DataBytesRead){// 如果所有字节都已经读出
                        m_state = READING_CHECKSUM;
                    }

                    break;
                case READING_CHECKSUM:
                    m_ptimer->cancel();
                    m_ptimer.reset();
                    /*计算校验和*/
                    uint32_t byteSum = 0;
                    for (size_t k=0; k<m_currentHeader.size(); k++)
                        byteSum += m_currentHeader.at(k);
                    for (size_t k=0; k<m_currentData.size(); k++)
                        byteSum += m_currentData.at(k);
//                    cout<<"bytesum is : "<<(uint8_t)(byteSum%256)<<endl;
                    if((uint8_t)(byteSum%256) == byte){
                        cout<<"A new datagram received!!"<<endl;
                        m_dataCallbackFunc(m_currentData, m_currentHeader[0]);
                    } else{
                        cout<<"checksum error!!"<<endl;
                    }

                    m_state = WAITING_FF;
                    break;

            }
        }
        start_a_read();
    }

    void SerialPort::writeHandler(const system::error_code &ec) {
        if(ec){
            // TODO: 报错
        }

        {
            mutex::scoped_lock lock(m_writeQueueMutex);
            m_writeQueue.pop();
            cout<<"have received!!"<<endl;
            if(m_writeQueue.empty() == false){
                start_a_write();
            }
        }
    }

    void SerialPort::timeoutHandler(const system::error_code &ec) {
        if (!ec)
        {
            cout << "Time Out !" << endl;
            m_state = WAITING_FF;
        }
    }

    void SerialPort::setSerialParams(const SerialParams &params) {
        m_serialParams = params;
    }

    void SerialPort::setTimeOut(int timeout) {
        m_timeOut = timeout;
    }

    bool SerialPort::startThread() {
        cout << "SerialPort::startThread() called!" << endl;

        // 创建io_service对象
        m_pios = make_shared<io_service>();

        try {
            // 创建一个serial_port对象, 替换掉原来的
            m_pSerial = make_shared<serial_port>(ref(*m_pios), m_serialParams.serialPort);
            cout<<"[startThread]m_serialParams.serialPort: "<<m_serialParams.serialPort<<endl;
            cout<<"[startThread]m_serialParams.baud_rate: "<<m_serialParams.baud_rate<<endl;

            // 设置串口通信参数
            // PS: 这里的强制转换不是什么好习惯... 我只是图省事
            m_pSerial->set_option(
                    serial_port::baud_rate(m_serialParams.baud_rate));
            m_pSerial->set_option(
                    serial_port::flow_control((serial_port::flow_control::type)m_serialParams.flow_control));
            m_pSerial->set_option(
                    serial_port::parity((serial_port::parity::type)m_serialParams.parity));
            m_pSerial->set_option(
                    serial_port::stop_bits((serial_port::stop_bits::type)m_serialParams.stop_bits));
            m_pSerial->set_option(serial_port::character_size(8));
        }
        catch (std::exception &e) {
            cout << "Failed to open serial port !" << endl;
            cout << "Error Info: " << e.what() << endl;
            return false;
        }

        try {
            // 创建线程
            m_thread = boost::thread(boost::bind(&SerialPort::mainRun, this));
        }
        catch (std::exception &e) {
            cout << "Failed to create thread !" << endl;
            cout << "Error Info: " << e.what() << endl;
            return false;
        }
        return true;
    }

    bool SerialPort::stopThread() {
        m_pios->stop();
        return true;
    }

    void SerialPort::setCallbackFunc(const function<void(ByteVector,int)> &func) {
        m_dataCallbackFunc = func;
    }

    bool SerialPort::writeRaw(const ByteVector &rawData) {
        mutex::scoped_lock lock(m_writeQueueMutex);	// 上锁

        bool writeIdle = m_writeQueue.empty();			// 检测当前队列是否为空
        pByteVector data(new ByteVector(rawData));
        m_writeQueue.push(data);						// 将数据拷贝一份, 并加入队列里去

        if (writeIdle) start_a_write();					// 如果没有在写数据, 则启动一次异步写过程

        return true;
    }
}