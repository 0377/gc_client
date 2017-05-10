#include "utils/CustomUtils.h"
#include "../3rd/rsa-euro/rsaeuro.h"
#include <stdlib.h>
#include "../3rd/md5/FileMD5.h"
#include "cocos2d.h"
#include "external/unzip/unzip.h"
#define BUFFER_SIZE    8192
#define MAX_FILENAME   512
#include "ui/CocosGUI.h"
#include "utils/HLCustomRichText.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
using namespace cocos2d::ui;
std::string CustomUtils::to_hex(const std::string & src)
{
	std::string ret;
	for (auto ch : src)
	{
		unsigned char c = static_cast<unsigned char>(ch) >> 4;
		if (c < 10)
		{
			ret += ('0' + c);
		}
		else
		{
			ret += 'a' + c - 10;
		}

		c = static_cast<unsigned char>(ch)& 0xf;
		if (c < 10)
		{
			ret += ('0' + c);
		}
		else
		{
			ret += 'a' + c - 10;
		}
	}

	return ret;
}

std::string CustomUtils::from_hex(const std::string & src)
{
	std::string ret;
	size_t sz = src.size();
	if (sz == 0 || (sz % 2) == 1)
		return ret;

	for (size_t i = 0; i < sz; i += 2)
	{
		char c = 0;
		if (src[i] >= 'a')
		{
			c |= (src[i] - 'a' + 10) << 4;
		}
		else
		{
			c |= (src[i] - '0') << 4;
		}

		if (src[i + 1] >= 'a')
		{
			c |= (src[i + 1] - 'a' + 10);
		}
		else
		{
			c |= (src[i + 1] - '0');
		}

		ret += c;
	}

	return ret;
}

