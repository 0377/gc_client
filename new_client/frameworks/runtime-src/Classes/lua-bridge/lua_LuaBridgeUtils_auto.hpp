#include "base/ccConfig.h"
#ifndef __LuaBridgeUtils_h__
#define __LuaBridgeUtils_h__

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif

int register_all_LuaBridgeUtils(lua_State* tolua_S);















#endif // __LuaBridgeUtils_h__
