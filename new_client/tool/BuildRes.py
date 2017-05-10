#coding=utf-8
import os,sys,shutil,random,time
from Helper import Helper

class BuildApk():

	def compileSource(self,path,b64 = False):
		#cmd = "cocos luacompile -s " + path + " -d " + path + " -e -k 2dxLua -b XXTEA"
		if b64:
			cmd = "cocos luacompile -s " + path + " -d " + path + " -e -k 2dxLuasdfsdf123123 -b yuxcvsdfswrwvbnmdggdg --bytecode-64bit"
		else:
			cmd = "cocos luacompile -s " + path + " -d " + path + " -e -k 2dxLuasdfsdf123123 -b yuxcvsdfswrwvbnmdggdg --disable-compile"
		cmd = "cocos luacompile -s " + path + " -d " + path + " -e -k 2dxLuasdfsdf123123 -b yuxcvsdfswrwvbnmdggdg --disable-compile"
		return os.system(cmd)
		
	def removeLuaFile(self,path):
		for parent,dirnames,filenames in os.walk(path):
			for filename in filenames: 
				if filename.endswith('.lua') > 0:
					os.remove(parent + "/" + filename)
					
					
	def getEncryptoKeys(self):
		random.seed(time.time())
		
		temp = random.randint(0,0xFF)
		HEAD = []
		
		for i in range(0,8):
			base = 1 << i
			key = 0
			a = base & temp

			while True:			
				if a == 0:
					key = random.randint(0,0x7F)
				else:
					key = random.randint(0x80,0xFF)
				if key & base ^ a == 0:
					break
					
			HEAD.append(key)
			
		HEAD.append(temp)
		return HEAD
	
	def encryptoDir(self,path):
		tempList = []
		for parent,dirnames,filenames in os.walk(path):
			for filename in filenames: 
				fullpath = parent + "/" + filename
				tempList.append(fullpath)
		
		random.seed(time.time())
		for file in tempList:
			file_object_r = open(file,"rb+")
			try:
				all_the_text = file_object_r.read( )
				filedata2 = bytearray(all_the_text)
				
				HEAD = self.getEncryptoKeys()
				for i in range(0,min(len(filedata2),0xFF + 1)):
					filedata2[i] = filedata2[i] ^ HEAD[1+ i % 8]
				
				
				STATIC_HEAD = [0x59, 0x75, 0x72, 0x6E, 0x65, 0x72, 0x6F]
				for i in range(0,len(STATIC_HEAD)):
					HEAD.insert(0,STATIC_HEAD[len(STATIC_HEAD) - i - 1])
				for i in range(0,len(HEAD)):
					filedata2.insert(0,HEAD[len(HEAD) - i - 1])
					
			finally:
				file_object_r.close( )
				
			file_object_w = open(file,"wb+")
			try:
				file_object_w.write(filedata2)
			finally:
				file_object_w.close( )
				
			#os.remove(file)
	
	@staticmethod
	def run(projPath,curPath, args):
		this = BuildApk()
		res_dirs = ["src","res"]
		
		tempPath = curPath + "/output_buildRes"
		Helper.delFolder(tempPath)

		b64 = False
		for arg in args:
			if arg == "-64":
				b64 = true
				break
		
		
		for dir in res_dirs:
			src = projPath + "/" + dir
			dis = tempPath + "/" + dir
			
			Helper.copy(src,dis)
			
			this.compileSource(dis,b64)
			
			this.removeLuaFile(dis)
			
			this.encryptoDir(dis)
			
	

	
if __name__ == "__main__":
	BuildApk.run(sys.path[0] + "/../",sys.path[0],sys.argv[1:])