std::string CustomUtils::md5OfString(const std::string &str)//md5 str
{
	return MD5(str).toString();
}
std::string CustomUtils::md5OfFile(const std::string &path)//md5 file
{
	Data data = FileUtils::getInstance()->getDataFromFile(path);
	std::string md5Result = MD5(data.getBytes(), data.getSize()).toString();
	return md5Result;
}
void CustomUtils::rsa_key(std::string& pubKeyStr, std::string& privateKeyStr)
{
	R_RSA_PUBLIC_KEY  PubKey;
	R_RSA_PRIVATE_KEY PriKey;
	R_RANDOM_STRUCT   RandSt;
	R_RSA_PROTO_KEY   ProKey;
	//生成密钥对
	R_RandomCreate(&RandSt);
	ProKey.bits = 512;//512 or 1024 or 2048
	ProKey.useFermat4 = 1;
	R_GeneratePEMKeys(&PubKey, &PriKey, &ProKey, &RandSt);
	//将pubkey privekey转化为base64
	int len = sizeof(R_RSA_PUBLIC_KEY);
	unsigned char *pubKey_buff;
	pubKey_buff = (unsigned char *)malloc(sizeof(R_RSA_PUBLIC_KEY) + 1);
	memcpy(pubKey_buff, &PubKey, sizeof(PubKey));

	pubKeyStr.assign((char *)pubKey_buff, len);
	//static std::string	pubKey64Str = base64_encode((const unsigned char *)pubKey_buff, len);
	free(pubKey_buff);
	unsigned char *privateKeyBuffer;
	privateKeyBuffer = (unsigned char *)malloc(sizeof(R_RSA_PRIVATE_KEY) + 1);
	int privLen = sizeof(R_RSA_PRIVATE_KEY);
	memcpy(privateKeyBuffer, &PriKey, sizeof(PriKey));

	privateKeyStr.assign((char *)privateKeyBuffer, privLen);
	free(privateKeyBuffer);
	/**---------Test------------------**/
	//std::string src = "asdasd财政项目支持的发射点法发";
	//char *TestBuffer = (char *)src.c_str();
	//公钥加密私钥解密
	//std::string encode = UtilsHelper::rsa_encrypt(pubKeyStr, src);
	//std::cout << "encode:" << encode << std::endl;
	//printf("encode:%s\n", encode.c_str());
	//std::string decode = UtilsHelper::rsa_decrypt(privateKeyStr, encode);
	//std::cout << "cc encode:" << decode << std::endl;
	//printf("decode:%s\n", decode.c_str());
	//std::string inputStr = "中国";
	//std::string xx =  UtilsHelper::md5OfString(inputStr);
	//printf("md5:%s\n", xx.c_str());
}
std::string  CustomUtils::rsa_encrypt(const std::string& pubKeyStr, const std::string &src)
{
	R_RSA_PUBLIC_KEY  PubKey;
	memcpy(&PubKey, pubKeyStr.c_str(), sizeof(R_RSA_PUBLIC_KEY));
	R_RANDOM_STRUCT   RandSt;
	//公钥加密私钥解密
	char *TestBuffer = (char *)src.c_str();
	unsigned char EncryptBuffer[256] = { 0 };
	unsigned int InputLen = sizeof(EncryptBuffer);
	R_RandomCreate(&RandSt);
    unsigned int   testBufferLength = strlen(TestBuffer);
	RSAPublicEncrypt(EncryptBuffer, &InputLen, (unsigned char*)TestBuffer,testBufferLength , &PubKey, &RandSt);
	std::string encryptStr;
	encryptStr.assign((char *)EncryptBuffer, sizeof(EncryptBuffer));
	return encryptStr;
}
//私钥解密
std::string CustomUtils::rsa_decrypt(const std::string& privateKeyStr, const std::string &encryptStr)
{
	R_RSA_PRIVATE_KEY PriKey;
	memcpy(&PriKey, privateKeyStr.c_str(), sizeof(R_RSA_PRIVATE_KEY));
	unsigned char DecryptBuffer[256] = { 0 };
	unsigned int OutputLen = sizeof(DecryptBuffer);
	int inputLength = encryptStr.size();
	RSAPrivateDecrypt(DecryptBuffer, &OutputLen, (unsigned char*)encryptStr.c_str(), (PriKey.bits + 7) / 8, &PriKey);
	std::string decryptStr;
	decryptStr.assign((char *)DecryptBuffer, sizeof(DecryptBuffer));
	return decryptStr;
}
//得到文件路径的文件夹
std::string CustomUtils::getFilePathDirectory(const std::string& path)
{
	size_t found = path.find_last_of("/\\");

	if (std::string::npos != found)
	{
		return path.substr(0, found);
	}
	else
	{
		return path;
	}
}
Json::Value CustomUtils::parseJsonStr(const std::string &str)
{
	Json::Reader reader;
	Json::Value value;
	if (!reader.parse(str, value))
	{
		return Json::Value::null;
	}
	//    value.jsonStr = HLPublicUtils::getJsonStringWithValue(value);
	return value;
}
bool CustomUtils::decompress(const std::string &zip)
{
	// Find root path for zip file
	size_t pos = zip.find_last_of("/\\");
	if (pos == std::string::npos)
	{
		CCLOG("CustomUtils : no root path specified for zip file %s\n", zip.c_str());
		return false;
	}
	const std::string rootPath = zip.substr(0, pos + 1);

	// Open the zip file
	unzFile zipfile = unzOpen(zip.c_str());
	if (!zipfile)
	{
		CCLOG("CustomUtils : can not open downloaded zip file %s\n", zip.c_str());
		return false;
	}

	// Get info about the zip file
	unz_global_info global_info;
	if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
	{
		CCLOG("CustomUtils : can not read file global info of %s\n", zip.c_str());
		unzClose(zipfile);
		return false;
	}

	// Buffer to hold data read from the zip file
	char readBuffer[BUFFER_SIZE];
	// Loop to extract all files.
	uLong i;
	for (i = 0; i < global_info.number_entry; ++i)
	{
		// Get info about current file.
		unz_file_info fileInfo;
		char fileName[MAX_FILENAME];
		if (unzGetCurrentFileInfo(zipfile,
			&fileInfo,
			fileName,
			MAX_FILENAME,
			NULL,
			0,
			NULL,
			0) != UNZ_OK)
		{
			CCLOG("CustomUtils : can not read compressed file info\n");
			unzClose(zipfile);
			return false;
		}
		const std::string fullPath = rootPath + fileName;

		// Check if this entry is a directory or a file.
		const size_t filenameLength = strlen(fileName);
		if (fileName[filenameLength - 1] == '/')
		{
			//There are not directory entry in some case.
			//So we need to create directory when decompressing file entry
			if (!FileUtils::getInstance()->createDirectory(CustomUtils::getFilePathDirectory(fullPath)))
			{
				// Failed to create directory
				CCLOG("CustomUtils : can not create directory %s\n", fullPath.c_str());
				unzClose(zipfile);
				return false;
			}
		}
		else
		{
			// Entry is a file, so extract it.
			// Open current file.
			// add code by hl
			//start
			std::string dir = CustomUtils::getFilePathDirectory(fullPath);
			if (!FileUtils::getInstance()->isDirectoryExist(dir)) {
				if (!FileUtils::getInstance()->createDirectory(dir)) {
					// Failed to create directory  
					CCLOG("AssetsManagerEx : can not create directory %s\n", fullPath.c_str());
					unzClose(zipfile);
					return false;
				}

			}
			//end
			if (unzOpenCurrentFile(zipfile) != UNZ_OK)
			{
				CCLOG("CustomUtils : can not extract file %s\n", fileName);
				unzClose(zipfile);
				return false;
			}

			// Create a file to store current file.
			FILE *out = fopen(fullPath.c_str(), "wb");
			if (!out)
			{
				CCLOG("CustomUtils : can not create decompress destination file %s\n", fullPath.c_str());
				unzCloseCurrentFile(zipfile);
				unzClose(zipfile);
				return false;
			}

			// Write current file content to destinate file.
			int error = UNZ_OK;
			do
			{
				error = unzReadCurrentFile(zipfile, readBuffer, BUFFER_SIZE);
				if (error < 0)
				{
					CCLOG("CustomUtils : can not read zip file %s, error code is %d\n", fileName, error);
					fclose(out);
					unzCloseCurrentFile(zipfile);
					unzClose(zipfile);
					return false;
				}

				if (error > 0)
				{
					fwrite(readBuffer, error, 1, out);
				}
			} while (error > 0);

			fclose(out);
		}

		unzCloseCurrentFile(zipfile);

		// Goto next entry listed in the zip file.
		if ((i + 1) < global_info.number_entry)
		{
			if (unzGoToNextFile(zipfile) != UNZ_OK)
			{
				CCLOG("CustomUtils : can not read next file for decompressing\n");
				unzClose(zipfile);
				return false;
			}
		}
	}
	unzClose(zipfile);
	return true;

}

