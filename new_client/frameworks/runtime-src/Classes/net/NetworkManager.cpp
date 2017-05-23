#include "net/NetworkManager.h"  
#include "model/HLEventCustom.hpp"
#include "model/TCPMsgOb.h"
#include "utils/LuaManager.h"
#include "net/TCPConnection.h"  
USING_NS_CC;
NetworkManager::NetworkManager()
{
	
}
NetworkManager::~NetworkManager()
{
	delete tcpManager;
	tcpManager = nullptr;
}
/************************************************************************/
/*  init                                                                     */
/************************************************************************/
bool NetworkManager::init()
{
	registerNotification();
	tcpManager = new TCPManager();
	return true; 
}

bool NetworkManager::connectTCPSocket(const std::string &addr, const std::string &port, int connctionID, float timeout)
{
	return tcpManager->asynConnect(addr, port,connctionID,timeout);
}
//断开连接
bool NetworkManager::disconnect(int connectionID)
{
	return tcpManager->disconnect(connectionID);
}
void NetworkManager::sendTCPMsg(int connectionID, int msgID, const std::string &msgPbBufferStr)
{
	tcpManager->sendTCPMsg(connectionID, msgID, msgPbBufferStr);
}
void NetworkManager::sendTCPMSgWithLength(int connectionID, int msgID, const char *pbData, size_t length)
{
	std::string msgPbBufferStr;
	msgPbBufferStr.assign((char *)pbData, length);
	tcpManager->sendTCPMsg(connectionID, msgID, (const std::string)msgPbBufferStr);
}
int NetworkManager::getTCPConnectionStatus(int connectionID)
{
	int status = tcpManager->getTCPConnectionStatus(connectionID);
	return status;
}
//注册捕获通知 
void NetworkManager::registerNotification()
{
	EventDispatcher *dispatcher = Director::getInstance()->getEventDispatcher();
	EventListener *receiveOneFullTCPListener = EventListenerCustom::create(kNotifiy_ReceiveOneFullTCPMsgNotify, [&](EventCustom* event){
		//CCLOG("ready send msg to lua!");
		HLEventCustom *customEvent = dynamic_cast<HLEventCustom *>(event);
		if (customEvent)
		{
			TCPNormalMsgOb *tcpMsgOb = (TCPNormalMsgOb *)(customEvent->getUserData());
			int msgID = tcpMsgOb->getMsgID();
			std::string dataStr = tcpMsgOb->getMsgBufferDataStr();
			lua_State *luaState = LuaManager::getInstance()->getluaState();
			//取得函数
			lua_getglobal(luaState, "GameManager");
			lua_getfield(luaState, -1, "getInstance");
			lua_pushvalue(luaState, -2);
			if (lua_pcall(luaState,1,1,0) == 0)//调用getInstance
			{
				lua_getfield(luaState, -1, "callbackWhenReceiveOneFullTCPMsg");
				lua_pushvalue(luaState, -2);
				lua_pushinteger(luaState, msgID);
				lua_pushlstring(luaState, dataStr.c_str(), dataStr.length());
				//lua_pushstring(luaState, dataStr.c_str());
				if (lua_pcall(luaState,3,0,0) == 0)
				{

				}
				else
				{
					const char* errstr = lua_tostring(luaState, -1);
					CCLOG("%s:%d(%s)", __FILE__, __LINE__, errstr);
					lua_pop(luaState, 1);
				}

			}
			else
			{
				const char* errstr = lua_tostring(luaState, -1);
				CCLOG("%s:%d(%s)", __FILE__, __LINE__, errstr);
				lua_pop(luaState, 1);
			}
		}
    });
	dispatcher->addEventListenerWithSceneGraphPriority(receiveOneFullTCPListener,this);
    //监听tcp网络状态变化通知
	EventListener *connectionStatusChangeListener = EventListenerCustom::create(kNotifiy_ReceiveConnectionStatusChangeNotify, [&](EventCustom *event){
		HLEventCustom *customEvent = static_cast<HLEventCustom *>(event);
		TCPConnectionStatusMsgOb *statusInfo = (TCPConnectionStatusMsgOb *)(customEvent->getUserData());
		int status = statusInfo->getStatus();
        int connectionID = statusInfo->getConnectionID();
		lua_State *luaState = LuaManager::getInstance()->getluaState();
		//取得函数
		lua_getglobal(luaState, "GameManager");
		lua_getfield(luaState, -1, "getInstance");
		lua_pushvalue(luaState, -2);
		if (lua_pcall(luaState, 1, 1, 0) == 0)//调用getInstance
		{
			lua_getfield(luaState, -1, "callbackWhenReceiveTCPConnectionStatusModiy");
			lua_pushvalue(luaState, -2);
			lua_pushinteger(luaState, connectionID);
            lua_pushinteger(luaState, status);
			if (lua_pcall(luaState, 3, 0, 0) == 0)
			{

			}
			else
			{
				const char* errstr = lua_tostring(luaState, -1);
				CCLOG("%s:%d(%s)", __FILE__, __LINE__, errstr);
				lua_pop(luaState, 1);
			}

		}
		else
		{	
			const char* errstr = lua_tostring(luaState, -1);
			CCLOG("%s:%d(%s)", __FILE__, __LINE__, errstr);
			lua_pop(luaState, 1);
		}
	});
    dispatcher->addEventListenerWithSceneGraphPriority(connectionStatusChangeListener, this);
	dispatcher->resumeEventListenersForTarget(this);
}
 
