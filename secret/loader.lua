local player = game.Players.LocalPlayer
repeat wait() until game:IsLoaded()

if Key == nil then
    getgenv().Key = "ZeroFlux HUB"
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

--function sendnotification(title, subtitle)
	--Fluent:Notify({
		--Title = "ZeroFlux HUB",
		--Content = message,
		--SubContent = submessage, -- Optional
		--Duration = 5 -- Set to nil to make the notification not disappear
	--})
--end

function sendnotification(message, type, submessage)
    if type == false or type == nil then
        print("[ " .. Key .. " ]: " .. message)
    end
    if type == true or type == nil then
        Fluent:Notify({
			Title = Key,
			Content = message,
			SubContent = submessage, -- Optional
			Duration = 5 -- Set to nil to make the notification not disappear
		})
    end
en

sendnotification("Loader executed.", false)
--------------------------------------------------------------------------------------DEFINE----------------------------------------------------------------------------------------
local UIS = game:GetService("UserInputService")
local Touchscreen = UIS.TouchEnabled

--------------------------------------------------------------------------------------LISTS----------------------------------------------------------------------------------------
local games = {
    [142823291] = 'mm2',
    [123502902659217] = 'test'
}

--------------------------------------------------------------------------------------WHITE LIST-------------------------------------------------------------------------------
local listplayer = {
	["YaNeSkazy"] = true,
	["OTBEPTKA_2006"] = true,
	["KotKotoveevich"] = true,
	["lsad775"] = true,
}

local function checkPlayer(player)
	if listplayer[player.Name] then
		print(player.Name .. " успешно прошёл проверку белого списка.")
		sendnotification("Вы успешно прошли проверку белого списка.", nil)
		return true
	else
		sendnotification("Доступ запрещён: вы не в белом списке!", nil)
		wait(1)
		player:Kick("[ZeroFlux]/n Доступ запрещён: вы не в белом списке!")
		return false
	end
end
--------------------------------------------------------------------------------------LINK VERIFICATION-------------------------------------------------------------------------------
local scriptUrl = 'https://raw.githubusercontent.com/CrashCover123/ZeroFluxHUB/refs/heads/main/secret/loader.lua'


if not string.find(scriptUrl, 'CrashCover123') or scriptUrl ~= 'https://raw.githubusercontent.com/CrashCover123/ZeroFluxHUB/refs/heads/main/secret/loader.lua' then
    sendnotification("Ты используешь ПОДДЕЛЬНЫЙ скрипт  ❌")
	while true
		error("Detected fake script")
	end
	player:Kick("[ZeroFlux]/n Ты используешь ПОДДЕЛЬНЫЙ скрипт ❌")
    return
else
    sendnotification("Подтвержденная ссылка и создатель ✅")
end

--------------------------------------------------------------------------------------DEVICE CHECK------------------------------------------------------------------------------------
getgenv().R3TH_Device = Touchscreen and "Mobile" or "PC"
sendnotification(R3TH_Device .. " detected.", false)

if getgenv().R3TH_Device == "Mobile" then
    sendnotification("Мобильные устройства не поддерживаются, только ПК", nil)
    wait(2)
    player:Kick("[ZeroFlux]/n Мобильные устройства не поддерживаются, только ПК")
    return
end

sendnotification("Загрузка скрипта может занять некоторое время в зависимости от вашего ПК.", nil)
wait(2)

--------------------------------------------------------------------------------------LOADER----------------------------------------------------------------------------------------
if games[game.PlaceId] then
    sendnotification("Игра подерживается ✅", nil)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/CrashCover123/ZeroFluxHUB/refs/heads/main/game/games/' .. games[game.PlaceId] .. '.lua'))()
else
    sendnotification("Игра не подерживается ❌", nil)
	wait(2)
	player:Kick("[ZeroFlux] Игра не подерживается ❌")
end

