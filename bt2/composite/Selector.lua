local pairs 	= pairs
local coroutine = coroutine
local Composite = import("..base.Composite")

--------------------------------------------------------------------------------
-- ####Selector
-- + 遇到failure继续遍历，若Selector中子Task全返回failure，则Selector返回failure
-- + 遇到success则停止遍历，并返回success，
-- + 遇到running则停止继续遍历，并等待running的返回值(failure或者success)  
--------------------------------------------------------------------------------
local Selector  = class("Selector", function(...)
	return Composite.new(...)
end)

-- Auto 

function Selector:update(context)
	for index, task in pairs(self:getChildren()) do
		task:start_(context)
		task:start (context)
		local status = task:update(context)
		
		-- 如果task是running状态，则需要继续update当前task(running)
		-- 直到其返回success或者failure。
		-- 原理：挂起当前coroutine，然后去专门update这个task，直到其返回
		-- 值为success或者failure，将其返回值再赋值给status，继续当前遍历
		if status == context:running() then
			status = coroutine.yield(context:running(), task)
		end
		
		task:stop (context)
		task:stop_(context)

		if status == context:success() then
			return context:success(self)
		end
	end
	return context:failure(self)
end

return Selector