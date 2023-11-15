key BLANK = "e22e759f-396f-b16c-8ebe-486d5892e02c";

integer random          = TRUE;
integer duplicatecheck  = TRUE;

integer picturefacetext = 4;
integer picturefaceprim = 2;

integer numberoftextures;
integer current_texture;
integer primslength;

float time              = 30.0;

pictures(){
    integer counter;
    string texture = llGetInventoryName(INVENTORY_TEXTURE, current_texture);
    do{
        llSetLinkTexture(picturefaceprim, texture, picturefacetext);
        display_texture(current_texture);
    }
    while(++counter < primslength);
}

default{
    state_entry(){
        numberoftextures = llGetInventoryNumber(INVENTORY_TEXTURE);
        llAllowInventoryDrop(TRUE);
        if(numberoftextures <= 0)
            llSetLinkTexture(picturefaceprim, BLANK, picturefacetext);
        else if(numberoftextures == 1)
            llOwnerSay("I only found 1 picture in my inventory. I need more in order to change them.");
        else{
            llOwnerSay("I found " + (string)numberoftextures + " pictures which I will change every " + (string)time + ".");
            llSetTimerEvent(time);
        }
    }

    on_rez(integer num){
        llResetScript();
    }

    changed(integer change){
        if (change & CHANGED_INVENTORY)
            llResetScript();
    }

    timer(){
        if(random){
            integer randomtexture;
            if(duplicatecheck){
                do
                    randomtexture= llRound(llFrand(numberoftextures - 1));
                while(randomtexture == current_texture);
            }
            else
                randomtexture = llRound(llFrand(numberoftextures - 1));
            current_texture = randomtexture;
            pictures();
        }
        else{
            ++current_texture;
            if(current_texture == numberoftextures)
                current_texture = 0;
            pictures();
        }
        llSetTimerEvent(time);
    }    
}