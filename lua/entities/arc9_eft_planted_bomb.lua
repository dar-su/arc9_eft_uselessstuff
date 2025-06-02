-- Made by Matsilagi

AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = true

ENT.FlareColor = Color(255, 64, 30, 1)
local flaremat = Material("entities/eft_sp81_attachments/flare")

function ENT:Draw()
	self:DrawModel()

    local light = DynamicLight(self:EntIndex())

	self.Brightness = math.Approach(self.Brightness or 1, 0, FrameTime() * 1)

	local delta = math.max(0.5, self.Brightness)
	
    local minsize = 2 * delta
    local maxsize = 2 * delta

    local colorr = table.Copy(self.FlareColor)
    colorr.r = colorr.r * delta
    colorr.g = colorr.g * delta
    colorr.b = colorr.b * delta

    if light then
        light.Pos = self:GetPos() + Vector(0, 0, 16)
        light.r = colorr.r
        light.g = colorr.g
        light.b = colorr.b
        light.Brightness = 4
        light.Decay = 3
        light.Size = 32 * delta
        light.DieTime = CurTime() + 0.2
    end

	for i = 1, 5 do
		local att = self:GetAttachment(i)
		if att then
			render.SetMaterial(flaremat)
			render.DrawSprite(att.Pos, math.random(minsize, maxsize) * 7, math.random(minsize, maxsize) * 7, colorr)
			colorr.a = 255
			render.DrawSprite(att.Pos, math.random(minsize, maxsize), math.random(minsize, maxsize), colorr)
		end
	end
end

function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/weapons/arc9/darsu_eft/w_bomb.mdl" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		self:DrawShadow( true )
		self:EmitSound( "weapons/darsu_eft/bomb/blastgang_bomb_tick_idle_activated_digital.ogg" )
		self:SetUseType(SIMPLE_USE)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetBuoyancyRatio(0)
		end
	end

	self.BeepTimer = CurTime() + 3
	self.FinalBeep = 0
	self.FinalBeepTimer = CurTime()
	self.ExplodeTimer = CurTime() + 40
end

function ENT:PhysicsCollide(data, physobj)
	if SERVER then
		self:SetMoveType(MOVETYPE_NONE)
	end
end

-- function ENT:Use(activator,caller,useType,value)
-- 	if CLIENT then return end

-- 	if IsValid(activator) and activator:IsPlayer() then
-- 		self:EmitSound("CSGO.C4.disarmstart")

-- 		-- activator:SetNW2Entity("TFA_CSGO_DefuseTarget", self)
-- 		-- activator:SetNW2Float("TFA_CSGO_DefuseProgress", 0)
-- 	end
-- end

function ENT:Use(activator, caller, usetype, value)
	if !self.Defused then
		if !self.Defusing and IsValid(activator) and activator:EyePos():DistToSqr(self:GetPos()) <= (2/0.024)^2 then
			self.Defusing = true
			self.DefuseStartTime = CurTime()
			self.Defusor = activator

			self.Defusor:Give("arc9_eft_arena_bomb_defusor", true)
        	self.Defusor:ConCommand("use arc9_eft_arena_bomb_defusor")
			-- net.Start("arc9eftdefuseprogress")
			-- net.WriteBool(true)
			-- net.Send(activator)
			-- self.LoopSound = self:StartLoopingSound("weapons/darsu_eft/grenades/tripwire_grenade_defuse_loop.wav")
		end
	end
end

function ENT:Think()
	-- self:NextThink( CurTime() )

	self:SetBodygroup(1, IsValid(self.DefusorSWEP) and 1 or 0)

	if !self.Defused and self.BeepTimer <= CurTime() and self.ExplodeTimer > CurTime() + 2 then
		self.BeepTimer = CurTime() + ( self.ExplodeTimer - CurTime() ) / 35
		self.Brightness = 1

		if SERVER then
			local efdata = EffectData()
			efdata:SetEntity(self)
			efdata:SetFlags(1) -- regular beep

			util.Effect("csgo_nade_c4_beep", efdata)
			self:EmitSound( "weapons/darsu_eft/bomb/blastgang_bomb_tick_idle_activated_digital.ogg" )
		end
	end

	if SERVER then
		if !self.Defused and CurTime() > self.ExplodeTimer then
			self:Explode()
			self:Remove()

			return
		end

		if self.FinalBeep == 0 and self.ExplodeTimer <= CurTime() + 2 then
			self.FinalBeep = 1
			self.FinalBeepTimer = CurTime()
		end

		if self.FinalBeep == 1 and self.FinalBeepTimer <= CurTime() then
			local efdata = EffectData()
			efdata:SetEntity(self)
			efdata:SetFlags(2) -- trigger

			util.Effect("csgo_nade_c4_beep", efdata)

			self.FinalBeep = 2
			self.FinalBeepTimer = CurTime() + 1
		end

		if self.FinalBeep == 2 and self.FinalBeepTimer <= CurTime() then
			local efdata = EffectData()
			efdata:SetEntity(self)
			efdata:SetFlags(3) -- last beep right before explosion

			util.Effect("csgo_nade_c4_beep", efdata)

			self.FinalBeep = 3
		end

		
		if self.Defusing and !self.Defused then
			local defusor = self.Defusor
			if !IsValid(defusor) or defusor:EyePos():DistToSqr(self:GetPos()) > (2/0.024)^2 or !defusor:KeyDown(IN_USE) then
				self.Defusing = false
				self.DefuseStartTime = 0
				-- self:StopLoopingSound(self.LoopSound)

				if IsValid(defusor) then
					net.Start("arc9eftdefuseprogress")
					net.WriteBool(false)
					net.Send(defusor)
				end
			else
				local defuseprogress = CurTime() - self.DefuseStartTime
				if defuseprogress > 5 then
					self:Defuse()
				end
			end
		end
	end
end

function ENT:Defuse()
	if !self.Defused then
		self.Defused = true
		-- self:StopLoopingSound(self.LoopSound)
		self:EmitSound(")weapons/darsu_eft/grenades/tripwire_grenade_defuse_end.ogg", 60)

		if IsValid(self.Defusor) then
			net.Start("arc9eftdefuseprogress")
			net.WriteBool(false)
			net.Send(self.Defusor)
		end

		SafeRemoveEntityDelayed(self, 30)
	end
end


function ENT:OnRemove()
end

function ENT:Explode()
	local ply = IsValid(self:GetOwner()) and self:GetOwner() or self
	if SERVER then
	local explode = ents.Create( "info_particle_system" )
		explode:SetKeyValue( "effect_name", "explosion_c4_500" )
		explode:SetOwner( self.Owner )
		explode:SetPos( self:GetPos() )
		explode:Spawn()
		explode:Activate()
		explode:Fire( "start", "", 0 )
		explode:Fire( "kill", "", 30 )
		self:EmitSound( "CSGO.C4.explode" )
	end
	util.BlastDamage( self, ply, self:GetPos(), 1750, 500 )
	local spos = self:GetPos()
	local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-32), filter=self})
	util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)
end