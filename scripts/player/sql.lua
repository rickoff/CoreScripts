require('patterns')
local LIP = require('LIP')
local Database = require('database')
local BasePlayer = require('player.base')

local Player = class ("Player", BasePlayer)

function Player:__init(pid)
    BasePlayer.__init(self, pid)

    if self.hasAccount == nil then
        
        self.dbPid = self:GetDatabaseId()

        if self.dbPid ~= nil then
            self.hasAccount = true
        else
            self.hasAccount = false
        end
    end
end

function Player:CreateAccount()
    Database:InsertRow("player_login", self.data.login)
    self.dbPid = self:GetDatabaseId()
    Database:SavePlayer(self.dbPid, self.data)
    self.hasAccount = true
end

function Player:Save()
    if self.hasAccount and self.loggedIn then
        Database:SavePlayer(self.dbPid, self.data)
    end
end

function Player:Load()
    self.data = Database:LoadPlayer(self.dbPid)

    self.data.equipment = {}
end

function Player:GetDatabaseId()
    local escapedName = Database:Escape(self.accountName)
    return Database:GetSingleValue("player_login", "dbPid", string.format("WHERE name = '%s'", escapedName))
end

return Player
