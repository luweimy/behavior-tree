local Action = import("..base.Action")

--------------------------------------------------------------------------------
-- ####Invoke
-- 回调一个函数
-- 若函数没有返回值则Task返回success
-- 否则返回函数的返回值，但是函数返回值必须是failure, success, running之一
--------------------------------------------------------------------------------
local Invoke = class("Invoke", function(...)
	return Action.new(...)
end)

Invoke.callback_ = nil

function Invoke:ctor()
end

function Invoke:callback(callback)
	self.callback_ = callback
	return self
end

-- Auto 

function Invoke:start(context)
end

function Invoke:update(context)
	local rt
	if self.callback_ then
		rt = self.callback_(self, context)
	end
	if rt == nil then
		return context:success(self)
	end
	return rt
end

function Invoke:stop(context)
end

return Invoke