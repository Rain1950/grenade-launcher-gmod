AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



function ENT:Initialize()
    self:SetModel("models/ammo/rocket-grenade.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetModelScale(2)
    self:DrawShadow(false ) 
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS ) 
    self.fakegravity = true 
    self.ArmedOnTouch = false 
    self.emitSound = false
    local phys = self:GetPhysicsObject()
    timer.Simple(0.5,function ()
        self.fakegravity = false 

       
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
        phys:ApplyForceOffset( self:GetUp()*-0.05, self:LocalToWorld(Vector(0,0,0.2)))
    end 

   
    
end

function ENT:DelayedFuseExpl(delay)

    self.ArmedOnTouch = true 
    timer.Simple(delay,function ()
        if self:IsValid() then
            self:EmitSound("ambient/explosions/explode_" .. math.random(1, 9) .. ".wav")  // delayed fuse arm after collision
            local effectdata = EffectData()
            effectdata:SetOrigin(self:GetPos())
            effectdata:SetMagnitude(500)
            effectdata:SetScale(1)
            util.Effect("Explosion",effectdata)
            util.BlastDamage(self,self,self:GetPos(),350,100)
            self:Remove()
        end
    end)
end



function ENT:PhysicsCollide( data, phys )
    local hitent = data.HitEntity
    if(self.emitSound == false) then
        self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(1,3).. ".wav",70,150,0.6)
        self.emitSound = true
    end
    
    if( self.ArmedOnTouch == false  ) then
        self:DelayedFuseExpl(2)
    end
    
end



