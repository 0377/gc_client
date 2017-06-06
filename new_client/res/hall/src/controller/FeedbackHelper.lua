local FeedbackHelper = {}
FeedbackHelper.CONFIG_FEEDBACK_CAT = {
    ["提建议"] = "1",
    ["提BUG"] = "2",
    ["充值问题"] = "3",
    ["咨询其他"] = "4",
}

--- 获取是否有新的反馈信息状态
function FeedbackHelper.queryFeedbackStatus()
    local playInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    local guid = playInfo:getGuid()
    local sign = 12345678
    local feedbackLoginURL = CustomHelper.getOneHallGameConfigValueWithKey("feedback_login_url")
    GameManager:getInstance():getNetworkManager():sendHttpRequest(feedbackLoginURL,
        {
            guid = guid,
            sign = CustomHelper.md5String(guid .. sign),
        }, function(xhr,isSuccess)
            if isSuccess then
                local responseStr = xhr.response;
                local data = json.decode(responseStr)
                -- dump(data)

                if data.status and data.status == 1 then
                    local playInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
                    local feedbackInfo = playInfo:getFeedbackInfo()
                    feedbackInfo:setUnreadMessageCount(data.data.unread_count or 0)
                    FeedbackHelper.postRefreshFeedBackReadNotify();
                else
                end
            else
            end
        end, "POST")
end
function FeedbackHelper.postRefreshFeedBackReadNotify()
    local event1 = cc.EventCustom:new("kNotifyName_RefreshFeedbackReaded");
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event1);
end
--- 提交反馈
function FeedbackHelper.submitFeedback(type,content,callback)
    --    （1）guid          玩家账号
    --    （2）type          反馈类型
    --    （3）content       反馈内容
    --    （4）sign          签名（guid,type,content）字段和顺序
    --     签名规则:md5(guid + type+ content + 12345678)
    local playInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    local guid = playInfo:getGuid()
    local sign = CustomHelper.md5String(guid .. type .. content .. "12345678")
    local feedbackCreateURL = CustomHelper.getOneHallGameConfigValueWithKey("feedback_create_url");
    GameManager:getInstance():getNetworkManager():sendHttpRequest(feedbackCreateURL,
        {
            guid = guid,
            type = type,
            content = content,
            sign = sign,
        }, function(xhr,isSuccess)
            callback(xhr,isSuccess)
        end, "POST")
end

--- 获取历史反馈信息
function FeedbackHelper.queryFeedback(page,callback)
--    （1） guid			   玩家账号
--    （2） page          页码（不传则为第一页）
--    （3） sign          签名（guid）字段和顺序
--    签名规则:md5(guid + 12345678)
	FeedbackHelper.queryCallback = callback
    local playInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    local guid = playInfo:getGuid()
    local sign = CustomHelper.md5String(guid .. "12345678")
    local feedbackListURL = CustomHelper.getOneHallGameConfigValueWithKey("feedback_list_url")
    GameManager:getInstance():getNetworkManager():sendHttpRequest(feedbackListURL,
        {
            guid = guid,
            page = page,
            sign = sign,
        }, function(xhr,isSuccess)
            if isSuccess then
                local responseStr = xhr.response;
                responseStr = string.gsub(responseStr, "\\", "")
                local data = json.decode(responseStr)
                -- dump(data, "FeedbackHelper.queryFeedback", nesting)
                if data and data.status == 1 then
                    local playInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
                    local feedbackInfo = playInfo:getFeedbackInfo()
                    feedbackInfo:addData(data.data,page)
                    feedbackInfo:setCurentPage(page + 1)
                    feedbackInfo:setHasMore(data.has_more == 1)
                    -- 1有未读消息  0没有
                    local  isHasUnRead = false;
                    if data.unread_count > 0 then
                         isHasUnRead = true; 
                    end
                    feedbackInfo:setUnreadMessageCount(data.unread_count or 0)
                    FeedbackHelper.postRefreshFeedBackReadNotify();
                end
            end
			if FeedbackHelper.queryCallback then
				FeedbackHelper.queryCallback(xhr,isSuccess)
			end
            
        end, "POST")

end
--清除查询回调
--当查询任务耗时，但是UI已经销毁的时候，回调就不用了 这里只适用于单一回调处理
function FeedbackHelper.clearQueryCallback()
	FeedbackHelper.queryCallback = nil
end

return FeedbackHelper