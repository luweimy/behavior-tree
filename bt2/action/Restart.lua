local coroutine = coroutine
local Action 	= import("..base.Action")

--------------------------------------------------------------------------------
-- 中断此次运行，重新运行行为树
--------------------------------------------------------------------------------
local Restart = class("Restart", function(...)
	return Action.new(...)
end)

function Restart:ctor()
end

-- Auto 

function Restart:start(context)
end

function Restart:update(context)
	coroutine.yield(context:success(), self, true)
	return context:success(self)
end

function Restart:stop(context)
end

return Restart