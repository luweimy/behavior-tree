local Task 	   = import(".Task")

--------------------------------------------------------------------------------
-- Action的基类
--------------------------------------------------------------------------------
local Action = class("Action", function(...)
	return Task.new(...)
end)

function Action:ctor()
	self:setType(Task.TYPE_ACTION)
end

return Action