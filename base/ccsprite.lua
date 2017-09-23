--------------------------------------------------------------------------------
-- @module ccsprite
-- @desc 对ccsprite的函数扩展
--------------------------------------------------------------------------------

local ccSprite = cc.Sprite

local ccSprite_pressedListener = function(sender)
	sender.__color__ = sender.__color__ or sender:getColor()
	local offset = -50
	local newColor = cc.c3b(cc.clampf(sender.__color__.r+offset, 0, 255), 
							cc.clampf(sender.__color__.g+offset, 0, 255), 
							cc.clampf(sender.__color__.b+offset, 0, 255) )
	sender:color(newColor)
end

local ccSprite_unpressedListener = function(sender)
	sender:color(sender.__color__)
end

--------------------------------------------------------------------------------
-- @param: listener - 精灵点击监听事件
--         pressedListener - 精灵被按下时的回调
--         unpressedListener - 精灵释放时的回调
-- @return: self - 返回精灵自身
--			cc.EventListener - 可用于删除监听[cc.Sprite:unlisten]
-- @warning: 最好不要和swallow共同使用(先调用的优先级高)
--------------------------------------------------------------------------------
function ccSprite:listen(listener, pressedListener, unpressedListener)
	if not listener then return
	end

	local pressedListener = pressedListener or ccSprite_pressedListener
	local unpressedListener = unpressedListener or ccSprite_unpressedListener

	-- touch event listener to imp button logic
	local event_touchbegan = function(touch, event)
		local box = self:getBoundingBox()
		box.x, box.y = 0, 0
	    local curLoc = self:convertToNodeSpace(touch:getLocation())
	    if cc.rectContainsPoint(box, curLoc) then
	    	pressedListener(self)
	    	return true
	    end
	end
	local event_touchended = function(touch, event)
		unpressedListener(self)
		local box = self:getBoundingBox()
		box.x, box.y = 0, 0
	    local curLoc = self:convertToNodeSpace(touch:getLocation())
		if cc.rectContainsPoint(box, curLoc) then
			listener(self)
		end
	end
	local event_touchcancelled = function(touch, event)
		unpressedListener(self)
	end

    local eventListener = cc.EventListenerTouchOneByOne:create()
    eventListener:setSwallowTouches(true)
    eventListener:listen(event_touchbegan, cc.Handler.EVENT_TOUCH_BEGAN)
    eventListener:listen(event_touchended, cc.Handler.EVENT_TOUCH_ENDED)
    eventListener:listen(event_touchcancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(eventListener, self)
    return self, eventListener
end

--------------------------------------------------------------------------------
-- 删除精灵监听函数，与[cc.Sprite:listen]匹配
--------------------------------------------------------------------------------
function ccSprite:unlisten(eventListener)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:removeEventListener(eventListener)
	return self
end

--------------------------------------------------------------------------------
-- 给精灵设置shader
-- @param: script - 脚本muse.shader.script.gray
-- 		   params - 所有uniform参数
--------------------------------------------------------------------------------
function ccSprite:shader(script, params)
	muse.shader:set(self, script, params)
	return self
end

--------------------------------------------------------------------------------
-- 将精灵的shader设为默认的
--------------------------------------------------------------------------------
function ccSprite:clearShader()
	muse.shader:set(self, muse.shader.script.normal)
	return self
end


