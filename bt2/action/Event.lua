local muse   = muse
local Action = import("..base.Action")

--------------------------------------------------------------------------------
-- 派发一个消息(Local or Global)
--------------------------------------------------------------------------------
local Event = class("Event", function(...)
	return Action.new(...)
end)

Event.event_ = nil
Event.global_ = nil

function Event:ctor()
	self.global_ = false
end

--------------------------------------------------------------------------------
-- 设置要派发的消息
-- - event: 消息结构，注意要与要派发的消息类型匹配
-- - global: 是否全局派发(默认false)
--------------------------------------------------------------------------------
function Event:event(event, global)
	self.event_  = event
	self.global_ = global
	return self
end

-- Auto 

function Event:start(context)
end

function Event:update(context)
	if self.event_ then
		if self.global_ then
			muse.mgr.event:dispatch(self.event_)
		else
			context:dispatchEvent(self.event_)
		end
	end
	return context:success(self)
end

function Event:stop(context)
end

return Event