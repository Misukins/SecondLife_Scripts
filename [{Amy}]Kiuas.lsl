key sauna_stove_knob    = "de01e7b3-3f5a-a565-95bb-3096c47cf60c";
key sauna_steam         = "4814a5e9-c928-71bb-96e6-621b13544ea5";
key sauna_stove_buzz    = "5a43fd78-eaee-6cde-ac6e-110b969f7aca";
key id;

integer channel;
integer listen_handle;
integer TurnedON = FALSE;
integer addedWater = FALSE;
integer RDYtoAddwater = FALSE;
integer SaunaRDY4Use = 1800;
integer steamDuration = 10;
integer cancelEverything = 0;

list main_menu;

MainMenu(key detectedKey)
{
    if ((!TurnedON) && (!RDYtoAddwater))
        main_menu = [ "Turn ON", "Exit" ];
    else if ((TurnedON) && (!RDYtoAddwater))
        main_menu = [ "Turn OFF", "Exit" ];
    else
        main_menu = [ "Turn OFF", "Add Water", "Exit" ];
    list avatar_name = llParseString2List(llGetDisplayName(detectedKey), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", detectedKey, "");
    llDialog(detectedKey, "Hello " + (string)avatar_name + ".\nSelect a an option", main_menu, channel);
}

TurnON()
{
    TurnedON = TRUE;
    llLoopSound(sauna_stove_buzz, 0.2);
    RDYtoAddwater = FALSE;
}

TurnOFF()
{
    TurnedON = FALSE;
    llStopSound();
    addedWater = FALSE;
    RDYtoAddwater = FALSE;
    llParticleSystem([]);
    llSetTimerEvent(cancelEverything);
}

addWater()
{
    llTriggerSound(sauna_steam, 1);
    makeSteam();
    llSetTimerEvent(steamDuration);
}

makeSteam()
{
    key texture = "5de058da-95f0-2736-b0e0-e218184ddece";
    float age = 5.0;                    // particle lifetime
    float rate = 0.5;                    // particle burst rate
    integer count = 3;                   // particle count
    vector startColor = <0.5, 0.5, 0.5>; // particle start color
    vector endColor = <0.5, 0.5, 0.5>;   // particle end color
    float startAlpha = 1.0;              // particle start alpha
    float endAlpha = 0.0;                // particle end alpha
    vector startScale = <0.1, 0.1, 0>;   // particle start size (100%)
    vector endScale = <4, 4, 0>;         // particle end size (100%)
    float minSpeed = 0.0;                // particle min. burst speed (100%)
    float maxSpeed = 0.1;                // particle max. burst speed (100%)
    float burstRadius = 0.1;             // particle burst radius (100%)
    vector partAccel = <0, 0, 0.2>;      // particle accelleration (100%)
    llParticleSystem([
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_TEXTURE, texture,
        PSYS_PART_START_COLOR, startColor,
        PSYS_PART_END_COLOR, endColor,
        PSYS_PART_START_ALPHA, startAlpha,
        PSYS_PART_END_ALPHA, endAlpha,
        PSYS_PART_START_SCALE, startScale,
        PSYS_PART_END_SCALE, endScale,
        PSYS_PART_MAX_AGE, age,
        PSYS_SRC_BURST_RATE, rate,
        PSYS_SRC_BURST_PART_COUNT, count,
        PSYS_SRC_BURST_SPEED_MIN, minSpeed,
        PSYS_SRC_BURST_SPEED_MAX, maxSpeed,
        PSYS_SRC_BURST_RADIUS, burstRadius,
        PSYS_SRC_ACCEL, partAccel,
        PSYS_PART_FLAGS,
        0 |
        PSYS_PART_EMISSIVE_MASK |
        PSYS_PART_FOLLOW_VELOCITY_MASK |
        PSYS_PART_INTERP_COLOR_MASK |
        PSYS_PART_INTERP_SCALE_MASK
    ]);
}

default
{
    state_entry()
    {
        llPreloadSound(sauna_stove_knob);
        llPreloadSound(sauna_steam);
        llPreloadSound(sauna_stove_buzz);
    }

    touch_start(integer total_number)
    {
        id = llDetectedKey(0);
        MainMenu(id);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Turn ON"){
            llTriggerSound(sauna_stove_knob, 1);
            llSleep(.6);
            TurnON();
            llSetTimerEvent(SaunaRDY4Use);
        }
        else if (message == "Turn OFF"){
            llTriggerSound(sauna_stove_knob, 1);
            TurnOFF();
        }
        else if (message == "Exit")
            return;
    }

    timer()
    {
        state RDY;
    }
}

state RDY
{
    state_entry()
    {
        RDYtoAddwater = TRUE;
    }

    touch_start(integer total_number)
    {
        id = llDetectedKey(0);
        MainMenu(id);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Add Water"){
            if (!addedWater)
                addWater();
            MainMenu(id);
        }
        else if (message == "Turn OFF"){
            llTriggerSound(sauna_stove_knob, 1);
            TurnOFF();
            state default;
        }
        else if (message == "Exit")
            return;
    }
    
    timer()
    {
        llParticleSystem([]);
        addedWater = FALSE;
    }
}
