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

local function LaserAttack1(e,self)

local laser = {}

laser.Callback = function(a, tr, d)

    tr.Entity:SetHealth(0)
	tr.Entity:Dissolve(math.random(0,3))
	tr.Entity:Ignite(5) 
	
	tr.Entity.AcceptInput = function() return false end                    
    tr.Entity.OnRemove = function(self,...) self:Remove() end
	tr.Entity.OnDeath = function(self,...) self:Remove() end
	tr.Entity.OnTakeDamage = function(self,...) self:Remove() end
	tr.Entity.OnTraceAttack = function(self,...) self:Remove() end
	tr.Entity.CustomThink = function(self,...) self:Remove() end
	tr.Entity.Think = function(self,...) self:Remove() end
	
	
	if (tr.Entity:IsPlayer() and tr.Entity:HasGodMode()) then
	     tr.Entity:Kill()
	     tr.Entity:Dissolve(math.random(0,3))
	     tr.Entity:RemoveFlags(32768)
    end
	
	if (tr.Entity:IsPlayer() and tr.Entity:IsAlive()) then
	     tr.Entity:Kill()
	     tr.Entity:Dissolve(math.random(0,3))
	     tr.Entity:RemoveFlags(32768)
    end
	
    d:SetDamage(1/0)						  
    d:SetInflictor(self.Owner)
    d:SetAttacker(self.Owner)
    d:SetDamageType(DMG_AIRBOAT,DMG_BLAST,DMG_NEVERGIB,DMG_DIRECT,DMG_ENERGYBEAM)
    d:SetDamageForce(self.Owner:GetAimVector()*1e9)
	
end

    laser.Num = 1
    laser.Src = self.Owner:GetShootPos()			
    laser.Dir = self.Owner:GetAimVector()
    laser.Force = 1/0
    laser.Damage = 1/0
    laser.Trace = 1
    laser.TracerName 	= "ToolTracer"
	laser.Attacker = self.Owner

    self:FireBullets(laser)
	
	if SERVER then
	
	local hitscan = ents.FindAlongRay(self.Owner:GetShootPos() + self.Owner:GetAimVector(), self.Owner:GetEyeTrace().HitPos)
	
    for _, e in pairs(hitscan) do
		
		 if e~=self.Owner then
		
		     if (e:IsPlayer() and e:HasGodMode()) then
	              e:Kill()
	              e:Dissolve(math.random(0,3))
	              e:RemoveFlags(32768)
             end
	
             if (e:IsPlayer() and e:IsAlive()) then
	              e:Kill()
	              e:Dissolve(math.random(0,3))
	              e:RemoveFlags(32768)
             end
			
		      if e:GetClass()~="predicted_viewmodel" and not(e:IsWeapon() and e:GetOwner()==self.Owner) and e:GetClass()~="gmod_hands" and e:IsValid() then

			         for i = 1, 4 do
					      e:EmitSound("weapons/fx/rics/ric1.wav")
					 end
			
               local d = DamageInfo()
                     d:SetDamage(1/0)						  
                     d:SetInflictor(self.Owner)
                     d:SetAttacker(self.Owner)
                     d:SetDamageType(DMG_AIRBOAT,DMG_BLAST,DMG_NEVERGIB,DMG_DIRECT,DMG_ENERGYBEAM)
                     d:SetDamageForce(self.Owner:GetAimVector()*1e9)
                     e:TakeDamageInfo(d)
					 
					 e.AcceptInput = function() return false end                    
			         e.OnRemove = function(self,...) self:Remove() end
					 e.OnDeath = function(self,...) self:Remove() end
					 e.OnTakeDamage = function(self,...) self:Remove() end
					 e.OnTraceAttack = function(self,...) self:Remove() end
			         e.CustomThink = function(self,...) self:Remove() end
			         e.Think = function(self,...) self:Remove() end
	
					 e:SetHealth(0)
					 e:Dissolve(math.random(0,3))
		             e:Ignite(5)	
					 e:SetVelocity(self.Owner:GetAimVector()*10000)
					 
					if e:GetClass()=="prop_ragdoll" then
					    timer.Create(tostring(e), 0.15, 10 * 17, function()
                            if e:IsValid() then
                                for i = 1, e:GetPhysicsObjectCount() - 1 do
                                local phys = e:GetPhysicsObjectNum(i)
                                    if phys:IsValid() then
                                    local randomVelocity = Vector(math.random(-7, 7), math.random(-7, 7), math.random(-7, 7)) * math.random(50, 300)
                                    phys:SetVelocity(randomVelocity)
                                    end
                                end
                            end
                        end)
					end	
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
    LaserAttack1(e,self)
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack()
end

function SWEP:GetNPCBulletSpread(p)
	return 0
end
