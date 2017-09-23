local print  = print
local assert = assert
local string = string

--------------------------------------------------------------------------------
-- 所有树节点的基类
--------------------------------------------------------------------------------
local Task   = class("Task")

Task.priority_  = 0
Task.nickname_ 	= nil
Task.parent_ 	= nil
Task.type_ 	 	= 0
Task.uniqueId_  = 0
Task.context_ 	= nil

Task.TYPE_CONDITIONAL = 1
Task.TYPE_COMPOSITE   = 2
Task.TYPE_DECORATOR   = 3
Task.TYPE_ACTION 	  = 4
Task.TYPE_NONE 		  = 0

local __UNIQUE_ID = 0

function Task:ctor(nickname)
	__UNIQUE_ID = __UNIQUE_ID + 1

	self.type_ 		= Task.TYPE_NONE
	self.uniqueId_ 	= __UNIQUE_ID

	if type(nickname) == 'string' then
		self.nickname_ = nickname or ""
	end
end

function Task:getId()
	return self.uniqueId_
end

function Task:setName(nickname)
	self.nickname_ = nickname
	return self
end

function Task:getName()
	return self.nickname_
end

-- Task Workflow (start_()->start()->|update()|->stop()->stop_())

function Task:start(context)
end

function Task:start_(context)
	assert(context)
	self.context_ = context
	-- 当前Task入栈
	context:visitPush(self)

	if context.debug then
		-- 
		local level  = string.letsuffix(string.rep('+', context:visitingLevel()), 8)
		local ltype  = self:getTypePrefix(perfix, 8)
		local cname  = string.letsuffix(self:getClassname(), 25, '.')
		local status = string.letsuffix(" start ", 9, ' ')
		local tname  = self:getName()

		MUSE_BTREE_LOG (level .. ltype .. cname .. status .. tname)
	end
end

function Task:stop(context)
end

function Task:stop_(context)
	assert(context)

	-- 查看当前Task是否存在
	local index = context:visitObjectIndex(self)

	if not index then return
	end
	
	-- 将当前task出栈，
	-- decorator比较特殊，若当前task是decorator，其之上可能会存在sub-task
	-- 所以一并出栈
	local object = context:visitPeek()
	while object ~= self do
		object:stop (context)
		object:stop_(context)

		object = context:visitPeek()
	end

	object = context:visitPop()
	assert(self == object)

	if context.debug then
		-- 
		local level  = string.letsuffix(string.rep('+', index), 8)
		local ltype  = self:getTypePrefix(perfix, 8)
		local cname  = string.letsuffix(self:getClassname(), 25, '.')
		local status = string.format(" stop(%s) ", context:getStatusShort(self))
		local tname  = self:getName()
		
		MUSE_BTREE_LOG (level .. ltype .. cname .. status .. tname)
	end

end

--------------------------------------------------------------------------------
-- 要返回success, running, failure三者之一
-- 若返回success, 则表示成功, 随后会执行stop
-- 若返回failure, 则表示失败, 随后会指定stop
-- 若返回running, 则表示正在执行, 随后会一直运行update, 直到返回success或者failure
--------------------------------------------------------------------------------
function Task:update(context)	
	assert(context)
	assert(false)
	return context:success(self)
end

-- Type

function Task:setType(type)
	self.type_ = type
end

function Task:getType()
	return self.type_
end

-- Priority

function Task:setPriority(priority)
	self.priority_ = priority
	return self
end

function Task:getPriority()
	return self.priority_
end

-- Tree Visit

function Task:getParent()
	return self.parent_
end

function Task:setParent(parent)
	self.parent_ = parent
	return self
end

-- Debug

function Task:visit(callback, depth)
	callback(self, depth or 0)
end

function Task:getClassname()
	return self.class.__cname
end

function Task:getTypePrefix()
	local typeshort
	if self:getType() == Task.TYPE_CONDITIONAL then
		typeshort = "[CON]"
	elseif self:getType() == Task.TYPE_COMPOSITE then
		typeshort = "[COM]"
	elseif self:getType() == Task.TYPE_DECORATOR then
		typeshort = "[DEC]"
	elseif self:getType() == Task.TYPE_ACTION then
		typeshort = "[ACT]"
	elseif self:getType() == Task.TYPE_NONE then
		typeshort = "[NON]"
	end
	return typeshort
end

return Task