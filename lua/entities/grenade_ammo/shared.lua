ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "GL_Ammo"
ENT.Author = "Rain"
ENT.Spawnable = false 





game.AddParticles("particles/Rain_particles.pcf")
PrecacheParticleSystem("Thruster_Fire")
PrecacheParticleSystem("Thruster_Smoke")


timer.Simple(0,function()
    game.AddParticles("particles/Rain_particles.pcf")
end)




hook.Add("Initialize","add_ammo_rain",function ()
    game.AddAmmoType({
        name = "grenade_rocket",
        dmgtype = DMG_BLAST,
        tracer = TRACER_NONE,
        plydmg = 5,
        npcdmg = 5,
        force = 2000,
        minsplash = 10,
        maxsplash = 5
    
    })
end)