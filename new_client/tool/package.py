#-*- encoding=utf-8 -*- 
import datetime
import os
import shutil
import sys

import util
import phputil

from optparse import OptionParser

RETRY_TIMES = 5
tryTimes = 0 

COCOS_CONSOLE_PATH = os.path.join(os.environ["COCOS_CONSOLE_ROOT"], "../../")
COCOS_CONSOLE_MODIFIED_PATH = os.path.join(sys.path[0], "Framework_Modified")
ANDROID_STUDIO_PATH = os.path.join(sys.path[0], "../frameworks/runtime-src/proj.android-studio")
SCRIPT_PATH = os.path.join(sys.path[0])
SOURCE_RES_PATH = os.path.join(sys.path[0], "../res")
SOURCE_SRC_PATH = os.path.join(sys.path[0], "../src")
MOBILE_DEST_RES_PATH = os.path.join(sys.path[0], "packageTmp/res")
MOBILE_DEST_SRC_PATH = os.path.join(sys.path[0], "packageTmp/src")
PACKAGE_OUT_PATH = os.path.join(sys.path[0], "PackageOut")
BUILD_CONFIG_PACKAGE = os.path.join(sys.path[0], "../frameworks/runtime-src/proj.android-studio/build-cfg-package.json")
BUILD_CONFIG_DEFAULT = os.path.join(sys.path[0], "../frameworks/runtime-src/proj.android-studio/build-cfg-default.json")
BUILD_CONFIG_USING = os.path.join(sys.path[0], "../frameworks/runtime-src/proj.android-studio/build-cfg.json")
GAMES_PATH = os.path.join(sys.path[0], "output_buildRes/res/games")
CLIENT_CONST_PATH = os.path.join(sys.path[0], "../res/client_const.json")
CLIENT_CONST_OUT_PATH = os.path.join(sys.path[0], "../res/client_const_out.json")

key = "2dxLuasdfsdf123123"
sign = "yuxcvsdfswrwvbnmdggdg"

date = datetime.datetime.today().strftime("%Y-%m-%d")

def cleanAndroidPro():
	os.chdir(ANDROID_STUDIO_PATH)

	command = 'gradlew clean'
	if os.system(command) != 0:
		print("%s fail !" % (command))
		phputil.callPhpResult(phputil.STATUS_CLEAN_ANDROID_ERROR)

	os.chdir(SCRIPT_PATH)

def copyConsoleFile():
	if os.path.isdir(COCOS_CONSOLE_MODIFIED_PATH):
		util.copyFiles(COCOS_CONSOLE_MODIFIED_PATH, COCOS_CONSOLE_PATH)
		print("copy cocos2d-console to %s success !" % (COCOS_CONSOLE_PATH))

def buildAndroidPro(opts):
	# --compile-script 1 关闭脚本编译功能
	command = "cocos compile -p android --android-studio -m %s --compile-script 1" % (opts.mode)
	global tryTimes
	if os.system(command) != 0:
		tryTimes = tryTimes + 1
		if (tryTimes < RETRY_TIMES):
			buildAndroidPro(opts)
		else:
			print("%s fail !" % (command))
			phputil.callPhpResult(phputil.STATUS_BUILD_ANDROID_ERROR)
	tryTimes = 0

def createPackageOutPath():
	if not os.path.exists(PACKAGE_OUT_PATH):
		os.mkdir(PACKAGE_OUT_PATH)

# def removeSrc():
# 	if os.path.isdir(MOBILE_DEST_SRC_PATH):
# 		shutil.rmtree(MOBILE_DEST_SRC_PATH)

# def compileLuaScript(sourcePath, destPath):
# 	removeSrc()

# 	# 不编译，只加密
# 	# command = 'cocos luacompile -s %s  -d %s -e -k %s -b %s --disable-compile' % (SOURCE_SRC_PATH, MOBILE_DEST_SRC_PATH, key, sign)
# 	command = 'cocos luacompile -s %s  -d %s -e -k %s -b %s' % (sourcePath, destPath, key, sign)
# 	global tryTimes
# 	if os.system(command) != 0:
# 		tryTimes = tryTimes + 1
# 		if (tryTimes < RETRY_TIMES):
# 			compileLuaScript(sourcePath, destPath)
# 		else:
# 			print("%s fail !" % (command))
# 	tryTimes = 0

