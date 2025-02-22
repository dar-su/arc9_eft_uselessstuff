AddCSLuaFile()
SWEP.Base = "arc9_eft_rsp30_white"
SWEP.Category = "ARC9 - Escape From Tarkov"
SWEP.SubCategory = ARC9:GetPhrase("eft_subcat_grenades")
SWEP.Spawnable = true

------------------------- |||           Trivia            ||| -------------------------

ARC9:AddPhrase("eft_weapon_rsp30b", "RSP-30 (Blue)", "en")
ARC9:AddPhrase("eft_weapon_rsp30b", "РСП-30 (Синий)", "ru")
ARC9:AddPhrase("eft_weapon_rsp30b", "RSP-30 (Blue)", "uwu")
SWEP.PrintName = ARC9:GetPhrase("eft_weapon_rsp30b")
SWEP.Description = [[A reactive signal cartridge for commanding and maintaining squad interaction. Some Scavs use this flare color to send some kinds of signals. The question is, what do these signals mean? ]]

SWEP.DefaultSkin = 0 -- no skin
SWEP.ShootEnt = "arc9_eft_26x75_blue"