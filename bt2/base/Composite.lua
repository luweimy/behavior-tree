local assert = assert
local string = string
local table  = table
local pairs  = pairs
local Task 	 = import(".Task")

--------------------------------------------------------------------------------
-- Composite的基类
--------------------------------------------------------------------------------
local Composite = class("Composite", function(...)
	return Task.new(...)
end)

Composite.children_ = nil

function Composite:ctor(children)
	self.children_ = {}
	self:setType(Task.TYPE_COMPOSITE)

	if type(children) == 'table' then
		self:addChildren(children)
	end
end

-- Tree Support

function Composite:addChildren(children)
	for _, child in pairs(children) do
		self:addChild(child)
	end
end

function Composite:addChild(child)
	assert(child and not child:getParent())
	table.insert(self.children_, child)
	child:setParent(self)
	return self
end

function Composite:removeChild(child)
	assert(child)
	local count = table.removebyvalue(self.children_, child)
	if count > 0 then
		child:setParent(nil)
	end
	return self
end

function Composite:hasChild(child)
	assert(child)
	return table.isexist(self.children_, child)
end

function Composite:getChildren()
	return self.children_
end

-- Debug

function Composite:visit(callback, depth)
	depth = depth or 0
	callback(self, depth)
	for _, node in pairs(self.children_) do
		node:visit(callback, depth+1)
	end
	return self
end

function Composite:dump()
	self:visit(function(node, indent)
		local perfix = string.rep("+", indent)
		print(perfix .. node:getDescription())
	end)
	return self
end

return Composite