bool CustomUtils::decompressAsync(const std::string &zip, int func){
	// Find root path for zip file
	size_t pos = zip.find_last_of("/\\");
	if (pos == std::string::npos)
	{
		CCLOG("CustomUtils : no root path specified for zip file %s\n", zip.c_str());
		return false;
	}
	const std::string rootPath = zip.substr(0, pos + 1);

	TargetUncompress::create(zip, rootPath, func);

	return true;
}

static GLProgramState *glProgramState_Gray = nullptr;
void CustomUtils::changeToGrayColor(Node *tmpNode)
{
	if (!glProgramState_Gray)
	{
		/*
		string fsh = "#ifdef GL_ES\n \
		precision mediump float;\n\
		#endif\n\
		\n\
		varying vec4 v_fragmentColor;\n\
		varying vec2 v_texCoord;\n\
		\n\
		void main(void)\n\
		{\n\
		vec4 c = texture2D(CC_Texture0, v_texCoord);\n\
		gl_FragColor.xyz = vec3(0.299*c.r + 0.587*c.g + 0.114*c.b);\n\
		gl_FragColor.w = c.w;\n\
		}";
		auto glprogram = GLProgram::createWithByteArrays(ccPositionTextureColor_noMVP_vert, fsh.c_str());
		glProgramState_Gray = GLProgramState::getOrCreateWithGLProgram(glprogram);
		*/
		glProgramState_Gray = GLProgramState::getOrCreateWithGLProgramName(GLProgram::SHADER_NAME_POSITION_GRAYSCALE);
	}
	Widget *widget = dynamic_cast<Widget *>(tmpNode);
	if (widget)
	{
		Button *btn = dynamic_cast<Button *>(widget);
		if (btn)
		{
			widget->setBright(false);
		}
		ImageView *imageView = dynamic_cast<ImageView *>(widget);
		if (imageView)
		{
			cocos2d::ui::Scale9Sprite *temp9Sprite = static_cast<cocos2d::ui::Scale9Sprite *>(imageView->getVirtualRenderer());
			temp9Sprite->setCascadeOpacityEnabled(true);
			temp9Sprite->setState(cocos2d::ui::Scale9Sprite::State::GRAY);
		}
	}
	else
	{
		tmpNode->setGLProgramState(glProgramState_Gray);
	}
	for (auto child : tmpNode->getChildren())
	{
		CustomUtils::changeToGrayColor(child);
	}
}
static GLProgramState *glProgramState_Normal = nullptr;
void CustomUtils::changeToNormalColor(Node *tmpNode)
{
	if (!glProgramState_Normal)
	{
		/*
		std::string fsh = "\
		#ifdef GL_ES\n\
		precision mediump float;\n\
		#endif\n\
		\n\
		varying vec4 v_fragmentColor;\n\
		varying vec2 v_texCoord;\n\
		\n\
		void main(void)\n\
		{\n\
		gl_FragColor = texture2D(CC_Texture0, v_texCoord);\n\
		}\n\
		";
		*/
		//     GLProgramState  *glState = GLProgramState::getOrCreateWithGLProgramName(GLProgram::SHADER_NAME_POSITION_TEXTURE_COLOR_NO_MVP);//normal
		//     GLProgramState *glState = GLProgramState::getOrCreateWithGLProgramName(GLProgram::SHADER_NAME_POSITION_GRAYSCALE);//gray
		/*
		auto fragSource = fileUtiles->getStringFromFile(fragmentFullPath);
		auto glprogram = GLProgram::createWithByteArrays(ccPositionTextureColor_noMVP_vert,fsh.c_str());

		glProgramState_Normal = GLProgramState::getOrCreateWithGLProgram(glprogram);
		*/
		glProgramState_Normal = GLProgramState::getOrCreateWithGLProgramName(GLProgram::SHADER_NAME_POSITION_TEXTURE_COLOR_NO_MVP);
	}
	Widget *widget = dynamic_cast<cocos2d::ui::Widget *>(tmpNode);
	if (widget)
	{
		Button *btn = dynamic_cast<Button *>(widget);
		if (btn)
		{
			widget->setBright(true);
		}
		ImageView *imageView = dynamic_cast<ImageView *>(widget);
		if (imageView)
		{
			cocos2d::ui::Scale9Sprite *temp9Sprite = static_cast<cocos2d::ui::Scale9Sprite *>(imageView->getVirtualRenderer());
			temp9Sprite->setState(cocos2d::ui::Scale9Sprite::State::NORMAL);
		}
	}
	else
	{
		tmpNode->setGLProgramState(glProgramState_Normal);
	}
	for (auto child : tmpNode->getChildren())
	{
		CustomUtils::changeToNormalColor(child);
	}
}

