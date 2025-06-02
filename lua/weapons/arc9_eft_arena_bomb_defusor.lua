AddCSLuaFile()

SWEP.Base = "arc9_base"
SWEP.NotAWeapon = true
SWEP.Spawnable = true 
SWEP.AdminOnly = false
SWEP.Category = "ARC9 - Escape From Tarkov"
SWEP.SubCategory = ARC9:GetPhrase("eft_subcat_grenades")

SWEP.PrintName = "EFT Defusor"

SWEP.ViewModelFOVBase = 62

SWEP.ViewModel = "models/weapons/arc9/darsu_eft/c_bomb_phone.mdl"
SWEP.WorldModel = "models/weapons/arc9/darsu_eft/w_bomb_phone.mdl"
SWEP.DefaultBodygroups = "00000000000000000000"
SWEP.MirrorVMWMHeldOnly = true

SWEP.EntitySelectIcon = true
SWEP.m_bPlayPickupSound = false

SWEP.Slot = 0

SWEP.MirrorVMWM = true
SWEP.TPIKforcelefthand = false
-- SWEP.TPIKParentToSpine4 = true
SWEP.WorldModelOffset = {
    Pos = Vector(-5, 4, -19),
    Ang = Angle(0, 0, 180),
    TPIKPos = Vector(-18, -1, -1),
    TPIKAng = Angle(0, 0, 180),
    -- TPIKPos = Vector(10, -12, -3),
    -- TPIKAng = Angle(0, 90, 90),
    Scale = 1
}

SWEP.CamQCA = 1
SWEP.CamOffsetAng = Angle(0, 0, 90)
SWEP.CamQCA_Mult = 0.5

SWEP.BottomlessClip = true
SWEP.ChamberSize = 0 -- The amount of rounds this gun can chamber.
SWEP.ClipSize = 1 -- Self-explanatory.
SWEP.SupplyLimit = 1 -- Amount of magazines of ammo this gun can take from an ARC9 supply crate.
SWEP.SecondarySupplyLimit = 0 -- Amount of reserve UBGL magazines you can take.
SWEP.Crosshair = false 
SWEP.Disposable = true 

SWEP.NoAimAssist = true
SWEP.CanLean = false 
SWEP.NotForNPCs = true   
SWEP.CantSafety = true   

SWEP.FreeAimRadius = 0 -- In degrees, how much this gun can free aim in hip fire.
SWEP.Sway = 0 -- How much the gun sways.

SWEP.Ammo = ""

SWEP.Firemodes = {{Mode = 1}}

SWEP.SprintPos = Vector(-0.45, 1.8, -1)
SWEP.SprintAng = Angle(0, 0, 0)

