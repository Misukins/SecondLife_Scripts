string objName = "[{Amy}]Camera Mod v3 - Teleporter";
key id;

doTeleport(key id)
{
    llRequestPermissions(id, PERMISSION_TELEPORT | PERMISSION_TRACK_CAMERA);
}

default
{
    state_entry()
    {
        llSetObjectName(objName);
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    touch_start(integer total_num)
    {
        id = llGetOwner();
        doTeleport(id);
    }

    link_message(integer from,integer to,string msg,key id)
    {
      if (msg == "RESET"){
          llOwnerSay("Resetting - Teleport 2 Camera Script!");
          llResetScript();
        }
    }

    run_time_permissions(integer perm)
    {
        id = llGetOwner();
        if (perm & (PERMISSION_TELEPORT | PERMISSION_TRACK_CAMERA)){
            vector CamPos = llGetCameraPos();
            rotation CamRot = llGetCameraRot();
            vector CamFoc = CamPos + llRot2Fwd(CamRot);
            llTeleportAgent(id, "", CamPos, CamFoc);
        }
        else{
           llResetScript();
        }
    }
}