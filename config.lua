----   ____    ____         ----   
----  /\  _`\ /\  _`\       ----  
----  \ \ \/\ \ \ \L\ \     ----
----   \ \ \ \ \ \ ,  /     ----
----    \ \ \_\ \ \ \\ \    ----
----     \ \____/\ \_\ \_\  ----
----      \/___/  \/_/\/ /  ----

ESX               				= nil
local PlayerData                = {}
local PoliceJob 				= 'police'

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

-- RegisterNetEvent('esx:setJob')
-- AddEventHandler('esx:setJob', function(job)
	-- PlayerData.job = job
-- end)

local isJudge = false
local isPolice = false
local isSheriff = false
local isMechanic = false
local isMedic = false
local isDoctor = false
local isNews = false
local isPet = false
local isDead = false
local isInstructorMode = false
local myJob = "unemployed"
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}

rootMenuConfig =  {
    {
        id = "general",
        displayName = "Genel",
        icon = "#globe-europe",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"general:emotes", "general:tasi", "general:tasi2", "general:cancelemotes", "general:bagir", "general:bacik" }
    },
	{
        id = "police",
        displayName = "Polis/Sheriff",
        icon = "#police-action",
        enableMenu = function()
            return (not isDead and (isPolice or isSheriff))
        end,
        subMenus = {"cuffs:cuff", "cuffs:cuffsoft", "cuffs:uncuff", "police:escort", "police:putinvehicle", "police:unseatnearest", "cuffs:checkinventory", "police:faturacheck", "police:communityservice", "police:hapisatryuk", "police:impound", "police:opendoor", "police:runplate", "cuffs:revive", "gps:kodbelirle", "gps:kapat"}
    },
	{
        id = "polisobjeleri",
        displayName = "Polis/Sheriff Obje",
        icon = "#animation-hobo",
        enableMenu = function()
            return (not isDead and (isPolice or isSheriff))
        end,
        subMenus = {"policeobje:koni", "policeobje:bariyer", "policeobje:kapan", "policeobje:kutu", "policeobje:temizle" }
    },
	{
        id = "k9",
        displayName = "K9",
        icon = "#k9",
		functionName = "K9:OpenMenu",
        enableMenu = function()
            return (not isDead and isPolice)
        end,
        -- subMenus = {"k9:follow", "k9:vehicle", "k9:sit", "k9:stand", "k9:lay",  "k9:spawn", }
    },
	{
        id = "petmenu",
        displayName = "Pet Menü",
        icon = "#k9",
		functionName = "K9:OpenMenu",
        enableMenu = function()
            return (not isDead and isPet)
        end,
    },
	{
        id = "medic",
        displayName = "Doktor",
        icon = "#medic",
        enableMenu = function()
            return (not isDead and isMedic)
        end,
        subMenus = {"medic:revive", "medic:heal", "medic:bigheal", "medic:putinvehicle", "gps:kodbelirle", "gps:kapat"}
    },
	{
        id = "mechanic",
        displayName = "Mekanik",
        icon = "#police-vehicle",
        enableMenu = function()
            return (not isDead and isMechanic)
        end,
        subMenus = { "mechanic:hijack", "mechanic:repair", "mechanic:clean", "mechanic:impound"}
    },
	{
        id = "animations",
        displayName = "Yürüyüşler",
        icon = "#walking",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "animations:brave", "animations:hurry", "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien" }
    },
    {
        id = "kimlik",
        displayName = "Kimlik İşlemleri",
        icon = "#kimlik-islemler",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "kimlik:goster", "kimlik:gor", "meslek:gor"}
    },
    {
        id = "expressions",
        displayName = "Yüz İfadeleri",
        icon = "#expressions",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
    },
    {
        id = "blips",
        displayName = "İşaret",
        icon = "#blips",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "blips:gasstations", --[["blips:trainstations",]] "blips:garages","blips:eczane", "blips:barbershop", "blips:tattooshop"}
    },
	{
        id = "thief",
        displayName = "Soy",
        icon = "#human",
		functionName = "soyguncu",
        enableMenu = function()
            return not (isDead or isMedic or isPolice or isSheriff)
        end,
    },
    {
        id = "vehicleneon",
        displayName = "Neon Aç/Kapat",
        icon = "#general-check-vehicle",
        functionName = "neon:on",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end,
    },
    {
        id = "vehicle",
        displayName = "Araç",
        icon = "#vehicle-options-vehicle",
        functionName = "carcontrol:opens",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end,
    }
}

