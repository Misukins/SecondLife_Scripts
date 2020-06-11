vector sit_pos = <0.0, 0.5, 0.8>;
vector sit_rot = <0, 0, 90>;

string ANIMATION;
integer is_sitting = FALSE;
integer anim_num;
integer fire_anim_num;

list SIT_ANIMATIONS = [];

RANDOM_SELECT_ANIMATION()
{
    anim_num = llGetInventoryNumber(INVENTORY_ANIMATION) - 1;
    fire_anim_num = llRound(llFrand(anim_num));
}

SIT_ANIMATION()
{
    ANIMATION = llGetInventoryName(INVENTORY_ANIMATION, fire_anim_num);
}

default
{
    state_entry()
    {
        is_sitting = 0;
        llSitTarget(sit_pos, llEuler2Rot(sit_rot*DEG_TO_RAD));
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            key av = llAvatarOnSitTarget();
            RANDOM_SELECT_ANIMATION();
            if (av != NULL_KEY)
            {
                llRequestPermissions(av, (PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS));
            }
            else
            {
                if ((llGetPermissions() & (PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS)) && is_sitting)
                {
                    is_sitting = 0;
                    llStopAnimation(ANIMATION);
                    llReleaseControls();
                }
            }
        }
        SIT_ANIMATION();
    }
    
    run_time_permissions(integer perm)
    {
        if(perm & (PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS))
        {
            key av = llAvatarOnSitTarget();
            llTakeControls(CONTROL_FWD | CONTROL_BACK, TRUE, FALSE);
            is_sitting = TRUE;
            llStopAnimation("sit_generic");
            llStopAnimation("sit");
            llStartAnimation(ANIMATION);
            llInstantMessage(av, "Up or Down arrow key to change positions");
        }
    }
    
    control(key id, integer level, integer edge)
    {
        if(level & CONTROL_FWD)
        {
            llSleep(0.1);
            fire_anim_num = fire_anim_num + 1;
            if(fire_anim_num > anim_num)
            {
                fire_anim_num = 0;
            }
            llStopAnimation(ANIMATION);
            ANIMATION = llGetInventoryName(INVENTORY_ANIMATION, fire_anim_num);
            llStartAnimation(ANIMATION);
        }
        if(level & CONTROL_BACK)
        {
            llSleep(0.1);
            fire_anim_num = fire_anim_num - 1;
            if(fire_anim_num < 0)
            {
                fire_anim_num = anim_num;
            }
            llStopAnimation(ANIMATION);
            ANIMATION = llGetInventoryName(INVENTORY_ANIMATION, fire_anim_num);
            llStartAnimation(ANIMATION);
        }
    }
}
