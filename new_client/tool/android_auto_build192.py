import json
import os
import shutil
import package
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
	jsonStr = json.dumps(jsonData);
	save(client_const_path,jsonStr) 	
	print("update client_const.json success!!")
def updateAppName(appName):
 	#s=raw_input(appName)
	appName = appName.decode('gb2312').encode('utf-8')
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
	(opts, args) = parser.parse_args()
	opts.mode = "release"
	channelPrefix = opts.channel
	opts.platform = "android"
	for num in range(1,2): 
		opts.channel = "alipay_android_12_192ddz"
		opts.packageName = opts.channel + "_" + date +".apk"
		updateAppName(opts.name);
		modidyClientJson(opts.channel,opts.version)
		package.buildAndroid(opts)

		print("11111111111111:"+str(num))



