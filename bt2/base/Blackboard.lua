local Blackboard = class("Blackboard")

Blackboard.publicMap_  = nil
Blackboard.privateMap_ = nil

function Blackboard:ctor()
	self.publicMap_  = {}
	self.privateMap_ = {}
end

-- Public Setter/Getter

function Blackboard:set(key, value)
	assert(not self.publicMap_[key])
	self.publicMap_[key] = value
end

function Blackboard:get(key)
	return self.publicMap_[key]
end

-- Private Setter/Getter

function Blackboard:privateSet(id, key, value)
	local map = self.privateMap_[id] or {}
	map[key]  = value
	self.privateMap_[id] = map
end

function Blackboard:privateGet(id, key)
	local map = self.privateMap_[id] or {}
	local value = map[key]
	self.privateMap_[id] = map
	return value
end

return Blackboard