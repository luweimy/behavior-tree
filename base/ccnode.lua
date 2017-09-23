--------------------------------------------------------------------------------
-- @module ccnode
-- @desc 对ccnode的函数扩展
--------------------------------------------------------------------------------

local tolua = tolua
local ccNode = cc.Node

ccNode.delay 	= ccNode.performWithDelay
ccNode.parent 	= ccNode.getParent
ccNode.position = ccNode.getPosition

function ccNode:retain()
	tolua.getcfunction(self, "retain")(self)
	return self
end

function ccNode:release()
	tolua.getcfunction(self, "release")(self)
	return self
end

function ccNode:pause()
    tolua.getcfunction(self, "pause")(self)
    return self
end

function ccNode:resume()
    tolua.getcfunction(self, "resume")(self)
    return self
end

function ccNode:run(action)
    self:runAction(action)
    return self
end

function ccNode:setName(name)
    tolua.getcfunction(self, "setName")(self, name)
    return self
end

function ccNode:getType()
    return tolua.type(self)
end

function ccNode:box()
    return self:getBoundingBox()
end

function ccNode:scale(...)
    self:setScale(...)
    return self
end

function ccNode:center(xx, yy)
    local xx = xx or 0
    local yy = yy or 0
    self:setPosition(display.cx+xx, display.cy+yy)
    return self
end

function ccNode:pos(x, y)
    if type(x) == "table" then
        self:setPosition(x)
    else
        self:setPosition(x, y)
    end
    return self
end

function ccNode:pos3(xx, yy, zz)
    xx = xx or 0
    yy = yy or 0
    zz = zz or 0
    self:setPosition3D(cc.vec3(xx, yy, zz))
    return self
end

function ccNode:px(xx)
	self:setPositionX(xx or 0)
	return self
end

function ccNode:py(yy)
	self:setPositionY(yy or 0)
	return self
end

function ccNode:pz(zz)
	self:setPositionZ(zz or 0)
	return self
end

function ccNode:offset(xx, yy, zz)
    xx = xx or 0
    yy = yy or 0
    zz = zz or 0
    local x, y = self:getPosition()
    local z = self:getPositionZ()
    self:setPosition(x+xx,y+yy)
    self:setPositionZ(z+zz)
    return self
end

function ccNode:ox(xx)
    local x = self:getPositionX()
    self:setPositionX(x+xx)
    return self
end

function ccNode:oy(yy)
    local y = self:getPositionY()
    self:setPositionY(y+yy)
    return self
end

function ccNode:oz(zz)
    local z = self:getPositionZ()
    self:setPositionZ(z+zz)
    return self
end

function ccNode:centerTo(node)
    local box = node:getBoundingBox()
    local cx, cy = box.width/2, box.height/2
    self:setPosition(cx, cy)
    return self
end

function ccNode:rightTopTo(node)
    local box = node:getBoundingBox()
    self:setPosition(box.width, box.height)
    return self
end

function ccNode:rightCenterTo(node)
    local box = node:getBoundingBox()
    self:setPosition(box.width, box.height/2)
    return self
end

function ccNode:rightBottomTo(node)
    local box = node:getBoundingBox()
    self:setPosition(box.width, 0)
    return self
end

function ccNode:leftTopTo(node)
    local box = node:getBoundingBox()
    self:setPosition(0, box.height)
    return self
end

function ccNode:parentCenter()
    local box = self:getParent():getBoundingBox()
    local cx, cy = box.width/2, box.height/2
    self:setPosition(cx, cy)
    return self
end

function ccNode:removeSelf()
    self:removeFromParent(true)
    return self
end

function ccNode:color(color)
	if color then
		self:setColor(color)
	end
	return self
end

function ccNode:anchor(anchorPoint)
    self:setAnchorPoint(anchorPoint)
    return self
end

function ccNode:tag(tag)
    self:setTag(tag)
    return self
end

function ccNode:name(name)
    self:setName(name)
    return self
end

function ccNode:userdata(userdata)
    self:setUserdata(userdata)
    return self
end

function ccNode:removeSelfDelay(delay)
    self:delay(function()
        self:removeSelf()
    end, delay)
    return self
end

function ccNode:setFlag0()
    self:setCameraMask(cc.CameraFlag.DEFAULT)
    return self
end
function ccNode:setFlag1()
    self:setCameraMask(cc.CameraFlag.USER1)
    return self
end
function ccNode:setFlag2()
    self:setCameraMask(cc.CameraFlag.USER2)
    return self
end

function ccNode:setFlag3()
    self:setCameraMask(cc.CameraFlag.USER3)
    return self
end

function ccNode:setFlag4()
    self:setCameraMask(cc.CameraFlag.USER4)
    return self
end

function ccNode:setFlag5()
    self:setCameraMask(cc.CameraFlag.USER5)
    return self
end

function ccNode:setFlag6()
    self:setCameraMask(cc.CameraFlag.USER6)
    return self
end

function ccNode:setFlag7()
    self:setCameraMask(cc.CameraFlag.USER7)
    return self
end

function ccNode:setFlag8()
    self:setCameraMask(cc.CameraFlag.USER8)
    return self
end

