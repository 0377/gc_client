#include "TCPConnection.h"
//#include "cocos2d.h"
#include <iostream>
USING_NS_CC;
TCPConnection::TCPConnection()
{

}
TCPConnection::~TCPConnection()
{
	//std::cout << "TCPConnection::~TCPConnection()" << std::endl;
   // CCLOG("TCPConnection::~TCPConnection()");
}
TCPConnection*  TCPConnection::createTCPConnection(mg_connection *nc)
{
	TCPConnection *tcpConnection = new TCPConnection();
	tcpConnection->setMGConnection(nc);
	return tcpConnection;
}
bool TCPConnection::init()
{
	return true;
}

void TCPConnection::start()
{
	//_isDone = false;
	setIsDone(false);
	mg_mgr *mgr = _mgConnection->mgr;
	//while (!_isDone)
	while (!getIsDone())
	{
		mg_mgr_poll(mgr, 50);
	}
}
void TCPConnection::closed()
{
	setTCPConnectionStatus(TCPConnectionStatus_Close);
	//_isDone = true;
	setIsDone(true);
}

void TCPConnection::setIsDone(bool status)
{
	std::lock_guard<std::recursive_mutex> lock(_mutex);
	_isDone = status;
}

bool TCPConnection::getIsDone()
{
	return _isDone;
}
