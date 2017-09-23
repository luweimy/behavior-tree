local print  = print
local Action = import("..base.Action")

--------------------------------------------------------------------------------
-- 打印日志
--------------------------------------------------------------------------------
local Log = class("Log", function(...)
	return Action.new(...)
end)

Log.message_ = nil

function Log:ctor()
end

function Log:message(message)
	self.message_ = message
	return self
end

-- Auto 

function Log:start(context)
end

function Log:update(context)
	print(self.message_)
	return context:success(self)
end

function Log:stop(context)
end

return Log