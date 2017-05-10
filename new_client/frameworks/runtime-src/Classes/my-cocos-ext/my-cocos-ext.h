#pragma once
#ifndef _CC_EXT_H_
#define  _CC_EXT_H_

#ifdef __cplusplus
#define NS_MY_COCOS_EXT_BEGIN                     namespace  ccext {
#define NS_MY_COCOS_EXT_END                      }
#else
#define NS_CC_BEGIN 
#define NS_CC_END 
#define USING_NS_CC 
#define NS_CC
#endif 


#include "ExtendAction.h"


#endif //_CC_EXT_H_