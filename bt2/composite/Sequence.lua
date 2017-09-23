local pairs 	= pairs
local coroutine = coroutine
local Composite = import("..base.Composite")

--------------------------------------------------------------------------------
-- ####Sequence
-- + 遇到failure则停止继续遍历，则Sequence直接返回failure    
-- + 遇到success则继续遍历，若Sequence的全部子Task都返回success，则Sequence返回success    
-- + 遇到running则停止继续遍历，并则等待running的返回值(failure或者success)    
--------------------------------------------------------------------------------
local Sequence  = class("Sequence", function(...)
	return Composite.new(...)
end)

-- Auto 

function Sequence:update(context)
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

		if status == context:failure() then
			return context:failure(self)
		end
	end
	return context:success(self)
end

return Sequence