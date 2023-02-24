AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
    self:SetModel("models/rocketbox/rocketbox.mdl")
    self:SetModelScale(2)
    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS ) 
    -- self:SetCollisionGroup(COLLISION_GROUP_WEAPON) //no collision with players

    
end


function ENT:Use(activator,caller)
    if (IsValid(activator)) then
        activator:GiveAmmo(4,"grenade_rocket")
        self:Remove()
    end

    
end