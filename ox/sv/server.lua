---------------------------------------------------------------
ESX = exports['es_extended']:getSharedObject() local lib = exports['ox_lib']
---------------------------------------------------------------

local function sendToDiscord(webhookURL, name, embed)
    local payload = {
        username = name,
        embeds = { embed }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

if GetPlayerIdentifiers == nil then

else
    AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata)
        local _source = playerId
        local playerName = GetPlayerName(_source)
        local identifiers = GetPlayerIdentifiers(_source)
        local identifierStr = ''
        local discordMention = ''

        for _, id in ipairs(identifiers) do
            if string.find(id, 'license:') or string.find(id, 'license2:') then
                identifierStr = identifierStr .. id .. '\n'
            elseif string.find(id, 'discord:') then
                local discordId = id:gsub('discord:', '')
                discordMention = '<@' .. discordId .. '>'
                identifierStr = identifierStr .. '' .. id .. '\n'
            end
        end

        local metadataStr = metadata and json.encode(metadata) or 'None'

        local description = string.format("Le joueur **%s** %s (ID: %d) a utilisé l'item **%s** (slot: %d)\n\n**__Informations de connexion :__**\n%s", 
                                          playerName, discordMention, _source, name, slotId, identifierStr)
        
        local embed = {
            title = "Logs System - Utilisation d'un item",
            description = description,
            color = 3447003, -- Bleu
            footer = {
                text = os.date("%Y-%m-%d %H:%M:%S"),
            }
        }

        sendToDiscord(Config.Webhooks["useitem"], 'Ox-Inventory - Logs', embed)
    end)

    AddEventHandler('ox_inventory:openedInventory', function(playerId, inventoryId)
        local _source = playerId
        local playerName = GetPlayerName(_source)
        local identifiers = GetPlayerIdentifiers(_source)
        local identifierStr = ''
        local discordMention = ''

        for _, id in ipairs(identifiers) do
            if string.find(id, 'license:') or string.find(id, 'license2:') then
                identifierStr = identifierStr .. id .. '\n'
            elseif string.find(id, 'discord:') then
                local discordId = id:gsub('discord:', '')
                discordMention = '<@' .. discordId .. '>'
                identifierStr = identifierStr .. 'Discord ID: ' .. id .. '\n'
            end
        end

        local playerItems = exports.ox_inventory:GetInventoryItems(_source)

        local playerItemsStr = ""
        for i, item in ipairs(playerItems) do
            playerItemsStr = playerItemsStr .. item.name .. " (x" .. item.count .. ")"
            if i ~= #playerItems then
                playerItemsStr = playerItemsStr .. " - "
            end
        end

        local description
        if tostring(_source) == tostring(inventoryId) then
            description = string.format("Le joueur **%s** %s (ID: %d) a ouvert son propre inventaire\n\n**__Contenu de l'inventaire du joueur :__**\n%s\n\n**__Informations de connexion :__**\n%s", 
                                        playerName, discordMention, _source, playerItemsStr, identifierStr)
        else
            local inventoryItems = exports.ox_inventory:GetInventoryItems(inventoryId, false)
            local inventoryItemsStr = ""
            for i, item in ipairs(inventoryItems) do
                inventoryItemsStr = inventoryItemsStr .. item.name .. " (x" .. item.count .. ")"
                if i ~= #inventoryItems then
                    inventoryItemsStr = inventoryItemsStr .. " - "
                end
            end

            description = string.format("Le joueur **%s** %s (ID: %d) a ouvert l'inventaire **%s**\n\n**__Contenu de l'inventaire du joueur :__**\n%s\n\n**__Contenu de l'inventaire ouvert :__**\n%s\n\n**__Informations de connexion :__**\n%s", 
                                        playerName, discordMention, _source, inventoryId, playerItemsStr, inventoryItemsStr, identifierStr)
        end

        local embed = {
            title = "Logs System - Ouverture Inventaire",
            description = description,
            color = 3447003, -- Bleu
            footer = {
                text = os.date("%Y-%m-%d %H:%M:%S"),
            }
        }

        sendToDiscord(Config.Webhooks["openinventory"], 'Ox-Inventory - Logs', embed)
    end)

    AddEventHandler('ox_inventory:closedInventory', function(playerId, inventoryId)
        local _source = playerId
        local playerName = GetPlayerName(_source)
        local identifiers = GetPlayerIdentifiers(_source)
        local identifierStr = ''
        local discordMention = ''

        for _, id in ipairs(identifiers) do
            if string.find(id, 'license:') or string.find(id, 'license2:') then
                identifierStr = identifierStr .. id .. '\n'
            elseif string.find(id, 'discord:') then
                local discordId = id:gsub('discord:', '')
                discordMention = '<@' .. discordId .. '>'
                identifierStr = identifierStr .. 'Discord ID: ' .. id .. '\n'
            end
        end

        local playerItems = exports.ox_inventory:GetInventoryItems(_source)

        local playerItemsStr = ""
        for i, item in ipairs(playerItems) do
            playerItemsStr = playerItemsStr .. item.name .. " (x" .. item.count .. ")"
            if i ~= #playerItems then
                playerItemsStr = playerItemsStr .. " - "
            end
        end

        local description
        if tostring(_source) == tostring(inventoryId) then
            description = string.format("Le joueur **%s** %s (ID: %d) a fermer son propre inventaire\n\n**__Contenu de l'inventaire du joueur :__**\n%s\n\n**__Informations de connexion :__**\n%s", 
                                        playerName, discordMention, _source, playerItemsStr, identifierStr)
        else
            local inventoryItems = exports.ox_inventory:GetInventoryItems(inventoryId, false)
            local inventoryItemsStr = ""
            for i, item in ipairs(inventoryItems) do
                inventoryItemsStr = inventoryItemsStr .. item.name .. " (x" .. item.count .. ")"
                if i ~= #inventoryItems then
                    inventoryItemsStr = inventoryItemsStr .. " - "
                end
            end

            description = string.format("Le joueur **%s** %s (ID: %d) a fermer l'inventaire **%s**\n\n**__Contenu de l'inventaire du joueur :__**\n%s\n\n**__Contenu de l'inventaire ouvert :__**\n%s\n\n**__Informations de connexion :__**\n%s", 
                                        playerName, discordMention, _source, inventoryId, playerItemsStr, inventoryItemsStr, identifierStr)
        end

        local embed = {
            title = "Logs System - Fermeture Inventaire",
            description = description,
            color = 3447003, -- Bleu
            footer = {
                text = os.date("%Y-%m-%d %H:%M:%S"),
            }
        }

        sendToDiscord(Config.Webhooks["closeinventory"], 'Ox-Inventory - Logs', embed)
    end)

end
-- By Shoen discord : s4mh