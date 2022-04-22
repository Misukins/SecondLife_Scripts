
float minOffset         = 0.07;
float maxOffset         = 0.37;

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
        llOffsetTexture(0, 0.07, ALL_SIDES);
    }

    //llSetPrimitiveParams([PRIM_TEXTURE, LINK_THIS, default_texture_DIFF, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0]);
    listen(integer chan, string name, key id, string msg)
    {
        integer i; for (;i < msg; ++i){
            llOffsetTexture(0, msg, ALL_SIDES);
        }
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

        /* if (msg == "UPDATEHEALTH,0")
            llOffsetTexture(0, 0.37, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,1") || (msg == "UPDATEHEALTH,10"))
            llOffsetTexture(0, 0.4, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,11") || (msg == "UPDATEHEALTH,20"))
            llOffsetTexture(0, 0.43, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,21") || (msg == "UPDATEHEALTH,30"))
            llOffsetTexture(0, 0.45, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,31") || (msg == "UPDATEHEALTH,40"))
            llOffsetTexture(0, 0.48, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,41") || (msg == "UPDATEHEALTH,50"))
            llOffsetTexture(0, 0.51, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,51") || (msg == "UPDATEHEALTH,60"))
            llOffsetTexture(0, 0.54, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,61") || (msg == "UPDATEHEALTH,70"))
            llOffsetTexture(0, 0.57, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,71") || (msg == "UPDATEHEALTH,80"))
            llOffsetTexture(0, 0.6, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,81") || (msg == "UPDATEHEALTH,90"))
            llOffsetTexture(0, 0.62, ALL_SIDES);
        else if ((msg == "UPDATEHEALTH,91") || (msg == "UPDATEHEALTH,100"))
            llOffsetTexture(0, 0.7, ALL_SIDES); */
    }
}