ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

--- coords

open = false
local mainMenu = RageUI.CreateMenu("~b~SY_~r~ADMIN", "∑ Menu Coords", nil, nil, "sy_admin-banner", "sy_banner")
mainMenu.Closed = function() 
    open = false 
end

local function openMenuCoords()
    if open then 
        open = false 
        RageUI.Visible(mainMenu, false)
        return 
    else
        open = true 
        RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do 
                local coords = GetEntityCoords(PlayerPedId())                
                RageUI.IsVisible(mainMenu, function()

                    RageUI.Button("vector3("..coordsmenu.mainColor.."x~s~, "..coordsmenu.mainColor.."y~s~, "..coordsmenu.mainColor.."z~s~)", nil, {}, true, {
                        onSelected = function()
                            SendNUIMessage({
                                type = 'clipboard',
                                data = "vector3("..coords.x..", "..coords.y..", "..coords.z..")"
                            })
                            ESX.ShowAdvancedNotification('Coordonnées', "~g~Succès", "Coordonées copiées !\rContenu de la copie : ~b~vector3("..math.floor(coords.x)..", "..math.floor(coords.y)..", "..math.floor(coords.z)..")~s~", coordsmenu.CHAR, 0)
                        end
                    })

        
                    RageUI.Button("{x = "..coordsmenu.mainColor.."x~s~, y = "..coordsmenu.mainColor.."y~s~, z = "..coordsmenu.mainColor.."z~s~}", nil, {}, true, {
                        onSelected = function()
                            SendNUIMessage({
                                type = 'clipboard',
                                data = "{x = "..coords.x..", y = "..coords.y..", z = "..coords.z.."}"
                            })
                            ESX.ShowAdvancedNotification('Coordonnées', "~g~Succès", "Coordonées copiées !\rContenu de la copie : ~b~{x = "..math.floor(coords.x)..", y = "..math.floor(coords.y)..", z = "..math.floor(coords.z).."}", coordsmenu.CHAR, 0)
                        end
                    })

                    RageUI.Button(""..coordsmenu.mainColor.."x~s~, "..coordsmenu.mainColor.."y~s~, "..coordsmenu.mainColor.."z~s~", nil, {}, true, {
                        onSelected = function()
                            SendNUIMessage({
                                type = 'clipboard',
                                data = ""..coords.x..","..coords.y..","..coords.z..""
                            })
                            ESX.ShowAdvancedNotification('Coordonnées', "~g~Succès", "Coordonées copiées !\rContenu de la copie : ~b~"..math.floor(coords.x)..", "..math.floor(coords.y)..", "..math.floor(coords.z), coordsmenu.CHAR, 0)
                        end
                    })

                    RageUI.Button("Angle", nil, {}, true, {
                        onSelected = function()
                            local headingPed = GetEntityHeading(PlayerPedId())
                            SendNUIMessage({
                                type = 'clipboard',
                                data = headingPed
                            })
                            ESX.ShowAdvancedNotification('Coordonnées', "~g~Succès", "Angle copié !\rContenu de la copie : ~b~"..math.floor(headingPed), coordsmenu.CHAR, 0)
                            
                        end
                    })
                end)
                Wait(0)
            end
        end)
    end
end
----

local staffmode = false
local gamerTags = {}
local selected = nil
local name
local Items = {}

