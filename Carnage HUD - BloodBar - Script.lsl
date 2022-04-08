integer listenChannel   = -458790;

string desc_            = "(c)Amy (meljonna Resident)";
string onjectName       = "CARNAGE - BloodBar";

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

    listen(integer chan, string name, key id, string msg)
    {
        if (msg == "UPDATEBLOOD,0")
            llOffsetTexture(0, -0.07, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,1") || (msg == "UPDATEBLOOD,10"))
            llOffsetTexture(0, 0.02, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,11") || (msg == "UPDATEBLOOD,20"))
            llOffsetTexture(0, 0.08, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,21") || (msg == "UPDATEBLOOD,30"))
            llOffsetTexture(0, 0.08, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,31") || (msg == "UPDATEBLOOD,40"))
            llOffsetTexture(0, 0.12, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,41") || (msg == "UPDATEBLOOD,50"))
            llOffsetTexture(0, 0.15, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,51") || (msg == "UPDATEBLOOD,60"))
            llOffsetTexture(0, 0.10, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,61") || (msg == "UPDATEBLOOD,70"))
            llOffsetTexture(0, 0.21, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,71") || (msg == "UPDATEBLOOD,80"))
            llOffsetTexture(0, 0.24, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,81") || (msg == "UPDATEBLOOD,90"))
            llOffsetTexture(0, 0.26, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,91") || (msg == "UPDATEBLOOD,100"))
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