newSubMenus = {
    ['general:emotes'] = {
        title = "Animasyonlar",
        icon = "#general-emotes",
        functionName = "dp:RecieveMenu"
    },   
    ['general:cancelemotes'] = {
        title = "Animasyon İptali",
        icon = "#k9-dismiss",
        functionName = "cancelemotes"
    },    
    ['general:escort'] = {
        title = "Escort",
        icon = "#general-escort",
        functionName = "escortPlayer"
    },
    ['general:putinvehicle'] = {
        title = "Araca Bindir",
        icon = "#general-put-in-veh",
        functionName = "torchizm-radial:putInVehicle"
    },
    ['general:unseatnearest'] = {
        title = "Araçtan İndir",
        icon = "#general-unseat-nearest",
        functionName = "torchizm-radial:putOutVehicle"
    },    
    ['general:flipvehicle'] = {
        title = "Aracı çevir",
        icon = "#general-flip-vehicle",
        functionName = "FlipVehicle"
    },
    ['general:tasi'] = {
        title = "Taşı",
        icon = "#general-escort",
        functionName = "tasi"
    },
	['general:tasi2'] = {
        title = "Kucakla",
        icon = "#general-escort",
        functionName = "kucakla"
    },
	['general:bagir'] = {
        title = "Bağaja Gir",
        icon = "#police-vehicle",
        functionName = "bagir"
    },	
	['general:bacik'] = {
        title = "Bağajdan Çık",
        icon = "#police-vehicle",
        functionName = "bacik"
    },		
	['meslek:gor'] = {
        title = "Mesleğini Öğren",
        icon = "#kimlik-goster",
        functionName = "meslekbak"
    },
    ['animations:brave'] = {
        title = "Cesur",
        icon = "#animation-brave",
        functionName = "walkanimation",
        functionParameters = "move_m@casual@d"
    },
    ['kimlik:goster'] = {
        title = "Kimlik Göster",
        icon = "#kimlik-goster",
        functionName = "kimlikmenu",
        functionParameters = "goster"
    },
    ['kimlik:gor'] = {
        title = "Kimlik Gör",
        icon = "#kimlik-gor",
        functionName = "kimlikmenu",
        functionParameters = "gor"
    },
    ['kimlik:ehliyetgor'] = {
        title = "Ehliyet Gör",
        icon = "#kimlik-gor",
        functionName = "kimlikmenu",
        functionParameters = "ehliyetgor"
    },
    ['kimlik:ehliyetver'] = {
        title = "Ehliyet Ver",
        icon = "#kimlik-gor",
        functionName = "kimlikmenu",
        functionParameters = "ehliyetver"
    },
    ['animations:hurry'] = {
        title = "Hafif tempolu",
        icon = "#animation-hurry",
        functionName = "walkanimation",
        functionParameters = "move_m@gangster@var_i"
    },
    ['animations:business'] = {
        title = "İş adamı",
        icon = "#animation-business",
        functionName = "walkanimation",
        functionParameters = "move_m@gangster@var_e"
    },
    ['animations:tipsy'] = {
        title = "İçkili",
        icon = "#animation-tipsy",
        functionName = "walkanimation",
        functionParameters = "MOVE_M@DRUNK@VERYDRUNK"
    },
    ['animations:injured'] = {
        title = "Yaralı",
        icon = "#animation-injured",
        functionName = "walkanimation",
        functionParameters = "move_heist_lester"
    },
    ['animations:tough'] = {
        title = "Kaslı",
        icon = "#animation-tough",
        functionName = "walkanimation",
        functionParameters = "move_characters@michael@fire"
    },
    ['animations:sassy'] = {
        title = "Kadın",
        icon = "#animation-sassy",
        functionName = "walkanimation",
        functionParameters = "FEMALE_FAST_RUNNER"
    },
    ['animations:sad'] = {
        title = "Üzgün",
        icon = "#animation-sad",
        functionName = "walkanimation",
        functionParameters = "move_m@gangster@var_f"
    },
    ['animations:posh'] = {
        title = "Lüks",
        icon = "#animation-posh",
        functionName = "walkanimation",
        functionParameters = "move_m@bag"
    },
    ['animations:alien'] = {
        title = "Sarsılmış",
        icon = "#animation-alien",
        functionName = "walkanimation",
        functionParameters = "MOVE_M@BAIL_BOND_NOT_TAZERED"
    },
    ['animations:nonchalant'] =
    {
        title = "Soğuk",
        icon = "#animation-nonchalant",
        functionName = "walkanimation",
        functionParameters = "move_m@casual@d"
    },
    ['animations:hobo'] = {
        title = "Serseri",
        icon = "#animation-hobo",
        functionName = "walkanimation",
        functionParameters = "clipset@move@trash_fast_turn"
    },
    ['animations:money'] = {
        title = "Gösterişli",
        icon = "#animation-money",
        functionName = "walkanimation",
        functionParameters = "MOVE_M@POSH@"
    },
    ['animations:swagger'] = {
        title = "Çalım",
        icon = "#animation-swagger",
        functionName = "walkanimation",
        functionParameters = "move_characters@Jimmy@slow@"
    },
    ['animations:shady'] = {
        title = "Gölgeli",
        icon = "#animation-shady",
        functionName = "walkanimation",
        functionParameters = "move_p_m_zero_slow"
    },
    ['animations:maneater'] = {
        title = "Yamyam",
        icon = "#animation-maneater",
        functionName = "walkanimation",
        functionParameters = "ANIM_GROUP_MOVE_BALLISTIC"
    },
    ['animations:chichi'] = {
        title = "Korkak",
        icon = "#animation-chichi",
        functionName = "walkanimation",
        functionParameters = "move_f@scared"
    },
    ['animations:default'] = {
        title = "Normal",
        icon = "#animation-default",
        functionName = "walkanimation:default"
    },
    ['blips:gasstations'] = {
        title = "Benzin istasyonları",
        icon = "#blips-gasstations",
        functionName = "ygx:togglegas"
    },    
    ['blips:garages'] = {
        title = "Garajlar",
        icon = "#blips-garages",
        functionName = "ygx:togglegaraj"
    },['blips:eczane'] = {
        title = "Eczaneler",
        icon = "#eczane",
        functionName = "ygx:toggleeczane"
    },
    ['blips:barbershop'] = {
        title = "Berber",
        icon = "#blips-barbershop",
        functionName = "ygx:togglebarber"
    },    
    ['blips:tattooshop'] = {
        title = "Dövme",
        icon = "#blips-tattooshop",
        functionName = "ygx:toggletattos"
    },
	--POLIS
    ['cuffs:cuff'] = {
        title = "Sert Kelepçele",
        icon = "#cuffs-cuff",
        functionName = "esx_policejob:kelepcele"
    },
	['cuffs:cuffsoft'] = {
        title = "Hafif Kelepçele",
        icon = "#cuffs-cuff",
        functionName = "esx_policejob:kelepcelesoft"
    },
    ['cuffs:onHijacks'] = {
        title = "Araç Kapıs Açma",
        icon = "#cuffs-uncuff",
        functionName = "esx_policejob:onHijacks"
    },
    ['cuffs:uncuff'] = {
        title = "Kelepçeyi Çöz",
        icon = "#cuffs-uncuff",
        functionName = "esx_policejob:kelepcecoz"
    },
	['cuffs:revive'] = {
        title = "İlk Yardım",
        icon = "#medic-revive",
        functionName = "esx_policejob:iyilestir"
    },	
	['police:escort'] = {
        title = "Taşı",
        icon = "#general-escort",
        functionName = "esx_policejob:tasi"
    },
    ['police:putinvehicle'] = {
        title = "Araca Koy",
        icon = "#general-put-in-veh",
        functionName = "esx_policejob:aracakoy"
    },
    ['police:unseatnearest'] = {
        title = "Araçtan çıkart",
        icon = "#general-unseat-nearest",
        functionName = "esx_policejob:aractancikar"
    },
	['cuffs:checkinventory'] = {
        title = "Üstünü Ara",
        icon = "#cuffs-check-inventory",
        functionName = "esx_policejob:ustarama"
    },
	['police:faturacheck'] = {
        title = "Fatura Kontrol",
        icon = "#judge-licenses-grant-business",
        functionName = "esx_policejob:fatura"
    },
    ['police:communityservice'] = {
        title = "Kamu Hizmeti",
        icon = "#judge-licenses-grant-business",
        functionName = "esx_policejob:kamu"
    },
	['police:impound'] = {
        title = "Araca El Koy",
        icon = "#police-vehicle",
        functionName = "policearaccek"
    },
    ['police:faturr'] = {
        title = "Fatura Menüsü",
        icon = "#police-vehicle",
        functionName = "esx_policejob:fatura"
    },
    ['police:hapisatryuk'] = {
        title = "Hapis Menü",
        icon = "#judge-licenses-grant-business",
        functionName = "hapisryuk"
    },	
	-- ['ortak:eup'] = {
    --     title = "EUP Menu",
    --     icon = "#general-clothes",
    --     functionName = "eupmenu"
    -- },
	['police:runplate'] = {
        title = "Plaka Sorgu",
        icon = "#police-vehicle-plate",
        functionName = "esx_policejob:plakasorgu"
    },
	['policeobje:koni'] = {
        title = "Koni Yerleştir",
        icon = "#police-vehicle",
        functionName = "policejob:konikoy"
    },
	['policeobje:bariyer'] = {
        title = "Bariyer Yerleştir",
        icon = "#police-vehicle",
        functionName = "policejob:bariyerkoy"
    },
	['policeobje:kapan'] = {
        title = "Kapan Yerleştir",
        icon = "#police-vehicle",
        functionName = "policejob:kapankoy"
    },
	['policeobje:kutu'] = {
        title = "Kutu Yerleştir",
        icon = "#police-vehicle",
        functionName = "policejob:kutukoy"
    },
	['policeobje:temizle'] = {
        title = "Objeleri Kaldır",
        icon = "#police-vehicle",
        functionName = "policejob:objesil"
    },
	['gps:kodbelirle'] = {
        title = "GPS Aç",
        icon = "#police-action-gsr",
        functionName = "gps:ac"
    },
	['gps:kapat'] = {
        title = "GPS Kapat",
        icon = "#k9-spawn",
        functionName = "gps:kapat"
    },
	-- ['k9:spawn'] = {
        -- title = "K9 Menüsü",
        -- icon = "#k9-spawn",
        -- functionName = "K9:OpenMenu"
    -- },
    -- ['k9:follow'] = {
        -- title = "Takip Et",
        -- icon = "#k9-follow",
        -- functionName = "K9:ToggleFollow"
    -- },
    -- ['k9:vehicle'] = {
        -- title = "Araca bindir/indir",
        -- icon = "#k9-vehicle",
        -- functionName = "K9:vehicletoggle"
    -- },
    -- ['k9:sit'] = {
        -- title = "Otur",
        -- icon = "#k9-sit",
        -- functionName = "K9:sit" -- yanlış olabilir
    -- },
    -- ['k9:lay'] = {
        -- title = "Yat",
        -- icon = "#k9-lay",
        -- functionName = "K9:laydown"
    -- },
    -- ['k9:stand'] = {
        -- title = "Kalk",
        -- icon = "#k9-stand",
        -- functionName = "K9:standup"
    -- },
	--DOKTOR
	['medic:revive'] = {
        title = "İlk Yardım",
        icon = "#medic-revive",
        functionName = "esx_ambulancejob:iyilestir"
    },
    ['medic:heal'] = {
        title = "Küçük Yaraları İyileştir",
        icon = "#medic-heal",
        functionName = "esx_ambulancejob:bandajla"
    },
    ['medic:bigheal'] = {
        title = "Büyük Yaraları İyileştir",
        icon = "#medic-heal",
        functionName = "esx_ambulancejob:medkitle"
    },
    ['medic:putinvehicle'] = {
        title = "Araca Koy",
        icon = "#general-put-in-veh",
        functionName = "esx_ambulancejob:aracakoy"
    },
    ['medic:takeoutvehicle'] = {
        title = "Araçtan Çıkar",
        icon = "#general-unseat-nearest",
        functionName = "st:emstakeoutvehicle"
    },
	['medic:hastakaydi'] = {
        title = "Hasta Kaydı",
        icon = "#judge-licenses-grant-business",
        functionName = "esx_ambulancejob:hastakaydi"
    },
	--MEKANİK
	['mechanic:hijack'] = {
        title = "Kilit Aç",
        icon = "#police-vehicle",
        functionName = "esx_mechanicjob:onHijack"
    },
    ['mechanic:repair'] = {
        title = "Aracı Tamir Et",
        icon = "#police-vehicle",
        functionName = "nk_repair:MenuRipara"
    },
    ['mechanic:clean'] = {
        title = "Aracı Temizle",
        icon = "#police-vehicle",
        functionName = "esx_mechanicjob:temizle"
    },
    ['mechanic:impound'] = {
        title = "Aracı Çek",
        icon = "#police-vehicle",
        functionName = "esx_mechanicjob:araccek"
    },
    ["expressions:angry"] = {
        title="Kızgın",
        icon="#expressions-angry",
        functionName = "expressions",
        functionParameters =  "mood_angry_1" 
    },
    ["expressions:drunk"] = {
        title="Sarhoş",
        icon="#expressions-drunk",
        functionName = "expressions",
        functionParameters =  "mood_drunk_1" 
    },
    ["expressions:dumb"] = {
        title="Aptal",
        icon="#expressions-dumb",
        functionName = "expressions",
        functionParameters =  "pose_injured_1"
    },
    ["expressions:electrocuted"] = {
        title="Elektrik Çarpılmış",
        icon="#expressions-electrocuted",
        functionName = "expressions",
        functionParameters =  "electrocuted_1"
    },
    ["expressions:grumpy"] = {
        title="Huysuz",
        icon="#expressions-grumpy",
        functionName = "expressions", 
        functionParameters =  "mood_drivefast_1" 
    },
    ["expressions:happy"] = {
        title="Mutlu",
        icon="#expressions-happy",
        functionName = "expressions",
        functionParameters =  "mood_happy_1"
    },
    ["expressions:injured"] = {
        title="Yaralı",
        icon="#expressions-injured",
        functionName = "expressions",
        functionParameters =  "mood_injured_1"
    },
    ["expressions:joyful"] = {
        title="Neşeli",
        icon="#expressions-joyful",
        functionName = "expressions",
        functionParameters =  "mood_dancing_low_1"
    },
    ["expressions:mouthbreather"] = {
        title="Ağzı açık",
        icon="#expressions-mouthbreather",
        functionName = "expressions",
        functionParameters = "smoking_hold_1"
    },
    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        functionName = "expressions",
        functionParameters = "mood_normal_1"
    },
    ["expressions:oneeye"]  = {
        title="Tek göz",
        icon="#expressions-oneeye",
        functionName = "expressions",
        functionParameters = "pose_aiming_1"
    },
    ["expressions:shocked"]  = {
        title="Şok",
        icon="#expressions-shocked",
        functionName = "expressions",
        functionParameters = "shocked_1"
    },
    ["expressions:sleeping"]  = {
        title="Uykulu",
        icon="#expressions-sleeping",
        functionName = "expressions",
        functionParameters = "dead_1"
    },
    ["expressions:smug"]  = {
        title="Kendini beğenmiş",
        icon="#expressions-smug",
        functionName = "expressions",
        functionParameters = "mood_smug_1"
    },
    ["expressions:speculative"]  = {
        title="Düşünüyor",
        icon="#expressions-speculative",
        functionName = "expressions",
        functionParameters = "mood_aiming_1"
    },
    ["expressions:stressed"]  = {
        title="Stresli",
        icon="#expressions-stressed",
        functionName = "expressions",
        functionParameters = "mood_stressed_1"
    },
    ["expressions:sulking"]  = {
        title="Somurtma",
        icon="#expressions-sulking",
        functionName = "expressions",
        functionParameters = "mood_sulk_1" --
    },
    ["expressions:weird"]  = {
        title="Garip",
        icon="#expressions-weird",
        functionName = "expressions",
        functionParameters = "effort_2"
    },
    ["expressions:weird2"]  = {
        title="Garip 2",
        icon="#expressions-weird2",
        functionName = "expressions",
        functionParameters = "effort_3"
    }
}

