
local muse = muse
local Armature = ccs.Armature

function Armature:getBoneNames()
	return muse.ccs_Armature_getBoneNames(self)
end

