SWEP.PrintName = "Grenade Launcher"
SWEP.Author = "Rain"
SWEP.Spawnable = true 
SWEP.Category = "Rain's"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false 
SWEP.Primary.Ammo		= "grenade_rocket"
SWEP.Primary.Recoil = 50
SWEP.Primary.Delay = 0.5
SWEP.Primary.Automatic = false



SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.UseHands = true   

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true 
SWEP.DrawCrosshair		= true


SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.ShootSound = Sound( "Metal.SawbladeStick" )


function SWEP:PrimaryAttack()
	if self:Clip1() > 0 then
		self:SetNextPrimaryFire( CurTime() + 0.5 )	

		self:FireRocket()
		self:TakePrimaryAmmo(1)
	end
end
 


function SWEP:FireRocket()
	local owner = self:GetOwner()
	if ( not owner:IsValid() ) then return end
	self:EmitSound( self.ShootSound )
 
	if ( CLIENT ) then return end

	local  ent = ents.Create( "grenade_ammo" )

	if ( not ent:IsValid() ) then return end

	

	local aimvec = owner:GetAimVector()
	local pos = aimvec * 16 
	pos:Add( owner:EyePos() ) 
	ent:SetPos( pos )
	ent:SetAngles(  owner:EyeAngles())
	ent:Spawn()
	
 
	local  phys = ent:GetPhysicsObject()
	if ( not phys:IsValid() ) then ent:Remove() return end
 
	aimvec:Mul( 500)
	aimvec:Add( VectorRand( -10, 10 ) )
	phys:ApplyForceCenter( aimvec )
	
end

