
local coroutine  = coroutine
local string 	 = string
local Task 		 = import(".Task")
local Blackboard = import(".Blackboard")

local BehaviorTree = class("BehaviorTree")

-- 当前的线程(协程)，每次更新整棵树都会重新创建
BehaviorTree.currentThread_ = nil
-- 当前的Task(叶子节点)，只有在当前Task返回Running时才会记录
BehaviorTree.currentTask_ 	= nil
-- 整棵树的根节点
BehaviorTree.rootTask_ 		= nil
-- 更新间隔
BehaviorTree.delta_ 		= nil
-- 主体(行为树依赖的主体)
BehaviorTree.target_ 		= nil
-- 最后存储的状态
BehaviorTree.lastStatus_ 	= nil
-- 黑板
BehaviorTree.blackboard_ 	= nil
-- 调用堆栈
BehaviorTree.visitStack_	= nil
-- 状态map
BehaviorTree.statusMap_		= nil

BehaviorTree.debug 			= nil
BehaviorTree.restart 		= nil

-- 行为树三种状态
BehaviorTree.FAILURE 		= 1
BehaviorTree.RUNNING 		= 2
BehaviorTree.SUCCESS 		= 3

BehaviorTree.EVENT_BTREE_UPDATE 	= "EVENT_BTREE_UPDATE"
BehaviorTree.EVENT_BTREE_UPDATE_END = "EVENT_BTREE_UPDATE_END"

function BehaviorTree:ctor()
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    self.blackboard_ = Blackboard.new()
    self.visitStack_ = {}
    self.statusMap_  = {}
    self.debug     	 = false
    self.restart 	 = false
end

-- Public

--------------------------------------------------------------------------------
-- 设置/获得Blackboard
--------------------------------------------------------------------------------
function BehaviorTree:setBlackboard(blackboard)
	self.blackboard_ = blackboard
end
function BehaviorTree:getBlackboard()
	return self.blackboard_
end

--------------------------------------------------------------------------------
-- 设置/获得行为树依赖的主体
--------------------------------------------------------------------------------
function BehaviorTree:setTarget(target)
	self.target_ = target
end
function BehaviorTree:getTarget()
	return self.target_
end

--------------------------------------------------------------------------------
-- 设置行为树结构节点
--------------------------------------------------------------------------------
function BehaviorTree:setTree(tree)
	self.rootTask_ = tree
	return self
end

function BehaviorTree:setDebug(v)
	self.debug = v
end

