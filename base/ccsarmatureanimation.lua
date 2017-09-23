local muse = muse
local ArmatureAnimation = ccs.ArmatureAnimation

function ArmatureAnimation:stop()
	muse.ccs_ArmatureAnimation_stop(self)
	return self
end

function ArmatureAnimation:pause()
	muse.ccs_ArmatureAnimation_pause(self)
	return self
end

function ArmatureAnimation:resume()
	muse.ccs_ArmatureAnimation_resume(self)
	return self
end

function ArmatureAnimation:getAnimationNames()
	return muse.ccs_ArmatureAnimation_getAnimationNames(self)
end

function ArmatureAnimation:playOnce(key, completion)
	self:play(key, -1, 0)
	self:setMovementEventCallFunc(completion)
	return self
end

function ArmatureAnimation:playLoop(key, completion)
	self:play(key, -1, 1)
	self:setMovementEventCallFunc(completion)
	return self
end

function ArmatureAnimation:playSeq(keys, completion)
	if #keys == 0 then return 
	end
	local callback
	local index = 1
	callback = function(sender, movementType, movementID)
		index = index + 1
		local key = keys[index]

		if key then
			self:playOnce(key, callback)
		else
			if completion then 
				if (movementType == ccs.MovementEventType.loopComplete or 
					movementType == ccs.MovementEventType.complete) then
					completion(sender, movementType, movementID) 
				end
			end
		end
	end
	self:playOnce(keys[index], callback)
	return self
end

function ArmatureAnimation:clearFrameEvent()
	self:setMovementEventCallFunc(function()end)
end
