#ifndef __Network_Manager_H__
#define __Network_Manager_H__
#include "cocos2d.h"
class TCPManager;
class NetworkManager:public cocos2d::Node
{
public:
	CREATE_FUNC(NetworkManager);
	NetworkManager();
	~NetworkManager();
	virtual bool init();
	bool connectTCPSocket(const std::string &addr, const std::string &port, int connctionID,float timeout);
	//断开连接
	bool disconnect(int connectionID);
	//发送tcp消息
	void sendTCPMsg(int connectionID, int msgID, const std::string &msgPbBufferStr);
	void sendTCPMSgWithLength(int connectionID, int msgID, const char *pb, size_t length);
	//得到tcp连接状态
	int getTCPConnectionStatus(int connectionID);
private:
	TCPManager										  *tcpManager;
	//注册捕获通知
	void registerNotification();
};
#endif

