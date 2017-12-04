function init()
	self.inspectionRanges = {20, 30}
	activeItem.setCursor("/cursors/inspect.cursor")
	animator.setLightActive("flashlight", true)
end

function activate()
	local aimpos = activeItem.ownerAimPosition()
	if  world.magnitude(world.entityPosition(activeItem.ownerEntityId()), aimpos) < self.inspectionRanges[2] then --world.tileIsOccupied(aimpos) and 
--		local targetObj = world.objectAt(aimpos)
--		local target = nil
--		if targetObj then target = world.entityName(targetObj) else
		local target = world.material(aimpos, "foreground") or world.material(aimpos, "background") --end
		sb.logInfo("thingy at world position: %s", target)
--		if target and root.recipesForItem(target)[1] then sb.logInfo("%s -> player.giveBlueprint(target)", root.assetJson(root.materialPath(target)).description) end --, root.recipesForItem(target)
		if target then
			sb.logInfo("json: %s", sb.printJson(root.assetJson(root.materialPath(target))), true)
			world.sendEntityMessage(activeItem.ownerEntityId(), "interruptRadioMessage")
			world.sendEntityMessage(activeItem.ownerEntityId(), "queueRadioMessage", {messageId = "aaa", unique= false, text = root.assetJson(root.materialPath(target)).description, textSpeed = 70})
			buildProjectileThingy(world.entityPosition(activeItem.ownerEntityId()), root.assetJson(root.materialPath(target)).description)
		  if root.recipesForItem(target)[1] then sb.logInfo("%s -> player.giveBlueprint(target)", root.recipesForItem(target))  end
		end
	end
end

function uninit()
	animator.setLightActive("flashlight", false)
end

function update()
	self.aimAngle, self.facingDirection = activeItem.aimAngleAndDirection(0, activeItem.ownerAimPosition())
	activeItem.setFacingDirection(self.facingDirection)
	activeItem.setArmAngle(self.aimAngle)
end

function buildProjectileThingy(position, text, color, size, offset, duration, layer)
world.spawnProjectile("invisibleprojectile", position, 0, {0,0}, false,  {
		timeToLive = 0, damageType = "NoDamage", actionOnReap =
		{
			{
                action = "particle",
                specification = {
                    text =  text or "default Text",
                    color = color or {255, 255, 255, 255},  -- white
                    destructionImage = "/particles/acidrain/1.png",
                    destructionAction = "fade", --"shrink", "fade", "image" (require "destructionImage")
                    destructionTime = duration or 0.8,
                    layer = layer or "front",   -- 'front', 'middle', 'back' 
                    position = offset or {0, 2},
                    size = size or 0.7,  
                    approach = {0,20},    -- dunno what it is
                    initialVelocity = {0, 0.8},   -- vec2 type (x,y) describes initial velocity
                    finalVelocity = {0,0.5},
                    -- variance = {initialVelocity = {3,10}},  -- 'jitter' of included parameter
                    angularVelocity = 0,                                   
                    flippable = false,
                    timeToLive = duration or 2,
                    rotation = 0,
                    type = "text"                 -- our best luck
            	}
        	} 
    	}
    }
	)
end