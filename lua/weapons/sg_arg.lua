AddCSLuaFile() --Makes it show up in singleplayer

SWEP.PrintName = "Anti Replicator Gun"
--set it to CAP categories if CAP is installed, else set to normal 'stargate category'
if (StarGate == nil or StarGate.CheckModule == nil or not StarGate.CheckModule("weapon")) then
    SWEP.Category = "Stargate"
else
    if (SGLanguage != nil and SGLanguage.GetMessage != nil) then
        SWEP.Category = SGLanguage.GetMessage("weapon_misc_cat")
    end

    list.Set("CAP.Weapon", SWEP.PrintName or "", SWEP)
end

local SWEP = {Primary = {}, Secondary = {}}
SWEP.Author = "Nova Astral"
SWEP.Purpose = "Destroy those bugs"
SWEP.Instructions = "LMB - Fire Anti Replicator Wave"
SWEP.DrawCrosshair = true
SWEP.SlotPos = 10
SWEP.Slot = 2
SWEP.Spawnable = true
SWEP.Weight = 1
SWEP.WorldModel = "models/cryptalchemy/humans/weapons/replicator_disruptor.mdl"
SWEP.ViewModel = "models/cryptalchemy/humans/weapons/replicator_disruptor.mdl"
SWEP.ViewModelFOV = 50

SWEP.HoldType = "normal"
SWEP.Primary.Ammo = "none" --This stops it from giving pistol ammo when you get the swep
SWEP.Primary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

function SWEP:CanPrimaryAttack() return false end
function SWEP:CanSecondaryAttack() return false end
function SWEP:Holster() return true end
function SWEP:ShouldDropOnDie() return true end

SWEP.IronSightsPos = Vector(-15,-10,-10)
SWEP.IronSightsAng = Vector(-85,180,90)

function SWEP:GetViewModelPosition(EyePos, EyeAng)
	local Mul = 1.0

	local Offset = self.IronSightsPos

	if (self.IronSightsAng) then
        EyeAng = EyeAng * 1
        
		EyeAng:RotateAroundAxis(EyeAng:Right(),self.IronSightsAng.x * Mul)
		EyeAng:RotateAroundAxis(EyeAng:Up(),self.IronSightsAng.y * Mul)
		EyeAng:RotateAroundAxis(EyeAng:Forward(),self.IronSightsAng.z * Mul)
	end

	local Right = EyeAng:Right()
	local Up = EyeAng:Up()
	local Forward = EyeAng:Forward()

	EyePos = EyePos + Offset.x * Right * Mul
	EyePos = EyePos + Offset.y * Forward * Mul
	EyePos = EyePos + Offset.z * Up * Mul
	
	return EyePos, EyeAng
end

function SWEP:Initialize()
    if(self.SetHoldType) then
        self:SetHoldType("pistol")
    end

    self:DrawShadow(false)
end

if SERVER then
    function SWEP:PrimaryAttack()
        self:SetNextPrimaryFire(CurTime()+2)
        local ply = self:GetOwner()
        if(not IsValid(ply)) then return end

        timer.Simple(0.01,function() --i dont know why, but the sound only works in a timer
            self:EmitSound("stargate/arg_fire.mp3",75,100,1)
        end)
        
        timer.Simple(0.1,function()
            local direction = ply:GetAimVector()

            local ent = ents.Create("sg_arg_projectile")
            ent:SetOwner(ply)
            ent:Initialize()
            ent:SetPos(ply:EyePos() + Vector(10,5,-5))
            ent:SetAngles(ply:EyeAngles())
            ent:SetColor(Color(255,255,255,0))

            local Phys = ent:GetPhysicsObject()

            if(IsValid(Phys)) then
                Phys:EnableGravity(false)
                Phys:SetVelocity(direction * 800)
            end
        end)
    end
end

timer.Simple(0.1, function() weapons.Register(SWEP,"sg_arg", true) end) --Putting this in a timer stops bugs from happening if the weapon is given while the game is paused