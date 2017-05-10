#include "LuaBridgeUtils.h"
#include "utils/CustomUtils.h"
#include "ui/UIHelper.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include <httpext.h>  
#include <windef.h>  
#include <nb30.h>  
#include <TCHAR.H>
#pragma comment(lib,"netapi32")
bool GetMAC(std::string &strMac)
{
	CHAR mac[20] = { 0 };
	NCB ncb;
	typedef struct _ASTAT_
	{
		ADAPTER_STATUS   adapt;
		NAME_BUFFER   NameBuff[30];
	}ASTAT, *PASTAT;

	ASTAT Adapter;

	typedef struct _LANA_ENUM
	{
		UCHAR   length;
		UCHAR   lana[MAX_LANA];
	}LANA_ENUM;

	LANA_ENUM lana_enum;
	UCHAR uRetCode;
	memset(&ncb, 0, sizeof(ncb));
	memset(&lana_enum, 0, sizeof(lana_enum));
	ncb.ncb_command = NCBENUM;
	ncb.ncb_buffer = (unsigned char *)&lana_enum;
	ncb.ncb_length = sizeof(LANA_ENUM);
	uRetCode = Netbios(&ncb);

	if (uRetCode != NRC_GOODRET)
		return false;

	for (int lana = 0; lana < lana_enum.length; lana++)
	{
		ncb.ncb_command = NCBRESET;
		ncb.ncb_lana_num = lana_enum.lana[lana];
		uRetCode = Netbios(&ncb);
		if (uRetCode == NRC_GOODRET)
			break;
	}

	if (uRetCode != NRC_GOODRET)
		return false;

	memset(&ncb, 0, sizeof(ncb));
	ncb.ncb_command = NCBASTAT;
	ncb.ncb_lana_num = lana_enum.lana[0];
	strcpy_s((char*)ncb.ncb_callname, sizeof("*"), "*");
	ncb.ncb_buffer = (unsigned char *)&Adapter;
	ncb.ncb_length = sizeof(Adapter);
	uRetCode = Netbios(&ncb);

	if (uRetCode != NRC_GOODRET)
		return false;

	sprintf(mac, ("%02X:%02X:%02X:%02X:%02X:%02X"),
		Adapter.adapt.adapter_address[0],
		Adapter.adapt.adapter_address[1],
		Adapter.adapt.adapter_address[2],
		Adapter.adapt.adapter_address[3],
		Adapter.adapt.adapter_address[4],
		Adapter.adapt.adapter_address[5]);

	strMac = mac;


	return true;
};
#endif
std::string LuaBridgeUtils::getMacString()
{
	std::string strMac = "";
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	if (GetMAC(strMac))
	{
		return strMac;
	}
#endif
	return strMac;
}


std::string LuaBridgeUtils::crypto_encrypt_password(const std::string &public_key, const std::string  &password)
{
	std::string pwd = CustomUtils::rsa_encrypt(CustomUtils::from_hex(public_key), password);
	return CustomUtils::to_hex(pwd);
}
std::string LuaBridgeUtils::md5File(const std::string &filePath)
{
	return CustomUtils::md5OfFile(filePath);
}
std::string LuaBridgeUtils::md5String(const std::string &string)
{
	return CustomUtils::md5OfString(string);
}
std::string LuaBridgeUtils::getFilePathDirectory(const std::string &path)
{
	return CustomUtils::getFilePathDirectory(path);
}
bool LuaBridgeUtils::decompress(const std::string &zip)
{
	return CustomUtils::decompress(zip);
}

bool LuaBridgeUtils::decompressAsync(const std::string &zip, int func){
	return CustomUtils::decompressAsync(zip, func);
}

void LuaBridgeUtils::changeNodeToGray(Node *node)
{
	return CustomUtils::changeToGrayColor(node);
}
void LuaBridgeUtils::changeNodeToNormal(Node *node)
{
	return CustomUtils::changeToNormalColor(node);
}
const char* LuaBridgeUtils::getBytesDataFromFile(const std::string &path)
{
	Data data = FileUtils::getInstance()->getDataFromFile(path);
	return (const char*)data.getBytes();
}
//std::string LuaBridgeUtils::subUTF8String(std::string &src, int start, int length)
//{
//	long strLen = StringUtils::getCharacterCountInUTF8String(src);
//	std::string cutWords = ui::Helper::getSubStringOfUTF8String(src, start, strLen - start);
//	return cutWords;
//}
int64_t LuaBridgeUtils::getCharacterCountInUTF8String(const std::string& utf8)
{
	int64_t strLen = StringUtils::getCharacterCountInUTF8String(utf8);
	return strLen;
}
std::string LuaBridgeUtils::replaceUTF8String(std::string &src, int pos, std::string &targetSrc)
{
	long strLen = StringUtils::getCharacterCountInUTF8String(src);
	std::string result;
	if (pos <= strLen)
	{
		std::string startStr = ui::Helper::getSubStringOfUTF8String(src, 0,pos -1);
		int start = pos;
		std::string endStr = ui::Helper::getSubStringOfUTF8String(src, start, strLen - start);
		result = StringUtils::format("%s%s%s", startStr.c_str(), targetSrc.c_str(), endStr.c_str());
	}
	return result;
}
ui::HLCustomRichText *     LuaBridgeUtils::createHLCustomRichTextWithNode(const std::string &text, cocos2d::ui::Text *parameterTextNode, cocos2d::ui::HLCustomRichText::TextHorizontalAlignment hAlign, cocos2d::ui::HLCustomRichText::TextVerticalAlignment vAlgin)
{
	return CustomUtils::createHLCustomRichTextWithNode(text, parameterTextNode, hAlign, vAlgin);
}

void LuaBridgeUtils::showMessage(const char* content, const char* title)
{
	cocos2d::MessageBox(content, title);
}