local function getPlayerInv(id)
	Items = {}
	
	ESX.TriggerServerCallback('SY_ADMIN:getOtherPlayerData', function(data)
		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(Items, {
					label    = data.inventory[i].label,
					right    = data.inventory[i].count,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end
	end, id)
end

local reportlist = {}
local function getInfoReport()
    local info = {}
    ESX.TriggerServerCallback('SY_ADMIN:infoReport', function(info)
        reportlist = info
    end)
end

RegisterNetEvent('SY_ADMIN:co')
AddEventHandler('SY_ADMIN:co', function(name)
    if staffmode then
        ESX.ShowNotification(('%s s\'est ~p~connecté(e)~s~.'):format(name))
    end
end)
RegisterNetEvent('SY_ADMIN:deco')
AddEventHandler('SY_ADMIN:deco', function(name)
    if staffmode then
        ESX.ShowNotification(('%s s\'est ~p~déconnecté(e)~s~.'):format(name))
    end
end)

RegisterNetEvent("SY_ADMIN:Open/CloseReport")
AddEventHandler("SY_ADMIN:Open/CloseReport", function(type, nomdumec)
    if type == 1 then
        if staffmode then ESX.ShowNotification('Un nouveau report à été effectué !') end
    elseif type == 2 then
        if staffmode then ESX.ShowNotification(('Le report de ~b~%s~s~ à été fermé !'):format(nomdumec)) end
    end
end)

RegisterNetEvent('SY_ADMIN:reportpris')
AddEventHandler('SY_ADMIN:reportpris', function(nom, staff)
    if staffmode then ESX.ShowNotification(("~r~Staff~s~\nReport de ~b~%s~s~ pris par ~b~%s~s~."):format(nom, staff)) end
end)

local resultItemC = {}
RegisterNetEvent('SY_ADMIN:resultItem')
AddEventHandler('SY_ADMIN:resultItem', function(resultItemS) resultItemC = resultItemS end)

RegisterCommand("tpm", function()
    if Required.TPM == true then
        if staffmode then
            TPMarker()
        else
            ESX.ShowNotification("~r~→~s~ Vous devez être en mode staff.")
        end
    else TPMarker() end
end)

RegisterCommand("spectate", function(source, args, rawCommand)
    if staffmode then 
        id = tonumber(args[1])
        SpectatePlayer(GetPlayerPed(GetPlayerFromServerId(id)), GetPlayerFromServerId(id), GetPlayerName(GetPlayerFromServerId(id))) 
    end
end)

RegisterCommand('pos', function()
    if staffmode then print(GetEntityCoords(PlayerPedId())) end
end)

local playerscacheC = {}
RegisterNetEvent('SY_ADMIN:listplayer')
AddEventHandler('SY_ADMIN:listplayer', function(playerscache) if staffmode then playerscacheC = playerscache end end)

--

RegisterCommand('openadminmenu', function()
    ESX.TriggerServerCallback('SY_ADMIN:getgroup', function(group)
        for _,v in pairs(Admin.Acces.General) do
            if group == v then
                OpenMenuAdmin(group)
            end
        end
    end)
end)

RegisterCommand('noclip', function()
    ESX.TriggerServerCallback('SY_ADMIN:getgroup', function(group)
        for _,v in pairs(Admin.Acces.Noclip) do
            if group == v then
                if Required.NoClip == true then 
                    if staffmode then 
                        NoCLIP()
                    else
                        ESX.ShowNotification("~r~→~s~ Vous devez être en mode staff.")
                    end 
                else 
                    NoCLIP()
                end
            end
        end   
    end)
end)

RegisterCommand('reviveall', function()
    ESX.TriggerServerCallback('SY_ADMIN:getgroup', function(group)
        for _,v in pairs(Admin.Acces.General) do
            if group == v then
                TriggerServerEvent('SY_ADMIN:reviveall')
            end
        end   
    end)
end)


RegisterKeyMapping('openadminmenu', '~r~[ADMIN]~s~ Ouvrir SY_ADMIN', 'keyboard', Control.MenuAdmin)
RegisterKeyMapping('noclip', '~r~[ADMIN]~s~ Touche pour NoClip', 'keyboard', Control.NoClip)

local open = false
local MainMenu = RageUI.CreateMenu("~b~SY_~r~ADMIN", "∑ Menu D'administration", nil, nil, "sy_admin-banner", "sy_banner") -- Mettre la banniere clasic : "commonmenu", "interaction_bgd")
local sub_menu1 = RageUI.CreateSubMenu(MainMenu, "~b~SY_~r~ADMIN", "∑ Gestions des Joueurs :")
local sub_menu2 = RageUI.CreateSubMenu(sub_menu1, "~b~SY_~r~ADMIN", "∑ Joueurs.")
local sub_menu3 = RageUI.CreateSubMenu(MainMenu, "~b~SY_~r~ADMIN", "∑ Items :")
local sub_menu4 = RageUI.CreateSubMenu(MainMenu, "~b~SY_~r~ADMIN", "∑ Operations Personnel :")
local sub_menu5 = RageUI.CreateSubMenu(MainMenu, "~b~SY_~r~ADMIN", "∑ Operation de Vehicules :")
local sub_menu6 = RageUI.CreateSubMenu(sub_menu3, "~b~SY_~r~ADMIN", "∑ Operation sur l'Item.")
local sub_menu7 = RageUI.CreateSubMenu(sub_menu2, "~b~SY_~r~ADMIN", "∑ Contenu de l'inventaire.")
local sub_menu8 = RageUI.CreateSubMenu(MainMenu, "~b~SY_~r~ADMIN", "∑ Gestions des Reports :")
local sub_menu9 = RageUI.CreateSubMenu(MainMenu, "~b~SY_~r~ADMIN", "∑ Operation sur le Report.")
MainMenu.Display.Header = true
MainMenu.Closed = function()
    open = false
end

local filterArray = { "Aucun", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1

local Customs = {
    List1 = 1,
    List2 = 1,
    List3 = 1, 
    List4 = 1,
    List5 = 1,
    List6 = 1,
    List7 = 1
}

function RageUI.Info(Title, RightText, LeftText)
    local LineCount = #RightText >= #LeftText and #RightText or #LeftText
    if Title ~= nil then
        RenderText("~h~" .. Title .. "~h~", 332 + 20 + 100, 7, 0, 0.34, 255, 255, 255, 255, 0)
    end
    if RightText ~= nil then
        RenderText(table.concat(RightText, "\n"), 332 + 20 + 100, Title ~= nil and 37 or 7, 0, 0.28, 255, 255, 255, 255, 0)
    end
    if LeftText ~= nil then
        RenderText(table.concat(LeftText, "\n"), 332 + 332 + 100, Title ~= nil and 37 or 7, 0, 0.28, 255, 255, 255, 255, 2)
    end
    RenderRectangle(332 + 10 + 100, 0, 332, Title ~= nil and 50 + (LineCount * 20) or ((LineCount + 1) * 20), 0, 0, 0, 160)
end

function OpenMenuAdmin(group)
    if open then
        open = false
        RageUI.Visible(MainMenu, false)
    else
        open = true
        RageUI.Visible(MainMenu, true)
        Citizen.CreateThread(function()
            while open do
                Wait(0)

                RageUI.IsVisible(MainMenu, function()
                    RageUI.Checkbox("~g~Activer~s~ / ~r~Désactiver~s~ le Mode STAFF !", "Le mode staff ne peut être utilisé que pour modérer le serveur, tout abus sera sévèrement puni, l'intégralité de vos actions sera enregistrée.", staffmode, {RightLabel = ""}, {                       
                        onChecked = function()                            
                            staffmode = true                          
                        end,
                        onUnChecked = function()
                            staffmode = false
                            ShowName = false
                            godmod = false
                            invisible = false
                            for _, v in pairs(GetActivePlayers()) do
                                RemoveMpGamerTag(gamerTags[v])
                            end
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                SetEntityVisible(Vehicle, true)
                            else
                                SetEntityVisible(PlayerPedId(), true)
                            end
                            SetEntityInvincible(PlayerPedId(), false)
                        end
                    })
                    if not staffmode then
                        RageUI.Info('Vos Infos :', {'Steam ~b~: ','ID :~g~ ','Permition :~o~ '}, { GetPlayerName(PlayerId()), GetPlayerServerId(PlayerId()), group })                          
                        RageUI.Line()
                        --[[RageUI.Separator(("⚠️"))
                        RageUI.Separator(("Le mode staff ne peut être utilisé que pour"))
                        RageUI.Separator(("Modérer le serveur. En HRP uniquement."))]]
                        RageUI.Button(NAMEBUTTOM.Report, nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, {})
                        RageUI.Button(NAMEBUTTOM.Player, nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, {})
                        RageUI.Button(NAMEBUTTOM.Perso, nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, {})
                        RageUI.Button(NAMEBUTTOM.Vehicle, nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, {})
                        RageUI.Button(NAMEBUTTOM.Item, nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, {})
                    end
                    if staffmode then
                        RageUI.Line()
                        RageUI.Button(NAMEBUTTOM.Report, nil, {RightBadge = RageUI.BadgeStyle.Ammo}, true, { onSelected = function() getInfoReport() end }, sub_menu8)
                        RageUI.Button(NAMEBUTTOM.Player, nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, {}, sub_menu1)
                        RageUI.Button(NAMEBUTTOM.Perso, nil, {RightBadge = RageUI.BadgeStyle.Armour}, true, {}, sub_menu4)
                        RageUI.Button(NAMEBUTTOM.Vehicle, nil, {RightBadge = RageUI.BadgeStyle.Car}, true, {}, sub_menu5)
                        RageUI.Button(NAMEBUTTOM.Item, nil, {RightBadge = RageUI.BadgeStyle.Mask}, true, { onSelected = function() TriggerServerEvent('SY_ADMIN:getItem') end }, sub_menu3)
                    end
                end)
                

                RageUI.IsVisible(sub_menu1, function()
                    RageUI.List("Filtre:", filterArray, Customs.List3, nil, {Preview}, true, {
                        onListChange = function(i, Item)
                            Customs.List3 = i
                            filter = i
                        end,
                    })
                    RageUI.Line()
                    for _,v in pairs(playerscacheC) do
                        if Customs.List3 == 1 then
                            RageUI.Button(("[~b~%s~s~] | ~b~%s~s~"):format(v.id, v.name), nil, {RightLabel = "→"}, true, {
                                onSelected = function() selected = _ end
                            }, sub_menu2)
                        end
                        if starts(v.name:lower(), filterArray[filter]:lower()) then
                            RageUI.Button(("[~b~%s~s~] | ~b~%s~s~"):format(v.id, v.name), nil, {RightLabel = "→"}, true, {
                                onSelected = function() selected = _ end
                            }, sub_menu2)
                        end
                    end
                end)

                RageUI.IsVisible(sub_menu2, function()
                    if (selected == nil) then return else
                        if (not playerscacheC[selected]) then RageUI.GoBack() else
                            local player = playerscacheC[selected]
                            RageUI.Separator(("Id:~b~ %s~s~"):format(player.id))
                            RageUI.Separator(("Steam:~b~ %s~s~"):format(player.name))
                            RageUI.Separator(("Argent: ~b~%s$~s~"):format(player.money))
                            RageUI.Separator(("Métier: ~b~%s~s~ | Grade: ~b~%s~s~"):format(player.job.label, player.job.grade_label))
                     --       RageUI.Separator(("Gang: ~b~%s~s~ | Grade: ~b~%s~s~"):format(player.job2.label, player.job2.grade_label))
                            RageUI.Line()
                            RageUI.Checkbox("Freeze/Defreeze", nil, freeze, {RightLabel = ""}, {
                                onChecked = function()
                                    freeze = true
                                    TriggerServerEvent('SY_ADMIN:freezeS', player.id, 1)
                                end,
                                onUnChecked = function()
                                    freeze = false
                                    TriggerServerEvent('SY_ADMIN:freezeS', player.id, 2)
                                end
                            })
                            RageUI.Button("Spectate", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    SpectatePlayer(GetPlayerPed(GetPlayerFromServerId(player.id)), GetPlayerFromServerId(player.id), GetPlayerName(GetPlayerFromServerId(player.id))) 
                                end
                            })
                            RageUI.Button("Se TP sur lui", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TpSurId(player.id)
                                end
                            })
                            RageUI.Button("Se TP sur Moi", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TriggerServerEvent('SY_ADMIN:bring', player.id, GetEntityCoords(PlayerPedId()))
                                end
                            })
                            RageUI.Button("Spawn une Blista", "", {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand('car blista')
                                end
                            })
                            RageUI.Button("Soigner", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TriggerServerEvent('SY_ADMIN:healS', player.id)
                                    ESX.ShowNotification("Joueur soigner avec ~g~succès~s~.")
                                end
                            })
                            RageUI.Button("Revive", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TriggerEvent('SY_ADMIN:reviveS', player.id)
                                end
                            })
                            RageUI.Button("L'envoler", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TriggerServerEvent('SY_ADMIN:slapS', player.id)
                                end
                            })
                            RageUI.Button("Crash", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TriggerServerEvent("SY_ADMIN:crash", player.id)
                                end
                            })
                            RageUI.Button("Envoyer un message", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local text = KeyboardInput("Votre message", "", 255)
                                    if text ~= "" then
                                        TriggerServerEvent("SY_ADMIN:message", player.id, ("~r~Staff~s~\n%s"):format(text))
                                    end
                                end
                            })
                            RageUI.Button("Kick", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local reason = KeyboardInput("Raison", "", 255)
                                    if reason  ~= "" then
                                        if reason  ~= nil then TriggerServerEvent('SY_ADMIN:kick', player.id, reason) end
                                    end
                                end
                            })
                            RageUI.Button("Inventaire", nil, {RightLabel = "→"}, true, { onSelected = function() getPlayerInv(player.id) pId = player.id end }, sub_menu7)
                            RageUI.List("Give money", {"Banque", "Cash", "Sale"}, Customs.List6, nil, {Preview}, true, {
                                onListChange = function(i, Item)
                                    Customs.List6 = i;
                                end,
                                onSelected = function()
                                    if Customs.List6 == 1 then
                                        local amount = KeyboardInput("Montant", "", 10)
                                        if amount ~= "" then
                                            TriggerServerEvent('SY_ADMIN:givemoneybank', player.id, amount)
                                        end
                                    elseif Customs.List6 == 2 then
                                        local amount = KeyboardInput("Montant", "", 10)
                                        if amount ~= "" then
                                            TriggerServerEvent('SY_ADMIN:givemoneycash', player.id, amount)
                                        end
                                    elseif Customs.List6 == 3 then
                                        local amount = KeyboardInput("Montant", "", 10)
                                        if amount ~= "" then
                                            TriggerServerEvent('SY_ADMIN:givemoneysale', player.id, amount)
                                        end
                                    end
                                end
                            })
                            RageUI.List("Setjob", {"Job1", "Job2"}, Customs.List2, nil, {Preview}, true, {
                                onListChange = function(i, Item)
                                    Customs.List2 = i;
                                end,
                                onSelected = function()
                                    if Customs.List2 == 1 then
                                        local job = KeyboardInput("Job", "", 15)
                                        local grade = KeyboardInput("Grade", "", 15)
                                        if job ~= "" and grade ~= "" then
                                            TriggerServerEvent('SY_ADMIN:setjob', player.id, job, grade)
                                        end
                                    elseif Customs.List2 == 2 then
                                        local job = KeyboardInput("Job", "", 15)
                                        local grade = KeyboardInput("Grade", "", 15)
                                        if job ~= "" and grade ~= "" then
                                            TriggerServerEvent('SY_ADMIN:setjob2', player.id, job, grade)
                                        end
                                    end
                                end
                            })
                            RageUI.List("Téléporter", {"MASEBANK", "Au PC", "Hôpital", "PDP", "Vetement", "Sandy Shores", "Paleto", "Epicerie"}, Customs.List4, nil, {Preview}, true, {
                                onListChange = function(i, Item)
                                    Customs.List4 = i;
                                end,

                                onSelected = function()
                                    if Customs.List4 == 1 then
                                        TriggerServerEvent('SY_ADMIN:tpS', player.id, TP.MASEBANK)
                                    elseif Customs.List4 == 2 then
                                        TriggerServerEvent('SY_ADMIN:tpS', player.id, TP.PC)
                                    elseif Customs.List4 == 3 then
                                        TriggerServerEvent('SY_ADMIN:tpS', player.id, TP.Hopital)
                                    elseif Customs.List4 == 4 then
                                        TriggerServerEvent('SY_ADMIN:tpS', player.id, TP.PDP)
                                    elseif Customs.List4 == 5 then
                                        TriggerServerEvent('SY_ADMIN:tpS', player.id, TP.Vetement)
                                    elseif Customs.List4 == 6 then
                                        TriggerServerEvent('SY_ADMIN:tpS', player.id, TP.SandyShores)
                                    elseif Customs.List4 == 7 then
                                        TriggerServerEvent('SY_ADMIN:tpS', player.id, TP.Paleto)
                                    elseif Customs.List4 == 8 then
                                        TriggerServerEvent('SY_ADMIN:tpS', player.id, TP.Epicerie)
                                    end
                                end
                            })
                            RageUI.List("Wipe", {"Complet", "Inventaire"}, Customs.List7, nil, {Preview}, true, {
                                onListChange = function(i, Item)
                                    Customs.List7 = i;
                                end,

                                onSelected = function()
                                    if Customs.List7 == 1 then
                                        TriggerServerEvent('SY_ADMIN:wipe', player.id)
                                    elseif Customs.List7 == 2 then
                                        ExecuteCommand(('clearinventory %s'):format(player.id))
                                    end
                                end
                            })
                        end
                    end
                end)

                RageUI.IsVisible(sub_menu7, function()
                    for k,v  in pairs(Items) do
                        RageUI.Button(("~b~→~s~ %s"):format(v.label), nil, {RightLabel = ("~b~x%s~s~"):format(v.right)}, true, {
                            onSelected = function()
                                local amount = KeyboardInput("Quantité", "", 5)
                                if amount ~= "" then
                                    if amount ~= nil then
                                        TriggerServerEvent('SY_ADMIN:removeinventory', pId, v.value, amount)
                                        getPlayerInv(pId)
                                    end
                                end
                            end
                        })
                    end	
                end)

                RageUI.IsVisible(sub_menu8, function()
                    if #reportlist > 0 then
                        for k,v in pairs(reportlist) do
                            RageUI.Button(('%s - Report de  ~b~%s~s~  | Id :  ~b~%s~s~ '):format(k, v.nom, v.id), nil, {RightLabel = '→→'}, true, {
                                onSelected = function()
                                    nom = v.nom
                                    nbreport = k
                                    id = v.id
                                    raison = v.args
                                end
                            }, sub_menu9)
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Aucun Report~s~")
                        RageUI.Separator("")
                    end
                end)

                RageUI.IsVisible(sub_menu9, function()
                    RageUI.Separator("")
                    RageUI.Separator(("Report numéro : ~b~%s~s~"):format(nbreport))
                    RageUI.Separator(("Auteur : ~b~%s~s~ [ ~b~%s~s~ ]"):format(nom, id))
                    RageUI.Separator("")

                    RageUI.Button("Raison du report", raison, {RightLabel = '→→'}, true, {})
                    RageUI.Button(('S\'occuper du report de ~b~%s~s~'):format(nom), nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            TriggerServerEvent("SY_ADMIN:prendre_report", nom)
                        end
                    })
                    RageUI.Button(('Se téléporter sur ~b~%s~s~'):format(nom), nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            TpSurId(id)
                        end
                    })
                    RageUI.Button(('Téléporter ~b~%s~s~ sur moi'):format(nom), nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            TriggerServerEvent('SY_ADMIN:bring', id, GetEntityCoords(PlayerPedId()))
                        end
                    })
                    RageUI.Button('Répondre au report', nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            local reponse = KeyboardInput('~c~Entrez le message ici :', nil, 30)
                            local reponseReport = GetOnscreenKeyboardResult(reponse)
                            if reponseReport == "" then
                                ESX.ShowNotification("~r~Admin\n~r~Vous n'avez pas fourni de message")
                            else
                                if reponseReport then
                                    ESX.ShowNotification(("Le message : ~b~%s~s~ a été envoyer à ~r~%s~s~"):format(reponseReport, GetPlayerName(GetPlayerFromServerId(id))) )
                                    TriggerServerEvent("SY_ADMIN:message", id, ("~r~Staff~s~\n%s"):format(reponseReport))
                                end
                            end
                        end
                    })
                    RageUI.Button(('Fermer le report de ~b~%s~s~'):format(nom), nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            TriggerServerEvent('SY_ADMIN:CloseReport', nom, raison)
                            TriggerServerEvent("SY_ADMIN:message", id, "Votre report à été fermé !")
                            RageUI.GoBack()
                        end
                    })
                end)

                RageUI.IsVisible(sub_menu3, function()
                    RageUI.List("Filtre:", filterArray, Customs.List5, nil, {Preview}, true, {
                        onListChange = function(i, Item)
                            Customs.List5 = i
                            filter = i
                        end,
                    })
                    RageUI.Line()
                    for _,v in pairs(resultItemC) do
                        if Customs.List5 == 1 then
                            RageUI.Button(v.label, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    name = v.name
                                end
                            }, sub_menu6)
                        end
                        if starts(v.label:lower(), filterArray[filter]:lower()) then
                            RageUI.Button(v.label, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    name = v.name
                                end
                            }, sub_menu6)
                        end
                    end
                end)

                RageUI.IsVisible(sub_menu6, function()
                    RageUI.Button("Donner l'item à un joueur", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local id = KeyboardInput("Id du joueur", "", 3)
                            local qtty = KeyboardInput("Quantité", "", 4)
                            if id ~= "" then
                            if qtty ~= "" then
                                TriggerServerEvent('SY_ADMIN:giveitem', id, name, qtty)
                            end
                            end
                        end
                    })
                    RageUI.Button("Se give l'item", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local qtty = KeyboardInput("Quantité", "", 4)
                            if qtty ~= "" then TriggerServerEvent('SY_ADMIN:autogiveitem', name, qtty) end
                        end
                    })
                end)

                RageUI.IsVisible(sub_menu4, function()
                    RageUI.Checkbox("NoClip", nil, check, {RightLabel = ""}, {
                        onChecked = function()
                            check = true
                            NoCLIP()
                        end,
                        onUnChecked = function()
                            check = false
                            NoCLIP()
                        end
                    })
                    RageUI.Checkbox("Afficher les noms", nil, ShowName, {RightLabel = ""}, {
                        onChecked = function()
                            ShowName = true
                            local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
                            for _, v in pairs(GetActivePlayers()) do
                                local otherPed = GetPlayerPed(v)
            
                                if otherPed ~= pPed then
                                    if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
                                        gamerTags[v] = CreateFakeMpGamerTag(otherPed, (" [%s] %s"):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
                                        SetMpGamerTagVisibility(gamerTags[v], 4, 1)
                                    else
                                        RemoveMpGamerTag(gamerTags[v])
                                        gamerTags[v] = nil
                                    end
                                end
                            end
                        end,
                        onUnChecked = function()
                            ShowName = false
                            for _, v in pairs(GetActivePlayers()) do
                                RemoveMpGamerTag(gamerTags[v])
                            end
                        end
                    })
                    RageUI.Checkbox("Afficher les blips", nil, blipsActive, {RightLabel = ""}, {
                        onChecked = function()
                            blipsActive = true
                            Blips()
                        end,
                        onUnChecked = function()
                            blipsActive = false
                            Blips()
                        end
                    })
                    RageUI.Checkbox("GodMod", "Mode Invincible : ~n~ ~r~Utiliser qu'en HRP tous abus sera severement puni. ", godmod, {RightLabel = ""}, {
                        onChecked = function()
                            godmod = true
                            SetEntityInvincible(PlayerPedId(), true)
                        end,
                        onUnChecked = function()
                            godmod = false
                            SetEntityInvincible(PlayerPedId(), false)
                        end
                    })
                    RageUI.Checkbox("Se rendre invisible", nil, invisible, {RightLabel = ""}, {
                        onChecked = function()
                            invisible = true
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                SetEntityVisible(Vehicle, false)
                            else
                                SetEntityVisible(PlayerPedId(), false)
                            end
                        end,
                        onUnChecked = function()
                            invisible = false
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                SetEntityVisible(Vehicle, true)
                            else
                                SetEntityVisible(PlayerPedId(), true)
                            end
                        end
                    })
                    RageUI.Button("Se soigner", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            SetEntityHealth(PlayerPedId(), 200)
                            ExecuteCommand('heal')
                            ESX.ShowNotification("Vous vous êtes soigner avec ~g~succès~s~.")
                        end
                    })
                    RageUI.Button("Se revive", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                         --   TriggerEvent('SY_ADMIN:revive')
                         ExecuteCommand('revive')
                        end
                    })
                    RageUI.Button("Se tp sur marqueur", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            TPMarker()
                        end
                    })
                    RageUI.Button("Obtenir sa position", nil, {RightLabel = "→"}, true, {
                        onSelected = function() openMenuCoords()
             --               print(GetEntityCoords(PlayerPedId()))
                        end
                    })
                    RageUI.Button("Faire une annonce", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local text = KeyboardInput("Votre annonce", "", 255)
                            if text ~= "" then
                                TriggerServerEvent('SY_ADMIN:announce', text)
                            end
                        end
                    })
                    RageUI.List("Give money", {"Banque", "Cash", "Sale"}, Customs.List6, nil, {Preview}, true, {
                        onListChange = function(i, Item)
                            Customs.List6 = i;
                        end,
                        onSelected = function()
                            if Customs.List6 == 1 then
                                local amount = KeyboardInput("Montant", "", 10)
                                if amount ~= "" then
                                    TriggerServerEvent('SY_ADMIN:givemoneybank', GetPlayerServerId(PlayerId()), amount)
                                end
                            elseif Customs.List6 == 2 then
                                local amount = KeyboardInput("Montant", "", 10)
                                if amount ~= "" then
                                    TriggerServerEvent('SY_ADMIN:givemoneycash', GetPlayerServerId(PlayerId()), amount)
                                end
                            elseif Customs.List6 == 3 then
                                local amount = KeyboardInput("Montant", "", 10)
                                if amount ~= "" then
                                    TriggerServerEvent('SY_ADMIN:givemoneysale', GetPlayerServerId(PlayerId()), amount)
                                end
                            end
                        end
                    })
                end)

                RageUI.IsVisible(sub_menu5, function()
                    RageUI.Button("Faire apparaître un véhicule", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local type = KeyboardInput("Modèle du véhicule", "", 15)
                            if type ~= "" then ESX.Game.SpawnVehicle(type, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function()end) end
                        end
                    })
                    RageUI.Button("Supprimer le véhicule à proximité", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onActive = function()
                            local vCoords = GetEntityCoords(GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70))
                            DrawMarker(2, vCoords.x, vCoords.y, vCoords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                        end,
                        onSelected = function()
                            DeleteEntity(GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70))
                        end
                    })
                    RageUI.Line()
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                        RageUI.Button("Changer la plaque du véhicule", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local plate = KeyboardInput("Nouvelle plaque", "", 8)
                                SetVehicleNumberPlateText(vehicle, plate)
                            end
                        })
                        RageUI.Button("Customiser le véhicule au maximum", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                            onSelected = function()
                                ToggleVehicleMod(vehicle, 18, true)
                                ToggleVehicleMod(vehicle, 22, true)
                                SetVehicleMod(vehicle, 23, 11, false)
                                SetVehicleMod(vehicle, 24, 11, false)
                                ToggleVehicleMod(vehicle, 20, true)
                                LowerConvertibleRoof(vehicle, true)
                                SetVehicleIsStolen(vehicle, false)
                                SetVehicleIsWanted(vehicle, false)
                                SetVehicleHasBeenOwnedByPlayer(vehicle, true)
                                SetVehicleNeedsToBeHotwired(vehicle, false)
                                SetCanResprayVehicle(vehicle, true)
                                SetPlayersLastVehicle(vehicle)
                                SetVehicleFixed(vehicle)
                                SetVehicleDeformationFixed(vehicle)
                                SetVehicleTyresCanBurst(vehicle, false)
                                SetVehicleWheelsCanBreak(vehicle, false)
                                SetVehicleCanBeTargetted(vehicle, false)
                                SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
                                SetVehicleHasStrongAxles(vehicle, true)
                                SetVehicleDirtLevel(vehicle, 0)
                                SetVehicleCanBeVisiblyDamaged(vehicle, false)
                                IsVehicleDriveable(vehicle, true)
                                SetVehicleEngineOn(vehicle, true, true)
                                SetVehicleStrong(vehicle, true)
                                SetPedCanBeDraggedOut(PlayerPedId(), false)
                                SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
                                SetPedRagdollOnCollision(PlayerPedId(), false)
                                ResetPedVisibleDamage(PlayerPedId())
                                ClearPedDecorations(PlayerPedId())
                                SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)
                            end
                        })
                        RageUI.Button('Réparer le véhicule', nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                            onSelected = function()
                                SetVehicleEngineHealth(vehicle, 1000.0)
                                SetVehicleFixed(vehicle)
                                SetVehicleDeformationFixed(vehicle)
                            end
                        })
                        RageUI.Button("Retourner le véhicule", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                            onSelected = function()
                                local newCoords = (GetEntityCoords(PlayerPedId())) + vector3(0.0, 2.0, 0.0)
                                SetEntityCoords(vehicle, newCoords)
                            end
                        })
                        RageUI.Button("Supprimer le véhicule", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, { onSelected = function() DeleteEntity(vehicle) end })
                        RageUI.List("Changer la couleur du véhicule", {'Rouge', 'Bleu', 'Jaune', 'Vert', 'Violet', 'Orange'}, Customs.List1, nil, {Preview}, true, {
                            onListChange = function(i, Item)
                                Customs.List1 = i;
                            end,
                            onSelected = function()
                                if Customs.List1 == 1 then SetVehicleColours(vehicle, 27, 27)
                                elseif Customs.List1 == 2 then SetVehicleColours(vehicle, 64, 64)
                                elseif Customs.List1 == 3 then SetVehicleColours(vehicle, 89, 89)
                                elseif Customs.List1 == 4 then SetVehicleColours(vehicle, 53, 53)
                                elseif Customs.List1 == 5 then SetVehicleColours(vehicle, 71, 71)
                                elseif Customs.List1 == 6 then SetVehicleColours(vehicle, 41, 41)
                                end
                            end
                        })
                    else
                        RageUI.Button("~r~→~s~ Vous devez être dans un véhicule", nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {})
                    end
                end)

            end
        end)
    end
end