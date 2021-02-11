default
{
    state_entry()
    {
        llSetLinkTextureAnim(LINK_THIS, ANIM_ON | SMOOTH | LOOP, 0, 20, 0, 1.0, 1, 0.05);
        llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT, 0, TRUE]);
        llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_GLOW, 0, 0.25]);
        llSetTimerEvent(20.0);
    }
 
    timer() 
    {
        llSetLinkColor(LINK_THIS, <llFrand(1.0),llFrand(1.0),llFrand(1.0)>, 0);
        llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POINT_LIGHT, TRUE, <llFrand(1.0), llFrand(1.0), llFrand(1.0)>, 0.600, 4.0, 0.550 ]);
    }
}
