SWEP.Author = "1999"
SWEP.Category = "1999's Weapons (Admin)"
SWEP.PrintName = "Laser Gun"

SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"

SWEP.Spawnable = true 
SWEP.AdminOnly = true

SWEP.UseHands = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo		= ""

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.Primary.Sound = "weapons/airboat/airboat_gun_energy2.wav"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo		= ""

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true   

local function LaserAttack(v, self)
    local laser = {}

    laser.Callback = function(a, tr, d)
        tr.Entity:SetHealth(0)
        tr.Entity:Dissolve()

        tr.Entity.AcceptInput = function() return false end                    
        tr.Entity.OnRemove = function(self,...) self:Remove() end
	    tr.Entity.OnDeath = function(self,...) self:Remove() end
	    tr.Entity.OnTakeDamage = function(self,...) self:Remove() end
	    tr.Entity.OnTraceAttack = function(self,...) self:Remove() end
	    tr.Entity.CustomThink = function(self,...) self:Remove() end
	    tr.Entity.Think = function(self,...) self:Remove() end

        if (tr.Entity:IsPlayer() and tr.Entity:HasGodMode()) then
            tr.Entity:Kill()
            tr.Entity:Dissolve(math.random(0, 3))
            tr.Entity:RemoveFlags(32768)
        end

        if (tr.Entity:IsPlayer() and tr.Entity:IsAlive()) then
            tr.Entity:Kill()
            tr.Entity:Dissolve(math.random(0, 3))
            tr.Entity:RemoveFlags(32768)
        end

        d:SetDamage(1/0)
        d:SetInflictor(self.Owner)
        d:SetAttacker(self.Owner)
        d:SetDamageType(DMG_AIRBOAT,DMG_BLAST,DMG_NEVERGIB,DMG_DIRECT,DMG_ENERGYBEAM)
        d:SetDamageForce(self.Owner:GetAimVector() * 1e9)
    end

    laser.Num = 1
    laser.Src = self.Owner:GetShootPos()
    laser.Dir = self.Owner:GetAimVector()
    laser.Force = 1/0
    laser.Damage = 1/0
    laser.Trace = 1
    laser.TracerName = "ToolTracer"
    laser.Attacker = self.Owner

    self:FireBullets(laser)

    if SERVER then
        local hitscan = ents.FindAlongRay(self.Owner:GetShootPos() + self.Owner:GetAimVector(), self.Owner:GetEyeTrace().HitPos)

        for k, v in pairs(hitscan) do
            if v~=self.Owner then
                if (v:IsPlayer() and v:HasGodMode()) then
                    v:Kill()
                    v:Dissolve(math.random(0, 3))
                    v:RemoveFlags(32768)
                end

                if (v:IsPlayer() and v:Alive()) then
                    v:Kill()
                    v:Dissolve(math.random(0, 3))
                    v:RemoveFlags(32768)
                end

                if v:GetClass()~="predicted_viewmodel" and not (v:IsWeapon() and v:GetOwner() == self.Owner) and v:GetClass()~="gmod_hands" and v:IsValid() then
                    local d = DamageInfo()
                    d:SetDamage(1/0)
                    d:SetInflictor(self.Owner)
                    d:SetAttacker(self.Owner)
                    d:SetDamageType(DMG_AIRBOAT, DMG_BLAST, DMG_NEVERGIB, DMG_DIRECT, DMG_ENERGYBEAM)
                    d:SetDamageForce(self.Owner:GetAimVector() * 1e9)
                    v:TakeDamageInfo(d)

                    v.AcceptInput = function() return false end                    
			        v.OnRemove = function(self,...) self:Remove() end
					v.OnDeath = function(self,...) self:Remove() end
					v.OnTakeDamage = function(self,...) self:Remove() end
					v.OnTraceAttack = function(self,...) self:Remove() end
			        v.CustomThink = function(self,...) self:Remove() end
			        v.Think = function(self,...) self:Remove() end

                    v:SetHealth(0)
                    v:Dissolve()
                    v:SetVelocity(self.Owner:GetAimVector() * 10000)
                end
            end
        end
    end
end


function SWEP:FireAnimationEvent(pos,ang,event,options)
    return true
end

function SWEP:Initialize()
    self:SetWeaponHoldType("pistol")
    util.PrecacheSound(self.Primary.Sound) 
end

function SWEP:PrimaryAttack()
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self.Weapon:EmitSound(Sound(self.Primary.Sound))
    LaserAttack(v,self)
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack()
end

function SWEP:GetNPCBulletSpread(p)
	return 0.15
end
