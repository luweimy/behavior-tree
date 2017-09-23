--------------------------------------------------------------------------------
-- @module cceventlistener
-- @desc 对cc.EventListener系列的函数扩展
--------------------------------------------------------------------------------

local ccEventListener = cc.EventListener

function ccEventListener:listen( ... )
	self:registerScriptHandler(...)
	return self
end

function ccEventListener:unlisten( ... )
	self:unregisterScriptHandler(...)
	return self
end
