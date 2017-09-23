--------------------------------------------------------------------------------
-- @module cccamera
-- @desc 对cc.Camera系列的函数扩展
--------------------------------------------------------------------------------

local ccCamera = cc.Camera

function ccCamera:setFlag1()
	self:setCameraFlag(cc.CameraFlag.USER1)
	return self
end

function ccCamera:setFlag2()
	self:setCameraFlag(cc.CameraFlag.USER2)
	return self
end

function ccCamera:setFlag3()
	self:setCameraFlag(cc.CameraFlag.USER3)
	return self
end

function ccCamera:setFlag4()
	self:setCameraFlag(cc.CameraFlag.USER4)
	return self
end

function ccCamera:setFlag5()
	self:setCameraFlag(cc.CameraFlag.USER5)
	return self
end

function ccCamera:setFlag6()
	self:setCameraFlag(cc.CameraFlag.USER6)
	return self
end

function ccCamera:setFlag7()
	self:setCameraFlag(cc.CameraFlag.USER7)
	return self
end

function ccCamera:setFlag8()
	self:setCameraFlag(cc.CameraFlag.USER8)
	return self
end
