local table 	= table
local pairs 	= pairs
local coroutine = coroutine
local Composite = import("..base.Composite")

--------------------------------------------------------------------------------
-- ####Priority Selector
-- + 类似于Selector，但是并不是顺序遍历，而是根据优先级(Priority)的顺序进行遍历
-- + 优先级高的优先运行
-- + Task的默认优先级都是0
--------------------------------------------------------------------------------
local PrioritySelector = class("PrioritySelector", function(...)
	return Composite.new(...)
end)


-- Auto 

function PrioritySelector:update(context)
	local children = self:getChildren()
	local orderindexs = {}
	for index, task in pairs(children) do
		-- struct {i="task-index", p="task-priority"}
		orderindexs[index] = {i=index, p=task:getPriority()} 
	end
	
	-- 稳定排序后获得的，高优先级在前
	table.ssort(orderindexs, function(a,b) return a.p<b.p end)
	
	for index = 1, #orderindexs do
		local pack = orderindexs[index]
		local task = children[pack.i] 

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


return PrioritySelector