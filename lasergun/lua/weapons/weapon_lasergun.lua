SWEP.Author = "1999"
SWEP.Category = "1999's Weapons (Admin)"
SWEP.PrintName = "Laser Gun"
SWEP.Instructions = ""

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

local bullet = {}

bullet.Callback = function(a, tr, d)
if SERVER and tr.Entity:IsPlayer() then
tr.Entity:Kill()
end
if tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
d:SetDamageForce(self.Owner:GetAimVector()*2147483647)
end
if tr.Entity:GetClass()=="npc_helicopter" or tr.Entity:GetClass()=="npc_turret_floor" or tr.Entity:GetClass()=="npc_combinedropship" or tr.Entity:GetClass()=="npc_combinegunship" or tr.Entity:GetClass()=="npc_strider" or tr.Entity:GetClass()=="npc_cscanner" or tr.Entity:GetClass()=="npc_clawscanner" or tr.Entity:GetClass()=="npc_manhack" or tr.Entity:GetClass()=="npc_combine_camera" or tr.Entity:GetClass()=="npc_turret_ceiling" or tr.Entity:GetClass()=="npc_barnacle" or tr.Entity:GetClass()=="monster_barnacle" or tr.Entity:GetClass()=="npc_security_camera" then
tr.Entity:Fire("Kill")
end
d:SetAttacker(self.Owner)
d:SetInflictor(self.Owner)
d:SetDamage(2147483647)
d:SetDamageType(bit.bor(DMG_AIRBOAT,DMG_BLAST))
tr.Entity:TakeDamageInfo(d)
end

bullet.Num = 1
bullet.Src = self.Owner:GetShootPos()			
bullet.Dir = self.Owner:GetAimVector()
bullet.Force = 2147483647
bullet.Damage = 2147483647
bullet.Trace = 1
bullet.TracerName 	= "ToolTracer"
self:FireBullets(bullet)
 
end

function SWEP:SecondaryAttack()
self:PrimaryAttack()
end