//按分隔符各个
void CustomUtils::split(const std::string& src, const std::string& separator, std::vector<std::string>& dest)
{
	string str = src;
	string substring;
	string::size_type start = 0, index;

	do
	{
		index = str.find_first_of(separator, start);
		if (index != string::npos)
		{
			substring = str.substr(start, index - start);
			dest.push_back(substring);
			start = str.find_first_not_of(separator, index);
			if (start == string::npos)
				return;
		}
	} while (index != string::npos);

	//the last token
	substring = str.substr(start);
	dest.push_back(substring);
}
void CustomUtils::string_replace(string & strBig, const string & strsrc, const string &strdst)
{
	string::size_type pos = 0;
	string::size_type srclen = strsrc.size();
	string::size_type dstlen = strdst.size();
	while ((pos = strBig.find(strsrc, pos)) != string::npos)
	{
		strBig.replace(pos, srclen, strdst);
		pos += dstlen;
	}
}


#pragma mark color
int CustomUtils::hex_to_decimal(const char* szHex, int len)////得到十进制
{
	int result = 0;
	for (int i = 0; i < len; i++)
	{
		result += (int)pow((float)16, (int)len - i - 1) * CustomUtils::hex_char_value(szHex[i]);
	}
	return result;
}

int  CustomUtils::hex_char_value(char c)//将char 转化为10进制
{
	if (c >= '0' && c <= '9')
		return c - '0';
	else if (c >= 'a' && c <= 'f')
		return (c - 'a' + 10);
	else if (c >= 'A' && c <= 'F')
		return (c - 'A' + 10);
	assert(0);
	return 0;
}
Color3B CustomUtils::getColor3BFromString(const std::string &colorStr)//得到颜色
{
	Color3B c3b;
	colorStr.size();
	c3b.r = CustomUtils::hex_to_decimal(colorStr.substr(0, 2).c_str(), 2);
	c3b.g = CustomUtils::hex_to_decimal(colorStr.substr(2, 2).c_str(), 2);
	c3b.b = CustomUtils::hex_to_decimal(colorStr.substr(4, 2).c_str(), 2);
	return c3b;
}

