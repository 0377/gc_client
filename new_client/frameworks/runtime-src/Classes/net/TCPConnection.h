#ifndef __TCPConnection_h__
#define __TCPConnection_h__
#include <iostream>
#include <thread>
#include <mutex>
#include "3rd/mongoose/mongoose.h"
#include "cocos2d.h"
#include "net/TCPManager.h"
class TCPConnection
{
public:
	TCPConnection();
	virtual ~TCPConnection();
	static TCPConnection*  createTCPConnection(mg_connection *nc);
	virtual bool init();
	void	start();
	void closed();
	void setIsDone(bool status);
	bool getIsDone();
	CC_SYNTHESIZE(TCPConnectionStatus, tcpConnectionStatus, TCPConnectionStatus);
	CC_SYNTHESIZE(mg_connection*, _mgConnection, MGConnection);
    CC_SYNTHESIZE(int, connectionID, ConnectionID);
private:
	bool _isDone;
	std::recursive_mutex					_mutex;
};
#endif
