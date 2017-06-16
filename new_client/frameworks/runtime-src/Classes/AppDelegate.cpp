#include "AppDelegate.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "audio/include/SimpleAudioEngine.h"
#include "cocos2d.h"
#include "scripting/lua-bindings/manual/lua_module_register.h"

#include "net/NetworkManager.h"
#include "network/HttpClient.h"
#include "utils/LuaManager.h"
// 
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "bugly/CrashReport.h"
#include "bugly/lua/BuglyLuaAgent.h"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "CrashReport.h"
#include "BuglyLuaAgent.h"//
#endif

using namespace CocosDenshion;

USING_NS_CC;
using namespace std;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
    // NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
    RuntimeEngine::getInstance()->end();
#endif

}

// if you want a different context, modify the value of glContextAttrs
// it will affect all platforms
void AppDelegate::initGLContextAttrs()
{
    // set OpenGL context attributes: red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

// if you want to use the package manager to install more packages, 
// don't modify or remove this function
static int register_all_packages()
{
    return 0; //flag for packages manager
}

bool AppDelegate::applicationDidFinishLaunching()
{
	
	

    // register lua module
	LuaManager::getInstance()->initGameLua();


    //register custom function
    //LuaStack* stack = engine->getLuaStack();
    //register_custom_function(stack->getLuaState());

	//NetworkManager *networkmanager = NetworkManager::create();
	//networkmanager->retain();
	//networkmanager->connectTCPSocket("127.0.0.1", "8004", 1);
	//networkmanager->connectTCPSocket("127.0.0.1", "17000", 2);
    // set default FPS


    Director::getInstance()->setAnimationInterval(1.0 / 60.0f);
	//����client ��ʱʱ��
	cocos2d::network:: HttpClient::getInstance()->setTimeoutForConnect(10);
	cocos2d::network::HttpClient::getInstance()->setTimeoutForRead(10);

    // register lua module
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);

    register_all_packages();

    #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
        CrashReport::initCrashReport("59ef295b0f", false);
        BuglyLuaAgent::registerLuaExceptionHandler(engine);
    #elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        CrashReport::initCrashReport("c672f46926", false);
        BuglyLuaAgent::registerLuaExceptionHandler(engine);
    #endif


    LuaStack* stack = engine->getLuaStack();
    std::string keyStr = "2dxLuasdfsdf123123";
    std::string signStr = "yuxcvsdfswrwvbnmdggdg";//XXTEA
    stack->setXXTEAKeyAndSign(keyStr.c_str(), (int)strlen(keyStr.c_str()), signStr.c_str(), (int)strlen(signStr.c_str()));

    //register custom function
    //LuaStack* stack = engine->getLuaStack();
    //register_custom_function(stack->getLuaState());

#if CC_64BITS
    FileUtils::getInstance()->addSearchPath("src/64bit");
#endif
    FileUtils::getInstance()->addSearchPath("src");
    FileUtils::getInstance()->addSearchPath("res");
    if (engine->executeScriptFile("main.lua"))
    {
        return false;
    }
	return true;
}

// This function will be called when the app is inactive. Note, when receiving a phone call it is invoked.
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}
