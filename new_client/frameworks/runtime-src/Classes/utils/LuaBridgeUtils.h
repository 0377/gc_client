#pragma once
/**********************************************************************************************//**
 * \class	CryptoManager
 *
 * \brief	Manager for cryptoes.
 *
 * \date	2016/4/26
 **************************************************************************************************/
#include <iostream>
#include "cocos2d.h"
#include  "HLCustomRichText.h"
USING_NS_CC;
class LuaBridgeUtils
{
public:
	static std::string getMacString();
	static std::string crypto_encrypt_password(const std::string &public_key, const std::string  &password);
	static std::string md5File(const std::string &filePath);
	static std::string md5String(const std::string &string);
	static std::string getFilePathDirectory(const std::string &path);
	static bool decompress(const std::string &zip);
	static bool decompressAsync(const std::string &zip, int func);
	static void changeNodeToGray(Node *tmpNode);
	static void changeNodeToNormal(Node *tmpNode);
	static const char* getBytesDataFromFile(const std::string &path);
	//static std::string subUTF8String(std::string &src, int start, int length);
	static int64_t    getCharacterCountInUTF8String(const std::string& utf8);
	static std::string replaceUTF8String(std::string &src, int pos, std::string &targetSrc);
	static   ui::HLCustomRichText *     createHLCustomRichTextWithNode(const std::string &text, cocos2d::ui::Text *parameterTextNode, cocos2d::ui::HLCustomRichText::TextHorizontalAlignment hAlign = cocos2d::ui::HLCustomRichText::TextHorizontalAlignment::LEFT, cocos2d::ui::HLCustomRichText::TextVerticalAlignment vAlgin = cocos2d::ui::HLCustomRichText::TextVerticalAlignment::TOP);
	static void showMessage(const char* content, const char* title);
};
