-- Copyright (c) 2015, Benjamin Vianey. This file is licensed under the
-- Affero General Public License version 3 or later. See the COPYRIGHT file.

-- Original version, Hotscript is :
-- Copyright (c) 2014, Jeffrey Clark. This file is licensed under the
-- Affero General Public License version 3 or later. See the COPYRIGHT file.

include("support.lua")


database = getDatabase()
server = getServer()
motd = { time=0, message=nil }
motd_timer = nil
welcome_message = nil

playersOnline = {}

-- Didn't use the builtin yell api because it's not customizable
yellLabel = Gui:createLabel("", 0.99, 0.99);
yellLabel:setFontColor(0xCCFF00FF);
yellLabel:setBorderColor(0xFF000088);
yellLabel:setBorderThickness(4);
yellLabel:setFontsize(30);
yellLabel:setPivot(4);


function onPlayerCommand(event)
    print(timePrefix{text=event.player:getName() .. ": "..event.command})

    if string.sub(event.command,1,1) == "/" then
        local cmd = explode(" ", event.command, 2)
        cmd[1] = string.lower(cmd[1])

            ---------------------------------------------------------------------
            --                         Help command                            --
            ---------------------------------------------------------------------
            
        if cmd[1] == "/help" then
                event.player:sendTextMessage("[#00FFCC]/ahelp [#00CC88] Display admin help");
                event.player:sendTextMessage("[#00FFCC]/zhelp [#00CC88] Display common help");
               -- event.player:sendTextMessage("[#00FFCC]/ghelp [#00CC88] Display group management help");

        elseif cmd[1] == "/ahelp" then
            if event.player:isAdmin() then
                event.player:sendTextMessage("[#00FFCC]/ban [#00CC88]<player> <duration in minutes, -1 is permenant> <reason>");
                event.player:sendTextMessage("[#00FFCC]/unban [#00CC88]<player>");
                event.player:sendTextMessage("[#00FFCC]/setWelcome [#00CC88]<message>");
                event.player:sendTextMessage("[#00FFCC]/setMotd [#00CC88]<message>");
                event.player:sendTextMessage("[#00FFCC]/yell [#00CC88]<message>");
                event.player:sendTextMessage("[#00FFCC]/kill [#00CC88] <player ID> OR <player name>");
                event.player:sendTextMessage("[#00FFCC]/tp [#00CC88] <ID> OR <player name>");
                event.player:sendTextMessage("[#00FFCC]/tp2 [#00CC88] <ID> OR <player name>");
                event.player:sendTextMessage("[#00FFCC]/kick [#00CC88] <player ID> <reason>");
                event.player:sendTextMessage("[#00FFCC]/heal [#00CC88] <player ID or name>");

            else
                event.player:sendTextMessage("[#00FFCC]You're not an admin !");
            end

       -- elseif cmd[1] == "/ghelp" then
       --         event.player:sendTextMessage("[#00FFCC]/gkick [#00CC88] <playerID> OR <player Name> ");
       --         event.player:sendTextMessage("[#00FFCC]/gadd [#00CC88] <playerID> OR <player Name> ");
       --         event.player:sendTextMessage("[#00FFCC]/g [#00CC88] <message> ");
       --         event.player:sendTextMessage("[#00FFCC]/gsetAdmin [#00CC88] <playerID> OR <player Name> ");


        elseif cmd[1] == "/zhelp" then
            event.player:sendTextMessage("[#00FFCC]/last [#00CC88][player]");
            event.player:sendTextMessage("[#00FFCC]/whisper [#00CC88]<player> <message>");
            event.player:sendTextMessage("[#00FFCC]/pos");



            ---------------------------------------------------------------------
            --             Calling command based on console entry              --
            ---------------------------------------------------------------------
            
            ----------------------------
            --     Group Management   --
            ----------------------------
   --     elseif cmd[1] == "/gkick" then


    --    elseif cmd[1] == "/gadd" then


  --      elseif cmd[1] == "/g" then


  --      elseif cmd[1] == "/gsetAdmin" then    


            ----------------------------
            --       For Admin        --
            ----------------------------


        elseif cmd[1] == "/test" then
             event.player:sendTextMessage(event.player:getID());


        elseif cmd[1] == "/heal" then
            local target;
            -- Checking if admin :
            if not event.player:isAdmin() then return msgAccessDenied(event.player) end
            -- Checking if there's an argument
            if not cmd[2] then return msgInvalidUsage(event.player) end
            -- Checking if arg is a player ID OR a player name
            if tonumber(cmd[2]) == nil then
                -- here if cmd2's not a number
                -- Checking if targeted player exist
                 if not server:findPlayerByName(cmd[2]) then return msgBadID(event.player) end
                target = server:findPlayerByName(cmd[2]);
            else
                -- Checking if targeted player exist
                if not server:findPlayerByID(cmd[2]) then return msgBadID(event.player) end
                target = server:findPlayerByID(cmd[2]);
            end
            heal(target);


        elseif cmd[1] == "/kick" then
            local target;
            -- Checking if admin :
            if not event.player:isAdmin() then return msgAccessDenied(event.player) end
            -- Checking if there's an argument
            if not cmd[2] then return msgInvalidUsage(event.player) end
            -- Checking if arg is a player ID OR a player name
            if tonumber(cmd[2]) == nil then
                -- here if cmd2's not a number
                -- Checking if targeted player exist
                 if not server:findPlayerByName(cmd[2]) then return msgBadID(event.player) end
                target = server:findPlayerByName(cmd[2]);
            else
                -- Checking if targeted player exist
                if not server:findPlayerByID(cmd[2]) then return msgBadID(event.player) end
                target = server:findPlayerByID(cmd[2]);
            end
            kickPlayer(event.player, target, cmd[3]);



        elseif cmd[1] == "/kill" then
            local target;
            -- Checking if admin :
            if not event.player:isAdmin() then return msgAccessDenied(event.player) end
            -- Checking if there's an argument
            if not cmd[2] then return msgInvalidUsage(event.player) end
            -- Checking if arg is a player ID OR a player name
            if tonumber(cmd[2]) == nil then
                -- here if cmd2's not a number
                -- Checking if targeted player exist
                 if not server:findPlayerByName(cmd[2]) then return msgBadID(event.player) end
                target = server:findPlayerByName(cmd[2]);
            else
                -- Checking if targeted player exist
                if not server:findPlayerByID(cmd[2]) then return msgBadID(event.player) end
                target = server:findPlayerByID(cmd[2]);
            end
            kill(event.player, target)

        -- TP admin -> player 
        elseif cmd[1] == "/tp" then
            local target;
            -- Checking if admin :
            if not event.player:isAdmin() then return msgAccessDenied(event.player) end
            -- Checking if there's an argument
            if not cmd[2] then return msgInvalidUsage(event.player) end
            -- Checking if arg is a player ID OR a player name
            if tonumber(cmd[2]) == nil then
                -- here if cmd2's not a number
                -- Checking if targeted player exist
                 if not server:findPlayerByName(cmd[2]) then return msgBadID(event.player) end
                target = server:findPlayerByName(cmd[2]);
            else
                -- Checking if targeted player exist
                if not server:findPlayerByID(cmd[2]) then return msgBadID(event.player) end
                target = server:findPlayerByID(cmd[2]);
            end
            tp(event.player, target)
        

        -- TP player -> admin
        elseif cmd[1] == "/tp2" then
            local target;
            -- Checking if admin :
            if not event.player:isAdmin() then return msgAccessDenied(event.player) end
            -- Checking if there's an argument
            if not cmd[2] then return msgInvalidUsage(event.player) end
            -- Checking if arg is a player ID OR a player name
            if tonumber(cmd[2]) == nil then
                -- here if cmd2's not a number
                -- Checking if targeted player exist
                 if not server:findPlayerByName(cmd[2]) then return msgBadID(event.player) end
                target = server:findPlayerByName(cmd[2]);
            else
                -- Checking if targeted player exist
                if not server:findPlayerByID(cmd[2]) then return msgBadID(event.player) end
                target = server:findPlayerByID(cmd[2]);
            end
            tp(target, event.player)



        elseif cmd[1] == "/ban" then
            if not event.player:isAdmin() then return msgAccessDenied(event.player) end
            if not cmd[2] then return msgInvalidUsage(event.player) end
            local args = explode(" ", cmd[2], 3)
        if not args[1] or not args[2] or not args[3] then return msgInvalidUsage(event.player) end
        ban(args[1], args[2], args[3], event.player)

         elseif cmd[1] == "/unban" then
            if not event.player:isAdmin() then return msgAccessDenied(event.player) end
            if not cmd[2] then return msgInvalidUsage(event.player) end
            unban(cmd[2], event.player)

        elseif cmd[1] == "/setmotd" then
            if not event.player:isAdmin() then return msgAccessDenied(event.player) end
            if not cmd[2] then return msgInvalidUsage(event.player) end
            setMotd(cmd[2])
            event.player:sendTextMessage("[#00FFCC]motd set");

        elseif cmd[1] == "/setwelcome" then
            if not event.player:isAdmin() then return msgAccessDenied(event.player) end
            if not cmd[2] then return msgInvalidUsage(event.player) end
            setWelcome(cmd[2])
            event.player:sendTextMessage("[#00FFCC]welcome set");



            ----------------------------
            --       For all          --
            ----------------------------


        elseif cmd[1] == "/yell" then
            if not event.player:isAdmin() then return msgAccessDenied(event.player) end
            if not cmd[2] then return msgInvalidUsage(event.player) end
    
            yellLabel:setText(" "..event.player:getName()..": "..cmd[2].." ");
            yellLabel:setX(0.5);
            yellLabel:setY(0.3);
            yellLabel:setVisible(true)
            setTimer(function()
                    yellLabel:setVisible(false);
            end, 5, 1);

        elseif cmd[1] == "/last" then
        sendTableMessage{player=event.player, messages=getLastText{name=cmd[2]}}


        elseif cmd[1] == "/pos" then
            local pos = event.player:getPosition();
            event.player:sendTextMessage(pos)


        elseif cmd[1] == "/whisper" then
            if not cmd[2] then return msgInvalidUsage(event.player) end
            local args = explode(" ", cmd[2], 2)
            if not args[2] then return msgInvalidUsage(event.player) end
    
            local toPlayer = server:findPlayerByName(args[1])
            if not toPlayer then return msgPlayerNotFound(event.player) end
    
            toPlayer:sendTextMessage(timePrefix{text="[#FFFF00](whisper) "..decoratePlayerName(event.player)..": "..args[2]});
        end
    end
