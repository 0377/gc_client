#include "TCPManager.h"
#include <thread>
USING_NS_CC;
#include "3rd/jsoncpp/myjson.h"
#include "utils/CustomUtils.h"
#include "model/TCPMsgOb.h"
#include "model/HLEventCustom.hpp"
#include "net/TCPConnection.h"
#define  _parsePerFrameNum  5

/************************************************************************/
/*  socket receive handle                                                                     */
/************************************************************************/
static void ev_handler(struct mg_connection *nc, int ev, void *p) 
{
	TCPManager *networkManager = static_cast<TCPManager *>(nc->mgr->user_data);
	networkManager->dealWithReceiveHandler(nc, ev, p);
}
TCPManager::TCPManager()
{
    mg_mgr_init(&_mgr, this);
    
    Director::getInstance()->getScheduler()->schedule([&](float dt){
        update(dt);
    }, this, 0, false, "update");
}
TCPManager::~TCPManager()
{
    mg_mgr_free(&_mgr);
    Director::getInstance()->getScheduler()->unscheduleAllForTarget(this);
//    Director::getInstance()->getScheduler()->unscheduleUpdate(this);
}
void TCPManager::update(float dt)
{
    int index = 0;
	while (!_msgQueue.empty())
    {
		TCPMsgOb *msg = NULL;
		{
			std::lock_guard<std::recursive_mutex> lock(_mutex_msg);
			msg = _msgQueue.front();
			_msgQueue.pop();
		}
		postReceiveOneFullMsgNotify(msg);
		delete msg;
		index++;
		if (index > _parsePerFrameNum)
		{
			break;
		}
    }
}
//发出收到消息通知
void TCPManager::postReceiveOneFullMsgNotify(TCPMsgOb *msgOb)
{
    TCPNormalMsgOb *normalMsgOb = dynamic_cast<TCPNormalMsgOb *>(msgOb);
    if (normalMsgOb)
    {
        EventDispatcher *eventDispatcher = Director::getInstance()->getEventDispatcher();
        HLEventCustom *event = new HLEventCustom(kNotifiy_ReceiveOneFullTCPMsgNotify);
        event->setUserData(normalMsgOb);
        eventDispatcher->dispatchEvent(event);
        event->autorelease();
        return;
    }
    TCPConnectionStatusMsgOb *connectionStatusOb = dynamic_cast<TCPConnectionStatusMsgOb *>(msgOb);
    if (connectionStatusOb)
    {
        EventDispatcher *eventDispatcher = Director::getInstance()->getEventDispatcher();
        HLEventCustom *event = new HLEventCustom(kNotifiy_ReceiveConnectionStatusChangeNotify);
        event->setUserData(connectionStatusOb);
        eventDispatcher->dispatchEvent(event);
        event->autorelease();
        return;
    }
}
void TCPManager::dealWithReceiveHandler(struct mg_connection *nc, int ev, void *ev_data)
{
    TCPConnection *tcpConnection = static_cast<TCPConnection *>(nc->user_data);
	switch (ev)
	{
		case MG_EV_CONNECT:
		{
			//_isDone = true;
			mg_set_timer(nc, 0);
			int connect_status = *(int *)ev_data;
            TCPConnectionStatus status = TCPConnectionStatus_Close;
			if (connect_status == 0)
			{
				// Success
				CCLOG("connect success!!!");
                status = TCPConnectionStatus_Connected;
				if (tcpConnection && tcpConnection->getTCPConnectionStatus() != status)
				{

					tcpConnection->setTCPConnectionStatus(status);
					postConnectionStatusChangeNotify(tcpConnection);
				}
			}
			else
			{
                status = TCPConnectionStatus_Close;
				// Error
				//CCLOG("connect() error: %s\n", strerror(connect_status));
			}

			break;
		}
		case MG_EV_SEND://Data has been written to a socket
		{
			//CCLOG("send success"); 
			break;
		}
        case MG_EV_POLL:
        {
            break;
        }
		case MG_EV_RECV://收到数据
		{
			//CCLOG("receive Data");
			parseReciveBufferData(nc);
			break;
		}
		case MG_EV_CLOSE://关闭
		{
			//CCLOG("connection closed");
            if(tcpConnection->getTCPConnectionStatus() != TCPConnectionStatus_Close)
            {
                 tcpConnection->setTCPConnectionStatus(TCPConnectionStatus_Close);
                postConnectionStatusChangeNotify(tcpConnection);
				callbackWhenConnectionIsClosed(nc);
            }
            
			break;
		}
		case MG_EV_TIMER://超时
		{
			//CCLOG("connection timeout");
			//doCloseMgConnection(nc);
			break; 
		}
		default:
			break;
	}
}

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <err.h>

