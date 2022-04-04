integer listenChannel   = -458790;

init()
{
    llSetScale(llGetScale() + (<1.0, 1.0, 0.0>));
}

default
{
    state_entry()
    {
        init();
    }
    
    /* attach(key id)
    {
        if (id != NULL_KEY){
            //llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_SIZE, scale]);
        }
    } */

    listen(integer channel, string name, key id, string message)
    {
        //TODO
        if (channel == listenChannel){
            if (message == "healthFULL"){
                llSetLinkAlpha(LINK_THIS, 0.0, ALL_SIDES);
            }
            else if (message == "healthLOW"){
                llSetLinkAlpha(LINK_THIS, 0.4, ALL_SIDES);
            }
            else if (message == "healthCRIT"){
                llSetLinkAlpha(LINK_THIS, 0.7, ALL_SIDES);
            }
        }
    }
}
