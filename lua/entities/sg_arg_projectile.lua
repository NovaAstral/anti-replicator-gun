AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "ARG Projectile"
ENT.Author = "Nova Astral"
ENT.Category = "Stargate"
ENT.Contact	= "https://github.com/NovaAstral"
ENT.Purpose	= "meow :3"
ENT.Instructions = "weeeee"

ENT.Spawnable = false

if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local ent = ents.Create("sg_arg_projectile")
		ent:SetPos(tr.HitPos)
		ent:SetVar("Owner",ply)
		ent:Spawn()
		return ent 
	end

	function ENT:Initialize()
		self.Entity:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)

		self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			
		self.Entity:DrawShadow(false)

		self.Entity:SetColor(Color(255,255,255,0))
		self.Entity:SetNoDraw(true)
			
		self.phys = self.Entity:GetPhysicsObject()

		if(self.phys:IsValid()) then
			self.phys:SetMass(100)
			self.phys:EnableGravity(false)
			self.phys:Wake()
		end

		timer.Simple(1,function()
			self:StopARG()
		end)

		local findent = ents.FindInSphere(self:GetPos(),200) --do it instantly so it gets stuff easier

		for k,ent in pairs(findent) do
			if(ent:GetClass() == "replicator_queen" or ent:GetClass() == "replicator_queen_hive" or ent:GetClass() == "replicator_worker" or ent:GetClass() == "replicator_segment") then
				ent:TakeDamage(50,self:GetOwner(),self)
			end
		end

		timer.Create("rep_finder"..self:EntIndex(),0.1,0,function()
			local findent = ents.FindInSphere(self:GetPos(),200)

			for k,ent in pairs(findent) do
				if(ent:GetClass() == "replicator_queen" or ent:GetClass() == "replicator_queen_hive" or ent:GetClass() == "replicator_worker" or ent:GetClass() == "replicator_segment") then
					ent:TakeDamage(50,self:GetOwner(),self)
				end
			end
		end)

		local fx = EffectData()
        fx:SetEntity(self.Entity)
        fx:SetOrigin(self.Entity:GetPos())
        util.Effect("arg_effect", fx, true, true)

		timer.Create("arg_effect"..self:EntIndex(),0.1,0,function()
			local fx = EffectData()
            fx:SetEntity(self.Entity)
            fx:SetOrigin(self.Entity:GetPos())
            util.Effect("arg_effect", fx, true, true)
		end)
	end

	function ENT:PhysicsCollide(data,phys)
		self:StopARG()
	end

	function ENT:StopARG()
		if(self ~= nil) then
			timer.Remove("rep_finder"..self:EntIndex())
			timer.Remove("arg_effect"..self:EntIndex())
			
			self.phys:EnableMotion(false)

			timer.Simple(1,function()
				if(self.Entity ~= nil) then
					self:Remove()
				end
			end)
		end
	end
end