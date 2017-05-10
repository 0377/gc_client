//
//  HLEventCustom.hpp
//  RPGGame
//
//  Created by he on 22/1/16.
//
//

#ifndef HLEventCustom_hpp
#define HLEventCustom_hpp

#include <stdio.h>
#include "base/CCEventCustom.h"
class HLEventCustom:public cocos2d::EventCustom
{
    CC_SYNTHESIZE_RETAIN(Ref *, userObject, UserObject);
    HLEventCustom(const std::string& eventName);
    virtual ~HLEventCustom();
};
#endif /* HLEventCustom_hpp */
