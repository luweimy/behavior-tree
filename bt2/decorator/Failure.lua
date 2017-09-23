local Decorator = import("..base.Decorator")

--------------------------------------------------------------------------------
-- 一直返回failure
--------------------------------------------------------------------------------
local Failure = class("Failure", function(...)
	return Decorator.new(...)
end)

function Failure:ctor()
end

-- Auto 

function Failure:start(context)
	self:getTask():start_(context)
	self:getTask():start (context)
end

function Failure:update(context)
	local status = self:getTask():update(context)
	if status ~= context:running() then
		return context:failure(self)
	end
	return status
end

function Failure:stop(context)
	self:getTask():stop (context)
	self:getTask():stop_(context)
end

return Failure