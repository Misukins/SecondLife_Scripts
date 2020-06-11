default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        //
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "*Open*")
        {
            llSetLinkTexture(LINK_THIS, "1d20b793-99ec-3360-af57-3c404a62a350", 1);
            llSetLinkAlpha(LINK_THIS, 0.5, 1);
        }
        else if (str == "*Closed*")
        {
            llSetLinkTexture(LINK_THIS, "8a0f2798-e308-7616-3b86-c0baa091b3a3" , 1);
            llSetLinkAlpha(LINK_THIS, 1, 1);
        }
    }
}