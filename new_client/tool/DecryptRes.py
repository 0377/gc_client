#coding=utf-8
import os,sys,shutil,random,time,struct,binascii
from Helper import Helper

class DecryptRes():
	def isEncryptoHead(self,head):
		ENCRYPTO_HEAD_SIZE = 16
		STATIC_HEAD = [0x59, 0x75, 0x72, 0x6E, 0x65, 0x72, 0x6F]
		for i in range(0,len(STATIC_HEAD)):
			if STATIC_HEAD[i] != head[i]:
				return False

		tmp = head[15]
		for i in range(7,15):
			base = 1 << (i - 7)
			a = base & tmp


			if((head[i] & base  ^ a == 0) and (a == 0 and head[i] < 0x80 or head[i] > 0x7F)):
				if (i == ENCRYPTO_HEAD_SIZE - 2):
					return True
			else:
				return False

		return False

	def decryptoDir(self,path):
		tempList = []
		for parent,dirnames,filenames in os.walk(path):
			for filename in filenames: 
				fullpath = parent + "/" + filename
				tempList.append(fullpath)
		
		for file in tempList:
			file_object_r = open(file,"rb+")
			try:
				head = bytearray(file_object_r.read(16))
				isEncrypt = self.isEncryptoHead(head)
				if isEncrypt:
					data = bytearray(file_object_r.read())
			finally:
					file_object_r.close( )


			if isEncrypt:
				for i in range(0,min(0xFF + 1,len(data))):
					data[i] ^= head[8 + i % 8] & 0xFF
				file_object_w = open(file,"wb+")
				try:
					file_object_w.write(data)
				finally:
					file_object_w.close( )

			#os.remove(file)
			
	@staticmethod
	def run(projPath,curPath, args):
		this = DecryptRes()
		res_dirs = ["src","res"]
		
		tempPath = curPath + "/output_buildRes"
		outputPath = curPath + "/output_buildRes_decrypt"
		Helper.delFolder(outputPath)

		b64 = False
		for arg in args:
			if arg == "-64":
				b64 = true
				break
		
		
		for dir in res_dirs:
			src = tempPath + "/" + dir
			dis = outputPath + "/" + dir
			
			Helper.copy(src,dis)
			this.decryptoDir(dis)

if __name__ == "__main__":
	DecryptRes.run(sys.path[0] + "/../",sys.path[0],sys.argv[1:])