# def createTmpPath():
# 	tmpPath = os.path.join(sys.path[0], "packageTmp")	
# 	if not os.path.exists(tmpPath):
# 		os.mkdir(tmpPath)

# def copyRes():
# 	createTmpPath()

# 	# remove res
# 	if os.path.isdir(MOBILE_DEST_RES_PATH):
# 		shutil.rmtree(MOBILE_DEST_RES_PATH)

# 	# copy res
# 	os.mkdir(MOBILE_DEST_RES_PATH)
# 	if os.path.isdir(SOURCE_RES_PATH):
# 		util.copyFiles(SOURCE_RES_PATH, MOBILE_DEST_RES_PATH)
# 		print("copy res to %s success !" % (MOBILE_DEST_RES_PATH))

# 	compileLuaScript(MOBILE_DEST_RES_PATH, MOBILE_DEST_RES_PATH)

# 	util.zipFolder(os.path.join(sys.path[0], "test.zip"), MOBILE_DEST_RES_PATH)

def srcAndResHandle():
	command = 'python BuildRes.py'
	global tryTimes
	if os.system(command) != 0:
		tryTimes = tryTimes + 1
		if (tryTimes < RETRY_TIMES):
			srcAndResHandle()
		else:
			print("%s fail !" % (command))
			phputil.callPhpResult(phputil.STATUS_BUILD_RES_ERROR)
	tryTimes = 0

def removeGames():
	if os.path.isdir(GAMES_PATH):
		shutil.rmtree(GAMES_PATH)

def createBuildConfig():
	shutil.copyfile(BUILD_CONFIG_PACKAGE, BUILD_CONFIG_USING)

def restoreBuildConfig():
	shutil.copyfile(BUILD_CONFIG_DEFAULT, BUILD_CONFIG_USING)

def copyApk(opts):
	createPackageOutPath()

	# copy apk
	# sourceApkPath = os.path.join(sys.path[0], "../frameworks/runtime-src/proj.android-studio/app/build/outputs/apk")
	sourceApkPath = os.path.join(ANDROID_STUDIO_PATH, "app/build/outputs/apk/")
	apkEndWith = "-release.apk"
	if opts.mode == "release":
		sourceApkPath = os.path.join(ANDROID_STUDIO_PATH, "app/build/outputs/apk/")
		apkEndWith = "-release.apk"
	# if os.path.isdir(sourceApkPath):
	# 	#util.copyFiles(sourceApkPath, PACKAGE_OUT_PATH)
	# 	print("copy apk to %s success !" % (PACKAGE_OUT_PATH))
	if os.path.isdir(sourceApkPath):
		for item in os.listdir(sourceApkPath):
			if item.endswith(apkEndWith):
				shutil.move(os.path.join(sourceApkPath, item), os.path.join(PACKAGE_OUT_PATH, opts.packageName))
				return (os.path.join(PACKAGE_OUT_PATH, opts.packageName))
	return ""

def copyApkForDownload(opts, dest):
	shutil.copy(os.path.join(PACKAGE_OUT_PATH, opts.packageName), dest)

#修改applicationId
def modifyApplicationIdAndVersion(applicationId,applicationVersion):
	applicationIdFilePath = os.path.join(ANDROID_STUDIO_PATH,"application_info.properties")
	properties = "application_id="+str(applicationId)
	properties = properties + "\napplication_version="+applicationVersion
	file = open(applicationIdFilePath,'w')             
	file.write(properties) 
	file.close() 
def buildAndroid(opts):
	# compileLuaScript(SOURCE_SRC_PATH, MOBILE_DEST_SRC_PATH)
	# copyRes()
	srcAndResHandle()
	removeGames()
	cleanAndroidPro()
	modifyApplicationIdAndVersion(opts.appid,opts.version);	
	createBuildConfig()
	copyConsoleFile()
	buildAndroidPro(opts)
	restoreBuildConfig()
	copyApk(opts)
	phputil.callPhpResult(phputil.STATUS_OK)

if __name__ == '__main__':
	parser = OptionParser()
	parser.add_option("-p", "--platform", dest="platform", help='platform should be android, ios, pc, default is android')
	parser.add_option("-m", "--mode", dest="mode", help='mode should be debug or release, default is debug')
	(opts, args) = parser.parse_args()

	if opts.platform != "ios" and opts.platform != "pc":
		opts.platform = "android"

	if opts.mode != "release":
		opts.mode = "debug"

	if opts.platform == "android":
		buildAndroid(opts)

	