Citizen.CreateThread(function()
    --while true do
        --Citizen.Wait(15000)
        --PlayerData = {}
            while PlayerData == nil or PlayerData.job == nil do
                Citizen.Wait(0)
            end
                
            if PlayerData.job.name == 'police' then
                isPolice = true
                isSheriff = false 
                isMedic = false 
                isNews = false
                isMechanic = false
				isPet = false
			elseif PlayerData.job.name == 'sheriff' then
                isPolice = false
				isSheriff = true
                isMedic = false 
                isNews = false
                isMechanic = false
				isPet = false
            elseif PlayerData.job.name == 'ambulance' then 
                isPolice = false
				isSheriff = false				
                isMedic = true
                isNews = false
                isMechanic = false
				isPet = false
            elseif PlayerData.job.name == "reporter" then 
                isPolice = false
				isSheriff = false				
                isMedic = false 
                isNews = true 
                isMechanic = false
				isPet = false
            elseif PlayerData.job.name == 'mechanic' then 
                isPolice = false
				isSheriff = false
                isMedic = false
                isNews = false
                isMechanic = true
				isPet = false
            elseif PlayerData.job.name == 'illegalmechanic' then 
                isPolice = false
				isSheriff = false
                isMedic = false
                isNews = false
                isMechanic = true
				isPet = false
            elseif PlayerData.job.name == 'ivan' then 
                isPolice = false
				isSheriff = false
                isMedic = false
                isNews = false
                isMechanic = false
				isPet = true
            elseif PlayerData.job.name == 'mechanic2' then 
                isPolice = false
				isSheriff = false
                isMedic = false
                isNews = false
                isMechanic = true
				isPet = false
            elseif PlayerData.job.name == 'mechanic3' then 
                isPolice = false
				isSheriff = false
                isMedic = false
                isNews = false
                isMechanic = true
				isPet = false
			elseif PlayerData.job.name == 'mechanic4' then 
                isPolice = false
				isSheriff = false
                isMedic = false
                isNews = false
                isMechanic = true
				isPet = false	
            else
                isPolice = false
				isSheriff = false				
                isMedic = false 
                isNews = false  
                isMechanic = false 
				isPet = false
            end

            myJob = job
           -- print(isPolice)
            --print(isMedic)
            --print(isNews)
   -- end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    if PlayerData.job.name == 'police' then
        isPolice = true
        isSheriff = false 
        isMedic = false 
        isNews = false
        isMechanic = false
        isPet = false
    elseif PlayerData.job.name == 'sheriff' then
        isPolice = false
        isSheriff = true
        isMedic = false 
        isNews = false
        isMechanic = false
        isPet = false
    elseif PlayerData.job.name == 'ambulance' then 
        isPolice = false
        isSheriff = false 
        isMedic = true
        isNews = false
        isMechanic = false
		isPet = false
    elseif PlayerData.job.name == "news" then 
        isPolice = false
        isSheriff = false 
        isMedic = false 
        isNews = true 
        isMechanic = false
		isPet = false
    elseif PlayerData.job.name == 'mechanic' then 
        isPolice = false
        isSheriff = false
        isMedic = false
        isNews = false
        isMechanic = true
		isPet = false
    elseif PlayerData.job.name == 'ivan' then 
        isPolice = false
        isSheriff = false
        isMedic = false
        isNews = false
        isMechanic = false
		isPet = true
    elseif PlayerData.job.name == 'mechanic1' then 
        isPolice = false
        isSheriff = false
        isMedic = false
        isNews = false
        isMechanic = true
		isPet = false
    elseif PlayerData.job.name == 'mechanic2' then 
        isPolice = false
        isSheriff = false
        isMedic = false
        isNews = false
        isMechanic = true
		isPet = false
    elseif PlayerData.job.name == 'mechanic3' then 
        isPolice = false
        isSheriff = false
        isMedic = false
        isNews = false
        isMechanic = true
		isPet = false
    elseif PlayerData.job.name == 'mechanic3' then 
        isPolice = false
        isSheriff = false
        isMedic = false
        isNews = false
        isMechanic = true
		isPet = false
    elseif PlayerData.job.name == 'mechanic4' then 
        isPolice = false
        isSheriff = false
        isMedic = false
        isNews = false
        isMechanic = true
		isPet = false
    else
        isPolice = false
        isSheriff = false 
        isMedic = false 
        isNews = false  
        isMechanic = false 
		isPet = false
    end

    myJob = job.name
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)

RegisterNetEvent("drivingInstructor:instructorToggle")
AddEventHandler("drivingInstructor:instructorToggle", function(mode)
    if myJob == "driving instructor" then
        isInstructorMode = mode
    end
end)

RegisterNetEvent("police:currentHandCuffedState")
AddEventHandler("police:currentHandCuffedState", function(pIsHandcuffed, pIsHandcuffedAndWalking)
    isHandcuffedAndWalking = pIsHandcuffedAndWalking
    isHandcuffed = pIsHandcuffed
end)

RegisterNetEvent("menu:hasOxygenTank")
AddEventHandler("menu:hasOxygenTank", function(pHasOxygenTank)
    hasOxygenTankOn = pHasOxygenTank
end)

RegisterNetEvent('enablegangmember')
AddEventHandler('enablegangmember', function(pGangNum)
    gangNum = pGangNum
end)

function GetPlayers()
    local players = {}

    for i = 0, 32 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end