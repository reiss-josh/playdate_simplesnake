local snd = playdate.sound

SoundManager = {}
SoundManager.kPowerUp = 'powerUp'
local sounds = {}
for _, v in pairs(SoundManager) do
	sounds[v] = snd.sampleplayer.new('Sounds/' .. v)
end
SoundManager.sounds = sounds
function SoundManager:playSound(name)
	self.sounds[name]:play(1)		
end