SWEP.ActivePos = Vector(-0.45, 1.8, -1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.RestPos = Vector(-0.45, 1.8, -1)
SWEP.RestAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(-0.45, 1.8, -1)
SWEP.HolsterAng = Angle(0, 0, 0)

SWEP.HoldType = "revolver"
-- SWEP.HoldType = "normal"
SWEP.HoldTypeSprint = "normal"
SWEP.HoldTypeHolstered = "normal"
SWEP.HoldTypeSights = "normal"
SWEP.HoldTypeCustomize = "normal"
SWEP.HoldTypeBlindfire = "normal"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RELOAD_SUITCASE
SWEP.AnimReload = ACT_HL2MP_GESTURE_RELOAD_SUITCASE
SWEP.AnimDraw = ACT_HL2MP_GESTURE_RELOAD_SUITCASE

SWEP.Hook_TranslateAnimation = function(swep, anim)
    local elements = swep:GetElements()
end

SWEP.DeployTime = 0
SWEP.DrawTime = 1
SWEP.HolsterTime = 0

local path = "weapons/darsu_eft/bomb/"

SWEP.Animations = {
    ["idle"] = { Source = "defuse_idle" },
    -- ["idle"] = { Source = "defuse_stare" },  
    ["draw"] = { Source = "defuse_idle" },
    -- ["draw"] = { Source = "defuse_start" },
    ["fire"] = {
        Source = "defuse",
        EventTable = {
            { s = path .. "bg_defuse_start_no_tap.ogg", t = 0 },
            { s = path .. "bomb_signal_defuse.ogg", t = 0.25 },
            { s = path .. "blastgang_defuse_beep.ogg", t = 1.0 },
            { s = path .. "blastgang_finger_tap_oneshot_FP.ogg", t = 27/25 },
            { s = path .. "blastgang_finger_tap_oneshot_FP.ogg", t = 47/25 },
            { s = path .. "blastgang_code_running_FP2.ogg", t = 47/25 },
            { s = path .. "blastgang_finger_tap_oneshot_FP.ogg", t = 72/25 },
            { s = path .. "blastgang_code_running_FP2.ogg", t = 72/25 },
            { s = path .. "blastgang_finger_tap_oneshot_FP.ogg", t = 101/25 },
            { s = path .. "blastgang_code_running_FP2.ogg", t = 101/25 },
            { s = path .. "blastgang_finger_tap_oneshot_FP.ogg", t = 128/25 },
            { s = path .. "blastgang_code_running_FP2.ogg", t = 128/25 },
            { s = path .. "blastgang_finger_tap_oneshot_FP.ogg", t = 156/25 },
            { s = path .. "blastgang_code_running_FP2.ogg", t = 156/25 },
            { s = path .. "blastgang_defuse_end_fp.ogg", t = 186/25 },
            { s = path .. "blastgang_bomb_beep_defuse.ogg", t = 186/25 },
        },
        MinProgress = 1
    },
    ["cancel"] = {
        Source = "defuse_interrupt",
        EventTable = {
            { s = path .. "blastgang_defuse_end_fp.ogg", t = 0/25 },
        },
        MinProgress = 1
    },
}


SWEP.NoTPIK = false 

SWEP.NextUse = 0

local function SetTimerButShared(wep, time, callback, id) 
    if !IsFirstTimePredicted() and !game.SinglePlayer() then return end
    table.insert(wep.ActiveTimers, {time + CurTime(), id or "", callback})
end

function SWEP:Hook_BlockTPIK()
    -- print("meow")
    -- return self:GetNWBool("EFTNoTPIK", true)
    -- self:SetHoldType("revolver")
end

local starttime = CurTime()
local nextiptime = CurTime()
local stage = 0
SWEP.EFT_DefuseMode = true
local ostime = os.date( "%H:%M", os.time() )
local iptables = {}
for i = 1, 16 do
    table.insert(iptables, "192.168.0." .. math.random(1, 255))
end
iptables[0] = "192.168.0.0"


function SWEP:PrimaryAttack()
    if game.SinglePlayer() then
        self:CallOnClient("PrimaryAttack")
    end
    
    if self.NextUse > CurTime() then return end

    -- self.WasThrownByBind = nil

    local ply = self:GetOwner()

    
    if !self.EFT_DefuseMode then 
        self.EFT_CanPlant, self.EFT_BombSpot = self:EFT_TraceCheckBomb()
        if !self.EFT_CanPlant then return end
    end

    ply:Freeze( true )

    ply.EFTDefusingOrPlanting = true


    local time = self:PlayAnimation("fire", 1, true)

    self.NextUse = CurTime() + time
    self.StartUseTime = CurTime()




    starttime = CurTime()
    stage = 0
    nextiptime = CurTime() + 47/25 + 0.05
    ostime = os.date( "%H:%M", os.time() )
    iptables = {}
    for i = 1, 16 do
        table.insert(iptables, "192.168.0." .. math.random(1, 255))
    end
    iptables[0] = "192.168.0.0"

    -- self:SetHoldType("revolver")
    -- SetTimerButShared(self, 0.2, function()
    --     self:SetNWBool("EFTNoTPIK", false)
    -- end, "yestpik")

    SetTimerButShared(self, time * 0.9, function()
        -- if SERVER then 
        --     ply:SetHealth(math.Clamp(ply:Health() + 25, 0, ply:GetMaxHealth()))
        -- end

        self:TakeAmmo(1)
        ply:Freeze( false )

        if self.EFT_DefuseMode then
            ply.EFTDefusingOrPlanting = false
            if self.EFTBomba and IsValid(self.EFTBomba) then
                self.EFTBomba:Defuse()
            end
        else
            if SERVER then
                local bombastic = ents.Create("arc9_eft_planted_bomb")
                    
                bombastic:SetPos(self.EFT_BombSpot)
                bombastic:SetAngles(Angle(0, ply:EyeAngles().y - 90, 0))
                bombastic:Spawn()
            end
        end
        -- self:SetNWBool("EFTNoTPIK", true)
        -- self:SetHoldType(self.HoldType)
    end, "endanim")

    self:SetTimer(time, function()
        self:Holster()
        ply:ConCommand("lastinv") -- switch to prev weapon
    end, "endfull")
end

function SWEP:DoDeployAnimation()
    local owner = self:GetOwner()
    self:GetVM():SetPos(Vector(0, 0, 0)) -- sometimes quickswapping from hl2 gun set vm to weird position

    -- local WasDrawnByBind = owner:KeyDown(IN_ATTACK) or owner.ARC9QuickthrowPls
    -- owner.ARC9QuickthrowPls = nil 
    
    -- if WasDrawnByBind then
        -- self.WasThrownByBind = true
    -- else
    --     self:PlayAnimation("draw", 1, true)
    --     self:SetReady(true)
    -- end

    local possiblebomb

    local tEntities = ents.FindInBox(owner:GetPos() - Vector(64, 64, 64), owner:GetPos() + Vector(64, 64, 64))
    for i = 1, #tEntities do
		if tEntities[ i ]:GetClass() == "arc9_eft_planted_bomb" and !tEntities[ i ].Defused then
            possiblebomb = tEntities[ i ]
            break
		end
	end

    if possiblebomb then
        possiblebomb.DefusorSWEP = self
        self.EFTBomba = possiblebomb
        self:PrimaryAttack()
    else
        owner:ConCommand("lastinv") -- switch to prev weapon
        if SERVER then self:Remove() end
    end
end

function SWEP:Cancel()
    -- self:SetNWBool("EFTMEDNoTPIK", true)
    -- self:SetHoldType(self.HoldType)
    local ply = self:GetOwner()
    ply:Freeze( false )
    self:KillTimers() -- stop everything
    ply:ConCommand("lastinv") -- switch to prev weapon
    self.WasCanceled = true
    self.NextUse = CurTime() + 1
    ply.EFTDefusingOrPlanting = false
end

function SWEP:Hook_Think()
    local ply = self:GetOwner()
    if ply.EFTDefusingOrPlanting then
        if CurTime() - (self.StartUseTime or 0) > 0.2 then
            if ply:KeyPressed(IN_USE + IN_JUMP + IN_FORWARD + IN_BACK + IN_MOVELEFT + IN_MOVERIGHT) then
                self:Cancel()
            end
        end
    end
    if self.Hook_Think2 then self:Hook_Think2() end
end


-- DEFINE_BASECLASS(SWEP.Base)
-- function SWEP:Holster(wep)
--     if self.NextUse-0.1 > CurTime() then return end
--     return BaseClass.Holster(self, wep)
-- end

function SWEP:Holster(wep)
    if !IsValid(self) then return end
    local vm = self:GetVM()
    if !IsValid(vm) then return end
    if game.SinglePlayer() and CLIENT then vm:ResetSequenceInfo() return end

    if self.NextUse > CurTime() and !self.WasCanceled then
        self:Cancel()
        return 
    end

    local owner = self:GetOwner()

    if CLIENT and owner != LocalPlayer() then return end

    if owner:IsNPC() then
        return
    end

    self:SetCustomize(false)
    -- print(self:GetHolsterTime())
    if self:GetHolsterTime() > CurTime() then return false end

    if (self:GetHolsterTime() != 0 and self:GetHolsterTime() <= CurTime()) or !IsValid(wep) then
        -- Do the final holster request
        -- Picking up props try to switch to NULL, by the way
        self:SetHolsterTime(0)
        self:SetHolster_Entity(NULL)

        self:KillTimers()
        owner:SetFOV(0, 0)
        owner:SetCanZoom(true)
        self:EndLoop()

        self:ClientHolster()

        if game.SinglePlayer() then
            game.SetTimeScale(1)
        end

        -- if self.SetBreathDSP then
        --     self:GetOwner():SetDSP(0)
        --     self.SetBreathDSP = false
        -- end

        self:RunHook("Hook_Holster")

        if SERVER then self:KillShield() end

        if SERVER and self.WasDirectUsed then self:Remove() end
        
        if SERVER and self:GetProcessedValue("Disposable", true) and self:Clip1() == 0 and self:Ammo1() == 0 and !IsValid(self:GetDetonatorEntity()) then self:Remove() end

        
        self.WasCanceled = nil 

        self:SetLastHolsterTime(CurTime())

        if self.EFT_DefuseMode then self:Remove() end

        return true
    else
        -- Prepare the holster and set up the timer
        self:KillTimer("ejectat")
        self:SetHolster_Entity(wep)
        
            local selectholsteranimation = self.WasCanceled and "cancel" or "holster"
            
            if self:HasAnimation(selectholsteranimation) then
                local animation = self:PlayAnimation(selectholsteranimation, 1, true, false, nil, nil, true) or 0
                -- local aentry = self:GetAnimationEntry(self:TranslateAnimation(selectholsteranimation))
                -- local alength = aentry.MinProgress or animation
                -- alength = alength * (aentry.Mult or 1)
                -- print("yip yap", animation, alength)
                self:SetHolsterTime(CurTime() + animation)
            else
                self:SetHolsterTime(CurTime())
            end

        local animdrwa = self:GetValue("AnimDraw")

        if animdrwa then
            self:DoPlayerAnimationEvent(animdrwa)
        end

        -- self:ToggleBlindFire(false)
        self:SetInSights(false)
        self:ToggleUBGL(false)
        self:SetCycleFinishTime(0)
    end
end




if CLIENT then
    surface.CreateFont("eftdefusefont1", { font = "Bender", size = 12, weight = 550, blursize = 0, antialias = true, extended = true })
    surface.CreateFont("eftdefusefont2", { font = "Bender", size = 21, weight = 550, blursize = 0, antialias = true, extended = true })
    surface.CreateFont("eftdefusefont3", { font = "Bender", size = 26, weight = 550, blursize = 0, antialias = true, extended = true })
    surface.CreateFont("eftdefusefont4", { font = "Bender", size = 21, weight = 600, blursize = 0, antialias = true, extended = true })

	local eftscreenRT = GetRenderTarget("eftscreenRT", 1024, 512)

	local eftscreen = Material("models/weapons/arc9/darsu_eft/bomb/item_blastgang_backpack_screen_code_LOD0")
	local eftscreentest = Material("models/weapons/arc9/darsu_eft/bomb/Arena_Phone_Main_Screen.png", "mips")

	local footer = Material("models/weapons/arc9/darsu_eft/bomb/Arena_Phone_ icons_Footer.png", "mips")
	local charge = Material("models/weapons/arc9/darsu_eft/bomb/Arena_Phone_ icons_charge.png", "mips")
	local back = Material("models/weapons/arc9/darsu_eft/bomb/Arena_Phone_ icons_back_button.png", "mips")
	local attack = Material("models/weapons/arc9/darsu_eft/bomb/Arena_Phone_ icons_Attack.png", "mips")
	local buttn = Material("models/weapons/arc9/darsu_eft/bomb/Arena_Phone_Buttons.png", "mips")

	eftscreen:SetTexture("$basetexture", eftscreenRT:GetName())

	local fullcolor = Color(255, 255, 255, 255)
	local redcolor = Color(255, 27, 27)
	local greencolor = Color(27, 255, 27)
	local bgcolor = Color(12, 12, 12)
	local gray = Color(27, 27, 27)


    local nextipdelays = { 72/25 - 47/25, 101/25 - 72/25, 127/25 - 101/25, 156/25 - 127/25, 1, 1, 1, 1, 1, 1  }
    -- local nextipdelays = { 72/25 - 47/25, 10, 10, 10, 10, 10, 10, 10, 10, 10 }

    local smoothstage = 0
    local staticip = "192.0.2.15"
    
    local consoletexts = {
        "[OK][%s][Connecting to server %s]",
        "[OK][%s][Connected to server %s]",
        "[OK][%s][Check another connections on %s]",
        "[OK][%s][Apply drop rules to iptables on %s]",
        "[OK][%s][Check ssl-lib on %s]",
        "[OK][%s][Check ssh-pass-lib on %s]",
        "[OK][%s][Check ssh keys on %s]",
        "[OK][%s][Check root user activtiy on %s]",
        "[OK][%s][Check conncetion to " .. staticip .. " on %s]",
        "[OK][%s][Attempting to connect to " .. staticip .. "..]",
        "[ERR][%s][Failed attempt to connect to " .. staticip .. "]",

        "[ERR][%s][A stable chain of servers is established]",
        "[ERR][%s][Welcome to system!]",
        
        "[ERR][%s][Switching to alternitive server.]",
    }

	local nextcallrt = 0

    function SWEP:EFT_CallRT()
	-- local function callrt()
		if CurTime() < nextcallrt then return end
		nextcallrt = CurTime() + 0.02

		render.PushRenderTarget(eftscreenRT)
		render.OverrideAlphaWriteEnable(true, true)

		render.ClearDepth()
		render.Clear( 0, 0, 0, 0 )

        stage = math.min(stage, 7)
        if CurTime() > nextiptime then stage = stage + 1 nextiptime = CurTime() + nextipdelays[stage] end
        
        smoothstage = Lerp(0.2, smoothstage, stage)

        local consoleline = math.min(11, 10 - math.Round((nextiptime - 0.3 - CurTime()) * 15))

		cam.Start2D()
			surface.SetDrawColor(bgcolor)
			surface.DrawRect(0, 0, 1024, 512)

			-- surface.SetDrawColor(fullcolor)
			-- surface.SetMaterial(eftscreentest)
			-- surface.DrawTexturedRect(20, 10, 1024-40, 485)

            if self.EFT_DefuseMode and stage >= 0 and stage < 6 then
                surface.SetDrawColor(fullcolor)

                for i = 1, 16 - stage do
                    local offsett = -70 * 11 + smoothstage * 70 
                    surface.DrawRect(710, 10 + 70 * i + offsett, 250, 40)
                    draw.SimpleText("Connect to " .. iptables[16-i +1 ] .. "", "eftdefusefont4", 710 + 125, 30 + 70 * i + offsett, bgcolor, 1, 1)
                end
            end

			surface.SetDrawColor(bgcolor)
			surface.DrawRect(710, 55, 250, 15)

			surface.SetDrawColor(gray)
			surface.DrawRect(20, 10, 1024-40, 45)
			surface.DrawRect(20, 485-51, 1024-40, 60)

            
			surface.SetDrawColor(fullcolor)
            
			surface.SetMaterial(footer)
			surface.DrawTexturedRect(354, 460, 316, 19)
			surface.SetMaterial(charge)
			surface.DrawTexturedRect(946, 29, 22, 11)
			surface.SetMaterial(back)
			surface.DrawTexturedRect(65, 29, 8, 16)


			draw.SimpleText("78%", "eftdefusefont1", 920, 29, fullcolor, 0, 0)
			draw.SimpleText("BACK", "eftdefusefont2", 90, 25, fullcolor, 0, 0)

            if stage > 0 and stage < (self.EFT_DefuseMode and 6 or 4) then
                for i = 1, 10 do
                    if consoleline >= i - 1 then 
                        draw.SimpleText(string.format(consoletexts[i], ostime, iptables[stage]), "eftdefusefont3", 65, 38 + 30 * i, fullcolor, 0, 0) 
                    end
                end
                
                if consoleline >= 10 then
                    if self.EFT_DefuseMode then 
                        if stage < 5 then
                            draw.SimpleText(string.format(consoletexts[11], ostime, iptables[stage]), "eftdefusefont3", 65, 38 + 30 * 11, redcolor, 0, 0) 
                        else
                            draw.SimpleText(string.format(consoletexts[12], ostime), "eftdefusefont3", 65, 38 + 30 * 11, greencolor, 0, 0)
                            if consoleline >= 11 then draw.SimpleText(string.format(consoletexts[13], ostime), "eftdefusefont3", 65, 38 + 30 * 12, greencolor, 0, 0) end
                        end
                    else
                        if stage < 3 then
                            draw.SimpleText(string.format(consoletexts[11], ostime, iptables[stage]), "eftdefusefont3", 65, 38 + 30 * 11, redcolor, 0, 0) 
                            if consoleline >= 11 then draw.SimpleText(string.format(consoletexts[14], ostime), "eftdefusefont3", 65, 38 + 30 * 12, redcolor, 0, 0) end
                        else
                            draw.SimpleText(string.format(consoletexts[12], ostime), "eftdefusefont3", 65, 38 + 30 * 11, greencolor, 0, 0)
                            if consoleline >= 11 then draw.SimpleText(string.format(consoletexts[13], ostime), "eftdefusefont3", 65, 38 + 30 * 12, greencolor, 0, 0) end
                        end
                    end
                end
            end

            if stage >= (self.EFT_DefuseMode and 6 or 4) then
                surface.SetDrawColor(255, 255, 255, 255 * math.min(1, (smoothstage - (self.EFT_DefuseMode and 5 or 3))))
                surface.SetMaterial(attack)
                surface.DrawTexturedRect(409, 140, 200, 200)
            end
		cam.End2D()

		render.OverrideAlphaWriteEnable(false)
		render.PopRenderTarget()
	end

	timer.Simple(15, function() -- idkk
		eftscreen = Material("models/weapons/arc9/darsu_eft/bomb/item_blastgang_backpack_screen_code_LOD0")
		eftscreen:SetTexture("$basetexture", eftscreenRT:GetName())
	end)


    
    function SWEP:DrawTranslucentPass(wm)
        -- if !wm then
            self:EFT_CallRT()
        -- end
    end

    hook.Add("HUDPaint", "eftdefusehud", function()
        -- callrt()
        -- Entity(1):GetActiveWeapon():EFT_CallRT()
    end)
end
