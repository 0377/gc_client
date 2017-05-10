MsgPBParseManager = class("MsgPBParseManager");
local pb = require("protobuf");
function MsgPBParseManager:ctor()
	self.msgKeyMap = {};
end
function MsgPBParseManager:registerProtoFileToPb(fullFilePath)
	local bytes = cc.FileUtils:getInstance():getStringFromFile(fullFilePath)
	-- print("bytes:",string.len(bytes))
	pb.register(bytes);
	-- pb.register_file(fullFilePath);
end
--根据消息名字得到消息ID
function MsgPBParseManager:getTCPMsgEnumID(msgName)
	local msgID = pb.enum_id(msgName .. ".MsgID", "ID");
	return  msgID;
end
function MsgPBParseManager:getMsgNameWitMsgID(msgID)
	return self.msgKeyMap[msgID]
end
--注册消息Id,以及对应MSgName,外部接口调用
function MsgPBParseManager:addMsgNameKeyToKeyMap(msgName)
	--print("MsgPBParseManager:addMsgNameKeyToKeyMap:",msgName)
	local msgID = self:getTCPMsgEnumID(msgName);
	if msgID == nil then
		--todo
		print("msgID is not exist in pb file of "..msgName)
		CustomHelper.printStack()
		return 
	end
	self.msgKeyMap[msgID] = msgName;
end
--得到
function MsgPBParseManager:getEnumPropertyValue(enumType,enumName)
	local value = pb.enum_id(enumType,enumName);
	return value;
end
--解析数据
function MsgPBParseManager:decodeMsgToTab(msgID,bufferStr)
	local msgName = self.msgKeyMap[msgID];
	local msgTab = nil; 
	if msgName ~= nil then
		--todo	
		msgTab = self:decodeMsgToTabWithMsgName(msgName,bufferStr);
	else
		print("can't parse msgID:",msgID)
	end
	-- dump(msgTab, "msgTab", nesting)
	return msgTab;
end
--
function MsgPBParseManager:isMessage(name)
	return pb.check_is_message(name);
end
function MsgPBParseManager:decodeMsgToTabWithMsgName(msgName,buffer)
	--print("msgName:",msgName,",buffer:",buffer)
	-- for i=1,string.len(buffer) do
	-- 	print(string.byte(buffer,i))--返回一个参数函数的2进制代码
	-- end
	local tempTab = pb.decode(msgName,buffer);
	--因为导出来的tempTab重载了索引index，如果访问协议外其他字段会报错，需要转化
	local resultTab = CustomHelper.copyTab(tempTab);
	return resultTab;
end
--encode to pb buffer
function MsgPBParseManager:encodeToBuffer(msgName,infoTab)
	local pbBuffer = pb.encode(msgName,infoTab);
	
	--for i=1,string.len(pbBuffer) do
	--	local t = string.byte(pbBuffer,i)
	--	print("--t:"..t)--返回一个参数函数的2进制代码
	--end
	
	return pbBuffer;
end


