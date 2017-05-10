#ifndef __TCPManager_h__
#define __TCPManager_h__

#include "cocos2d.h"
#include <iostream>
#include <thread>
#include <mutex>
#include "../3rd/mongoose/mongoose.h"
#include "../model/TCPMsgOb.h"
#define kNotifiy_ReceiveOneFullTCPMsgNotify						"kNotifiy_ReceiveOneFullTCPMsgNotify"
#define kNotifiy_ReceiveConnectionStatusChangeNotify			"kNotifiy_ReceiveConnectionStatusChangeNotify"

/*
消息包头
*/
#define kMaxDataLength  8 * 1024
#pragma pack(1)
struct MsgHeader
{
	unsigned short							len;		// 消息总长度
	unsigned short							id;			// 消息id
};
struct MsgBuffer
{
	MsgHeader								msgHeader;
	unsigned char							msgData[kMaxDataLength];
};
typedef enum
{
	TCPConnectionStatus_Connecting	= 1,
	TCPConnectionStatus_Connected,
	TCPConnectionStatus_Close
}TCPConnectionStatus;
#pragma pack()
class TCPConnection;
class TCPManager
{
public:
	TCPManager();
	virtual ~TCPManager();
	//子线程中连接
	bool asynConnect(const std::string &addr, const std::string &port, int connectionID, float timeout);
	//断开连接
	bool disconnect(int connectionID);
	////connect 状态回调函数
	void dealWithReceiveHandler(struct mg_connection *nc, int ev, void *ev_data);
	//得到tcp连接状态
	TCPConnectionStatus getTCPConnectionStatus(int connectionID);
	//发送消息
	void sendTCPMsg(int connectionID, int msgID, const std::string &msgPbBufferStr);
	//解析数据
	void parseReciveBufferData(struct  mg_connection *nc);
	//关闭nc
	void doCloseMgConnection(struct mg_connection *nc);
private:
	//连接
	bool connect(const std::string &addr, const std::string &port, int connectId,float timeout);
	//连接被关闭时回调函数
	void callbackWhenConnectionIsClosed(mg_connection *nc);
    //发出收到消息通知
    void postReceiveOneFullMsgNotify(TCPMsgOb *msgOb);
	//发送状态变化通知
	void postConnectionStatusChangeNotify(TCPConnection *tcpConnection);
    void update(float dt);
	struct	mg_mgr _mgr;
	std::map <int, TCPConnection *>_connectionMaps;//记录链接状态
	bool   _isDone;
	std::recursive_mutex					_mutex_conn,_mutex_msg;//_mutex:连接锁 _mutex_msg 消息锁
    std::queue<TCPMsgOb*>					_msgQueue;    //消息队列
};

#endif