end
            ---------------------------------------------------------------------
            --           Effective command called by previous part             --
            ---------------------------------------------------------------------
            


function kickPlayer(kicker, target, reason)
    local tName = target:getName()
    target:kick(reason)
    kicker:sendTextMessage("You kicked "..tName.." !")
end


-- Suggested by username on official forum ! 
function heal(target)
    local tName = target:getName()
    target:setHealth(100);
    target:setHunger(100);
    target:setThirst(100);
    target:sendTextMessage("You've been healed !")
end


function sendTableMessage(opts)
    for i=1,#opts.messages do
        opts.player:sendTextMessage(opts.messages[i])
    end
end


function kill(admin, player)
    local aName = admin:getName();
    local pName = player:getName();
    admin:sendTextMessage("Player "..pName.." as been killed by admin "..aName);
    player:setHealth(0)
end

function tp(admin, player)
    local targetPos = player:getPosition();
    local newPosx = targetPos.x + 1.0;
    local newPosy = targetPos.y + 1.0;
    local newPosz = targetPos.z + 1.0;
    -- it seems that admin:setPosition(targetPos.x +1.0, targetPos.y +1.0, targetPos.z + 1.0) doesn't work ...
    -- so I try to add +1.0 to x y and z before calling the function
    admin:setPosition(newPosx, newPosy, newPosz); 
