
-- 是否开启行为树调试的LOG
MUSE_BTREE_LOG = print

local BT = {}

--------------------------------------------------------------------------------
-- Behavior Tree
--------------------------------------------------------------------------------
BT.BehaviorTree = import(".base.BehaviorTree")

--------------------------------------------------------------------------------
-- Base
--------------------------------------------------------------------------------
BT.Task 		= import(".base.Task")
BT.Action 		= import(".base.Action")
BT.Decorator 	= import(".base.Decorator")
BT.Composite 	= import(".base.Composite")
BT.Conditional 	= import(".base.Conditional")

--------------------------------------------------------------------------------
-- Composite Tasks
--------------------------------------------------------------------------------
BT.Selector 		= import(".composite.Selector")
BT.Sequence 		= import(".composite.Sequence")
BT.RandomSelector 	= import(".composite.RandomSelector")
BT.RandomSequence   = import(".composite.RandomSequence")
BT.PrioritySelector = import(".composite.PrioritySelector")

--------------------------------------------------------------------------------
-- Conditional Tasks
--------------------------------------------------------------------------------
BT.RandomProbability = import(".conditional.RandomProbability")

--------------------------------------------------------------------------------
-- Decorator Tasks
--------------------------------------------------------------------------------
BT.Inverter 	= import(".decorator.Inverter")
BT.Repeater 	= import(".decorator.Repeater")
BT.Failure 	 	= import(".decorator.Failure")
BT.Success 		= import(".decorator.Success")
BT.UntilFailure = import(".decorator.UntilFailure")
BT.UntilSuccess = import(".decorator.UntilSuccess")

--------------------------------------------------------------------------------
-- Action Tasks
--------------------------------------------------------------------------------
BT.Event 		= import(".action.Event")
BT.Restart 		= import(".action.Restart")
BT.Invoke 		= import(".action.Invoke")
BT.Wait 		= import(".action.Wait")
BT.Log 			= import(".action.Log")
BT.Empty 		= import(".action.Empty")

return BT