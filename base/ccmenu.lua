--------------------------------------------------------------------------------
-- @module ccmenu
-- @desc 对ccmenu和ccmenuitem系列的函数扩展
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- cc.Menu
--------------------------------------------------------------------------------

local ccMenu = cc.Menu 

function ccMenu:enabled()
	self:setEnabled(true)
	return self
end

function ccMenu:disabled()
	self:setEnabled(false)
	return self
end

function ccMenu:alignv(padding)
	if padding then
		self:alignItemsVerticallyWithPadding(padding)
	else
		self:alignItemsVertically()
	end
	return self
end

function ccMenu:alignh(padding)
	if padding then
		self:alignItemsHorizontallyWithPadding(padding)
	else
		self:alignItemsHorizontally()
	end
	return self
end

--------------------------------------------------------------------------------
-- cc.MenuItem
--------------------------------------------------------------------------------

local ccMenuItem = cc.MenuItem

function ccMenuItem:enabled()
	self:setEnabled(true)
	return self
end

function ccMenuItem:disabled()
	self:setEnabled(false)
	return self
end

function ccMenuItem:listen(listener)
	if listener then
		self:registerScriptTapHandler(listener)
	end
	return self
end

--------------------------------------------------------------------------------
-- cc.MenuItemLabel
--------------------------------------------------------------------------------

local ccMenuItemLabel = cc.MenuItemLabel

function ccMenuItem:getString()
	return self:getLabel():getString()
end
