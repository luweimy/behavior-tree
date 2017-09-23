local Decorator = import("..base.Decorator")

--------------------------------------------------------------------------------
-- 一直重复Task，直到Task返回failure
--------------------------------------------------------------------------------
local UntilFailure = class("UntilFailure", function(...)
	return Decorator.new(...)
end)

UntilFailure.lastStatus_ 	= nil

function UntilFailure:ctor()
end

-- Auto 

function UntilFailure:start(context)
	self.lastStatus_ = nil
end

function UntilFailure:update(context)
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
	if status == context:failure() then
		return context:success(self)
	end
	
	self.lastStatus_ = status
	return context:running()
end

function UntilFailure:stop(context)
end

return UntilFailure