//getString
std::string CustomUtils::stringWithPattern(const std::regex &regex, std::string &match)
{
	std::sregex_iterator next(match.begin(), match.end(), regex);
	const std::sregex_iterator end;  //需要注意一下这里
	Color3B color;
	//得到颜色
	std::string resultStr = "";
	if (next != end)
	{
		std::smatch match = *next;
		resultStr = match[1];
	}
	//colorString:<color>FFEEFF</color>
	return resultStr;
}
ui::HLCustomRichElementText*    CustomUtils::createHLCustomRichElementText(const std::string &text, RichTextConfig &textConfig)
{
	ui::HLCustomRichElementText *item = ui::HLCustomRichElementText::create(12, textConfig.color, 255, text.c_str(), textConfig.fontName.c_str(), textConfig.fontSize);
	return item;
}

cocos2d::ui::HLCustomRichText*  CustomUtils::createHLCustomRichText(const std::string &descStr, RichTextConfig &textConfig)
{
	//        std::string subStr = descStr;
	if (descStr == "")
	{
		//           descStr = "流浪剑\n客燃烧自己的灵n魂，\n对目标周围敌人造成<p><color>abcdef</color><key>500</key><underline>ABABAC#5</underline></p>点伤害，并眩晕<p><key>2</key><color>325633</color></p>秒，同时使所有敌人造成虚无状态，虚无状态下敌人防御降低<p><key>50%</key><color>FF0000</color></p>，生命上限降低<p><key>50%</key><color>FF0000</color></p>，怒气值降低至<p><key>50%</key><color>FF0000</color></p>，<p><key>10</key><color>FF0000</color></p>分钟内无法使用药水，<p><key>50</key><color>FF0000</color></p>分钟内无法使用技能";
	}

	const std::regex pattern("<p>([\\s\\S]*?)</p>");
	const std::sregex_iterator end;  //需要注意一下这里
	cocos2d::ui::HLCustomRichText *richText = ui::HLCustomRichText::create();
	std::string showStr = "";
	size_t startIndex = 0;
	//    int endIndex = 0;
	try
	{
		std::sregex_iterator i(descStr.begin(), descStr.end(), pattern);
		while (i != end)
		{
			std::smatch match = *i;
			std::string stringConfig = match[0];
			//得到start 到stringconfig需要显示的字符串
			size_t found = descStr.find(stringConfig, startIndex);
			if (found != std::string::npos)
			{
				//"对目标周围敌人造成"
				std::string preSubStr = descStr.substr(startIndex, found - startIndex);
				startIndex = found + stringConfig.length();
				showStr += preSubStr;
				ui::HLCustomRichElementText *preItem = CustomUtils::createHLCustomRichElementText(preSubStr, textConfig);
				richText->pushBackElement(preItem);
			}

			std::string valueStr = match[1];
			const std::regex colorRegex("<color>([\\s\\S]*?)</color>");
			std::string colorStr = CustomUtils::stringWithPattern(colorRegex, stringConfig);
			//得到颜色
			RichTextConfig tempTextConfig = textConfig;

			if (colorStr != "")
			{
				std::string colorStr = CustomUtils::stringWithPattern(colorRegex, stringConfig);
				tempTextConfig.color = CustomUtils::getColor3BFromString(colorStr);
			}
			//得到对应文本
			const std::regex textRegex("<key>([\\s\\S]*?)</key>");
			std::string tempShowStr = CustomUtils::stringWithPattern(textRegex, stringConfig);
			ui::HLCustomRichElementText *tempItem = CustomUtils::createHLCustomRichElementText(tempShowStr, tempTextConfig);
			//判断是否有下划线
			const std::regex underlineRegex("<underline>([\\s\\S]*?)</underline>");
			std::string unlineConfig = CustomUtils::stringWithPattern(underlineRegex, stringConfig);
			if (unlineConfig != "")
			{
				std::vector<std::string> unlineConfigVec;
				CustomUtils::split(unlineConfig, "#", unlineConfigVec);
				if (unlineConfigVec.size() == 2)
				{
					Color3B unlineColor = CustomUtils::getColor3BFromString(unlineConfigVec.at(0));
					float  unlineSize = atoi(unlineConfigVec.at(1).c_str());
					tempItem->enableLinkLine(Color4B(unlineColor.r, unlineColor.g, unlineColor.b, 255), unlineSize);
				}

			}
			richText->pushBackElement(tempItem);

			showStr += tempShowStr;
			i++;
		}
		std::string lastSubStr = descStr.substr(startIndex);
		showStr += lastSubStr;
		ui::HLCustomRichElementText *lastItem = CustomUtils::createHLCustomRichElementText(lastSubStr, textConfig);
		richText->pushBackElement(lastItem);
	}
	catch (std::regex_error& e)
	{
		// Syntax error in the regular expression
		CCLOG("%u", e.code());
	}
	richText->setShowTextStr(showStr);
	richText->setAnchorPoint(Vec2(0, 1));
	return richText;
}
ui::HLCustomRichText* CustomUtils::createHLCustomRichTextWithNode(const std::string &text, cocos2d::ui::Text *parameterTextNode, HLCustomRichText::TextHorizontalAlignment hAlign, HLCustomRichText::TextVerticalAlignment vAlgin)
{
	RichTextConfig descTextConfig;
	std::string fontName = parameterTextNode->getFontName();
	if (fontName == "")
	{
		fontName = "Arial";
	}
	descTextConfig.fontName = fontName;
	descTextConfig.fontSize = parameterTextNode->getFontSize();
	Color4B textColor = parameterTextNode->getTextColor();
	descTextConfig.color.r = textColor.r;
	descTextConfig.color.g = textColor.g;
	descTextConfig.color.b = textColor.b;
	//显示英雄描述
	std::string descRichNodeName = parameterTextNode->getName() + "_RichNode";
	//    Node *prevRichNode = parameterTextNode->getParent() ->getChildByName(descRichNodeName);
	//    if (prevRichNode)
	//    {
	//        prevRichNode->removeFromParent();
	//    }
	HLCustomRichText *desRichText = CustomUtils::createHLCustomRichText(text, descTextConfig);
	if (parameterTextNode->isShadowEnabled())
	{
		desRichText->enableShadow(parameterTextNode->getShadowColor(), parameterTextNode->getShadowOffset(), parameterTextNode->getShadowBlurRadius());
	}
	desRichText->setVisible(parameterTextNode->isVisible());
	parameterTextNode->setVisible(false);
	desRichText->setContentSize(parameterTextNode->getContentSize());
	desRichText->setInertiaScrollEnabled(true);
	desRichText->setAnchorPoint(parameterTextNode->getAnchorPoint());
	desRichText->setPosition(parameterTextNode->getPosition());
	desRichText->setName(descRichNodeName);
	desRichText->setTextHorizontalAlign(hAlign);
	desRichText->setTextVerticalAlign(vAlgin);
	desRichText->setAnchorPoint(parameterTextNode->getAnchorPoint());
	//    parameterTextNode->getParent()->addChild(desRichText,parameterTextNode->getZOrder()+1);
	return desRichText;
}
TargetUncompress::TargetUncompress()
	: m_percent(0)
	, m_ret(RET_NONE)
	, m_func(0)
{

}

