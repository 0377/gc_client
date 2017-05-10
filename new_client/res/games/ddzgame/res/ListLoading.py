
#*--coding:utf-8
import os,sys,shutil,re

class ListLoading():
    def ListFile(self, currentDir):
        parent_path = os.path.dirname(currentDir)

        output = open('loadingList', 'w')

        for parent,dirnames,filenames in os.walk(currentDir + "/sound"):
        #三个参数：分别返回1.父目录 2.所有文件夹名字（不含路径） 3.所有文件名字
            #for dirname in  dirnames:                       #输出文件夹信息
            #　  print "parent is:" + parent
            #  print  "dirname is" + dirname
            for filename in filenames:                        #输出文件信息
  
                    output.write(filename + "\n")
        output.close()
    @staticmethod
    def run():
        this = ListLoading()
        path = sys.path[0]
        this.ListFile(path)

if __name__ == "__main__":
    ListLoading.run()

