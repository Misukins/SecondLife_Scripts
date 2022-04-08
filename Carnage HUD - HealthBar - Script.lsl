integer listenChannel   = -458790;

string desc_            = "(c)Amy (meljonna Resident)";
string onjectName       = "CARNAGE - HealthBar";

default
{
    state_entry()
    {
        llSetObjectName(onjectName);
        llSetObjectDesc(desc_);
        llListen(listenChannel, "", "", "");
        llScaleTexture(1, 0.3, ALL_SIDES);
        llOffsetTexture(0, 0.3, ALL_SIDES);
    }

    //llSetPrimitiveParams([PRIM_TEXTURE, LINK_THIS, default_texture_DIFF, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0]);
    listen(integer chan, string name, key id, string msg)
    {
        if (msg == "UPDATEHEALTH,0")
            llOffsetTexture(0, -0.07, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,1") || (msg == "UPDATEHEALTH,10"))
            llOffsetTexture(0, 0.02, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,11") || (msg == "UPDATEHEALTH,20"))
            llOffsetTexture(0, 0.05, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,21") || (msg == "UPDATEHEALTH,30"))
            llOffsetTexture(0, 0.08, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,31") || (msg == "UPDATEHEALTH,40"))
            llOffsetTexture(0, 0.12, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,41") || (msg == "UPDATEHEALTH,50"))
            llOffsetTexture(0, 0.15, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,51") || (msg == "UPDATEHEALTH,60"))
            llOffsetTexture(0, 0.18, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,61") || (msg == "UPDATEHEALTH,70"))
            llOffsetTexture(0, 0.21, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,71") || (msg == "UPDATEHEALTH,80"))
            llOffsetTexture(0, 0.24, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,81") || (msg == "UPDATEHEALTH,90"))
            llOffsetTexture(0, 0.26, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,91") || (msg == "UPDATEHEALTH,100"))
            llOffsetTexture(0, 0.3, ALL_SIDES);
    }
}

/*
100% -
vscale 0.30000 | voffset 0.30000

90
vscale 0.30000 | voffset 0.26000

80
vscale 0.30000 | voffset 0.24000

70
vscale 0.30000 | voffset 0.21000

60
vscale 0.30000 | voffset 0.18000

50
vscale 0.30000 | voffset 0.15000

40
vscale 0.30000 | voffset 0.12000

30
vscale 0.30000 | voffset 0.08000

20
vscale 0.30000 | voffset 0.05000

10
vscale 0.30000 | voffset 0.02000

0
vscale 0.30000 | voffset -0.07000
*/