end


function decoratePlayerName(player)
    local str = "[#CCCCCC]"
    if type(player) == "string" then
        str = str..player
    else
        str = str..player:getName()
        if player:isAdmin() then
            str = str.."[#FF0000] (admin)"
        end
						
    end

    return str.."[#FFFFFF]"
end

function msgInvalidUsage(player)
    sendMessage("Invalid command usage.", player)
end

function msgBadID(player)
    sendMessage("Invalid ID or name.", player)
end

function msgAccessDenied(player)
    sendMessage("Access denied.", player)
end

function msgPlayerNotFound(player)
    sendMessage("Player not found.", player)
end

function broadcastPlayerStatus(player, msg)
    server:brodcastTextMessage(timePrefix{text="[#FFA500]** "..decoratePlayerName(player).." - "..msg})
    print(timePrefix{text="** ".. player:getName() .." - ".. msg})
end

function sendMessage(msg, player)
    player:sendTextMessage(timePrefix{text="[#FF0000]"..msg})
end

function setWelcome(msg)
    database:queryupdate("INSERT OR REPLACE INTO settings (`key`, `value`) VALUES ('welcome', '"..msg.."');");
end

function showWelcome(player)
    result = database:query("SELECT * FROM `settings` WHERE `key` = 'welcome';")
    if result:next() then
        player:sendTextMessage(timePrefix{text="[#FFA500]** ".. result:getString("value")})
    end
    result:close()
