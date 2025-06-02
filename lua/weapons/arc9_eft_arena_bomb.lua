AddCSLuaFile()
SWEP.Base = "arc9_eft_arena_bomb_defusor"
SWEP.Category = "ARC9 - Escape From Tarkov"
SWEP.SubCategory = ARC9:GetPhrase("eft_subcat_grenades")
SWEP.Spawnable = true

------------------------- |||           Trivia            ||| -------------------------

SWEP.PrintName = ARC9:GetPhrase("eft_weapon_bomb") or "bomb"

SWEP.ViewModel = "models/weapons/arc9/darsu_eft/c_bomb.mdl"
SWEP.WorldModel = "models/weapons/arc9/darsu_eft/w_bomb.mdl"

local path = "weapons/darsu_eft/bomb/"

SWEP.EFT_DefuseMode = false 

SWEP.Animations = {
    ["idle"] = { Source = "plant_idle" },
    ["draw"] = { Source = "plant_idle" },
    ["fire"] = {
        Source = "plant",
        EventTable = {
            { s = path .. "bg_plant_start_no_tap.ogg", t = 0 },
            { s = path .. "blastgang_finger_tap_oneshot_FP.ogg", t = 38/25 },
            { s = path .. "blastgang_plant_end_fp.ogg", t = 130/25 },
            { s = path .. "blastgang_code_running_FP2.ogg", t = 47/25 },
            { s = path .. "blastgang_code_running_FP2.ogg", t = 72/25 },
            { s = path .. "blastgang_code_running_FP2.ogg", t = 101/25 },
            { s = path .. "blastgang_bomb_beep_plant.ogg", t = 120/25 },
            { s = "" },
            { s = "" },
            { s = "" },
            { s = "" },
            { s = "" },
            { s = "" },
            { s = "" },
            { s = "" },
            { s = "" },
        },
        MinProgress = 1
    },
    ["cancel"] = {
        Source = "plant_interrupt",
        EventTable = {
            { s = path .. "blastgang_plant_end_fp.ogg", t = 0/25 },
        },
        MinProgress = 1
    },
}

function SWEP:DoDeployAnimation()
    local owner = self:GetOwner()
    self:GetVM():SetPos(Vector(0, 0, 0)) -- sometimes quickswapping from hl2 gun set vm to weird position

    local WasDrawnByBind = owner:KeyDown(IN_ATTACK) or owner.ARC9QuickthrowPls
    owner.ARC9QuickthrowPls = nil 
    
    if WasDrawnByBind then
        self.WasThrownByBind = true
    else
        self:PlayAnimation("draw", 1, true)
        self:SetReady(true)
    end
end












if EFT_ghostcsent then EFT_ghostcsent:Remove() end
EFT_ghostcsent = nil

local ghostmdl = "models/weapons/arc9/darsu_eft/w_bomb.mdl"
local cred, cgreen = Color(255, 0, 0, 160), Color(0, 255, 0, 160)
local wmat = Material("models/debug/debugwhite")

local vup = Vector(0, 0, 1)
local v2 = Vector(2, 2, 3)
local v3 = Vector(-2, -2, 0)
local v4 = Vector(1, 1, 1)
local v5 = Vector(-1, -1, -1)

function SWEP:EFT_TraceCheckBomb()
    local owner = self:GetOwner()

    local tr = util.TraceHull({
        maxs = v2,
        mins = v3,
        start = owner:EyePos(),
        endpos = owner:EyePos() + owner:EyeAngles():Forward() * 3 / 0.024,
        filter = owner
    })

    local valid = tr.Hit and tr.HitWorld and tr.HitNormal:Length() > 0.9 and math.abs(tr.HitNormal:Dot(vup)) > 0.98
    
    return valid, tr.HitPos
end

local v1 = Vector(0, 0, 2.5)

SWEP.Hook_Think2 = function(self)
    if CLIENT and self:GetOwner() == LocalPlayer() then
        local owner = self:GetOwner()
            -- print(owner.EFTDefusingOrPlanting)
        if !owner.EFTDefusingOrPlanting and !self.WasCanceled then
            if !IsValid(EFT_ghostcsent) then
                EFT_ghostcsent = ClientsideModel(ghostmdl)
                EFT_ghostcsent:Spawn()
                EFT_ghostcsent:SetMaterial("models/debug/debugwhite")
                EFT_ghostcsent:SetRenderMode( RENDERMODE_TRANSALPHA )
            end

            local valid, pos = self:EFT_TraceCheckBomb()
            EFT_ghostcsent:SetPos(pos)
            EFT_ghostcsent:SetAngles(Angle(0, owner:EyeAngles().y - 90, 0))
            EFT_ghostcsent:SetColor(valid and cgreen or cred)
        end
    end
end

if CLIENT then
    local nextcheckk = 0
    hook.Add("Think", "EFTBombGhost", function()
        if nextcheckk < CurTime() and (IsValid(EFT_ghostcsent)) then
            local lp = LocalPlayer()
            local wep = IsValid(lp) and lp:GetActiveWeapon()

            if !IsValid(lp) or !IsValid(wep) or wep:GetClass() != "arc9_eft_arena_bomb" or lp.EFTDefusingOrPlanting or wep.WasCanceled then
                if IsValid(EFT_ghostcsent) then EFT_ghostcsent:Remove() end
            end

            nextcheckk = CurTime() + 0.15
        end
    end)
end

-- SWEP.HookP_BlockFire = function(self)
--     if SERVER and self:GetFiremode() == 2 then
--         local owner = self:GetOwner()
--         if owner:KeyPressed(IN_ATTACK) and self:GetNextPrimaryFire() <= CurTime() then
--             self:EFT_PlaceTripwire()
--             self:SetNextPrimaryFire(CurTime() + 0.5)
--         end
--         return true 
--     end
-- end

-- function SWEP:EFT_PlaceTripwire()
--     local valid, pos = self:EFT_TraceCheckTripwire()
--     local state = ((self:GetEFTTripwireState() or 0) + 1) % 3

--         self:TakeAmmo()
--         -- self:PlayAnimation("fire_mine", 1, true)

--         timer.Simple(0.5, function()
--             if IsValid(self) then
--                 local pos = self:GetEFTTripwireFirstPos()
--                 local peg1 = ents.Create("sent_eft_tripwire_peg")
                
--                 peg1:SetPos(pos)
--             end
--         end)
--     end
-- end