#define CopyString(temp) (temp != NULL)? strdup(temp):NULL
std::string formatAddr(std::string server,std::string port) {
    struct addrinfo* res0;
    struct addrinfo* res;
    int n;
    if((n = getaddrinfo(server.c_str(), port.c_str(), NULL, &res0)) != 0)
    {
        printf("getaddrinfo failed %d", n);
        return "";
    }
    
    struct sockaddr_in6* addr6;
    struct sockaddr_in * addr;
    const char* pszTemp;
    
    std::string output;
    
    for(res = res0; res; res = res->ai_next)
    {
        char buf[32];
        if(res->ai_family == AF_INET6)
        {
            addr6 = (struct sockaddr_in6*)res->ai_addr;
            pszTemp = inet_ntop(AF_INET6, &addr6->sin6_addr, buf, sizeof(buf));
            output = cocos2d::StringUtils::format("[%s]:%s", pszTemp, port.c_str());
        }
        else
        {
            addr = (struct sockaddr_in*)res->ai_addr;
            pszTemp = inet_ntop(AF_INET, &addr->sin_addr, buf, sizeof(buf));
            output = cocos2d::StringUtils::format("%s:%s", pszTemp, port.c_str());
        }
        break;
    }
    
    freeaddrinfo(res0);

    return output;
}

#endif

//连接函数
bool TCPManager::connect(const std::string &addr, const std::string &port, int connectionID, float timeout)
{
	TCPConnection *tcpConnection = nullptr;
	{
		std::lock_guard<std::recursive_mutex> lock(_mutex_conn);
		if (_connectionMaps[connectionID] != nullptr) //如果已经存在，则直接返回
		{
			return true;
		}

		_isDone = false;
		std::string fullAddr = cocos2d::StringUtils::format("%s:%s", addr.c_str(), port.c_str());
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        fullAddr = formatAddr(addr,port);
#endif
		mg_connection *mgConnect = mg_connect(&_mgr, fullAddr.c_str(), ev_handler);

		if (mgConnect == NULL) //创建连接失败
		{
			return false;
		}

		mg_set_timer(mgConnect, mg_time() + timeout);
		tcpConnection = new TCPConnection();
		tcpConnection->setMGConnection(mgConnect);
		tcpConnection->setTCPConnectionStatus(TCPConnectionStatus_Connecting);//设置为正在连接状态
		tcpConnection->setConnectionID(connectionID);
		postConnectionStatusChangeNotify(tcpConnection);
		mgConnect->user_data = tcpConnection;
		_connectionMaps[connectionID] = tcpConnection;
	}

	tcpConnection->start();

	return true;
}

