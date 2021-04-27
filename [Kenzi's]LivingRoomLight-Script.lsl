integer LIGHT_SIDE = 1;

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        //llListen(14740, "", "", "");
    }

    link_message(integer from,integer to,string msg,key id)
    {
        if (msg == "Low")
        {
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.200, 4.0, 0.150 ]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_GLOW,LIGHT_SIDE,0.15]);
        }
        else if (msg == "Medium")
        {
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_GLOW,LIGHT_SIDE,0.25]);
        }
        else if (msg == "High")
        {
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 10.0, 2.0 ]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_GLOW,LIGHT_SIDE,0.55]);
        }
        else if (msg == "Off")
        {
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_GLOW,LIGHT_SIDE,0.0]);
        }
    }
}