end

function setMotd(msg)
    database:queryupdate("INSERT INTO motd (time, message) VALUES (strftime('%s', 'now'), '"..msg.."');");
end

function showMotd()
    result = database:query("SELECT * FROM motd ORDER BY time DESC LIMIT 1;")
    if result:next() then
        motd.time = result:getInt("time")
        motd.message = result:getString("message")
    end

    if motd.time > 0 then
        server:brodcastTextMessage(timePrefix{time=motd.time, text="[#FFA500]** ".. motd.message})
    end
    result:close()
end

function timePrefix(opts)
    if not type(opts.time) ~= "number" then
        opts.time = os.time()
    end
    return os.date("%x %X", opts.time) .." ".. opts.text
end

function getLastText(opts)
    local result = nil
    local last = Table.new()

    if type(opts.name) == "string" then
        result = database:query("SELECT * FROM `lastlog` WHERE `name` LIKE '".. opts.name .."' AND `disconnect_at` > -1 ORDER BY `id` DESC LIMIT 10")
    else
        result = database:query("SELECT * FROM `lastlog` WHERE `disconnect_at` > -1 GROUP BY `name` ORDER BY `id` DESC LIMIT 10")
    end

    while result:next() do
        local offtime = result:getInt("disconnect_at")
    if offtime == 0 then
            offtime = "[#CC0000]Lost Connection"
        else
            offtime = os.date("%x %X", offtime)
    end
        last:insert("[#00FFCC]".. result:getString("name") .."[#00CC88] ".. os.date("%x %X", result:getInt("connect_at")) .." - ".. offtime)
    end
    result:close()

    return last
end

