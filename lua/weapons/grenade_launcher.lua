SWEP.PrintName = "Grenade Launcher"
SWEP.Author = "Rain"
SWEP.Spawnable = true 
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.ShootSound = Sound( "Metal.SawbladeStick" )


function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.5 )	
	self:ThrowChair( "models/props/cs_office/Chair_office.mdl" )
end
 

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + 0.1 )
	self:ThrowChair( "models/props_c17/FurnitureChair001a.mdl" )
end

thruster = false 
function SWEP:ThrowChair( model_file )
	local owner = self:GetOwner()
	if ( not owner:IsValid() ) then return end
	self:EmitSound( self.ShootSound )
 
	if ( CLIENT ) then return end

	 ent = ents.Create( "prop_physics" )

	if ( not ent:IsValid() ) then return end

	-- Set the entity's model to the passed in model
	ent:SetModel( model_file )

	-- This is the same as owner:EyePos() + (self:GetOwner():GetAimVector() * 16)
	-- but the vector methods prevent duplicitous objects from being created
	-- which is faster and more memory efficient
	-- AimVector is not directly modified as it is used again later in the function
	 aimvec = owner:GetAimVector()
	local pos = aimvec * 16 -- This creates a new vector object
	pos:Add( owner:EyePos() ) -- This translates the local aimvector to world coordinates

	-- Set the position to the player's eye position plus 16 units forward.
	ent:SetPos( pos )

	-- Set the angles to the player'e eye angles. Then spawn it.
	ent:SetAngles( owner:EyeAngles() )
	ent:Spawn()
 
	-- Now get the physics object. Whenever we get a physics object
	-- we need to test to make sure its valid before using it.
	-- If it isn't then we'll remove the entity.
	 phys = ent:GetPhysicsObject()
	if ( not phys:IsValid() ) then ent:Remove() return end
 
	-- Now we apply the force - so the chair actually throws instead 
	-- of just falling to the ground. You can play with this value here
	-- to adjust how fast we throw it.
	-- Now that this is the last use of the aimvector vector we created,
	-- we can directly modify it instead of creating another copy
	aimvec:Mul( 10000)
	aimvec:Add( VectorRand( -10, 10 ) ) -- Add a random vector with elements [-10, 10)
	phys:ApplyForceCenter( aimvec )
    if ( not phys:IsValid() ) then ent:Remove() return end
    timer.Simple(0.3,function ()
        thruster = true
    end)
    timer.Simple(0.4,function ()
        if !ent:IsOnGround() then
             phys:ApplyForceCenter(aimvec*10)
        end
        thruster = false 
    end)
	-- Assuming we're playing in Sandbox mode we want to add this
	-- entity to the cleanup and undo lists. This is done like so.
	cleanup.Add( owner, "props", ent )
 
	undo.Create( "Thrown_Chair" )
		undo.AddEntity( ent )
		undo.SetPlayer( owner )
	undo.Finish()
	-- A lot of items can clutter the workspace.
	-- To fix this we add a 10 second delay to remove the chair after it was spawned.
	-- ent:IsValid() checks if the item still exists before removing it, eliminating errors.
	timer.Simple( 10, function() if ent and ent:IsValid() then ent:Remove() end end )
end

function SWEP:Think()
   if thruster && IsValid(phys) then
    phys:ApplyForceCenter(aimvec)
   end

end