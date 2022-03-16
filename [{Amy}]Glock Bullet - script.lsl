integer fade = FALSE;
float alpha = 1.0;

splat()
{      
        llSetStatus(STATUS_PHANTOM, TRUE);
        vector pos = llGetPos();  
        llMoveToTarget(pos, 0.3);
        llSetColor(<0,0,1>, ALL_SIDES);
        llTriggerSound("splat4", 1.0);
        llMakeFountain(50, 0.3, 2.0, 4.0, 0.5*PI, 
                        FALSE, "drop", <0,0,0>, 0.0);
        fade = TRUE;
        llSetTimerEvent(0.1);      
}

default
{
    state_entry()
    {
        llSetStatus( STATUS_DIE_AT_EDGE, TRUE);
    }
    
    on_rez(integer delay)
    {
        if (delay > 0)
            llSetTimerEvent((float)delay);
    }

    collision_start(integer total_number)
    {
        splat();
    }

    land_collision_start(vector pos)
    {
        splat();
    }
    
    timer()
    {
        if (!fade)
            llDie();
        else{
            llSetAlpha(alpha, -1);
            alpha = alpha * 0.95;
            if (alpha < 0.1)
                llDie();
        }
    }
}