-- checked on join
function checkban(player)
    local result = database:query("SELECT * FROM `banlist` WHERE `playername` = '".. player:getName() .."' AND (`applied_at` < 0 OR (`applied_at` + `duration`) > strftime('%s', 'now') OR `duration` < 0) COLLATE NOCASE;")
    if result:next() then
    duration = (result:getInt("duration") / 60)
    reason = result:getString("reason")

        local message = " banned by ".. result:getString("admin")
        if duration > 0 then
            message = message .." for ".. duration .." minutes"
        else
            message = message .." permenantly"
        end
    message = message .." (".. reason ..")"
        broadcastPlayerStatus(player, message)
    if result:getInt("applied_at") < 0 then
        database:queryupdate("UPDATE `banlist` SET `applied_at` = strftime('%s', 'now') WHERE `id` = ".. result:getString("id") ..";")
    end
        setTimer(function() player:ban(reason, duration); end, 1, 1);
    end
    result:close()
end

function unban(playername, adminPlayer)
    --- TODO: confirm player is banned
    database:queryupdate("DELETE FROM `banlist` WHERE `playername` = '".. playername .."' COLLATE NOCASE;")
    server:brodcastTextMessage(timePrefix{text="[#FF0000]** ".. decoratePlayerName(playername) .." ban removed by ".. decoratePlayerName(adminPlayer)})
end

function ban(playername, duration, reason, adminPlayer)
    --- Queue ban for next login attempt
    if duration == 0 then duration = 1 end
    database:queryupdate("INSERT INTO `banlist` (`playername`, `admin`, `serial`, `date`, `duration`, `reason`) VALUES ('".. playername .."', '".. adminPlayer:getName() .."', '', strftime('%s', 'now'), ".. (duration * 60) ..", '".. reason .."');")

    -- Ban immediately if online
    --- Don't use server:findPlayerByName because it's currently case sensitive
    local banPlayer = findOnlinePlayerByName(playername)
    if banPlayer then
        checkban(banPlayer)
    else
        server:brodcastTextMessage(timePrefix{text="[#FF0000]** ".. decoratePlayerName(playername) .." banned by ".. decoratePlayerName(adminPlayer)})
    end
end

function findOnlinePlayerByName(playername)
    local lname = string.lower(playername)
    if playersOnline[lname] then
        if server:findPlayerByID(playersOnline[lname].id) then
            return server:findPlayerByID(playersOnline[lname].id)
        else
            -- actually shouldn't happen, see onPlayerDisconnect
            playersOnline[lname] = nil
        end
    end
end

function lastlog(opts)
    local query = ""
    p = playersOnline[string.lower(opts.po)]
    if opts.action == "connect" then
        query = "INSERT INTO `lastlog` (`player_id`, `name`, `ip`, `connect_at`) VALUES (".. p.dbid ..", '".. p.name .."', '".. p.ip .."', strftime('%s', 'now'));"
    else
        query = "UPDATE `lastlog` SET `disconnect_at` = strftime('%s', 'now') WHERE `id` IN (SELECT `id` FROM `lastlog` WHERE `ip` = '".. p.ip .."' ORDER BY `id` DESC LIMIT 1);"
    end
    print(timePrefix{text=query})
    database:queryupdate(query)
end


            ---------------------------------------------------------------------
            --                Group management and DB stuff                    --
            ---------------------------------------------------------------------

-- function isInDB(player)
--     local id = player.getDBID();
--     local name = player.getName();
--     query = "SELECT name IN player WHERE ID ="..id.." ORDER BY name DESC LIMIT 1;";
--     print(timePrefix{text=query})
--     if name==database:queryupdate(query)
--         then return 1;
--     else
--         return 0;
--     end
-- end

-- function addToDB(player)
--     local id = player.getDBID();
--     local name = player.getName();
--     query = "INSERT INTO player (ID, name) VALUES ("..id..","..name..");";
--     print(timePrefix{text=query})
--     database:queryupdate(query)        
-- end

-- function removeFromDB(player)
--     local id = player.getDBID();
--     local name = player.getPlayerName();
--     query = "DELETE FROM player WHERE ID ="..id.." AND name="..name.." COLLATE NOCASE;"
--     print(timePrefix{text=query})
--     database:queryupdate(query)
-- end











            ---------------------------------------------------------------------
            --                         Event Handler                           --
            ---------------------------------------------------------------------


