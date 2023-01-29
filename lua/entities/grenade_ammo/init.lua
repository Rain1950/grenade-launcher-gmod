AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")






function ENT:Initialize()
    self:SetModel("models/weapons/grenade.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetModelScale(2)
    self:DrawShadow(false ) 
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS ) 
    
    self.fakegravity = true 
  

    local phys = self:GetPhysicsObject()

    timer.Simple(0.5,function ()
        self.fakegravity = false 
    end)
    
    if IsValid(phys) then
        timer.Simple(0.5,function ()
            if !IsValid(phys) then return end
            phys:ApplyForceCenter(self:GetForward()  * 1500 )
            
        end)
    end

    timer.Simple( 10, function() if self and self:IsValid() then self:Remove() end end )

end

function ENT:Think()
    if !self:OnGround() && self.fakegravity == true  then
        local phys = self:GetPhysicsObject()
        if !IsValid(phys) then return end
        phys:ApplyForceOffset( self:GetUp()*-0.2, self:LocalToWorld(Vector(0,0,1)))
    end 
end



function ENT:PhysicsCollide( data, phys )
    local hitent = data.HitEntity

    if(!hitent:IsPlayer()) then
        self:EmitSound("ambient/explosions/explode_" .. math.random(1, 9) .. ".wav")
        self:Remove()
    end
end

