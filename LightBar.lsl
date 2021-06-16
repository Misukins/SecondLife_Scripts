integer g_TIMER     = 0;
integer g_NDX       = 0;

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

default
{
    state_entry()
    {
        g_TIMER = !g_TIMER;
        llSetTimerEvent(g_TIMER);
    }

    timer()
    {
        if(g_NDX > llGetListLength(realcolors) - 1)
            g_NDX = 0;
        llSetLinkPrimitiveParams(LINK_THIS, [PRIM_COLOR, 1, llList2Vector(realcolors, g_NDX), 1.0]);
        llSetLinkPrimitiveParams(LINK_THIS, [PRIM_FULLBRIGHT, 1, TRUE]);
        llSetLinkPrimitiveParams(LINK_THIS, [PRIM_POINT_LIGHT, TRUE, llList2Vector(realcolors, g_NDX), 0.200, 4.0, 0.150 ]);
        llSetLinkPrimitiveParams(LINK_THIS, [PRIM_GLOW, 1, 0.15]);
        ++g_NDX;
    }
}