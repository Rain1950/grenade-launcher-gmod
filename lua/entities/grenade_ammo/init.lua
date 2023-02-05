AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

game.AddParticles("particles/Rain_particles.pcf")
PrecacheParticleSystem("Thruster_Smoke")



function ENT:Initialize()
    self:SetModel("models/weapons/grenade.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetModelScale(2)
    self:DrawShadow(false ) 
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS ) 
    self.fakegravity = true 
    self.ArmedOnTouch = false 

    local phys = self:GetPhysicsObject()

    timer.Simple(0.5,function ()
        self.fakegravity = false 
        ParticleEffectAttach("Thruster_Smoke",PATTACH_ABSORIGIN_FOLLOW,self,1)

       
    end)
    
    if IsValid(phys)  then
        timer.Simple(0.5,function ()
            self:EmitSound("physics/nearmiss/whoosh_large4.wav",105,math.random(80,150))
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

function ENT:DelayedFuseExpl(delay)
    self.ArmedOnTouch = true 
    timer.Simple(delay,function ()
        if self:IsValid() then
            self:EmitSound("ambient/explosions/explode_" .. math.random(1, 9) .. ".wav")  // delayed fuse arm after collision
            -- self:Remove()
        end
    end)
end


function ENT:PhysicsCollide( data, phys )
    local hitent = data.HitEntity
    if( self.ArmedOnTouch == false  ) then
        self:DelayedFuseExpl(2)
    end
    
end


