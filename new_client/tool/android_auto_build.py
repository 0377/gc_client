#-*- encoding=utf-8 -*- 
import json
import os
import shutil
import package
import platform
import datetime
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

from optparse import OptionParser
from xml.etree import ElementTree 
date = datetime.datetime.today().strftime("%Y-%m-%d")
def save(filename, contents): 
  fh = open(filename, 'w') 
  fh.write(contents) 
  fh.close() 
#modify client const
def modidyClientJson(channel,version):
	client_const_path = os.path.join(os.getcwd(), "../res/client_const.json")
	fpr = open(client_const_path, 'r')  
	jsonData = json.loads(fpr.read())
	fpr.close();
	jsonData["client_info"]["channel"] = channel
	jsonData["client_info"]["version"] = version;
	# 生成线上包环境，主要防止人工改动，漏掉了热更新、DEBUG等重要选项
	jsonData["client_info"]["encode_online"] = True
	jsonStr = json.dumps(jsonData);
	save(client_const_path,jsonStr) 	
	print("update client_const.json success!!")
def updateAppName(appName):
 	#s=raw_input(appName)
 	if (platform.system() == "Windows"):
 		appName = appName.decode('gb2312').encode('utf-8')
 	else:
		appName = unicode(appName).encode('utf-8')
	xml_file = os.path.join(os.getcwd(), "../frameworks/runtime-src/proj.android-studio/app/res/values/strings.xml") 
	xml = ElementTree.ElementTree(file=xml_file);
	root = xml.getroot()
	root.find('string').text= appName 
	xml.write(xml_file)

if __name__ == '__main__':
	parser = OptionParser()
	parser.add_option("-c", "--channel", dest="channel", help='channel name')
	parser.add_option("-v", "--version", dest="version", help='channel version')
	parser.add_option("-n", "--name", dest="name", help='app name')
	parser.add_option("-f", "--channel_from", dest="channel_from", help='channel from')
	parser.add_option("-t", "--channel_to", dest="channel_to", help='channel to')
	#parser.add_option("-appid","--appid",dest="application unique id",help="application id")
	(opts, args) = parser.parse_args()
	opts.mode = "release"
	channelPrefix = opts.channel
	# if (opts.name == None):
	# 	opts.name = "王者游戏"
	# opts.name = opts.name.decode('unicode_escape').encode('utf-8')
	opts.platform = "android"
	packageInfo = ""
	channelFrom = int(opts.channel_from);
	channelTo = int(opts.channel_to)
	for num in range(channelFrom,channelTo+1): #202
		print("start package channel:" + str(num))
		opts.appid = "com.my_new_game_studio.client_"+str(num)
		packageInfo += str(num)+"\t"+opts.appid + "\t android" + "\n"
		opts.packageName = opts.appid + "_" + date +".apk"
		updateAppName(opts.name);
		modidyClientJson(str(num),opts.version)
		package.buildAndroid(opts)
	print packageInfo
	curDir = os.path.dirname(__file__)	
	packageInfoTxtPath = os.path.join(curDir,"PackageOut","all_packages_info.txt")
	file_object = open(packageInfoTxtPath,"w")
 	# all_the_text = file_object.read( )
 	# print "all_the_text:"+all_the_text
 	# all_the_text = ""
 	all_the_text = packageInfo
 	save(packageInfoTxtPath,all_the_text)
 	file_object.close( )
	 	
 	


