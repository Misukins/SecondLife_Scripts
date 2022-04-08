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
        llOffsetTexture(0, 0.3, ALL_SIDES);
    }

    listen(integer chan, string name, key id, string msg)
    {
        if (msg == "UPDATESTAMINA,0")
            llOffsetTexture(0, -0.07, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,1") || (msg == "UPDATESTAMINA,10"))
            llOffsetTexture(0, 0.02, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,11") || (msg == "UPDATESTAMINA,20"))
            llOffsetTexture(0, 0.08, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,21") || (msg == "UPDATESTAMINA,30"))
            llOffsetTexture(0, 0.08, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,31") || (msg == "UPDATESTAMINA,40"))
            llOffsetTexture(0, 0.12, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,41") || (msg == "UPDATESTAMINA,50"))
            llOffsetTexture(0, 0.15, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,51") || (msg == "UPDATESTAMINA,60"))
            llOffsetTexture(0, 0.10, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,61") || (msg == "UPDATESTAMINA,70"))
            llOffsetTexture(0, 0.21, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,71") || (msg == "UPDATESTAMINA,80"))
            llOffsetTexture(0, 0.24, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,81") || (msg == "UPDATESTAMINA,90"))
            llOffsetTexture(0, 0.26, ALL_SIDES);
        else if ((msg == "UPDATESTAMINA,91") || (msg == "UPDATESTAMINA,100"))
            llOffsetTexture(0, 0.3, ALL_SIDES);
    }
}
