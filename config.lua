rootMenuConfig =  {
    {
        id = "emote",
        displayName = "ایموت",
        icon = "#emotes",
		enableMenu = function()
            return true
        end,
        subMenus = {"emote:emotes", "emote:chair", "emote:dance", "emote:cigar", "emote:clipboard", "emote:notepad", "emote:cop2"}
    },
    {
        id = "accessories",
        displayName = "لوازم",
        icon = "#accessories",
		enableMenu = function()
            return true
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
		subMenus = {"vehicle:engine", "vehicle:glovbox", "vehicle:changeseatDrvier", "vehicle:changeseat", "vehicle:inlight", "vehicle:doors"}
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
        functionParameters = "smoke2"
    },
    ['emote:chair'] = {
        title = "صندلی",
        icon = "#emotes-chair",
        functionName = "dpemotes:StartEmote",
        functionParameters = "sitchair2"
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
	
	['vehicle:changeseatDrvier'] = {
        title = "راننده",
        icon = "#vehicle-changeseat",
        functionName = "masterking32:SeatDriver",
        functionParameters = "-1"
    },
	['vehicle:changeseat'] = {
        title = "شاگرد",
        icon = "#vehicle-changeseat",
        functionName = "masterking32:SeatDriver",
        functionParameters = "0"
    },
	['vehicle:engine'] = {
        title = "موتور",
        icon = "#vehicle-engine",
        functionName = "master_radialmenu:EngineToggle"
    },
	['vehicle:inlight'] = {
        title = "داخلی",
        icon = "#vehicle-inlight",
        functionName = "master_radialmenu:InteriorLight"
    },
	['vehicle:doors'] = {
        title = "دربها",
        icon = "#vehicle-door",
        functionName = "master_radialmenu:DoorControl"
    },
	['vehicle:glovbox'] = {
        title = "داشبورد",
        icon = "#vehicle-glovbox",
        functionName = "Master_Inventory:OpenGlovBox"
    },
}

