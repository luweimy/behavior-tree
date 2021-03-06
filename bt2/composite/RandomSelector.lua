local pairs 	= pairs
local table  	= table
local coroutine = coroutine
local Composite = import("..base.Composite")

--------------------------------------------------------------------------------
-- ####Random Selector
-- + 类似于Selector，但是并不是顺序遍历，而是随机(Random)的顺序遍历
--------------------------------------------------------------------------------
local RandomSelector  = class("RandomSelector", function(...)
	return Composite.new(...)
end)

-- Auto 

function RandomSelector:update(context)
	local children = self:getChildren()
	local randomindexs = table.randomgenor(1, #children)
		
	for i = 1, #randomindexs do
		local index = randomindexs[i]
		local task = children[index] 

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

return RandomSelector