//断开连接
bool TCPManager::disconnect(int connectionID)
{
	std::lock_guard<std::recursive_mutex> lock(_mutex_conn);

	TCPConnection *tcpConnection = _connectionMaps[connectionID];
	if (tcpConnection)
	{
		doCloseMgConnection(tcpConnection->getMGConnection());
	}
	return true;
}
//子线程中连接
bool TCPManager::asynConnect(const std::string &addr, const std::string &port, int connectionID, float timeout)
{
	if (_connectionMaps[connectionID] != nullptr) //如果已经存在，则直接返回
	{
		return true;
	}
	std::thread *thread = new std::thread(&TCPManager::connect, this, addr, port, connectionID,timeout);
	thread->detach();
	delete thread;
	return true;
}
TCPConnectionStatus TCPManager::getTCPConnectionStatus(int connectionID)
{
	TCPConnection *tcpConnection = _connectionMaps[connectionID];
	if (tcpConnection)
	{
		return tcpConnection->getTCPConnectionStatus();
	}
	return TCPConnectionStatus_Close;
}
//发送消息
void TCPManager::sendTCPMsg(int connectionID, int msgID, const std::string &msgPbBufferStr)
{
	TCPConnection *tcpConnection = _connectionMaps[connectionID];
	if (tcpConnection)
	{
		std::string dataStr = msgPbBufferStr;
		MsgBuffer msgBuffer;
		msgBuffer.msgHeader.id = msgID;
		int dataLength = (int)dataStr.length();
		int len = sizeof(MsgHeader) + dataLength;
		msgBuffer.msgHeader.len = len;
		memset(&(msgBuffer.msgData), 0, dataLength);
		memcpy(&(msgBuffer.msgData), dataStr.c_str(), dataLength);
		mg_send(tcpConnection->getMGConnection(), (char *)&msgBuffer, len);
	}
	else
	{

	}
}
//解析消息
void TCPManager::parseReciveBufferData(struct  mg_connection *nc)
{
	std::lock_guard<std::recursive_mutex> lock(_mutex_msg);
	struct mbuf *io = &nc->recv_mbuf;
	size_t read_size = 0;
	size_t cur = 0;
	{
		read_size = io->len;
	}
	for (;;)
	{
		if (read_size - cur < sizeof(MsgHeader))
		{
			break;
		}
		//服务器传送过来的为MsgHeader
		MsgHeader* header = reinterpret_cast<MsgHeader*>(io->buf + cur);
		/*
		int maxBufferLength = kMaxDataLength + sizeof(header);
		if (header->len > maxBufferLength)
		{
			// 消息太长，应该错误了
			doCloseMgConnection(nc);
			return;
		}
		*/
		if (header->len > read_size - cur)
		{
			break;
		}
		int dataLength = header->len - sizeof(MsgHeader);
        
//        MsgBuffer *msgBuffer = new MsgBuffer();
//        msgBuffer->msgHeader = *header;
//        memcpy(&msgBuffer->msgData, header+1, dataLength);
//        
        std::string dataStr;
//        dataStr.assign((char *)msgBuffer->msgData,msgBuffer->msgHeader.len - sizeof(msgBuffer->msgHeader));
        dataStr.assign((char *)(header+1),dataLength);
        TCPNormalMsgOb *msgOb = new TCPNormalMsgOb();
        msgOb->setMsgID(header->id);
        msgOb->setMsgBufferDataStr(dataStr);
        {
			std::lock_guard<std::recursive_mutex> lock(_mutex_msg);
            _msgQueue.push(msgOb);
        }
        
		cur += header->len;
	}
	// Discard message from recv buffer	
	if (cur > 0)
	{
		std::lock_guard<std::recursive_mutex> lock(_mutex_msg);
		mbuf_remove(io,cur);
	}
}
//关闭nc
void TCPManager::doCloseMgConnection(struct mg_connection *nc)
{
	{
		std::lock_guard<std::recursive_mutex> lock(_mutex_conn);

		TCPConnection *tcpConnection = static_cast<TCPConnection *>(nc->user_data);
		tcpConnection->setIsDone(true);

		mg_close_conn(nc);
	}
}
//连接被关闭时回调函数
void TCPManager::callbackWhenConnectionIsClosed(mg_connection *nc)
{
	//从_connectionMap中关闭
	std::lock_guard<std::recursive_mutex> lock(_mutex_conn);
	TCPConnection *tcpConnection = static_cast<TCPConnection *>(nc->user_data);
	if (tcpConnection)
	{
//		if (tcpConnection->getTCPConnectionStatus() != TCPConnectionStatus_Close)//
		{
			tcpConnection->closed();
		}
		std::map <int, TCPConnection *>::iterator it = _connectionMaps.begin();
		for (; it != _connectionMaps.end(); it++)
		{
			if (it->second == tcpConnection)
			{
				_connectionMaps.erase(it);
				delete tcpConnection;
				break;
			}
		}
	}
}
//发送状态变化通知
void TCPManager::postConnectionStatusChangeNotify(TCPConnection *tcpConnection)
{
	std::lock_guard<std::recursive_mutex> lock(_mutex_msg);
    TCPConnectionStatusMsgOb  *statusInfo = new TCPConnectionStatusMsgOb();
	statusInfo->setConnectionID(tcpConnection->getConnectionID());
	statusInfo->setStatus(tcpConnection->getTCPConnectionStatus());
	_msgQueue.push(statusInfo);
}
