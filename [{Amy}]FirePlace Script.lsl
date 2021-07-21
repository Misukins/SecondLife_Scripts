//flame1
string FLAME_1     = "flame1";
string FLAME_2     = "flame2";
string WOOD_1      = "wood";

integer flame1;
integer flame2;
integer wood1;

integer ON = TRUE;

init()
{
    link_num = llGetNumberOfPrims();
    determine_display_links();
    setup_displays();
}

determine_display_links()
{
    integer i = link_num;
    integer found = 0;
    do {
        if(llGetLinkName(i) == DISPLAY_1){
            display1 = i;
            found++;
        } else if (llGetLinkName(i) == DISPLAY_2){
            display2 = i;
            found++;
        } else if (llGetLinkName(i) == LED_LIGHT){
            led1 = i;
            found++;
        }
    } while (i-- && found < 3);
}

firePlaceON()
{
    llLoopSound(llGetInventoryName(INVENTORY_SOUND, 0), 1);
    llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES, 4, 4, 4.0, 1, 1.1);
    llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
    llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POINT_LIGHT, TRUE,<0.95, 0.65, 0.35>, 1.000, 3.000, 2.000]);
    llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_GLOW, ALL_SIDES, 0.55]);
    llSetLinkAlpha(LINK_THIS, 1, ALL_SIDES);

    llMessageLinked(LINK_SET, 0, "ON", NULL_KEY);
}

firePlaceOFF()
{
    llStopSound();
    llSetTextureAnim(FALSE | SMOOTH | LOOP, ALL_SIDES, 4, 4, 4.0, 1, 1.1);
    llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
    llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POINT_LIGHT, FALSE,<0.95, 0.65, 0.35>, 1.000, 3.000, 2.000]);
    llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_GLOW, ALL_SIDES, 0.0]);
    llSetLinkAlpha(LINK_THIS, 0, ALL_SIDES);

    llMessageLinked(LINK_SET, 0, "OFF", NULL_KEY);
}

default
{
    state_entry()
    {
        firePlaceON();
    }

    touch_start(integer total_number)
    {
        if(ON)
            firePlaceON();
        else
            firePlaceOFF();
        ON = !ON;
    }
}

/*
flame2
default
{
    state_entry()
    {
        //
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "ON"){
            llSetLinkAlpha(LINK_THIS, 1, ALL_SIDES);
            llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,0,0,0.0, -1,-0.2);
        }
        else if (str == "OFF"){
            llSetLinkAlpha(LINK_THIS, 0, ALL_SIDES);
            llSetTextureAnim(FALSE | SMOOTH | LOOP, ALL_SIDES,0,0,0.0, -1,-0.2);
        }
    }
}

wood
default
{
    state_entry()
    {
        //
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "ON"){
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
        }
        else if (str == "OFF"){
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
        }
    }
}
*/