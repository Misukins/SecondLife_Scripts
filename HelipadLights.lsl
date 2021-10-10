string LIGHT_1        = "light1";
string LIGHT_2        = "light2";
string LIGHT_3        = "light3";
string LIGHT_4        = "light4";
string LIGHT_5        = "light5";
string LIGHT_6        = "light6";
string LIGHT_7        = "light7";

integer LIGHTFACE = 0;
integer light1;
integer light2;
integer light3;
integer light4;
integer light5;
integer light6;
integer light7;
integer link_num;

integer on = FALSE;
float refreshrate = 5;

determine_display_links()
{
    integer i = link_num;
    integer found = 0;
    do {
        if(llGetLinkName(i) == LIGHT_1){
            light1 = i;
            found++;
        }
        else if (llGetLinkName(i) == LIGHT_2){
            light2 = i;
            found++;
        }
        else if (llGetLinkName(i) == LIGHT_3){
            light3 = i;
            found++;
        }
        else if (llGetLinkName(i) == LIGHT_4){
            light4 = i;
            found++;
        }
        else if (llGetLinkName(i) == LIGHT_5){
            light5 = i;
            found++;
        }
        else if (llGetLinkName(i) == LIGHT_6){
            light6 = i;
            found++;
        }
        else if (llGetLinkName(i) == LIGHT_7){
            light7 = i;
            found++;
        }
    }
    while (i-- && found < 7);
}

init()
{
    link_num = llGetNumberOfPrims();
    on = FALSE;
    determine_display_links();
    llSetTimerEvent(refreshrate);
}

