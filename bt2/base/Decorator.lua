local Task 		= import(".Task")

--------------------------------------------------------------------------------
-- Decorator的基类
--------------------------------------------------------------------------------
local Decorator = class("Decorator", function(...)
	return Task.new(...)
end)

Decorator.task_ = nil

function Decorator:ctor(task)
	self:setType(Task.TYPE_DECORATOR)
	if type(task) == 'table' then
		self:setTask(task)
	end
end

function Decorator:setTask(task)
	assert(task and not task:getParent())
	if self.task_ then
		task:setParent(nil)
	end
	self.task_ = task
	task:setParent(self)
	return self
end

function Decorator:getTask()
	return self.task_
end

return Decorator