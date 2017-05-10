#pragma once
/**********************************************************************************************//**
 * \class	CryptoManager
 *
 * \brief	Manager for cryptoes.
 *
 * \date	2016/4/26
 **************************************************************************************************/
#include <iostream>
#include "3rd/jsoncpp/myjson.h"
//md5
#define  MD5String(str)                  CustomUtils::md5OfString(str)
#define  MD5File(filePath)               CustomUtils::md5OfFile(filePath);
#include "cocos2d.h"
USING_NS_CC;
#include "utils/HLCustomRichText.h"
#include <regex>
typedef struct
{
	float fontSize;
	std::string fontName;
	Color3B   color;
}RichTextConfig;
class CustomUtils
{
public:
	/************************************************************************/
	/*  md5 string                                                                     */
	/************************************************************************/
	static  std::string                           md5OfString(const std::string &str);//md5 str
	static  std::string                           md5OfFile(const std::string &path);//md5 file
	/**********************************************************************************************/
	static void rsa_key(std::string& public_key, std::string& private_key);
	/*rsa encrypt*/
	static std::string rsa_encrypt(const std::string& public_key, const std::string& src);
	/*rsa decrypt*/
	static std::string rsa_decrypt(const std::string& private_key,const std::string &src);
	/*get file Dir path*/
	static std::string getFilePathDirectory(const std::string& path);
	/*decompress file*/
	static bool decompress(const std::string &zip);
	static bool decompressAsync(const std::string &zip,int func);

	/* json value */
	static Json::Value parseJsonStr(const std::string &str);
	/*post notify */
	static void postNotify(const std::string &nofiyName,std::string jsonStr);
	/*lk's method */
	static std::string to_hex(const std::string & src);
	static std::string from_hex(const std::string & src);
	/**node to gray**/
	static void changeToGrayColor(Node *tmpNode);
	/*node to normal*/
	static void changeToNormalColor(Node *tmpNode);
	/*rich text*/
	static   void                                   split(const std::string& src, const std::string& separator, std::vector<std::string>& dest);
	static   void                                  string_replace(std::string & strBig, const std::string & strsrc, const std::string &strdst);
	/*文字变色相关方法*/
	static   int                                      hex_char_value(char c);//将char 转化为10进制
	static   int                                      hex_to_decimal(const char* szHex, int len);//得到十进制
	static   Color3B                             getColor3BFromString(const std::string &colorStr);//得到颜色
	static   std::string                             stringWithPattern(const std::regex &regex, std::string &match);
	static   ui::HLCustomRichText *                                       createHLCustomRichTextWithNode(const std::string &text, cocos2d::ui::Text *parameterTextNode, cocos2d::ui::HLCustomRichText::TextHorizontalAlignment hAlign = cocos2d::ui::HLCustomRichText::TextHorizontalAlignment::LEFT, cocos2d::ui::HLCustomRichText::TextVerticalAlignment vAlgin = cocos2d::ui::HLCustomRichText::TextVerticalAlignment::TOP);
	static   ui::HLCustomRichText *                                       createHLCustomRichText(const std::string &desc, RichTextConfig &textConfig);
	static   ui::HLCustomRichElementText *                         createHLCustomRichElementText(const std::string &text, RichTextConfig &textConfig);
};


class TargetUncompress : public cocos2d::Ref
{
	enum Rets {
		RET_NONE,
		RET_PROGRESSING,
		RET_SUCCEED,
		RET_FAILED,
	};
protected:
	std::string m_zipFilePath;
	std::string m_dirPath;
	std::string m_info;
	int m_func;
	float	m_percent;
	int		m_ret;

	bool uncompress();
	void runUncompress();
	void runUncompressCallback(float);
public:
	TargetUncompress();
	~TargetUncompress(){}

	void init(std::string zipFilePath, std::string dirPath, int func);


	static TargetUncompress* create(std::string zipFilePath, std::string dirPath, int func){
		TargetUncompress* entry = new (std::nothrow) TargetUncompress();
		entry->init(zipFilePath, dirPath, func);
		entry->autorelease();
		entry->retain();
		return entry;
	}
};
