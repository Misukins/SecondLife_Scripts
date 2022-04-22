//TODO - 
float minOffset         = 0.37;
float maxOffset         = 0.7;

integer listenChannel   = -458790;

string desc_            = "(c)Amy (meljonna Resident)";
string onjectName       = "CARNAGE - ExperienceBar";

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

        if (msg == "UPDATEEXP,0")
            llOffsetTexture(0, 0.37, ALL_SIDES);
        else if ((msg == "UPDATEEXP,1") || (msg == "UPDATEEXP,10"))
            llOffsetTexture(0, 0.4, ALL_SIDES);
        else if ((msg == "UPDATEEXP,11") || (msg == "UPDATEEXP,20"))
            llOffsetTexture(0, 0.43, ALL_SIDES);
        else if ((msg == "UPDATEEXP,21") || (msg == "UPDATEEXP,30"))
            llOffsetTexture(0, 0.45, ALL_SIDES);
        else if ((msg == "UPDATEEXP,31") || (msg == "UPDATEEXP,40"))
            llOffsetTexture(0, 0.48, ALL_SIDES);
        else if ((msg == "UPDATEEXP,41") || (msg == "UPDATEEXP,50"))
            llOffsetTexture(0, 0.51, ALL_SIDES);
        else if ((msg == "UPDATEEXP,51") || (msg == "UPDATEEXP,60"))
            llOffsetTexture(0, 0.54, ALL_SIDES);
        else if ((msg == "UPDATEEXP,61") || (msg == "UPDATEEXP,70"))
            llOffsetTexture(0, 0.57, ALL_SIDES);
        else if ((msg == "UPDATEEXP,71") || (msg == "UPDATEEXP,80"))
            llOffsetTexture(0, 0.6, ALL_SIDES);
        else if ((msg == "UPDATEEXP,81") || (msg == "UPDATEEXP,90"))
            llOffsetTexture(0, 0.62, ALL_SIDES);
        else if ((msg == "UPDATEEXP,91") || (msg == "UPDATEEXP,100"))
            llOffsetTexture(0, 0.7, ALL_SIDES);
    }
}