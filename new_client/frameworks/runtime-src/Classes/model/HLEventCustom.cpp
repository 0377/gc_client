//
//  HLEventCustom.cpp
//  RPGGame
//
//  Created by he on 22/1/16.
//
//

#include "HLEventCustom.hpp"
HLEventCustom::HLEventCustom(const std::string& eventName)
:EventCustom(eventName),
userObject(nullptr)
{
}
HLEventCustom::~HLEventCustom()
{
    if (userObject)
    {
        userObject->autorelease();
    }
}