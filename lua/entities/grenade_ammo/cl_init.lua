
include("shared.lua")






function ENT:Initialize()
      timer.Simple(0.5,function ()
        local FireEmitter = ParticleEmitter(self:GetPos())
        for i = 1, 25 do
            local part = FireEmitter:Add("effects/fire_embers"..math.random(1,3),self:GetPos())
            if ( part ) then
                part:SetDieTime( math.random(0.7,1.3) ) -- How long the particle should "live"
        
                part:SetStartAlpha( 180 ) -- Starting alpha of the particle
                part:SetEndAlpha( 0 ) -- Particle size at the end if its lifetime
        
                part:SetStartSize( math.random(3,5) ) -- Starting size
                part:SetEndSize( 0 ) -- Size when removed
                part:SetGravity( Vector( 0, 0, -250 ) ) -- Gravity of the particle
                local velocityVector = self:GetForward()
                velocityVector:Add(VectorRand(-0.5,0.5))
                part:SetVelocity( velocityVector * 75 ) -- Initial velocity of the particle
            end
        end
        FireEmitter:Finish()
        
        local SmokeEffects = {
            "splash1",
            "splash2",
            "splash4"
        }

        local SmokeEmitter = ParticleEmitter(self:GetPos())
        for k = 1,25 do
            local SmokePart = SmokeEmitter:Add("effects/"..SmokeEffects[math.random(1,#SmokeEffects)],self:GetPos())
            if (SmokePart) then
                SmokePart:SetDieTime( 2 ) -- How long the particle should "live"
                SmokePart:SetStartAlpha( 120 ) -- Starting alpha of the particle
                SmokePart:SetColor(255,255,255)
                SmokePart:SetEndAlpha( 0 ) -- Particle size at the end if its lifetime
                SmokePart:SetAngles(AngleRand())
                SmokePart:SetStartSize( 5 ) -- Starting size
                SmokePart:SetEndSize( 0 ) -- Size when removed
                SmokePart:SetGravity( Vector( 0, 0, -25 ) ) -- Gravity of the particle
                local velocityVector = self:GetForward()
                velocityVector:Add(VectorRand(-0.2,0.2))
                SmokePart:SetVelocity( velocityVector  * 50 ) -- Initial velocity of the particl
            
            end
        end
        SmokeEmitter:Finish()



      
         
               

            
            
        



      end)
end

function ENT:Draw()
    self:DrawModel()
end

