local Task 	   = import(".Task")

--------------------------------------------------------------------------------
-- Conditional的基类
--------------------------------------------------------------------------------
local Conditional = class("Conditional", function(...)
	return Task.new(...)
end)

function Conditional:ctor()
	self:setType(Task.TYPE_CONDITIONAL)
end

return Conditional