#-*- encoding=utf-8 -*- 

import os
import sys
import urllib
import urllib2

needCallPhp = False
platform = "android"
channel = 0
fileName = ""
show_channel = ""
pkgUrl = ""

STATUS_OK = 0
STATUS_GIT_ERROR = 1
STATUS_BUILD_RES_ERROR = 2
STATUS_CLEAN_ANDROID_ERROR = 3
STATUS_BUILD_ANDROID_ERROR = 4

def setNeedCallPhp(status):
    global needCallPhp
    needCallPhp = status

def setPlatform(p):
    global platform 
    platform = p

def setChannel(c):
    global channel
    channel = c

def setFileName(fn):
    global fileName
    fileName = fn

def setShowChannel(sc):
    global show_channel
    show_channel = sc

def setPkgUrl(pu):
    global pkgUrl
    pkgUrl = pu

def callPhpResult(status):
    print("[phputil] callPhpResult")
    if (needCallPhp):
        url = 'http://frame.milk.com/api/operator/editChannelTax' 
        values = {'status': status,
                    'url': pkgUrl,
                    'phone_type': platform,
                    'channel': channel,
                    'show_channel': show_channel} 
        data = urllib.urlencode(values) 
        req = urllib2.Request(url, data) 
        response = urllib2.urlopen(req)
        the_page = response.read()
    if (status != STATUS_OK):
        sys.exit()
    