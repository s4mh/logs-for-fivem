local ESX = exports['es_extended']:getSharedObject()

-- Fonction pour logger une commande
local function logCommand(playerId, name, command)
    PerformHttpRequest(Config.Webhook.commandtreespace, function(err, text, headers)
    end, 'POST', json.encode({
        embeds = {{
            title = "__**Logs de Commande**__",
            description = "\nNom du joueur: " .. name .. "`[" .. playerId .. "]`\nCommande: " .. command .. "\nID: " .. playerId,
            color = 15158332,
            footer = { text = "By Shoen" }
        }}
    }), { ['Content-Type'] = 'application/json' })
end

-- Capture des commandes saisies par les joueurs
AddEventHandler('onServerResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print('Script de logging des commandes et du chat chargé.')

        -- Utilisation de RegisterCommand pour capturer toutes les commandes, même celles avec des arguments
        RegisterCommand('', function(source, args, rawCommand)
            local playerId = source
            local name = GetPlayerName(playerId)
            local command = '/' .. rawCommand  -- La commande entière, y compris les arguments

            -- Log la commande avant d'exécuter l'action
            logCommand(playerId, name, command)
        end, true)
    end
end)

-- Capture des messages normaux dans le chat
AddEventHandler('chatMessage', function(source, name, message)
    local playerId = source

    PerformHttpRequest(Config.Webhook.chattreespace, function(err, text, headers)
    end, 'POST', json.encode({
        embeds = {{
            title = "__**Logs de Chat**__",
            description = "\nNom du joueur: " .. name .. "`[" .. playerId .. "]`\nMessage: " .. message .. "\nID: " .. playerId,
            color = 3447003,
            footer = { text = "By Shoen" }
        }}
    }), { ['Content-Type'] = 'application/json' })
end)

-- Événement de connexion du joueur
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local playerId = source
    deferrals.defer()
    Citizen.Wait(0)

    local identifiers = GetPlayerIdentifiers(playerId)
    local identifier = identifiers[1]

    -- Envoi des logs de connexion au webhook
    PerformHttpRequest(Config.Webhook.connecttreespace, function(err, text, headers)
        if err ~= 200 then
        end
    end, 'POST', json.encode({
        embeds = {{
            title = "__**Logs de Connexion**__",
            description = "\nNom du joueur: " .. playerName .. "`[" .. playerId .. "]`\nIdentifiant: " .. (identifier or "Aucun/e") .. "\nID: " .. playerId,
            color = 3066993,
            footer = { text = "By Shoen" }
        }}
    }), { ['Content-Type'] = 'application/json' })

    deferrals.done()
end)

-- Événement de déconnexion du joueur
AddEventHandler('playerDropped', function(reason)
    local playerId = source
    local lPlayer = ESX.GetPlayerFromId(playerId)

    if lPlayer then
        local identifier = lPlayer.identifier
        local playerName = GetPlayerName(playerId)
        local playerPing = GetPlayerPing(playerId)

        PerformHttpRequest(Config.Webhook.leavetreespace, function(err, text, headers)
            if err ~= 200 then
            end
        end, 'POST', json.encode({
            embeds = {{
                title = "__**Logs de Déconnexion**__",
                description = "\nNom du joueur: " .. playerName .. "`[" .. playerId .. "]`\nIdentifiant: " .. (identifier or "Aucun/e") .. "\nPing du joueur: " .. playerPing .. "\nRaison: " .. reason .. "\nID: " .. playerId,
                color = 3447003,
                footer = { text = "By Shoen" }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
end)

-- Événement de visée
RegisterServerEvent('treespace-logs:aimlogs')
AddEventHandler('treespace-logs:aimlogs', function(pedId)
    local source = source
    local name = GetPlayerName(source)
    local tname = GetPlayerName(pedId)

    PerformHttpRequest(Config.Webhook.shoottreespace, function(err, text, headers)
        if err ~= 200 then
        end
    end, 'POST', json.encode({
        embeds = {{
            title = "__**Logs de Tirs**__",
            description = "\nNom du joueur: " .. name .. "`[" .. source .. "]`\nVictime: " .. tname .. "`[" .. pedId .. "]`\nID: " .. source,
            color = 3447003,
            footer = { text = "By Shoen" }
        }}
    }), { ['Content-Type'] = 'application/json' })
end)

-- Événement de kill
RegisterServerEvent('treespace-logs:killlogs')
AddEventHandler('treespace-logs:killlogs', function(message, weapon)
    local source = source
    local time = os.date('*t')
    local hour = time.hour - 2

    -- Assurez-vous que 'weapon' n'est pas nil avant de l'utiliser
    weapon = weapon or "Aucun/e"

    PerformHttpRequest(Config.Webhook.killtreespace, function(err, text, headers)
        if err ~= 200 then
        end
    end, 'POST', json.encode({
        embeds = {{
            title = "__**Logs de Kill**__",
            description = "\n" .. (message or "Message non spécifié") .. "\nArme: " .. weapon .. "\nHeure: " .. hour .. ":" .. time.min .. "\nID: " .. source,
            color = 3447003,
            footer = { text = "By Shoen" }
        }}
    }), { ['Content-Type'] = 'application/json' })
end)
-- By Shoen discord : s4mh