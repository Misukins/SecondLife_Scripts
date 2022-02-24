integer FACE = 0;

default
{
    state_entry()
    {
        llSetPrimitiveParams([PRIM_FULLBRIGHT, FACE, TRUE]);
        llSetPrimitiveParams([PRIM_GLOW, FACE, 0.20]);
        llSetTimerEvent(3.0);
    }

    timer()
    {
        llSetColor(<llFrand(1.0), llFrand(1.0), llFrand(1.0)>, 0);
    }
}