function ccNode:enabledNodeEvent()
    self:setNodeEventEnabled(true)
    return self
end

--------------------------------------------------------------------------------
-- @param: listener - node触摸监听事件
-- @return: self - 返回node自身和cc.EventListener(可用于删除监听)
--------------------------------------------------------------------------------
function ccNode:onTouch(listener)
    if not listener then return
    end

    local eventListener = cc.EventListenerTouchOneByOne:create()
    eventListener:setSwallowTouches(true)
    eventListener:listen(listener, cc.Handler.EVENT_TOUCH_BEGAN)
    eventListener:listen(listener, cc.Handler.EVENT_TOUCH_MOVED)
    eventListener:listen(listener, cc.Handler.EVENT_TOUCH_ENDED)
    eventListener:listen(listener, cc.Handler.EVENT_TOUCH_CANCELLED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(eventListener, self)
    return self, eventListener
end

--------------------------------------------------------------------------------
-- 深度遍历节点的所有下属节点
--------------------------------------------------------------------------------
function ccNode:deepTraverse(callback)
    assert(callback)
    local recursiveFunc
    recursiveFunc = function (node, depth)
        callback(node, depth)
        local children = node:getChildren()
        for _, child_node in pairs(children) do
            recursiveFunc(child_node, depth + 1)
        end
    end
    recursiveFunc(self, 0)
end

--------------------------------------------------------------------------------
-- 打印出节点的下属节点结构(层级减小时前面的节点是后面节点的父节点)
--------------------------------------------------------------------------------
function ccNode:dump()
    self:deepTraverse(function(node, index)
        local typename = node:getType()
        local shift = string.rep("+", index)
        local name = string.format("%s|%s(%s)",shift,typename,node:getName())
        echo (name)
    end)
end

--------------------------------------------------------------------------------
-- 深度遍历将下属节点全部暂停/恢复
--------------------------------------------------------------------------------
function ccNode:deepPause()
    self:deepTraverse(function(node)
        node:pause()
    end)
end

function ccNode:deepResume()
    self:deepTraverse(function(node)
        node:resume()
    end)
end

--------------------------------------------------------------------------------
-- 拦截触摸事件，使之不再继续向下传播，与[cc.Node:unswallow]匹配
--------------------------------------------------------------------------------
function ccNode:swallow()
    if self.__ccnode_swallow_listener__ then return self
    end
    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:listen(function(touch, event) 
        local box = self:getBoundingBox()
        if box.width == 0 or box.height == 0 then return true
        end
        box.x, box.y = 0, 0
        local curLoc = self:convertToNodeSpace(touch:getLocation())
        return cc.rectContainsPoint(box, curLoc)
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    self.__ccnode_swallow_listener__ = listener

    return self
end

--------------------------------------------------------------------------------
-- 取消拦截触摸事件，使之继续向下传播，与[cc.Node:swallow]匹配
--------------------------------------------------------------------------------
function ccNode:unswallow()
    if not self.__ccnode_swallow_listener__ then return self
    end

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:removeEventListener(self.__ccnode_swallow_listener__)
    self.__ccnode_swallow_listener__ = nil
    return self
end

--------------------------------------------------------------------------------
-- quick事件捕获，优先级较高
--------------------------------------------------------------------------------
function ccNode:capture()
    if self.__ccnode_capture_listener__ then return self
    end
    
    local listener = self:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function(event)
        if event.name == "began" then
            -- 在 began 状态返回 false，将阻止事件
            return false
        end
    end)

    self.__ccnode_capture_listener__ = listener

    return self
end

function ccNode:uncapture()
    if not self.__ccnode_capture_listener__ then return self
    end

    self:removeNodeEventListener(self.__ccnode_capture_listener__)
    self.__ccnode_capture_listener__ = nil
    return self
end

--------------------------------------------------------------------------------
-- 将触摸事件全部打印出来，用于调试
--------------------------------------------------------------------------------
function ccNode:dumpTouch(label)
	local label = label or "<?>"
    local s_x = 1
    local s_y = 1

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)

    listener:listen(function(touch, event)
        local curLoc = self:convertToNodeSpace(touch:getLocation())
        echo (string.format("ccNode# TOUCH-BEGAN\t: (%f, %f)", curLoc.x*s_x, curLoc.y*s_y),label)
        return true 
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    listener:listen(function(touch, event)
        local curLoc = self:convertToNodeSpace(touch:getLocation())
        echo (string.format("ccNode# TOUCH-MOVED\t: (%f, %f)", curLoc.x*s_x, curLoc.y*s_y),label)
    end, cc.Handler.EVENT_TOUCH_MOVED)

    listener:listen(function(touch, event)
        local curLoc = self:convertToNodeSpace(touch:getLocation())
        echo (string.format("ccNode# TOUCH-ENDED\t: (%f, %f)", curLoc.x*s_x, curLoc.y*s_y),label)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    listener:listen(function(touch, event)
        local curLoc = self:convertToNodeSpace(touch:getLocation())
        echo (string.format("ccNode# TOUCH-CANCELLED\t: (%f, %f)", curLoc.x*s_x, curLoc.y*s_y),label)
    end, cc.Handler.EVENT_TOUCH_CANCELLED)
    
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    return listener
end