void TargetUncompress::init(string zipFilePath, string dirPath, int func){
	m_zipFilePath = zipFilePath;
	m_dirPath = dirPath;
	m_func = func;


	m_ret = RET_PROGRESSING;
	auto t = std::thread(std::bind(&TargetUncompress::runUncompress, this));
	t.detach();

	Director::getInstance()->getScheduler()->schedule(CC_SCHEDULE_SELECTOR(TargetUncompress::runUncompressCallback), this, 0.1, false);

}

bool TargetUncompress::uncompress(){
	// Open the zip file
	string outFileName = m_zipFilePath;
	unzFile zipfile = unzOpen(outFileName.c_str());
	if (!zipfile)
	{
		char str[1024];
		sprintf(str, "can not open downloaded zip file %s", outFileName.c_str());
		m_info = str;
		CCLOG("can not open downloaded zip file %s", outFileName.c_str());
		return false;
	}


	// Get info about the zip file
	unz_global_info global_info;
	if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
	{
		char str[1024];
		sprintf(str, "can not read file global info of %s", outFileName.c_str());
		m_info = str;
		CCLOG("can not read file global info of %s", outFileName.c_str());
		unzClose(zipfile);
		return false;
	}

	// Buffer to hold data read from the zip file
	char readBuffer[BUFFER_SIZE];

	CCLOG("start uncompressing");

	// Loop to extract all files.


	uLong i;
	for (i = 0; i < global_info.number_entry; ++i)
	{
		m_percent = (i + 1) / (float)global_info.number_entry;
		// Get info about current file.
		unz_file_info fileInfo;
		char fileName[MAX_FILENAME];
		if (unzGetCurrentFileInfo(zipfile,
			&fileInfo,
			fileName,
			MAX_FILENAME,
			nullptr,
			0,
			nullptr,
			0) != UNZ_OK)
		{
			CCLOG("can not read file info");
			m_info = "can not read file info";
			unzClose(zipfile);
			return false;
		}

		const string fullPath = m_dirPath + fileName;

		// Check if this entry is a directory or a file.
		const size_t filenameLength = strlen(fileName);
		if (fileName[filenameLength - 1] == '/')
		{
			// Entry is a direcotry, so create it.
			// If the directory exists, it will failed scilently.
			if (!FileUtils::getInstance()->createDirectory(fullPath.c_str()))
			{
				CCLOG("can not create directory %s", fullPath.c_str());
				char str[1024];
				sprintf(str, "can not create directory %s", fullPath.c_str());
				m_info = str;
				unzClose(zipfile);
				return false;
			}
		}
		else
		{
			//There are not directory entry in some case.
			//So we need to test whether the file directory exists when uncompressing file entry
			//, if does not exist then create directory
			const string fileNameStr(fileName);

			size_t startIndex = 0;

			size_t index = fileNameStr.find("/", startIndex);

			while (index != std::string::npos)
			{
				const string dir = m_dirPath + fileNameStr.substr(0, index);

				FILE *out = fopen(dir.c_str(), "r");

				if (!out)
				{
					if (!FileUtils::getInstance()->createDirectory(dir.c_str()))
					{
						CCLOG("can not create directory %s", dir.c_str());
						char str[1024];
						sprintf(str, "can not create directory %s", dir.c_str());
						m_info = str;
						unzClose(zipfile);
						return false;
					}
					else
					{
						//CCLOG("create directory %s", dir.c_str());
					}
				}
				else
				{
					fclose(out);
				}

				startIndex = index + 1;

				index = fileNameStr.find("/", startIndex);

			}



			// Entry is a file, so extract it.

			// Open current file.
			if (unzOpenCurrentFile(zipfile) != UNZ_OK)
			{
				char str[1024];
				sprintf(str, "can not open file %s", fileName);
				m_info = str;
				CCLOG("can not open file %s", fileName);
				unzClose(zipfile);
				return false;
			}

			// Create a file to store current file.
			FILE *out = fopen(fullPath.c_str(), "wb");
//			if (!out)
//			{
//				char str[1024];
//				sprintf(str, "can not open destination file %s", fullPath.c_str());
//				m_info = str;
//				CCLOG("can not open destination file %s", fullPath.c_str());
//				unzCloseCurrentFile(zipfile);
//				unzClose(zipfile);
//				return false;
//			}

			// 这么修改的原因是：playBackgroundMusic播放的音乐没有提供从内存释放的方法，文件在内存中，就无法被覆盖，会导致失败，所以改成如此，以忽略此类情况
			if (!out)
			{
				char str[1024];
				CCLOG("[CustomUtils] can not open destination file %s", fullPath.c_str());
				continue;
			}

			// Write current file content to destinate file.
			int error = UNZ_OK;
			do
			{
				error = unzReadCurrentFile(zipfile, readBuffer, BUFFER_SIZE);
				if (error < 0)
				{
					char str[1024];
					sprintf(str, "can not read zip file %s, error code is %d", fileName, error);
					m_info = str;
					CCLOG("can not read zip file %s, error code is %d", fileName, error);
					unzCloseCurrentFile(zipfile);
					unzClose(zipfile);
					return false;
				}

				if (error > 0)
				{
					fwrite(readBuffer, error, 1, out);
				}
			} while (error > 0);

			fclose(out);
		}

		unzCloseCurrentFile(zipfile);

		// Goto next entry listed in the zip file.
		if ((i + 1) < global_info.number_entry)
		{
			if (unzGoToNextFile(zipfile) != UNZ_OK)
			{
				m_info = "can not read next file";
				unzClose(zipfile);
				return false;
			}
		}
	}

	CCLOG("end uncompressing");
	unzClose(zipfile);

	return true;
}

