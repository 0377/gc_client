
color = color or {};

-- convert hex color to rgb color
function color.hex2rgb(hex)
	hex = string.gsub(hex, "#", "")
	local r = tonumber("0x"..string.sub(hex, 1, 2))
	local g = tonumber("0x"..string.sub(hex, 3, 4))
	local b = tonumber("0x"..string.sub(hex, 5, 6))
	return cc.c3b(r, g, b)
end

-- convert hex color to rgba color
function color.hex2rgba(hex)
	hex = string.gsub(hex, "#", "")
	local r = tonumber("0x"..string.sub(hex, 1, 2))
	local g = tonumber("0x"..string.sub(hex, 3, 4))
	local b = tonumber("0x"..string.sub(hex, 5, 6))
	local a = tonumber("0x"..string.sub(hex, 7, 8))
	return cc.c4b(r, g, b, a)
end

-- convert string to char array
function string.string2chars(input)
	local list = {}
	local length = string.len(input)
	local i = 1

	while i <= length do
		local b = string.byte(input, i)
		local offset = 1

		if b > 0 and b <= 127 then
			offset = 1
		elseif b >= 192 and b <= 223 then
			offset = 2
		elseif b >= 224 and b <= 239 then
			offset = 3
		elseif b >= 240 and b <= 247 then
			offset = 4
		end
		
		local char = string.sub(input, i, i + offset - 1)
		table.insert(list, char)

		i = i + offset
	end

	return list, #list
end

-- convert seconds to string just like this: 99:99:99
function string.seconds2str(seconds, sep)
	seconds = seconds or 0
	sep = sep or ":"
	
	if(tonumber(seconds) <= 0)then
		return "00" .. sep .. "00" .. sep .. "00"
	else
		return string.format("%02d%s%02d%s%02d", math.floor(seconds / (60 * 60)), sep, math.floor((seconds / 60) % 60), sep, seconds % 60)
	end
end

function string.cutShortStr(label, maxLength)
	if label ~= nil and maxLength > 0 then
		local width = label:getContentSize().width 
		while width > maxLength do
		     local str = label:getString()
		     local length = string.len(str)
		     local tempStr = string.sub(str, 1, length - 1 - 3)
		     tempStr = tempStr .. "..."
		     label:setString(tempStr)
		     width = label:getContentSize().width 
		end
	end
end
