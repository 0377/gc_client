#coding=utf-8 
import json
import os
import shutil
import package
import datetime
import sys

import gitutil
import phputil

reload(sys)
sys.setdefaultencoding('utf-8')

from optparse import OptionParser
from xml.etree import ElementTree 
date = datetime.datetime.today().strftime("%Y-%m-%d")

DOWNLOAD_LOCAL_PATH = "D:/Develop/Util/Php/Setup/WWW/pkgs"
DOWNLOAD_PATH = "http://192.168.7.75/pkgs/"

def save(filename, contents): 
  fh = open(filename, 'w') 
  fh.write(contents) 
  fh.close() 

#modify client const
def modidyClientJson(channel,version):
	client_const_path = os.path.join(sys.path[0], "../res/client_const.json")
	fpr = open(client_const_path, 'r')  
	jsonData = json.loads(fpr.read())
	fpr.close();
	jsonData["client_info"]["channel"] = channel
	jsonData["client_info"]["version"] = version;
	jsonStr = json.dumps(jsonData);
	save(client_const_path,jsonStr) 	
	print("update client_const.json success!!")

def updateAppName(appName):
 	#s=raw_input(appName)
	appName = unicode(appName).encode('utf-8')
	xml_file = os.path.join(sys.path[0], "../frameworks/runtime-src/proj.android-studio/app/res/values/strings.xml") 
	xml = ElementTree.ElementTree(file=xml_file);
	root = xml.getroot()
	root.find('string').text= appName 
	xml.write(xml_file)

def gitHandle():
	return gitutil.update()

if __name__ == '__main__':
	print("start package")
	os.chdir(sys.path[0])
	phputil.setNeedCallPhp(True)
	if gitHandle():
		parser = OptionParser()
		parser.add_option("-c", "--channel", dest="channel", help='channel name')
		parser.add_option("-v", "--version", dest="version", help='channel version')
		parser.add_option("-n", "--name", dest="name", help='app name')
		parser.add_option("-s", "--show_channel", dest="show_channel", help='show channel just for php')
		parser.add_option("-p", "--platform", dest="platform", help="platform, eg:android")
		parser.add_option("-f", "--channel_from", dest="channel_from", help='channel from')
		parser.add_option("-t", "--channel_to", dest="channel_to", help='channel to')
		#parser.add_option("-appid","--appid",dest="application unique id",help="application id")
		(opts, args) = parser.parse_args()
		opts.mode = "release"
		# channelPrefix = opts.channel
		phputil.setChannel(opts.channel)
		opts.platform = "android"
		phputil.setPlatform(opts.platform)
		phputil.setShowChannel(opts.show_channel)
		packageInfo = ""
		# channelFrom = int(opts.channel_from);
		# channelTo = int(opts.channel_to)
		# for num in range(channelFrom,channelTo+1): #202
		num = opts.channel
		opts.appid = "com.wangzhe_studio.client_"+str(num)
		packageInfo += str(num)+"\t"+opts.appid + "\t android" + "\n"
		opts.packageName = opts.appid + "_" + date +".apk"		
		phputil.setPkgUrl(os.path.join(DOWNLOAD_PATH, opts.packageName))
		# TODO:php should give version
		if (opts.name == None):
			opts.name = "王者游戏"
		opts.name = opts.name.decode('unicode_escape').encode('utf-8')
		updateAppName(opts.name);
		# TODO:php should give version
		if (opts.version == None):
			opts.version = "1.0.0"
		modidyClientJson(str(num),opts.version)
		package.buildAndroid(opts)

		# print packageInfo
		curDir = os.path.dirname(__file__)	
		packageInfoTxtPath = os.path.join(curDir,"PackageOut","all_packages_info.txt")
		file_object = open(packageInfoTxtPath,"w")
	 	# all_the_text = file_object.read( )
	 	# print "all_the_text:"+all_the_text
	 	# all_the_text = ""
	 	all_the_text = packageInfo
	 	save(packageInfoTxtPath,all_the_text)
	 	file_object.close( )

	 	# 把apk拷贝到www以支持下载
	 	package.copyApkForDownload(opts, DOWNLOAD_LOCAL_PATH)
	else:
 		print("fail: git fail")
 		phputil.callPhpResult(phputil.STATUS_GIT_ERROR)
	 	
 	


