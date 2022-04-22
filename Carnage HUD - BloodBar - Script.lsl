//TODO - 
float minOffset         = 0.37;
float maxOffset         = 0.7;

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
        llOffsetTexture(0, 0.37, ALL_SIDES);
    }

    //llSetPrimitiveParams([PRIM_TEXTURE, LINK_THIS, default_texture_DIFF, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0]);
    listen(integer chan, string name, key id, string msg)
    {
        /*
            0.7 //100
            0.62 //90
            0.6 //80
            0.57 //70
            0.54 //60
            0.51 //50
            0.48 //40
            0.45 //30
            0.43 //20
            0.4 //10
            0.37 //0
        */

        if (msg == "UPDATEBLOOD,0")
            llOffsetTexture(0, 0.37, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,1") || (msg == "UPDATEBLOOD,10"))
            llOffsetTexture(0, 0.4, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,11") || (msg == "UPDATEBLOOD,20"))
            llOffsetTexture(0, 0.43, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,21") || (msg == "UPDATEBLOOD,30"))
            llOffsetTexture(0, 0.45, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,31") || (msg == "UPDATEBLOOD,40"))
            llOffsetTexture(0, 0.48, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,41") || (msg == "UPDATEBLOOD,50"))
            llOffsetTexture(0, 0.51, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,51") || (msg == "UPDATEBLOOD,60"))
            llOffsetTexture(0, 0.54, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,61") || (msg == "UPDATEBLOOD,70"))
            llOffsetTexture(0, 0.57, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,71") || (msg == "UPDATEBLOOD,80"))
            llOffsetTexture(0, 0.6, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,81") || (msg == "UPDATEBLOOD,90"))
            llOffsetTexture(0, 0.62, ALL_SIDES);
        else if ((msg == "UPDATEBLOOD,91") || (msg == "UPDATEBLOOD,100"))
            llOffsetTexture(0, 0.7, ALL_SIDES);
    }
}