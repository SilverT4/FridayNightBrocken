function onCreate()

	makeLuaSprite('BG1','BG1',-970,-580)
	addLuaSprite('BG1',false)
    scaleObject('BG1',0.8,0.8)
	setLuaSpriteScrollFactor('BG1', 0.3, 0.3);

	makeLuaSprite('BG2','BG2',-1240,-650)
	addLuaSprite('BG2',false)
    scaleObject('BG2',0.5,0.5)
	setLuaSpriteScrollFactor('BG2', 0.6, 0.6);

end


function onBeatHit()-- for every beat
	-- body
end

function onStepHit()-- for every step
	-- body
end

function onUpdate()
	-- body
end
