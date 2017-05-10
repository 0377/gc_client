NetworkManager = class("NetworkManager")
NetworkManager.TCPConnectionStatus =
{
	TCPConnectionStatus_Connecting	= 1,
	TCPConnectionStatus_Connected = 2,
	TCPConnectionStatus_Close = 3
	-- TCPConnectionStatus_TimeOut = 4
}
function NetworkManager:ctor()
	self.netManager = myLua.NetworkManager:create();
	self.netManager:retain();
end
function NetworkManager:destory()
	if self.netManager then
		--todo
		print("1111111111111111111111111123123123123")
		self.netManager:release();
		self.netManager = nil;
	end
end
function NetworkManager:connect(connectionID,addr,port,timeout)
	self.netManager:connectTCPSocket(addr,port,connectionID,timeout);
end
function NetworkManager:disconnect(connectionID)
	self.netManager:disconnect(connectionID);
end
function NetworkManager:sendTCPMsg(connectionID,msgID,msgPbBufferStr)
	-- self.netManager:sendTCPMsg(connectionID,msgID,msgPbBufferStr)
	local sendMsgLengthMethod = "sendTCPMSgWithLength"
	if self.netManager[sendMsgLengthMethod] then
		--todo
		local length =  string.len(msgPbBufferStr)
		self.netManager[sendMsgLengthMethod](self.netManager,connectionID,msgID,msgPbBufferStr,length)
	else
		self.netManager:sendTCPMsg(connectionID,msgID,msgPbBufferStr);
	end

end
function NetworkManager:receiveTCPMsg()

end
function NetworkManager:sendHttpRequest(url,parameterTab,callback,method)
	-- body
	if method == nil then
		--todo
		method = "POST";
	end
    local xhr = cc.XMLHttpRequest:new()
    xhr:setRequestHeader("Content-Type","application/json; charset=utf-8");
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON-- cc.XMLHTTPREQUEST_RESPONSE_STRING-- cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER -- cc.XMLHTTPREQUEST_RESPONSE_JSON
    local function onReadyStateChanged()
    	local isSuccess = false;
    	if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
            isSuccess = true;
        else

		end
        callback(xhr,isSuccess);
        xhr:unregisterScriptHandler()
    end
    xhr:registerScriptHandler(onReadyStateChanged)
    local parameterStr = "";
    local dataJsonStr = nil;
	if parameterTab ~= nil and table.nums(parameterTab) >0 then
		--todo
		local isFirstParameter = true;
		dataJsonStr = CustomHelper.getJsonStrWithJsonTab(parameterTab);
		for k,v in pairs(parameterTab) do
			if isFirstParameter then
				--todo
				parameterStr = parameterStr..k.."="..v
				isFirstParameter = false
			else
				parameterStr = parameterStr.."&"..k.."="..v
			end
		end
	end
    if method == "POST" then
    	--todo
	    xhr:open(method,url);
	    -- if parameterTab ~= nil and table.nums(parameterTab) > 0 then
	    -- 	--todo
	    -- end
    	xhr:send(dataJsonStr)
	elseif method == "GET" then
    	--todo
		url = url.."?"..parameterStr;
		-- print("url:",url)
	    xhr:open(method,url);
	    xhr:send()
    end
    return xhr;
end
return NetworkManager
