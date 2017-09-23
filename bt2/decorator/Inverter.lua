local Decorator = import("..base.Decorator")

--------------------------------------------------------------------------------
-- 对子Task的结果取反
--------------------------------------------------------------------------------
local Inverter = class("Inverter", function(...)
	return Decorator.new(...)
end)

function Inverter:ctor()
end


-- Auto 

function Inverter:start(context)
	self:getTask():start_(context)
	self:getTask():start (context)
end

function Inverter:update(context)
	local status = self:getTask():update(context)
	if status == context:success() then
		return context:failure(self)
	elseif status == context:failure() then
		return context:success(self)
	end
	return status
end

function Inverter:stop(context)
	self:getTask():stop (context)
	self:getTask():stop_(context)
end

return Inverter