--------------------------------------------------------------------------------
-- 中断正在running的任务
-- success有三种选择
--		- true : 子任务返回success,并且继续运行当前行为树
--		- false: 子任务返回failure,并且继续运行当前行为树
-- 		- 默认，重启行为树
-- 需要注意：
-- * 1.若为decorator，则interrupt中断，success(failure)是对decorator的返回结果
-- * 2.UntilFailure时，interrupt(true)，则UntilFailure返回success
-- * 3.decorator存在running状态，慎用此方法
--------------------------------------------------------------------------------
function BehaviorTree:interrupt(success)
	-- running, suspended, normal, dead
	if not self.currentThread_ or
		'suspended' ~= coroutine.status(self.currentThread_) then
		return 
	end
	if not self.currentTask_ then
		return
	end

	if true == success then
		self.currentTask_ = nil
		local ok, status, task, restart 
					= coroutine.resume(self.currentThread_, self:success())
		self:checkTask_(ok, status, task, restart)
	elseif false == success then
		self.currentTask_ = nil
		local ok, status, task, restart 
					= coroutine.resume(self.currentThread_, self:failure())
		self:checkTask_(ok, status, task, restart)
	else
		self.currentTask_ = nil
		while #self.visitStack_ > 0 do 
			local task = self.visitStack_[#self.visitStack_]
			task:stop (self)
			task:stop_(self)
		end
	end	
end

function BehaviorTree:getDelta()
	return self.delta_
end

--------------------------------------------------------------------------------
-- 调用update才能驱动行为树进行决策
--------------------------------------------------------------------------------
function BehaviorTree:update(delta)
	self.delta_ = delta

	-- 仅更新树中的Running-Task
	if self.currentTask_ then
		local status = self.currentTask_:update(self)
		-- 如果当前的Running-Task返回了结果(success或者failure)
		-- 则将其返回结果传递到之前yield的coroutine中，然后清空当前Task
		-- 否则继续更新当前Running-Task
		if status ~= BehaviorTree.RUNNING then
			self.currentTask_ = nil
			-- ok      - 协程是否正常执行
			-- status  - 挂起或正常结束返回的状态(seccess, failure, running)
			-- task    - 挂起的子Task
			-- restart - 是否是Action-Restart
			local ok, status, task, restart 
					= coroutine.resume(self.currentThread_, status)
			self:checkTask_(ok, status, task, restart)
		end
		return
	end

	-- 正常更新整棵树开始
    self:dispatchEvent({name=BehaviorTree.EVENT_BTREE_UPDATE})
	local thread = coroutine.create(handler(self, self.treeUpdate_))
	local ok, status, task, restart = coroutine.resume(thread, delta)
	self.currentThread_ = thread

	-- 检测运行结果
	self:checkTask_(ok, status, task, restart)

    self:dispatchEvent({name=BehaviorTree.EVENT_BTREE_UPDATE_END})
end

-- Current Visit

function BehaviorTree:visitPush(object)
	assert(object)
	table.insert(self.visitStack_, object)
end

function BehaviorTree:visitPop()
	local object = self.visitStack_[#self.visitStack_]
	table.remove(self.visitStack_)
	return object
end

function BehaviorTree:visitPeek()
	return self.visitStack_[#self.visitStack_]
end

function BehaviorTree:visitObjectIndex(object)
	return table.indexof(self.visitStack_, object)
end

function BehaviorTree:visitingDump()
	for _, task in pairs(self.visitStack_) do
		print(task.__cname,task:getName())
	end
end

function BehaviorTree:visitingLevel()
	return #self.visitStack_
end

function BehaviorTree:visitingClear()
	while #self.visitStack_ > 0 do
		table.remove(self.visitStack_)
	end
end

-- Current Status

function BehaviorTree:setStatus(status, object)
	if object then
		self.statusMap_[object] = status
	else
		self.lastStatus_ = status
	end
	return self
end

function BehaviorTree:getStatus(object)
	return self.statusMap_[object] or self.lastStatus_
end

function BehaviorTree:success(object)
	self:setStatus(BehaviorTree.SUCCESS, object)
	return BehaviorTree.SUCCESS
end

function BehaviorTree:failure(object)
	self:setStatus(BehaviorTree.FAILURE, object)
	return BehaviorTree.FAILURE
end

function BehaviorTree:running()
	return BehaviorTree.RUNNING
end

function BehaviorTree:result(ret, object)
	assert(type(ret) == 'boolean')
	if ret == true then
		return self:success(object)
	elseif ret == false then
		return self:failure(object)
	end
end

function BehaviorTree:getStatusShort(object)
	local lastStatus = self:getStatus(object)
	local result = "U"
		if lastStatus == BehaviorTree.SUCCESS then result = "S"
	elseif lastStatus == BehaviorTree.FAILURE then result = "F"
	elseif lastStatus == BehaviorTree.RUNNING then result = "R"
	end
	return result
end

-- Private

function BehaviorTree:treeUpdate_(delta)
	self:visitingClear()

	-- 进入更新
	self.rootTask_:start_(self)
	self.rootTask_:start (self)
	local status = self.rootTask_:update(self)
	self.rootTask_:stop (self)
	self.rootTask_:stop_(self)

	-- if status == BehaviorTree.FAILURE then
	-- 	MUSE_BTREE_LOG ("<BT> decision failure")
	-- end
	return status
end

--------------------------------------------------------------------------------
-- 判断更新树过程中是否产生了Running-Task
-- 若产生了Running-Task，则切换到只更新Running-Task
--------------------------------------------------------------------------------
function BehaviorTree:checkTask_(ok, status, task, restart)
	if restart then
		task:stop (self)
		task:stop_(self)
	end
	if ok then
		if status == BehaviorTree.RUNNING then
			self.currentTask_ = task
		end
	else 
		local errmsg = status
		MUSE_BTREE_LOG(string.format("<BT> %s", errmsg))
	end
end

return BehaviorTree