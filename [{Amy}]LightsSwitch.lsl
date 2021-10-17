float soundVolume     = 1.0;

integer link_num;
integer LIGHT_SIDE = 1;
integer lights_switch;
integer ledlight_living;
integer ledlight_living1;
integer ledlight_living2;
integer LIGHTS_ON = FALSE;
integer VoiceChannel    = 0;

string  lightsON_Sound      = "6005e358-33fd-d08b-012f-6110ab27a413";
string  lightsOFF_Sound     = "091402dc-f0ea-81d4-6ca0-728649a1c0c5";
string _LIGTSSWITCH         = "button";
string _LEDLIGHT_LIVING     = "LedLight-LivingRoom";
string _LEDLIGHT_LIVING1    = "LedLight-LivingRoom1";
string _LEDLIGHT_LIVING2    = "LedLight-LivingRoom2";

rotation rotON;
rotation rotOFF;

vector rotatedON    = <5, 0, 0>;
vector rotatedOFF   = <-5, 0, 0>;

determine_display_links(){
    integer i = link_num;
    integer found = 0;
    do{
        if(llGetLinkName(i) == _LIGTSSWITCH){
            lights_switch = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_LIVING){
            ledlight_living = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_LIVING1){
            ledlight_living1 = i;
            found++;
        }
        else if(llGetLinkName(i) == _LEDLIGHT_LIVING2){
            ledlight_living2 = i;
            found++;
        }
    }
    while (i-- && found < 4);
}

init()
{
    LightOFF();
    llPreloadSound(lightsON_Sound);
    llPreloadSound(lightsOFF_Sound);
    rotatedON *= DEG_TO_RAD;
    rotatedOFF *= DEG_TO_RAD;
    rotON = llEuler2Rot(rotatedON);
    rotOFF = llEuler2Rot(rotatedOFF);
    link_num = llGetNumberOfPrims();
    determine_display_links();
    llListen(VoiceChannel, "", "", "");
    llSetLinkPrimitiveParamsFast(lights_switch, [PRIM_ROT_LOCAL, rotOFF]);
}

LightON()
{
    LIGHTS_ON = TRUE;
    llSetLinkPrimitiveParamsFast(lights_switch, [PRIM_ROT_LOCAL, rotON]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 4.0, 0.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.55]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 4.0, 0.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.55]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 1.000, 4.0, 0.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_GLOW,LIGHT_SIDE,0.55]);
    llTriggerSound(lightsON_Sound ,soundVolume);
}

LightOFF()
{
    LIGHTS_ON = FALSE;
    llSetLinkPrimitiveParamsFast(lights_switch, [PRIM_ROT_LOCAL, rotOFF]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living, [PRIM_GLOW,LIGHT_SIDE,0.0]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living1, [PRIM_GLOW,LIGHT_SIDE,0.0]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(ledlight_living2, [PRIM_GLOW,LIGHT_SIDE,0.0]);
    llTriggerSound(lightsOFF_Sound ,soundVolume);
}

default
{
    state_entry()
    {
        init();
    }

    touch_start(integer total_number)
    {
        if(!LIGHTS_ON)
            LightON();
        else
            LightOFF();
        //!LIGHTS_ON = LIGHTS_ON;
    }

    listen(integer chan, string name, key id, string msg)
    {
        if (chan == VoiceChannel){
            if (msg == "lights on"){
                if(!LIGHTS_ON)
                    LightON();
            }
            else if (msg == "lights off"){
                if(LIGHTS_ON)
                    LightOFF();
            }
            else
                return;
        }
    }
}