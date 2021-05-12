rootMenuConfig =  {
    {
        id = "emote",
        displayName = "ایموت",
        icon = "#emotes",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"emote:emotes", "emote:dance", "emote:cigar", "emote:clipboard", "emote:notepad", "emote:cop2"}
    },
    {
        id = "accessories",
        displayName = "لوازم",
        icon = "#accessories",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"accessories:mp3player", "accessories:hlaptop"}
    },
    {
        id = "vehicle",
        displayName = "خودرو",
        icon = "#car",
        functionName = "carcontrol:opens",
        enableMenu = function()
            return (IsPedInAnyVehicle(PlayerPedId(), false))
        end,
    }
}

newSubMenus = {
    ['emote:emotes'] = {
        title = "منو",
        icon = "#emotes-menu",
        functionName = "dp:RecieveMenu"
    },
    ['emote:dance'] = {
        title = "رقص",
        icon = "#emotes-dance",
        functionName = "dpemotes:StartEmote",
        functionParameters = "dance"
    },
    ['emote:cigar'] = {
        title = "سیگار",
        icon = "#emotes-cigar",
        functionName = "dpemotes:StartEmote",
        functionParameters = "cigar"
    },
    ['emote:clipboard'] = {
        title = "یادداشتها",
        icon = "#emotes-clipboard",
        functionName = "dpemotes:StartEmote",
        functionParameters = "clipboard"
    }, 
    ['emote:notepad'] = {
        title = "نوشتن",
        icon = "#emotes-notepad",
        functionName = "dpemotes:StartEmote",
        functionParameters = "notepad"
    },
	['emote:cop2'] = {
        title = "پلیس",
        icon = "#emotes-cop2",
        functionName = "dpemotes:StartEmote",
        functionParameters = "cop2"
    },
	
	
	['accessories:mp3player'] = {
        title = "MP3 Player",
        icon = "#accessories-mp3player",
        functionName = "master_mp3player:openUI"
    },
	['accessories:hlaptop'] = {
        title = "Laptop",
        icon = "#accessories-hlaptop",
        functionName = "master_hlaptop:OpenUI"
    },
}

