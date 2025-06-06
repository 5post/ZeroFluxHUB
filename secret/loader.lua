repeat task.wait() until game:IsLoaded()

local Key
if Key == nil then
    Key = "ZeroFlux HUB"
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local player = game.Players.LocalPlayer

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
end

if getgenv().r3thexecuted then 
    sendnotification("Скрипт уже запущен!", nil) 
    return 
end
getgenv().r3thexecuted = true

sendnotification("Loader executed.", false)

--------------------------------------------------------------------------------------DEFINE----------------------------------------------------------------------------------------
local UIS = game:GetService("UserInputService")
local Touchscreen = UIS.TouchEnabled

--------------------------------------------------------------------------------------LISTS----------------------------------------------------------------------------------------
local games = {
    [142823291] = 'mm2',
    [123502902659217] = 'test',
    [137175132329290] = 'test2',
    [107236557079189] = 'test3',
}

--------------------------------------------------------------------------------------WHITE LIST-------------------------------------------------------------------------------
local listplayer = {
    ["YaNeSkazy"] = true,
    ["OTBEPTKA_2006"] = true,
    ["KotKotoveevich"] = true,
    ["lsad775"] = true,
    ["Amerika_Obama"] = true,
    ["MNE_HOPMALNO1099"] = false, -- Пример заблокированного игрока
}

-- Проверка на белый список
local function checkWhitelist(player)
    if listplayer[player.Name] ~= nil then
        print(player.Name .. " успешно прошёл проверку белого списка.")
        sendnotification("Вы успешно прошли проверку белого списка.", nil)
        return true
    else
        sendnotification("Доступ запрещён: вы не в белом списке!", nil)
        task.wait(1)
        player:Kick("[ZeroFlux]\nДоступ запрещён: вы не в белом списке!")
        return false
    end
end

-- Проверка на блокировку
local function checkBlock(player)
    if listplayer[player.Name] == false then
        sendnotification("Доступ запрещён: вы были заблокированы!", nil)
        task.wait(1)
        player:Kick("[ZeroFlux]\nДоступ запрещён: вы были заблокированы!")
        return false
    else
        print(player.Name .. " не был заблокирован")
        sendnotification("Вы не заблокированы! Поздравляем!", nil, "Чтобы не получить блокировку, рекомендуется прочитать правила использования скрипта!")
        return true
    end
end

-- Основная функция для проверки игрока
local function checkPlayer(player)
    -- Сначала проверяем белый список
    if not checkWhitelist(player) then
        return false
    end
    -- Затем проверяем на блокировку
    return checkBlock(player)
end

--------------------------------------------------------------------------------------LINK VERIFICATION-------------------------------------------------------------------------------
local scriptUrl = 'https://raw.githubusercontent.com/CrashCover123/ZeroFluxHUB/refs/heads/main/secret/loader.lua'

if not string.find(scriptUrl, 'CrashCover123') or scriptUrl ~= 'https://raw.githubusercontent.com/CrashCover123/ZeroFluxHUB/refs/heads/main/secret/loader.lua' then
    sendnotification("Ты используешь ПОДДЕЛЬНЫЙ скрипт  ❌")
    wait(2)
    player:Kick("[ZeroFlux]\nТы используешь ПОДДЕЛЬНЫЙ скрипт ❌")
    return
else
    sendnotification("Подтвержденная ссылка и создатель ✅")
end

--------------------------------------------------------------------------------------DEVICE CHECK------------------------------------------------------------------------------------
local R3TH_Device = Touchscreen and "Mobile" or "PC"
sendnotification(R3TH_Device .. " detected.", false)

if R3TH_Device == "Mobile" then
    sendnotification("Мобильные устройства не поддерживаются, только ПК", nil)
    task.wait(2)
    player:Kick("[ZeroFlux]\nМобильные устройства не поддерживаются, только ПК")
    return
end

sendnotification("Загрузка скрипта может занять некоторое время в зависимости от вашего ПК.", nil)
task.wait(2)

--------------------------------------------------------------------------------------LOADER----------------------------------------------------------------------------------------
if games[game.PlaceId] then
    sendnotification("Игра поддерживается ✅", nil)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/CrashCover123/ZeroFluxHUB/refs/heads/main/game/games/' .. games[game.PlaceId] .. '.lua'))()
else
    sendnotification("Игра не поддерживается ❌", nil)
    task.wait(2)
    player:Kick("[ZeroFlux]\nИгра не поддерживается ❌")
end
