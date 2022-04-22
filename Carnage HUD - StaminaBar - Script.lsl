//TODO - 
float minOffset         = 0.37;
float maxOffset         = 0.7;

integer listenChannel   = -458790;

string desc_            = "(c)Amy (meljonna Resident)";
string onjectName       = "CARNAGE - StaminaBar";

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

        if (msg == "UPDATESTAMINA,0")
            llOffsetTexture(0, 0.37, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,1") || (msg == "UPDATESTAMINA,10"))
            llOffsetTexture(0, 0.4, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,11") || (msg == "UPDATESTAMINA,20"))
            llOffsetTexture(0, 0.43, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,21") || (msg == "UPDATESTAMINA,30"))
            llOffsetTexture(0, 0.45, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,31") || (msg == "UPDATESTAMINA,40"))
            llOffsetTexture(0, 0.48, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,41") || (msg == "UPDATESTAMINA,50"))
            llOffsetTexture(0, 0.51, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,51") || (msg == "UPDATESTAMINA,60"))
            llOffsetTexture(0, 0.54, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,61") || (msg == "UPDATESTAMINA,70"))
            llOffsetTexture(0, 0.57, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,71") || (msg == "UPDATESTAMINA,80"))
            llOffsetTexture(0, 0.6, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,81") || (msg == "UPDATESTAMINA,90"))
            llOffsetTexture(0, 0.62, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,91") || (msg == "UPDATESTAMINA,100"))
            llOffsetTexture(0, 0.7, ALL_SIDES);
    }
}