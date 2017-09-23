--------------------------------------------------------------------------------
-- @module ccdrawnode
-- @desc 对cc.DrawNode和cc.NVGDrawNode系列的函数扩展
--------------------------------------------------------------------------------

local tolua = tolua

--------------------------------------------------------------------------------
-- cc.DrawNode
--------------------------------------------------------------------------------

local ccDrawNode = cc.DrawNode

function ccDrawNode:drawPoint( ... )
	tolua.getcfunction(self, "drawPoint")(self, ...)
	return self
end

function ccDrawNode:drawPoints( ... )
	tolua.getcfunction(self, "drawPoints")(self, ...)
	return self
end

function ccDrawNode:drawLine( ... )
	tolua.getcfunction(self, "drawLine")(self, ...)
	return self
end

function ccDrawNode:drawRect( ... )
	tolua.getcfunction(self, "drawRect")(self, ...)
	return self
end

function ccDrawNode:drawPoly( ... )
	tolua.getcfunction(self, "drawPoly")(self, ...)
	return self
end

function ccDrawNode:drawCircle( ... )
	tolua.getcfunction(self, "drawCircle")(self, ...)
	return self
end

function ccDrawNode:drawQuadBezier( ... )
	tolua.getcfunction(self, "drawQuadBezier")(self, ...)
	return self
end

function ccDrawNode:drawCubicBezier( ... )
	tolua.getcfunction(self, "drawCubicBezier")(self, ...)
	return self
end

function ccDrawNode:drawCardinalSpline( ... )
	tolua.getcfunction(self, "drawCardinalSpline")(self, ...)
	return self
end

function ccDrawNode:drawCatmullRom( ... )
	tolua.getcfunction(self, "drawCatmullRom")(self, ...)
	return self
end

function ccDrawNode:drawDot( ... )
	tolua.getcfunction(self, "drawDot")(self, ...)
	return self
end

function ccDrawNode:drawRect( ... )
	tolua.getcfunction(self, "drawRect")(self, ...)
	return self
end

function ccDrawNode:drawSolidRect( ... )
	tolua.getcfunction(self, "drawSolidRect")(self, ...)
	return self
end

function ccDrawNode:drawSolidPoly( ... )
	tolua.getcfunction(self, "drawSolidPoly")(self, ...)
	return self
end

function ccDrawNode:drawSolidCircle( ... )
	tolua.getcfunction(self, "drawSolidCircle")(self, ...)
	return self
end

function ccDrawNode:drawSegment( ... )
	tolua.getcfunction(self, "drawSegment")(self, ...)
	return self
end

function ccDrawNode:drawPolygon( ... )
	tolua.getcfunction(self, "drawPolygon")(self, ...)
	return self
end

function ccDrawNode:drawTriangle( ... )
	tolua.getcfunction(self, "drawTriangle")(self, ...)
	return self
end

function ccDrawNode:clear()
	tolua.getcfunction(self, "clear")(self)
	return self
end

--------------------------------------------------------------------------------
-- cc.NVGDrawNode
--------------------------------------------------------------------------------

local ccNVGDrawNode = cc.NVGDrawNode

function ccNVGDrawNode:drawPoint( ... )
	tolua.getcfunction(self, "drawPoint")(self, ...)
	return self
end

function ccNVGDrawNode:drawPoints( ... )
	tolua.getcfunction(self, "drawPoints")(self, ...)
	return self
end

function ccNVGDrawNode:drawLine( ... )
	tolua.getcfunction(self, "drawLine")(self, ...)
	return self
end

function ccNVGDrawNode:drawRect( ... )
	tolua.getcfunction(self, "drawRect")(self, ...)
	return self
end

function ccNVGDrawNode:drawPolygon( ... )
	tolua.getcfunction(self, "drawPolygon")(self, ...)
	return self
end

function ccNVGDrawNode:drawCircle( ... )
	tolua.getcfunction(self, "drawCircle")(self, ...)
	return self
end

function ccNVGDrawNode:drawQuadBezier( ... )
	tolua.getcfunction(self, "drawQuadBezier")(self, ...)
	return self
end

function ccNVGDrawNode:drawCubicBezier( ... )
	tolua.getcfunction(self, "drawCubicBezier")(self, ...)
	return self
end

function ccNVGDrawNode:drawDot( ... )
	tolua.getcfunction(self, "drawDot")(self, ...)
	return self
end

function ccNVGDrawNode:drawSolidRect( ... )
	tolua.getcfunction(self, "drawSolidRect")(self, ...)
	return self
end

function ccNVGDrawNode:drawSolidCircle( ... )
	tolua.getcfunction(self, "drawSolidCircle")(self, ...)
	return self
end

function ccNVGDrawNode:drawArc( ... )
	tolua.getcfunction(self, "drawArc")(self, ...)
	return self
end

function ccNVGDrawNode:drawSolidPolygon( ... )
	tolua.getcfunction(self, "drawSolidPolygon")(self, ...)
	return self
end

function ccNVGDrawNode:setColor( ... )
	tolua.getcfunction(self, "setColor")(self, ...)
	return self
end

function ccNVGDrawNode:setFillColor( ... )
	tolua.getcfunction(self, "setFillColor")(self, ...)
	return self
end

function ccNVGDrawNode:setFill( ... )
	tolua.getcfunction(self, "setFill")(self, ...)
	return self
end

function ccNVGDrawNode:setLineColor( ... )
	tolua.getcfunction(self, "setLineColor")(self, ...)
	return self
end

function ccNVGDrawNode:setLineWidth( ... )
	tolua.getcfunction(self, "setLineWidth")(self, ...)
	return self
end

function ccNVGDrawNode:setRadius( ... )
	tolua.getcfunction(self, "setRadius")(self, ...)
	return self
end

function ccNVGDrawNode:setOpacityf( ... )
	tolua.getcfunction(self, "setOpacityf")(self, ...)
	return self
end

function ccNVGDrawNode:addPoint( ... )	
	tolua.getcfunction(self, "addPoint")(self, ...)
	return self
end

function ccNVGDrawNode:setPoints( ... )
	tolua.getcfunction(self, "setPoints")(self, ...)
	return self
end

function ccNVGDrawNode:clear()
	tolua.getcfunction(self, "clear")(self)
	return self
end