ON()
{
    llSetLinkPrimitiveParamsFast(light1, [PRIM_POINT_LIGHT, TRUE,<1.000, 0.000, 0.000>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(light1, [PRIM_FULLBRIGHT,LIGHTFACE,TRUE]);
    llSetLinkPrimitiveParamsFast(light1, [PRIM_GLOW, LIGHTFACE, 0.5]);
    llSetLinkColor(light1, <1.000, 0.000, 0.000>, LIGHTFACE);
    
    llSetLinkPrimitiveParamsFast(light2, [PRIM_POINT_LIGHT, TRUE,<1.000, 0.000, 0.000>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(light2, [PRIM_FULLBRIGHT,LIGHTFACE,TRUE]);
    llSetLinkPrimitiveParamsFast(light2, [PRIM_GLOW, LIGHTFACE, 0.5]);
    llSetLinkColor(light2, <1.000, 0.000, 0.000>, LIGHTFACE);
    
    llSetLinkPrimitiveParamsFast(light3, [PRIM_POINT_LIGHT, TRUE,<1.000, 0.000, 0.000>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(light3, [PRIM_FULLBRIGHT,LIGHTFACE,TRUE]);
    llSetLinkPrimitiveParamsFast(light3, [PRIM_GLOW, LIGHTFACE, 0.5]);
    llSetLinkColor(light3, <1.000, 0.000, 0.000>, LIGHTFACE);
    
    llSetLinkPrimitiveParamsFast(light4, [PRIM_POINT_LIGHT, TRUE,<1.000, 0.000, 0.000>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(light4, [PRIM_FULLBRIGHT,LIGHTFACE,TRUE]);
    llSetLinkPrimitiveParamsFast(light4, [PRIM_GLOW, LIGHTFACE, 0.5]);
    llSetLinkColor(light4, <1.000, 0.000, 0.000>, LIGHTFACE);
    
    llSetLinkPrimitiveParamsFast(light5, [PRIM_POINT_LIGHT, TRUE,<1.000, 0.000, 0.000>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(light5, [PRIM_FULLBRIGHT,LIGHTFACE,TRUE]);
    llSetLinkPrimitiveParamsFast(light5, [PRIM_GLOW, LIGHTFACE, 0.5]);
    llSetLinkColor(light5, <1.000, 0.000, 0.000>, LIGHTFACE);
    
    llSetLinkPrimitiveParamsFast(light6, [PRIM_POINT_LIGHT, TRUE,<1.000, 0.000, 0.000>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(light6, [PRIM_FULLBRIGHT,LIGHTFACE,TRUE]);
    llSetLinkPrimitiveParamsFast(light6, [PRIM_GLOW, LIGHTFACE, 0.5]);
    llSetLinkColor(light6, <1.000, 0.000, 0.000>, LIGHTFACE);
    
    llSetLinkPrimitiveParamsFast(light7, [PRIM_POINT_LIGHT, TRUE,<1.000, 0.000, 0.000>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(light7, [PRIM_FULLBRIGHT,LIGHTFACE,TRUE]);
    llSetLinkPrimitiveParamsFast(light7, [PRIM_GLOW, LIGHTFACE, 0.5]);
    llSetLinkColor(light7, <1.000, 0.000, 0.000>, LIGHTFACE);
    llSetTimerEvent(refreshrate);
}

OFF()
{
    llSetLinkPrimitiveParamsFast(light1, [PRIM_POINT_LIGHT, FALSE,<1.000, 1.000, 0.950>, 0.502, 5.0, 2.000 ]);
    llSetLinkPrimitiveParamsFast(light1, [PRIM_FULLBRIGHT,LIGHTFACE,FALSE]);
    llSetLinkPrimitiveParamsFast(light1, [PRIM_GLOW, LIGHTFACE, 0.0]);
    llSetLinkColor(light1, <1.000, 1.000, 0.950>, LIGHTFACE);

    llSetLinkPrimitiveParamsFast(light2, [PRIM_POINT_LIGHT, FALSE,<1.000, 1.000, 0.950>, 0.502, 5.0, 2.000 ]);
    llSetLinkPrimitiveParamsFast(light2, [PRIM_FULLBRIGHT,LIGHTFACE,FALSE]);
    llSetLinkPrimitiveParamsFast(light2, [PRIM_GLOW, LIGHTFACE, 0.0]);
    llSetLinkColor(light2, <1.000, 1.000, 0.950>, LIGHTFACE);

    llSetLinkPrimitiveParamsFast(light3, [PRIM_POINT_LIGHT, FALSE,<1.000, 1.000, 0.950>, 0.502, 5.0, 2.000 ]);
    llSetLinkPrimitiveParamsFast(light3, [PRIM_FULLBRIGHT,LIGHTFACE,FALSE]);
    llSetLinkPrimitiveParamsFast(light3, [PRIM_GLOW, LIGHTFACE, 0.0]);
    llSetLinkColor(light3, <1.000, 1.000, 0.950>, LIGHTFACE);

    llSetLinkPrimitiveParamsFast(light4, [PRIM_POINT_LIGHT, FALSE,<1.000, 1.000, 0.950>, 0.502, 5.0, 2.000 ]);
    llSetLinkPrimitiveParamsFast(light4, [PRIM_FULLBRIGHT,LIGHTFACE,FALSE]);
    llSetLinkPrimitiveParamsFast(light4, [PRIM_GLOW, LIGHTFACE, 0.0]);
    llSetLinkColor(light4, <1.000, 1.000, 0.950>, LIGHTFACE);

    llSetLinkPrimitiveParamsFast(light5, [PRIM_POINT_LIGHT, FALSE,<1.000, 1.000, 0.950>, 0.502, 5.0, 2.000 ]);
    llSetLinkPrimitiveParamsFast(light5, [PRIM_FULLBRIGHT,LIGHTFACE,FALSE]);
    llSetLinkPrimitiveParamsFast(light5, [PRIM_GLOW, LIGHTFACE, 0.0]);
    llSetLinkColor(light5, <1.000, 1.000, 0.950>, LIGHTFACE);

    llSetLinkPrimitiveParamsFast(light6, [PRIM_POINT_LIGHT, FALSE,<1.000, 1.000, 0.950>, 0.502, 5.0, 2.000 ]);
    llSetLinkPrimitiveParamsFast(light6, [PRIM_FULLBRIGHT,LIGHTFACE,FALSE]);
    llSetLinkPrimitiveParamsFast(light6, [PRIM_GLOW, LIGHTFACE, 0.0]);
    llSetLinkColor(light6, <1.000, 1.000, 0.950>, LIGHTFACE);

    llSetLinkPrimitiveParamsFast(light7, [PRIM_POINT_LIGHT, FALSE,<1.000, 1.000, 0.950>, 0.502, 5.0, 2.000 ]);
    llSetLinkPrimitiveParamsFast(light7, [PRIM_FULLBRIGHT,LIGHTFACE,FALSE]);
    llSetLinkPrimitiveParamsFast(light7, [PRIM_GLOW, LIGHTFACE, 0.0]);
    llSetLinkColor(light7, <1.000, 1.000, 0.950>, LIGHTFACE);
    llSetTimerEvent(refreshrate);
}

default
{
    state_entry()
    {
        init();
    }

    timer()
    {
        if(on)
            ON();
        else
            OFF();
        on = !on;
    }
}