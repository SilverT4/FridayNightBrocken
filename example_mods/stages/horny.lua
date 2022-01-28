function onCreate()
	-- background shit
	makeLuaSprite('ground','ass',-285.95,-105.9)
	addLuaSprite('ground', false)

	makeLuaSprite('sky','vagina',-547.85,528.2)
	addLuaSprite('sky', false)



	addAnimatedLuaSprite('pll','dick',-136,568.35)
	addAnimationByPrefix('pll','bounce', 'ppopbop',24,true)
	addLuaSprite('pll', true)
	objectPlayAnimation('ppl','bounce', false)















	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

function onBeatHit()

end

function onStepHit()

end

function onUpdate()

end