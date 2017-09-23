local Decorator = import("..base.Decorator")

--------------------------------------------------------------------------------
-- 一直重复Task，直到Task返回success
--------------------------------------------------------------------------------
local UntilSuccess = class("UntilSuccess", function(...)
	return Decorator.new(...)
end)

UntilSuccess.lastStatus_ 	= nil

function UntilSuccess:ctor()
end

-- Auto 

function UntilSuccess:start(context)
	self.lastStatus_ = nil
end

function UntilSuccess:update(context)
	-- start
	if self.lastStatus_ ~= context:running() then
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
	if status == context:success() then
		return context:success(self)
	end
	
	self.lastStatus_ = status
	return context:running()
end

function UntilSuccess:stop(context)
end

return UntilSuccess