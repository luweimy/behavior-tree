local Action = import("..base.Action")

--------------------------------------------------------------------------------
-- 等待指定的时间，在等待过程中一直返回running，最后返回success
--------------------------------------------------------------------------------
local Wait = class("Wait", function(...)
	return Action.new(...)
end)

Wait.waitsecond_  = 0
Wait.accumulator_ = 0

function Wait:ctor()
end

function Wait:time(time)
	self.waitsecond_ = time
	return self
end

-- Auto 

function Wait:start(context)
	self.accumulator_ = 0
end

function Wait:update(context)
	if self.accumulator_ >= self.waitsecond_ then
		return context:success(self)
	end
	self.accumulator_ = self.accumulator_ + context:getDelta()
	return context:running()
end

function Wait:stop(context)
end

return Wait