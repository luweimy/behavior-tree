local Action = import("..base.Action")

local Empty = class("Empty", function(...)
	return Action.new(...)
end)


function Empty:ctor()
end

-- Auto 

function Empty:start(context)
end

function Empty:update(context)
	return context:success(self)
end

function Empty:stop(context)
end

return Empty