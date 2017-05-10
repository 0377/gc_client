#pragma once
#ifndef __XMLPARSER_H__
#define __XMLPARSER_H__
#include "cocos2d.h"
#include "../../../cocos2d-x/cocos/editor-support/cocostudio/CocoStudio.h"

USING_NS_CC;
using namespace cocostudio;

class XMLParser : public Ref
{
public:
	XMLParser();
	~XMLParser();

	bool init();
	CREATE_FUNC(XMLParser);
	ValueMap parseXML(std::string filename, std::string index = "");
	static void updateArmatureGLProgram(Armature *arm, GLProgram *prm);
private:
	int size;
};

#endif

