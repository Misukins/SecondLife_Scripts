//Lights Setup
vector  lightsColorON   = <1.000, 1.000, 0.850>;
vector  lightsColorOFF  = <1.000, 1.000, 1.000>;
integer lightsON        = TRUE;
integer lightsOFF       = FALSE;
integer lightsFace      = 1;
float   lightsGlowON    = 0.15;
float   lightsGlowOFF   = 0.0;
float   lightsIntensity = 0.502;
float   lightsRadius    = 5.000;
float   lightsFalloff   = 2.000;
float   lightsAlpha     = 0.90;
//------------------------------------------------------
integer link_num;
integer _lamp1;
integer _lamp2;
integer _lamp3;
integer _lamp4;
integer _lamp5;
integer _lamp6;
integer _lamp7;
integer _lamp8;
integer _lamp9;
integer _lamp10;
integer _lamp11;
integer _lamp12;
integer _lamp13;
integer _lamp14;
integer _lamp15;
integer _lamp16;
integer _lamp17;
integer _lamp18;
integer _lamp19;
integer _lamp20;
integer _lamp21;

string LAMP_1  = "Lamp1";
string LAMP_2  = "Lamp2";
string LAMP_3  = "Lamp3";
string LAMP_4  = "Lamp4";
string LAMP_5  = "Lamp5";
string LAMP_6  = "Lamp6";
string LAMP_7  = "Lamp7";
string LAMP_8  = "Lamp8";
string LAMP_9  = "Lamp9";
string LAMP_10 = "Lamp10";
string LAMP_11 = "Lamp11";
string LAMP_12 = "Lamp12";
string LAMP_13 = "Lamp13";
string LAMP_14 = "Lamp14";
string LAMP_15 = "Lamp15";
string LAMP_16 = "Lamp16";
string LAMP_17 = "Lamp17";
string LAMP_18 = "Lamp18";
string LAMP_19 = "Lamp19";
string LAMP_20 = "Lamp20";
string LAMP_21 = "Lamp21";

integer daytime()
{
   vector pos = llGetSunDirection();
   if (pos.z > 0)
    return TRUE;
   else
    return FALSE;
}

determine_Lamp_links()
{
    integer i = link_num;
    integer found = 0;
    do {
        if(llGetLinkName(i) == LAMP_1){
            _lamp1 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_2){
            _lamp2 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_3){
            _lamp3 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_4){
            _lamp4 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_5){
            _lamp5 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_6){
            _lamp6 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_7){
            _lamp7 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_8){
            _lamp8 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_9){
            _lamp9 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_10){
            _lamp10 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_11){
            _lamp11 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_12){
            _lamp12 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_13){
            _lamp13 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_14){
            _lamp14 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_15){
            _lamp15 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_16){
            _lamp16 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_17){
            _lamp17 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_18){
            _lamp18 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_19){
            _lamp19 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_20){
            _lamp20 = i;
            found++;
        }
        else if(llGetLinkName(i) == LAMP_21){
            _lamp21 = i;
            found++;
        }
    }
    while (i-- && found < 21);
    llSetLinkAlpha(_lamp1,  lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp2,  lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp3,  lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp4,  lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp5,  lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp6,  lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp7,  lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp8,  lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp9,  lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp10, lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp11, lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp12, lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp13, lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp14, lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp15, lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp16, lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp17, lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp18, lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp19, lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp20, lightsAlpha, lightsFace);
    llSetLinkAlpha(_lamp21, lightsAlpha, lightsFace);
}

_isDay()
{
    llSetLinkPrimitiveParamsFast(_lamp1, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp1, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp1, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp1, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp2, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp2, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp2, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp2, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp3, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp3, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp3, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp3, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp4, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp4, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp4, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp4, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp5, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp5, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp5, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp5, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp6, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp6, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp6, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp6, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp7, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp7, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp7, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp7, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp8, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp8, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp8, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp8, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp9, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp9, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp9, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp9, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp10, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp10, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp10, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp10, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp11, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp11, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp11, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp11, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp12, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp12, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp12, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp12, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp13, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp13, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp13, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp13, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp14, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp14, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp14, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp14, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp15, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp15, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp15, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp15, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp16, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp16, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp16, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp16, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp17, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp17, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp17, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp17, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp18, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp18, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp18, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp18, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp19, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp19, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp19, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp19, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp20, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp20, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp20, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp20, lightsColorOFF, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp21, [PRIM_POINT_LIGHT, lightsOFF, lightsColorOFF, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp21, [PRIM_FULLBRIGHT, lightsFace, lightsOFF]);
    llSetLinkPrimitiveParamsFast(_lamp21, [PRIM_GLOW, lightsFace, lightsGlowOFF]);
    llSetLinkColor(_lamp21, lightsColorOFF, lightsFace);
}

_isNight()
{
    llSetLinkPrimitiveParamsFast(_lamp1, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp1, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp1, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp1, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp2, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp2, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp2, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp2, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp3, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp3, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp3, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp3, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp4, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp4, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp4, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp4, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp5, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp5, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp5, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp5, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp6, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp6, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp6, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp6, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp7, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp7, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp7, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp7, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp8, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp8, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp8, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp8, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp9, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp9, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp9, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp9, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp10, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp10, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp10, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp10, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp11, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp11, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp11, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp11, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp12, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp12, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp12, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp12, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp13, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp13, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp13, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp13, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp14, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp14, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp14, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp14, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp15, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp15, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp15, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp15, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp16, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp16, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp16, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp16, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp17, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp17, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp17, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp17, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp18, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp18, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp18, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp18, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp19, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp19, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp19, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp19, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp20, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp20, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp20, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp20, lightsColorON, lightsFace);
    llSetLinkPrimitiveParamsFast(_lamp21, [PRIM_POINT_LIGHT, lightsON, lightsColorON, lightsIntensity, lightsRadius, lightsFalloff ]);
    llSetLinkPrimitiveParamsFast(_lamp21, [PRIM_FULLBRIGHT, lightsFace, lightsON]);
    llSetLinkPrimitiveParamsFast(_lamp21, [PRIM_GLOW, lightsFace, lightsGlowON]);
    llSetLinkColor(_lamp21, lightsColorON, lightsFace);
}
default
{
    state_entry()
    {
        link_num = llGetNumberOfPrims();
        determine_Lamp_links();
        if (!daytime())
            state night;
        _isDay();
        llSetTimerEvent(30.0);
    }

    timer()
    {
        if (!daytime())
            state night;
    }
}

state night
{
    state_entry()
    {
        link_num = llGetNumberOfPrims();
        determine_Lamp_links();
        if (daytime())
            state default;
        _isNight();
        llSetTimerEvent(30.0);
    }

    timer()
    {
        if (daytime())
            state default;
    }
}