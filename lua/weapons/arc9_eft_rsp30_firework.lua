AddCSLuaFile()
SWEP.Base = "arc9_eft_rsp30_white"
SWEP.Category = "ARC9 - Escape From Tarkov"
SWEP.SubCategory = ARC9:GetPhrase("eft_subcat_grenades")
SWEP.Spawnable = true

------------------------- |||           Trivia            ||| -------------------------

ARC9:AddPhrase("eft_weapon_rsp30f", "RSP-30 (Firework)", "en")
ARC9:AddPhrase("eft_weapon_rsp30f", "РСП-30 (Фейерверк)", "ru")
ARC9:AddPhrase("eft_weapon_rsp30f", "RSP-30 (Firework)", "uwu")
SWEP.PrintName = ARC9:GetPhrase("eft_weapon_rsp30f")
SWEP.Description = [[RSP-30 is a reactive signal cartridge for commanding and maintaining squad interaction. Multi-star rocket cartridges are used as flares. ]]

SWEP.DefaultSkin = 2
SWEP.ShootEnt = "arc9_eft_26x75_firework"