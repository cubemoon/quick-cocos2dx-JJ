local ui = {}

ui.JJButton  = import(".JJButton")
ui.JJCheckBox = import(".JJCheckBox")
ui.JJEditBox = import(".JJEditBox")
ui.JJSeekBar = import(".JJSeekBar")
ui.JJScrollView = import(".JJScrollView")
ui.JJBaseAdapter = import(".JJBaseAdapter")
ui.JJTableCell = import(".JJListCell")
ui.JJLabel = import(".JJLabel")
ui.JJToast = import(".JJToast")
ui.JJLoadingBar = import(".JJLoadingBar")
ui.JJDialog = import(".JJDialog")
ui.JJGalleryView = import(".JJGalleryView")
ui.JJViewGroup = import(".JJViewGroup")
ui.JJView = import(".JJView")
ui.JJListView = import(".JJListView")
ui.JJImage = import(".JJImage")
ui.JJAlertDialog = import(".JJAlertDialog")
ui.JJRootView = import(".JJRootView")
ui.JJLabelBMFont = import(".JJLabelBMFont")
ui.JJSprite = import(".JJSprite")
ui.JJLabelTTF = import(".JJLabelTTF")

local clickSound = nil
local bMute = false
local function initOnClickSound(sound)
	clickSound = sound
	audio.preloadSound(clickSound)
end

local function getOnClickSound()
	return clickSound
end

local function setMute(flag)
	bMute = flag
end

local function isMute()
	return bMute
end

ui.setOnClickSound = initOnClickSound
ui.getOnClickSound = getOnClickSound
ui.setOnClickSoundMute = setMute
ui.isOnClickSoundMute = isMute
return ui
