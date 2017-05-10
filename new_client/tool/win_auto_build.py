#coding:utf-8
import os
import shutil
import datetime
import sys
import zipfile
from Helper import Helper
reload(sys)
sys.setdefaultencoding('utf-8')
def srcAndResHandle():
	command = 'python BuildRes.py'
	global tryTimes
	if os.system(command) != 0:
		tryTimes = tryTimes + 1
		if (tryTimes < RETRY_TIMES):
			srcAndResHandle()
		else:
			print("%s fail !" % (command))
	tryTimes = 0

srcAndResHandle();
curDir = os.path.dirname(__file__)
resDir = os.path.join(curDir,"output_buildRes","res")
srcDir = os.path.join(curDir,"output_buildRes","src")

winTargetDir = os.path.join(curDir,"..","..","..","gamingcity_common","win")
Helper.delFolder(winTargetDir)
os.mkdir(winTargetDir)

targetSrcDir = os.path.join(winTargetDir,"src")
Helper.delFolder(targetSrcDir)
os.mkdir(targetSrcDir);
Helper.copy(srcDir,targetSrcDir)
targetResDir = os.path.join(winTargetDir,"res")
Helper.delFolder(targetResDir)
os.mkdir(targetResDir);
Helper.copy(resDir,targetResDir)

#
simulatorDir = os.path.join(curDir,"..","simulator")
targetSimulatorDir = os.path.join(winTargetDir,"simulator")
Helper.delFolder(targetSimulatorDir)
os.mkdir(targetSimulatorDir);
Helper.copy(simulatorDir,targetSimulatorDir)

#copy client_const.json
clientJsonPath = os.path.join(curDir,"..","res","client_const.json")
targetClientJsonPath = os.path.join(targetResDir,"client_const.json")
if os.path.exists(targetClientJsonPath):
	os.remove(targetClientJsonPath)
shutil.copy(clientJsonPath, targetClientJsonPath)

#zip win
zipPath = os.path.join(winTargetDir,"..","win.zip")
# zip_dir(zipPath)
# zip_dir(winTargetDir,zipPath)
Helper.zipFolder(zipPath,winTargetDir)
Helper.delFolder(winTargetDir);