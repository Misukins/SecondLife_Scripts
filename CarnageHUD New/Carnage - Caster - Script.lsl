
integer Receiver;
integer startParam = 1;
integer llChan     = -458704;

string fireballcast = "f6d4dd62-c5ff-5007-b8f4-2603e3692b9c";
string object = "BloodBullet";

rotation relativeRot = <.1,.0,.0,.0>; 

vector relativePosOffset = <0.00, 0.0, 0.0>; 
vector relativeVel = <50.0, 0.0, 0.0>; 

default
{
    state_entry()
    {
        if(llGetAttached())
            llSay(llChan, "casterON");
        llPreloadSound(fireballcast);
        Receiver = llListen(330, "", NULL_KEY, "");
        llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
    }
    
    on_rez(integer param)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
        llResetScript();
    }

    attach(key attached)
    {
        if (attached != NULL_KEY)
            llSay(llChan, "casterON");
        else
            llSay(llChan, "casterOFF");
    }
    
    run_time_permissions(integer perm)
    {
        if(PERMISSION_TAKE_CONTROLS & perm){
            llTakeControls(
                CONTROL_FWD |
                CONTROL_BACK |
                CONTROL_LEFT |
                CONTROL_RIGHT |
                CONTROL_ROT_LEFT |
                CONTROL_ROT_RIGHT |
                CONTROL_UP |
                CONTROL_DOWN |
                CONTROL_LBUTTON |
                CONTROL_ML_LBUTTON ,
                TRUE, TRUE);
        }
    }
    
    control(key id, integer level, integer edge)
    {
        if ((edge & level & CONTROL_ML_LBUTTON)) {
            relativePosOffset = <0.5, 0.0, 0.5>;  
            vector myPos = llGetPos();
            rotation myRot = llGetRot();
            vector rezPos = myPos+relativePosOffset*myRot;
            vector rezVel = relativeVel*myRot;
            rotation rezRot = relativeRot*myRot;
            llRezObject(object, rezPos, rezVel, rezRot, startParam);
        }        
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == llKey2Name(llGetOwner())+"shoot"){
            relativePosOffset = <0.5, 0.0, 0.5>; 
            vector myPos = llGetPos();
            rotation myRot = llGetRot();
            vector rezPos = myPos+relativePosOffset*myRot;
            vector rezVel = relativeVel*myRot;
            rotation rezRot = relativeRot*myRot;
            llRezObject(object, rezPos, rezVel, rezRot, startParam);
            llTriggerSound(fireballcast, 1.0);
        }
    }
}
