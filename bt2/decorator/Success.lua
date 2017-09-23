local Decorator = import("..base.Decorator")

--------------------------------------------------------------------------------
-- 一直返回success
--------------------------------------------------------------------------------
local Success = class("Success", function(...)
	return Decorator.new(...)
end)

function Success:ctor()
end

-- Auto 

function Success:start(context)
	self:getTask():start_(context)
	self:getTask():start (context)
end

function Success:update(context)
	local status = self:getTask():update(context)
	if status ~= context:running() then
		return context:success(self)
	end
	return status
end

function Success:stop(context)
	self:getTask():stop (context)
	self:getTask():stop_(context)
end

return Success