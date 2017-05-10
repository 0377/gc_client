#pragma once

#ifndef __lua_cocos_ext_manual_h__
#define __lua_cocos_ext_manual_h__

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif

int register_all_my_cocos_ext_manual(lua_State* tolua_S);


#endif // __lua_cocos_ext_manual_h__
