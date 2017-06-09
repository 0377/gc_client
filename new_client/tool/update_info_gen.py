#coding:utf-8
import hashlib
import sys
import os,os.path,shutil
import datetime
import zipfile

RETRY_TIMES = 5
tryTimes = 0 
zipNameMap = {}
# gameIdMap = {"brnngame_res.zip": "8",
#              "brnngame_src.zip": "8",
#              "ddzgame_res.zip": "5",
#              "ddzgame_src.zip": "5",
#              "gflower_res.zip": "6",
#              "gflower_src.zip": "6",
#              "lhjgame_res.zip": "12",
#              "lhjgame_src.zip": "12",}
backstageIdMap = {"frame_res.zip": "1",
                  "frame_src.zip": "2",
                  "hall_res.zip": "1",
                  "hall_src.zip": "2",
                  "ddzgame_res.zip": "1",
                  "ddzgame_src.zip": "2",
                  "gflower_res.zip": "3",
                  "gflower_src.zip": "4",
                  "brnngame_res.zip": "5",
                  "brnngame_src.zip": "6",
                  "lhjgame_res.zip": "7",
                  "lhjgame_src.zip": "8",
                  "dzpkgame_res.zip": "9",
                  "dzpkgame_src.zip": "10",
                  "shgame_res.zip": "11",
                  "shgame_src.zip": "12",
                  "qznngame_res.zip": "13",
                  "qznngame_src.zip": "14",
		  "fishgame_res.zip": "15",
                  "fishgame_src.zip": "16",
		  "tmjgame_res.zip": "17",
                  "tmjgame_src.zip": "18"}


from Helper import Helper
#删除文件夹
def delete_dir(delete_dir):
    Helper.delFolder(delete_dir)
#处理一个game需要解压缩的包，主要为src和res    
def genrate_one_gameZip(oneGameName,oneGamePath,saveZipDir, mapKey):
    # print(mapKey)
    oneGameDirs = os.listdir(oneGamePath);
    for oneGameSubDir in oneGameDirs:
        #因为压缩后的文件结构不能变，如src，解压后的格式必须为brnngame/src,因此需要构建一个需要压缩的文件
        #构建要压缩的文件夹 如  brnngame/src 
        if not oneGameSubDir.startswith("."):
            # print "oneGameSubDir:"+oneGameSubDir
            tempNeedZipDir = os.path.join(oneGamePath,"tempDir");#oneGameSubDir 下创建需要压缩的文件夹路径
            tempCopyTargetDir = os.path.join(tempNeedZipDir,oneGameName,oneGameSubDir);
            needCopyDir = os.path.join(oneGamePath,oneGameSubDir)
            #拷贝文件
            Helper.copy(needCopyDir,tempCopyTargetDir)
            #压缩文件
            saveZipPath = os.path.join(saveZipDir,oneGameName+"_"+oneGameSubDir+".zip")
            # print(oneGameName+"_"+oneGameSubDir+".zip")
            zipNameMap[(oneGameName+"_"+oneGameSubDir+".zip")] = mapKey
            Helper.zipFolder(saveZipPath,tempNeedZipDir)
            delete_dir(tempNeedZipDir)
def generate_zip(path,_saveZipDir):
    resFiles = os.listdir(resDir)
    for name in resFiles:
        fullPath =os.path.join(resDir,name)
        if name == "frame":
             #print "pbfile:%s" %fullname
             # print name
             # zip_dir(fullPath,os.path.join(_saveZipDir,name+".zip"))
             genrate_one_gameZip(name,fullPath,_saveZipDir, name)
             # print ""
        elif name == "hall":
            # print ""
            genrate_one_gameZip(name,fullPath,_saveZipDir, name)
        elif name == "games":
            allGameDirs = os.listdir(fullPath)
            print("----------------------------------");
            for oneGameName in allGameDirs:
                if not oneGameName.startswith("."):
                  oneGamePath = os.path.join(fullPath,oneGameName)
                  genrate_one_gameZip(oneGameName,oneGamePath,_saveZipDir, "game")
def GetFileMd5(filename):
    if not os.path.isfile(filename):
        return
    myhash = hashlib.md5()
    f = file(filename,'rb')
    while True:
        b = f.read(8096)
        if not b :
            break
        myhash.update(b)
    f.close()
    return myhash.hexdigest()    

def srcAndResHandle():
    command = 'python BuildRes.py'
    global tryTimes
    if os.system(command) != 0:
        tryTimes = tryTimes + 1
        if (tryTimes < RETRY_TIMES):
            srcAndResHandle()
        else:
            print("%s fail !" % (command))
            sys.exit()
    tryTimes = 0

curDir = os.path.dirname(__file__)
resDir = os.path.join(curDir,"output_buildRes","res")
print("resPath:"+resDir);
saveZipDir = os.path.join(curDir,"needUpdateZips");
delete_dir(saveZipDir)
srcAndResHandle()
os.mkdir(saveZipDir)
generate_zip(resDir,saveZipDir);
allZips = os.listdir(saveZipDir)
infoText = ""
for oneZipName in allZips:
    # print(oneZipName)
    if backstageIdMap.has_key(oneZipName):
        zipFilePath = os.path.join(saveZipDir,oneZipName);
        md5 = GetFileMd5(zipFilePath);
        size = os.path.getsize(zipFilePath)
        # 类名 文件名字 md5 大小 游戏id
        # game brnn_res.zip 141243 23412 8 百人牛牛
        infoText += zipNameMap[oneZipName] + " " + backstageIdMap[oneZipName] + " " + oneZipName + " "+ md5 + " " + str(size) + "\n"
file = open(os.path.join(saveZipDir,"ReadMe.txt"),'w')             
file.write(infoText) 
file.close()