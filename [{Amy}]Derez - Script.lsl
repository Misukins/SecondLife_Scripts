integer NOBODYSITTING = 3600; //1hour

default
{
    state_entry()
    {
        llOwnerSay("Nobody sitting on me, i will be deleted in 1hour.");
        llSetTimerEvent(NOBODYSITTING);
    }

    on_rez(integer start_parm)
    {
        llOwnerSay("Nobody sitting on me, i will be deleted in 1hour.");
        llSetTimerEvent(NOBODYSITTING);
    }

    changed(integer change)
    {
        if(change & CHANGED_LINK){
            if(llAvatarOnSitTarget() != NULL_KEY)
            state Sitting;
            else
                llSetTimerEvent(0);
        }
    }

    timer()
    {
        llDie();
    }
}

state Sitting
{
    changed(integer change)
    {
        if(change & CHANGED_LINK){
            if(llAvatarOnSitTarget() == NULL_KEY)
                state default;
        }
    }
}
