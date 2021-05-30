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
        if (str == "*Open*"){
            llSetLinkAlpha(LINK_THIS, 0.5, 2);
            llSetLinkTexture(LINK_THIS, "1d20b793-99ec-3360-af57-3c404a62a350", 2);
            llSetLinkColor(LINK_THIS, <0.128, 0.128, 0.128>, 2);
        }
        else if (str == "*Closed*"){
            llSetLinkAlpha(LINK_THIS, 1, 2);
            llSetLinkTexture(LINK_THIS, "5748decc-f629-461c-9a36-a35a221fe21f", 2);
            llSetLinkColor(LINK_THIS, <0, 0, 0>, 2);
        }
    }
}