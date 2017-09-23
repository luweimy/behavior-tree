local Decorator = import("..base.Decorator")

--------------------------------------------------------------------------------
-- 一直重复子Task指定的次数
--------------------------------------------------------------------------------
local Repeater = class("Repeater", function(...)
	return Decorator.new(...)
end)

Repeater.count_ 		= 99999999999999
Repeater.endOfFailure_  = true

Repeater.lastStatus_ 	= nil
Repeater.index_		 	= 0

function Repeater:ctor()
end

--------------------------------------------------------------------------------
-- 设置被修饰的Task被重复的次数和是否子Task返回failure时停止重复
--------------------------------------------------------------------------------
function Repeater:setCount(count, endOfFailure)
	self.count_ = count
	self.endOfFailure_ = endOfFailure
	return self
end

-- Auto 

function Repeater:start(context)
	self.lastStatus_ = nil
	self.index_ 	 = 0
end

function Repeater:update(context)
	-- start
	if self.lastStatus_ ~= context:running() then
		if self.index_ >= self.count_ then
			return context:success(self)		
		end
		self.index_ = self.index_ + 1
		self:getTask():start_(context)
		self:getTask():start (context)
	end

	-- update
	local status = self:getTask():update(context)
	
	-- stop
	if self.lastStatus_ ~= context:running() then
		self:getTask():stop (context)
		self:getTask():stop_(context)
	end
	if self.endOfFailure_ and status == context:failure() then
		return context:failure(self)
	end
	self.lastStatus_ = status
	return context:running()
end

function Repeater:stop(context)
end

return Repeater