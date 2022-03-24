float blood;

/*NOTE Orig size
<0.02371, 0.09964, 0.01530>

NEW Size = <0.02371, 0.26028, 0.01477>

<0.02371, 0.01000, 0.01000>
*/
default
{
    state_entry()
    {
        //
    }
    
    link_message(integer from,integer to,string msg,key id)
    {
        vector scale = llGetScale();
        float  y     = scale.y;
        float newBlood = blood/5;
        if (msg == "1.00"){
            llSetLinkAlpha(LINK_THIS, 1, ALL_SIDES);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_SIZE, scale]);
        }
        else if (msg == "0.25"){
            llSetLinkAlpha(LINK_THIS, 1, ALL_SIDES);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_SIZE, <newBlood, 0, 0>]);
        }
        else if (msg == "0.10"){
            llSetLinkAlpha(LINK_THIS, 1, ALL_SIDES);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_SIZE, <newBlood, 0, 0>]);
        }
        else if (msg == "EMPTY"){
            llSetLinkAlpha(LINK_THIS, 0, ALL_SIDES);
        }
    }

    /*
    touch_start(integer total_number)
    {
        llOwnerSay("
            I used a prim thats black over the ui blood meter bar...
            im wondering if theres a way to script it somewhat accurate with the seperate meter...
            by making it transparent when full using blocks...like 4 black blocks like this...
            25%50%75%100% not exactly accurate but close i guess....
            the other purple bar i was hoping to make a magicka bar where after you use an ability it drops like 10% once 
            it reaches 0 have to wait for it to regenerate at like 5-10% every minute...before the orb above can be 
            used again to cast the ball....this is to prevent people from mashing the spell.
        ");
    }
    */
}
