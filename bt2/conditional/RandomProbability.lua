local Conditional 	    = import("..base.Conditional")

--------------------------------------------------------------------------------
-- 随机概率，可以指定概率返回成功
--------------------------------------------------------------------------------
local RandomProbability = class("RandomProbability", function(...)
	return Conditional.new(...)
end)

RandomProbability.probability_ = 0

function RandomProbability:ctor()
end

--------------------------------------------------------------------------------
-- RandomProbability
-- - probability: 返回success的概率[0,1]
--------------------------------------------------------------------------------
function RandomProbability:setProbability(probability)
	self.probability_ = probability
	return self
end

-- Auto 

function RandomProbability:start(context)
end

function RandomProbability:update(context)
	if math.ok(self.probability_) then
		return context:success(self)
	end
	return context:failure(self)
end

function RandomProbability:stop(context)
end

return RandomProbability