//-3044044
integer lightsON = FALSE;
integer channel = -3044044;
integer listenHandle;
integer g_TIMER     = 0;
integer g_NDX       = 0;
integer _FACE       = 0;

list realcolors = [
        <1.000000, 0.000000, 0.000000>, <1.000000, 0.200000, 0.000000>,
        <1.000000, 0.400000, 0.000000>, <1.000000, 0.501961, 0.000000>,
        <1.000000, 0.600000, 0.000000>, <1.000000, 0.698039, 0.000000>,
        <1.000000, 0.800000, 0.000000>, <1.000000, 0.898039, 0.000000>,
        <1.000000, 1.000000, 0.000000>, <0.800000, 1.000000, 0.000000>,
        <0.200000, 1.000000, 0.000000>, <0.000000, 0.800000, 0.000000>,
        <0.000000, 0.698039, 0.400000>, <0.000000, 0.600000, 0.600000>,
        <0.000000, 0.400000, 0.698039>, <0.000000, 0.200000, 0.800000>,
        <0.098039, 0.098039, 0.698039>, <0.200000, 0.000000, 0.600000>,
        <0.250980, 0.000000, 0.600000>, <0.400000, 0.000000, 0.600000>,
        <0.600000, 0.000000, 0.600000>, <0.800000, 0.000000, 0.600000>,
        <0.898039, 0.000000, 0.400000>
    ];

ON()
{
    g_TIMER = !g_TIMER;
    llSetTimerEvent(g_TIMER);
    lightsON = TRUE;
}

OFF()
{
    llSetTimerEvent(0);
    llSetLinkPrimitiveParams(LINK_THIS, [PRIM_COLOR, _FACE, <0.3, 0.3, 0.3>, 1.0]);
    llSetLinkPrimitiveParams(LINK_THIS, [PRIM_FULLBRIGHT, _FACE, FALSE]);
    llSetLinkPrimitiveParams(LINK_THIS, [PRIM_POINT_LIGHT, FALSE, llList2Vector(realcolors, g_NDX), 0.200, 4.0, 0.150 ]);
    llSetLinkPrimitiveParams(LINK_THIS, [PRIM_GLOW, _FACE, 0.0]);
    lightsON = FALSE;
}

default
{
    state_entry()
    {
        listenHandle = llListen(channel, "", "", "");
    }

    listen(integer chan, string name, key id, string msg)
    {
        if(msg == "V5UW||P||<37.75028, 112.18530, 25.12497>||4ccf1ba4-790e-df0b-8397-d3bce8e565e9||1")
            ON();
        else if(msg == "V5UW||P||<37.75028, 112.18530, 25.12497>||4ccf1ba4-790e-df0b-8397-d3bce8e565e9||0")
            OFF();
    }

    timer()
    {
        if(g_NDX > llGetListLength(realcolors) - 1)
            g_NDX = 0;
        llSetLinkPrimitiveParams(LINK_THIS, [PRIM_COLOR, _FACE, llList2Vector(realcolors, g_NDX), 1.0]);
        llSetLinkPrimitiveParams(LINK_THIS, [PRIM_FULLBRIGHT, _FACE, TRUE]);
        llSetLinkPrimitiveParams(LINK_THIS, [PRIM_POINT_LIGHT, TRUE, llList2Vector(realcolors, g_NDX), 0.200, 4.0, 0.150 ]);
        llSetLinkPrimitiveParams(LINK_THIS, [PRIM_GLOW, _FACE, 0.15]);
        ++g_NDX;
    }

    /*
     V5UW||P||<37.75028, 112.18530, 25.12497>||4ccf1ba4-790e-df0b-8397-d3bce8e565e9||1
    */
}