void TargetUncompress::runUncompress(){
	int ret = uncompress();

	m_ret = ret ? RET_SUCCEED : RET_FAILED;
}

void TargetUncompress::runUncompressCallback(float dt){
	if (m_func != 0){
#if CC_ENABLE_SCRIPT_BINDING
		auto*_stack = cocos2d::LuaEngine::getInstance()->getLuaStack();
		int count = 0;
		switch (m_ret){
		case RET_NONE:return;
		case RET_PROGRESSING:
			count = 2;
			_stack->pushString("progressing");
			_stack->pushFloat(m_percent);
			break;
		case RET_SUCCEED:
			count = 1;
			_stack->pushString("succeed");
                CCLOG("m_zipFilePath:%s",m_zipFilePath.c_str());
			break;
		case RET_FAILED:
			count = 2;
			_stack->pushString("failed");
			_stack->pushString(m_info.c_str());
			break;
		}


		int ret = _stack->executeFunctionByHandler(m_func, count);
		_stack->clean();
#endif
	}
	if (m_ret == RET_SUCCEED || m_ret == RET_FAILED){
        m_ret = RET_NONE;
        Director::getInstance()->getScheduler()->unscheduleAllForTarget(this);
//		Director::getInstance()->getScheduler()->unschedule(CC_SCHEDULE_SELECTOR(TargetUncompress::runUncompressCallback), this);
		release();
	}
}
