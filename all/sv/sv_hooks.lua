
hooks = hooks or {}

for name, data in pairs(hooks) do
    if data and data.from and data.to and data.callback then
        addTypeHook(name, data.from, data.to, data.callback)
    else
        print("^1[logs] ^0Warning: hook '" .. tostring(name) .. "' is missing required data.")
    end
end

function sendWebhook(webhook, data)
    if webhooks[webhook] == nil then
        print('^1[logs] ^0Webhook ' .. webhook .. ' does not exist.')
        return
    end

    PerformHttpRequest(
        webhooks[webhook],
        function(err, text, headers)
        end,
        'POST',
        json.encode({ embeds = data }),
        { ['Content-Type'] = 'application/json' }
    )
end
-- By Shoen discord : s4mh