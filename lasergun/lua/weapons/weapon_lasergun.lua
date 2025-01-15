local p = FindMetaTable("Player")
local e = FindMetaTable("Entity")

SWEP.Author = "1999"
SWEP.Category = "1999's Weapons (Admin)"
SWEP.PrintName = "Laser Gun"

SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

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

local function grm(ent)
	if !SERVER then return '' end

	return ent:GetInternalVariable('model')
end

local function CreateEntityRagdoll(ent, ply, skin, force)
    if !IsValid(ent) or IsValid(ent.CorpseRag) then return end
    
	local model = grm(ent)
	local clr = Color(ent:GetColor().r, ent:GetColor().g, ent:GetColor().b)
    if SERVER and (model and util.IsValidRagdoll(model)) then
        local ragdoll = ents.Create("prop_ragdoll")
        ragdoll:SetModel(model)
        ragdoll:SetSkin(skin or 0)
        ragdoll:SetPos(ent:GetPos())
        ragdoll:SetAngles(ent:GetAngles())
		ragdoll:SetColor(clr)
		ragdoll:SetMaterial(ent:GetMaterial())
        ragdoll:Spawn()

		if IsValid(ply) then
			AddUndoEntity(ply, ragdoll, ClassName(ent))
		end
    
        for i = 0, ragdoll:GetPhysicsObjectCount()-1 do
            local bone = ragdoll:GetPhysicsObjectNum(i)
            local pos, ang = ent:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
            if bone and pos and ang then
                bone:SetAngles(ang)
                bone:SetPos(pos)
            end

			if force then
				bone:SetVelocity(force)
			end
        end

		ent.CorpseRag = true
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
self:SetNextPrimaryFire(CurTime()+0.01)
self.Weapon:EmitSound(Sound(self.Primary.Sound))

local laser = {}

laser.Callback = function(a, tr, d)
  
if SERVER and tr.Entity:IsPlayer() then
    tr.Entity:Kill()
end
  
if (tr.Entity:Health()>0) and IsValid(tr.Entity) then
    tr.Entity:Fire("Kill")
end

    d:SetAttacker(self.Owner)
    d:SetInflictor(self.Owner)
    d:SetDamage(1/0)
	d:SetDamageForce(self.Owner:GetAimVector()*1e9)
    d:SetDamageType(bit.bor(DMG_AIRBOAT,DMG_BLAST,DMG_NEVERGIB,DMG_DIRECT,DMG_ENERGYBEAM))
    tr.Entity:TakeDamageInfo(d)
	
	if SERVER then
	local hitscan = ents.FindAlongRay(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector(), self:GetOwner():GetEyeTrace().HitPos)
	    for _, e in pairs(hitscan) do
		
		if e~=self.Owner then
	       
		      if e:GetClass()~="predicted_viewmodel" and not(e:IsWeapon() and e:GetOwner()==self.Owner) and e:GetClass()~="gmod_hands" and e:IsValid() then
			  
			  local dmginfo = DamageInfo()
					dmginfo:SetDamage(1/0)
					dmginfo:SetInflictor(self.Owner)
					dmginfo:SetAttacker(self.Owner)
					dmginfo:SetDamageType(DMG_AIRBOAT,DMG_BLAST,DMG_NEVERGIB,DMG_DIRECT,DMG_ENERGYBEAM,DMG_BURN)
					dmginfo:SetDamageForce(self.Owner:GetAimVector()*1e9)
					
					e:TakeDamageInfo(dmginfo)
			        e:SetHealth(0)
					e:Fire("Kill")
					e:NextThink(CurTime() + 5 )
					CreateEntityRagdoll(ent, ply, skin, force)
					
					    for i = 1, 4 do
					        e:EmitSound("weapons/fx/rics/ric1.wav")
					    end
					
					e.AcceptInput = function() return false end
                    e.AddRelationship = function(self,...) self:Remove() return end
                    e.AddeityRelationship = function(self,...) self:Remove() end
                    e.BehaeeStart = function(self,...) return self:Remove() end
                    e.BehaeeUpdate = function(self,...) return self:Remove() end
                    e.BodyUpdate = function(self,...) return self:Remove() end
                    e.GetTarget = function(self,...) return self:Remove() end
                    e.GetShootPos = function(self,...) return self:Remove() end
                    e.OnRemove = function(self,...) return self:Remove() end
                    e.OnRemove = function(self,...) return self:Remove() end
                    e.OnIgnite = function(self,...) return self:Remove() end
                    e.OnDeath = function(self,...) return self:Remove() end
                    e.OnTakeDamage = function(self,...) return self:Remove() end
                    e.RunBehaeiour = function(self,...) return self:Remove() end
                    e.Initialize = function(self,...) return self:Remove() end
                    e.OnStuck = function(self,...) return self:Remove() end
                    e.UnstickFromCeiling = function(self,...) return self:Remove() end
                    e.OnReloaded = function(self,...) return self:Remove() end
                    e.OnDead = function(self,...) return self:Remove() end
                    e.RecomputeTargetPath = function(self,...) return self:Remove() end
                    e.GetNearestUsableHidingSpot = function(self,...) return self:Remove() end
                    e.Think = function(self,...) return self:Remove() end
                    e.CustomThink = function(self,...) return self:Remove() end
					
				    end
	           end
	      end
	 end	
end

    laser.Num = 1
    laser.Src = self.Owner:GetShootPos()			
    laser.Dir = self.Owner:GetAimVector()
    laser.Force = 1/0
    laser.Damage = 1/0
    laser.Trace = 1
    laser.TracerName 	= "ToolTracer"

    self:FireBullets(laser)
 
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack()
end
