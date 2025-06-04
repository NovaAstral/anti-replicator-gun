hook.Add("WeaponEquip","weprint",function(wep,ply)
    if(wep:GetClass() == "replicator_disruptor") then
        wep:Remove()
        timer.Simple(0.1,function()
            ply:Give("sg_arg")
            ply:SelectWeapon("sg_arg")
        end)
        
        ply:ChatPrint("You spawned the wrong Anti-Replicator gun! But don't worry, I replaced it with the correct one.")
    end
end)