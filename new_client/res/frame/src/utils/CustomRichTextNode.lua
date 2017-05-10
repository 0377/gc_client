local CustomRichTextNode = class("CustomRichTextNode",ccui.ListView)
function CustomRichTextNode.createHLCustomRichTextWithXML(desc,parameterTextNode)
	local customRichNode = CustomRichTextNode:create();
	customRichNode:initRichNodeWithXML(desc);
	return customRichNode;
end
function CustomRichTextNode:initRichNodeWithXML(desc)
	print("1111111111111111111")
	self:setContentSize(cc.size(500,400));
	local default = {

		KEY_FONT_SIZE = 20,
		
	}
	self._richTextNode = ccui.RichText:createWithXML(desc,default)
	local size = self._richTextNode:getContentSize();
	dump(size, "size", nesting)
	self:addChild(self._richTextNode);
end
return CustomRichTextNode;