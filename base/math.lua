--------------------------------------------------------------------------------
-- @module math
-- @desc 对math库的扩展
--------------------------------------------------------------------------------

local os = os
local math = math
local ipairs = ipairs
local tonumber = tonumber
local tostring = tostring

--------------------------------------------------------------------------------
-- 传入一个[0, 1]的值p, 则会有p的几率返回true
--------------------------------------------------------------------------------
function math.ok(p)
	if math.random(1, 100) <= p * 100 then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- 两点间的距离
--------------------------------------------------------------------------------
function math.dist(ax, ay, bx, by)
    local dx, dy = bx - ax, by - ay
    return math.sqrt(dx * dx + dy * dy)
end

--------------------------------------------------------------------------------
-- 返回一个数是否为奇数
--------------------------------------------------------------------------------
function math.isodd(num)
	local t = math.fmod(num, 2)
	if 0 == t then
		return false
	elseif 1 == t then
		return true
	end
end

--------------------------------------------------------------------------------
-- 获得一系列数字中最小的数
-- @param: ... - 数字
-- @return: minNum - 最小的数字和其index
--------------------------------------------------------------------------------
function math.min(...)
	local arg = {...}
	local min, index = arg[1], 1
	for i, v in ipairs(arg) do
		if min > v then
			min, index = v, i
		end
	end
	return min, index
end

--------------------------------------------------------------------------------
-- 获得随机浮点数，支持负数
-- @param: 	start- 起始值
-- 			stop - 停止值
-- 			prec - 精确位数
--------------------------------------------------------------------------------
function math.randomf(start, stop, prec)
	prec = prec or 3
	prec = math.pow(10, prec)
	local start_ = start * prec
	local stop_ = stop * prec
	return math.random(start_, stop_) / prec
end

math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
math.random()
math.random()
math.random()
math.random()	