function onPlayerSpawn(event)
    event.player:addGuiElement(yellLabel)
    broadcastPlayerStatus(event.player, " joined the world")
    showWelcome(event.player);
    -- check for players that were offline when banned
    checkban(event.player)
    event.player:sendTextMessage("[#00FFCC]This server is using Zcript ");
             
end

function onPlayerConnect(event)
    playersOnline[string.lower(event.player:getName())] = { id=event.player:getID(), name=event.player:getName(), ip=event.player:getIP(), dbid=event.player:getDBID() }
    lastlog{action='connect', po=event.player:getName()}

    -- broadcastPlayerStatus(event.player, " is connecting")
    -- if !(addToDB(event.player)==1)
    --     then
    --         addToDB(event.player);
    -- end   



end

function onPlayerDisconnect(event)
    lastlog{action='disconnect', po=event.player:getName()}
    -- TODO: compact the table
    playersOnline[string.lower(event.player:getName())] = nil
    broadcastPlayerStatus(event.player, " disconnected")
end

function onPlayerDeath(event)
    broadcastPlayerStatus(event.player, " is dead")
end

function onPlayerText(event)
    event.prefix = timePrefix{text=decoratePlayerName(event.player)}
    print(timePrefix{text=event.player:getName()..": " .. event.text})
end





            ---------------------------------------------------------------------
            --                         Adding events                           --
            ---------------------------------------------------------------------
            


addEvent("PlayerSpawn", onPlayerSpawn);
addEvent("PlayerConnect", onPlayerConnect);
addEvent("PlayerDisconnect", onPlayerDisconnect);
addEvent("PlayerDeath", onPlayerDeath);
addEvent("PlayerText", onPlayerText);
addEvent("PlayerCommand", onPlayerCommand);


            ---------------------------------------------------------------------
            --              On enable function, called when server start       --
            ---------------------------------------------------------------------


function onEnable()
    print(timePrefix{text="Loaded"});

    database:queryupdate("CREATE TABLE IF NOT EXISTS `motd` (`ID` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `time` INTEGER, `message` VARCHAR);");
    database:queryupdate("CREATE TABLE IF NOT EXISTS `settings` (`key` PRIMARY KEY NOT NULL, `value` VARCHAR);");
    database:queryupdate("CREATE TABLE IF NOT EXISTS `banlist` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `playername` NOT NULL, `admin` VARCHAR, `serial` VARCHAR, `date` INTEGER NOT NULL, `duration` LONG DEFAULT -1, `reason` VARCHAR, `applied_at` BOOLEAN DEFAULT 0);");
    database:queryupdate("CREATE TABLE IF NOT EXISTS `lastlog` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `player_id` INTEGER, `name` VARCHAR, `ip` VARCHAR, `connect_at` INTEGER, `disconnect_at` INTEGER DEFAULT -1)");


    -- Group management DB entry
    database:queryupdate("CREATE TABLE IF NOT EXISTS player (ID INTEGER PRIMARY KEY NOT NULL, name VARCHAR NOT NULL, groupID INTEGER);");
    database:queryupdate("CREATE TABLE IF NOT EXISTS 'group' (ID INTEGER PRIMARY KEY NOT NULL, name VARCHAR NOT NULL, adminID INTEGER NOT NULL);");
    database:queryupdate("CREATE TABLE IF NOT EXISTS groupAdmin (ID INTEGER PRIMARY KEY NOT NULL, admin1 INTEGER, admin2 INTEGER, admin3 INTEGER);");


    -- Cleanup lost connections (server crash)
    database:queryupdate("UPDATE `lastlog` SET `disconnect_at` = 0 WHERE `disconnect_at` = -1")

    -- Broadcast motd every 60 minutes
    motd_timer = setTimer(function() showMotd(); end, 3600, -1);
end
