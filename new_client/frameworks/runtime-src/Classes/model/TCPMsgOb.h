#ifndef __TCPMsgOb__H__
#define __TCPMsgOb__H__ 
#include "cocos2d.h"
class TCPMsgOb
{
public:
    virtual ~TCPMsgOb(){};
};
//sd
class TCPNormalMsgOb: public TCPMsgOb
{
public:
    virtual ~TCPNormalMsgOb(){};
	CC_SYNTHESIZE(std::string,msgBufferStr,MsgBufferDataStr);
	CC_SYNTHESIZE(int, msgID, MsgID);
private:

};
class TCPConnectionStatusMsgOb:public TCPMsgOb
{
public:
    virtual ~TCPConnectionStatusMsgOb(){};
    CC_SYNTHESIZE(int, connectionID, ConnectionID);
    CC_SYNTHESIZE(int, status, Status);
};
#endif /* defined(__RPGGame__LuaManager__) */
