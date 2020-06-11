integer channel;
integer listen_handle;

integer normal          = TRUE;
integer showtail        = TRUE;
integer showdecor       = TRUE;
integer sitOverride     = FALSE;

string Link_tail        = "tail";
string Link_decorring   = "decor";
string Link_decor1      = "decor1";
string Link_decor2      = "decor2";
string Link_decor3      = "decor3";

integer link_num;

integer tail;
integer decorring;
integer decor1;
integer decor2;
integer decor3;

integer Link_decorring_FACE = 3;

float _tailwagTime = 3.0;
float _tailwagTimeRandom = 5.0;

vector start;

vector white    = <1.0, 1.0, 1.0>;
vector black    = <0.0, 0.0, 0.0>;
vector purple   = <0.5, 0.0, 0.5>;
vector pink     = <1.0, 0.75, 0.8>;
vector red      = <1.0, 0.0, 0.0>;
vector green    = <0.0, 1.0, 0.0>;
vector blue     = <0.0, 0.0, 1.0>;
vector gray     = <0.502, 0.502, 0.502>;

determine_links()
{
    integer i = link_num;
    integer found = 0;
    do {
        if(llGetLinkName(i) == Link_tail){
            tail = i;
            found++;
        }
        else if (llGetLinkName(i) == Link_decor1){
            decor1 = i;
            found++;
        }
        else if (llGetLinkName(i) == Link_decor2){
            decor2 = i;
            found++;
        }
        else if (llGetLinkName(i) == Link_decor3){
            decor3 = i;
            found++;
        }
        else if (llGetLinkName(i) == Link_decorring){
            decorring = i;
            found++;
        }
    } while (i-- && found < 12);
}

normal_tailwag()
{
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -10 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -10 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, -10 + llFrand(-10), 0>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0,  10 + llFrand(10), 0>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -10 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -10 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0,  10 + llFrand(10), 0>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, -10 + llFrand(-10), 0>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -10 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -10 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -10 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, -10 + llFrand(-10), 0>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0,  10 + llFrand(10), 0>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -10 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -10 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -10 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0,  10 + llFrand(10), 0>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, -10 + llFrand(-10), 0>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  -10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  -10 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 10 + llFrand(10), 0>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 10 + llFrand(10), 0>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*(start)));
}

sitting_tailwag()
{
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  5 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -5 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0,  5 + llFrand(5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot())) + <0, 0, -5 + llFrand(-5)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*(start)));
}

sitting()
{
    string curAnimState = llGetAnimation(llGetOwner());
    if (curAnimState == "Sitting"){
        llSetTimerEvent(_tailwagTime + llFrand(_tailwagTimeRandom));
        sitting_tailwag();
    }
}

// ► ◄ ▲ ▼  □  ■ \\
AdminMenu(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list main_admin = [];
    if (normal){
        main_admin = [ "■ On ■", "Options", "▼" ];
    }
    else{
        main_admin = [ "□ On □", "Options", "▼" ];
    }
    llListenRemove(listen_handle);
    channel = llRound(llFrand(99999)+10);
    listen_handle = llListen(channel, "", id, "");
    llDialog(id, (string)owner_name + "'s DemonTail Menu", main_admin, channel);
}

AdminMenuSetup(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list MenuSetup = [ "Toggle Tail", "Toggle Decor", "Color", "Glow", "◄", "▼" ];
    llListenRemove(listen_handle);
    channel = llRound(llFrand(99999)+10);
    listen_handle = llListen(channel, "", id, "");
    llDialog(id, (string)owner_name + "'s DemonTail Menu", MenuSetup, channel);
}

AdminMenuGlow(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list MenuSetupGlow = [ "Glow-Off", "Glow-5", "Glow-10", "Glow-20", "Glow-40", "Glow-60", "Glow-80", "Glow-100", "◄", "▼" ];
    llListenRemove(listen_handle);
    channel = llRound(llFrand(99999)+10);
    listen_handle = llListen(channel, "", id, "");
    llDialog(id, (string)owner_name + "'s DemonTail Menu", MenuSetupGlow, channel);
}

AdminMenuColor(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list MenuSetupColor = [ "White", "Black", "Purple", "Pink", "Red", "Green", "Blue", "---", "---", "---", "◄", "▼" ];
    llListenRemove(listen_handle);
    channel = llRound(llFrand(99999)+10);
    listen_handle = llListen(channel, "", id, "");
    llDialog(id, (string)owner_name + "'s DemonTail Menu", MenuSetupColor, channel);
}

toggle_showtail()
{
    if (!showtail){
        llSetLinkAlpha(LINK_SET, 0.0, ALL_SIDES);
        llSetLinkPrimitiveParamsFast(decor1, [ PRIM_GLOW, ALL_SIDES, 0.0 ]);
        llSetLinkPrimitiveParamsFast(decor1, [ PRIM_FULLBRIGHT, ALL_SIDES, FALSE ]);
        llSetLinkPrimitiveParamsFast(decor2, [ PRIM_GLOW, ALL_SIDES, 0.0 ]);
        llSetLinkPrimitiveParamsFast(decor2, [ PRIM_FULLBRIGHT, ALL_SIDES, FALSE ]);
        llSetLinkPrimitiveParamsFast(decor3, [ PRIM_GLOW, ALL_SIDES, 0.0 ]);
        llSetLinkPrimitiveParamsFast(decor3, [ PRIM_FULLBRIGHT, ALL_SIDES, FALSE ]);
        llSetLinkPrimitiveParamsFast(decorring, [ PRIM_GLOW, Link_decorring_FACE, 0.0 ]);
        llSetLinkPrimitiveParamsFast(decorring, [ PRIM_FULLBRIGHT, Link_decorring_FACE, FALSE ]);
        normal = FALSE;
    }
    else{
        llSetLinkAlpha(LINK_SET, 1.0, ALL_SIDES);
        llSetLinkPrimitiveParamsFast(decor1, [ PRIM_GLOW, ALL_SIDES, 0.2 ]);
        llSetLinkPrimitiveParamsFast(decor1, [ PRIM_FULLBRIGHT, ALL_SIDES, TRUE ]);
        llSetLinkPrimitiveParamsFast(decor2, [ PRIM_GLOW, ALL_SIDES, 0.2 ]);
        llSetLinkPrimitiveParamsFast(decor2, [ PRIM_FULLBRIGHT, ALL_SIDES, TRUE ]);
        llSetLinkPrimitiveParamsFast(decor3, [ PRIM_GLOW, ALL_SIDES, 0.2 ]);
        llSetLinkPrimitiveParamsFast(decor3, [ PRIM_FULLBRIGHT, ALL_SIDES, TRUE ]);
        llSetLinkPrimitiveParamsFast(decorring, [ PRIM_GLOW, Link_decorring_FACE, 0.2 ]);
        llSetLinkPrimitiveParamsFast(decorring, [ PRIM_FULLBRIGHT, Link_decorring_FACE, TRUE ]);
        normal = TRUE;
    }
    showtail = !showtail;
}

toggle_showdecor()
{
    if (!showdecor){
        llSetLinkAlpha(decor1, 0.0, ALL_SIDES);
        llSetLinkPrimitiveParamsFast(decor1, [ PRIM_GLOW, ALL_SIDES, 0.0 ]);
        llSetLinkPrimitiveParamsFast(decor1, [ PRIM_FULLBRIGHT, ALL_SIDES, FALSE ]);
        llSetLinkAlpha(decor2, 0.0, ALL_SIDES);
        llSetLinkPrimitiveParamsFast(decor2, [ PRIM_GLOW, ALL_SIDES, 0.0 ]);
        llSetLinkPrimitiveParamsFast(decor2, [ PRIM_FULLBRIGHT, ALL_SIDES, FALSE ]);
        llSetLinkAlpha(decor3, 0.0, ALL_SIDES);
        llSetLinkPrimitiveParamsFast(decor3, [ PRIM_GLOW, ALL_SIDES, 0.0 ]);
        llSetLinkPrimitiveParamsFast(decor3, [ PRIM_FULLBRIGHT, ALL_SIDES, FALSE ]);
        llSetLinkPrimitiveParamsFast(decorring, [ PRIM_GLOW, Link_decorring_FACE, 0.0 ]);
        llSetLinkPrimitiveParamsFast(decorring, [ PRIM_FULLBRIGHT, Link_decorring_FACE, FALSE ]);
    }
    else{
        llSetLinkAlpha(decor1, 1.0, ALL_SIDES);
        llSetLinkPrimitiveParamsFast(decor1, [ PRIM_GLOW, ALL_SIDES, 0.2 ]);
        llSetLinkPrimitiveParamsFast(decor1, [ PRIM_FULLBRIGHT, ALL_SIDES, TRUE ]);
        llSetLinkAlpha(decor2, 1.0, ALL_SIDES);
        llSetLinkPrimitiveParamsFast(decor2, [ PRIM_GLOW, ALL_SIDES, 0.2 ]);
        llSetLinkPrimitiveParamsFast(decor2, [ PRIM_FULLBRIGHT, ALL_SIDES, TRUE ]);
        llSetLinkAlpha(decor3, 1.0, ALL_SIDES);
        llSetLinkPrimitiveParamsFast(decor3, [ PRIM_GLOW, ALL_SIDES, 0.2 ]);
        llSetLinkPrimitiveParamsFast(decor3, [ PRIM_FULLBRIGHT, ALL_SIDES, TRUE ]);
        llSetLinkPrimitiveParamsFast(decorring, [ PRIM_GLOW, Link_decorring_FACE, 0.2 ]);
        llSetLinkPrimitiveParamsFast(decorring, [ PRIM_FULLBRIGHT, Link_decorring_FACE, TRUE ]);
    }
    showdecor = !showdecor;
}

info(string message)
{
    llOwnerSay("[INFO] " + message);
}

init()
{
    info("Setting up your DemonTail.");
    link_num = llGetNumberOfPrims();
    determine_links();
    if(normal){
        info("Tail: Currently on!");
        start = (RAD_TO_DEG*llRot2Euler(llGetLocalRot()));
        llSetTimerEvent(_tailwagTime + llFrand(_tailwagTimeRandom));
        normal = TRUE;
    }
    else{
        info("Tail: Currently off!");
        normal = FALSE;
    }

    if(showtail)
        showtail = TRUE;
    else
        showtail = FALSE;

    if(showdecor)
        showdecor = TRUE;
    else
        showdecor = FALSE;

    toggle_showtail();
    toggle_showdecor();
    info("Finished setting up your DemonTail.");
}

default
{
    state_entry()
    {
        init();
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    touch_start(integer _num)
    {
        key toucher_key = llDetectedKey(0);
        if (toucher_key == llGetOwner())
            AdminMenu(toucher_key);
    }

    listen( integer _channel, string _name, key _id, string _message)
    {
        if (_id == llGetOwnerKey(_id)){
            if ( _message == "▼" )
                return;
            else if (( _message == "□ On □" ) || (_message == "■ On ■")){
                if(normal){
                    normal_tailwag();
                }
                normal = !normal;
            }
            else if (_message == "Toggle Tail"){
                toggle_showtail();
                AdminMenuSetup(_id);
            }
            else if (_message == "Toggle Decor"){
                toggle_showdecor();
                AdminMenuSetup(_id);
            }
            else if ( _message == "◄" )
                AdminMenu(_id);
            else if ( _message == "Options" )
                AdminMenuSetup(_id);
            else if ( _message == "Glow" )
                AdminMenuGlow(_id);
            else if ( _message == "Color" )
                AdminMenuColor(_id);
            else if ( _message == "Glow-Off" ){
                llSetLinkPrimitiveParamsFast(decor1, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(decor2, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(decor3, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(decorring, [PRIM_GLOW,Link_decorring_FACE,0.0]);
                AdminMenuGlow(_id);
            }
            else if ( _message == "Glow-5" ){
                llSetLinkPrimitiveParamsFast(decor1, [PRIM_GLOW,ALL_SIDES,0.05]);
                llSetLinkPrimitiveParamsFast(decor2, [PRIM_GLOW,ALL_SIDES,0.05]);
                llSetLinkPrimitiveParamsFast(decor3, [PRIM_GLOW,ALL_SIDES,0.05]);
                llSetLinkPrimitiveParamsFast(decorring, [PRIM_GLOW,Link_decorring_FACE,0.05]);
                AdminMenuGlow(_id);
            }
            else if ( _message == "Glow-10" ){
                llSetLinkPrimitiveParamsFast(decor1, [PRIM_GLOW,ALL_SIDES,0.1]);
                llSetLinkPrimitiveParamsFast(decor2, [PRIM_GLOW,ALL_SIDES,0.1]);
                llSetLinkPrimitiveParamsFast(decor3, [PRIM_GLOW,ALL_SIDES,0.1]);
                llSetLinkPrimitiveParamsFast(decorring, [PRIM_GLOW,Link_decorring_FACE,0.1]);
                AdminMenuGlow(_id);
            }
            else if ( _message == "Glow-20" ){
                llSetLinkPrimitiveParamsFast(decor1, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(decor2, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(decor3, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(decorring, [PRIM_GLOW,Link_decorring_FACE,0.2]);
                AdminMenuGlow(_id);
            }
            else if ( _message == "Glow-40" ){
                llSetLinkPrimitiveParamsFast(decor1, [PRIM_GLOW,ALL_SIDES,0.4]);
                llSetLinkPrimitiveParamsFast(decor2, [PRIM_GLOW,ALL_SIDES,0.4]);
                llSetLinkPrimitiveParamsFast(decor3, [PRIM_GLOW,ALL_SIDES,0.4]);
                llSetLinkPrimitiveParamsFast(decorring, [PRIM_GLOW,Link_decorring_FACE,0.4]);
                AdminMenuGlow(_id);
            }
            else if ( _message == "Glow-60" ){
                llSetLinkPrimitiveParamsFast(decor1, [PRIM_GLOW,ALL_SIDES,0.6]);
                llSetLinkPrimitiveParamsFast(decor2, [PRIM_GLOW,ALL_SIDES,0.6]);
                llSetLinkPrimitiveParamsFast(decor3, [PRIM_GLOW,ALL_SIDES,0.6]);
                llSetLinkPrimitiveParamsFast(decorring, [PRIM_GLOW,Link_decorring_FACE,0.6]);
                AdminMenuGlow(_id);
            }
            else if ( _message == "Glow-80" ){
                llSetLinkPrimitiveParamsFast(decor1, [PRIM_GLOW,ALL_SIDES,0.8]);
                llSetLinkPrimitiveParamsFast(decor2, [PRIM_GLOW,ALL_SIDES,0.8]);
                llSetLinkPrimitiveParamsFast(decor3, [PRIM_GLOW,ALL_SIDES,0.8]);
                llSetLinkPrimitiveParamsFast(decorring, [PRIM_GLOW,Link_decorring_FACE,0.8]);
                AdminMenuGlow(_id);
            }
            else if ( _message == "Glow-100" ){
                llSetLinkPrimitiveParamsFast(decor1, [PRIM_GLOW,ALL_SIDES,1.0]);
                llSetLinkPrimitiveParamsFast(decor2, [PRIM_GLOW,ALL_SIDES,1.0]);
                llSetLinkPrimitiveParamsFast(decor3, [PRIM_GLOW,ALL_SIDES,1.0]);
                llSetLinkPrimitiveParamsFast(decorring, [PRIM_GLOW,Link_decorring_FACE,1.0]);
                AdminMenuGlow(_id);
            }
            else if ( _message == "White" ){
                llSetLinkColor(decor1, white, ALL_SIDES);
                llSetLinkColor(decor2, white, ALL_SIDES);
                llSetLinkColor(decor3, white, ALL_SIDES);
                llSetLinkColor(decorring, white, Link_decorring_FACE);
                AdminMenuColor(_id);
            }
            else if ( _message == "Black" ){
                llSetLinkColor(decor1, black, ALL_SIDES);
                llSetLinkColor(decor2, black, ALL_SIDES);
                llSetLinkColor(decor3, black, ALL_SIDES);
                llSetLinkColor(decorring, black, Link_decorring_FACE);
                AdminMenuColor(_id);
            }
            else if ( _message == "Purple" ) {
                llSetLinkColor(decor1, purple, ALL_SIDES);
                llSetLinkColor(decor2, purple, ALL_SIDES);
                llSetLinkColor(decor3, purple, ALL_SIDES);
                llSetLinkColor(decorring, purple, Link_decorring_FACE);
                AdminMenuColor(_id);
            }
            else if ( _message == "Pink" ) {
                llSetLinkColor(decor1, pink, ALL_SIDES);
                llSetLinkColor(decor2, pink, ALL_SIDES);
                llSetLinkColor(decor3, pink, ALL_SIDES);
                llSetLinkColor(decorring, pink, Link_decorring_FACE);
                AdminMenuColor(_id);
            }
            else if ( _message == "Red" ) {
                llSetLinkColor(decor1, red, ALL_SIDES);
                llSetLinkColor(decor2, red, ALL_SIDES);
                llSetLinkColor(decor3, red, ALL_SIDES);
                llSetLinkColor(decorring, red, Link_decorring_FACE);
                AdminMenuColor(_id);
            }
            else if ( _message == "Green" ) {
                llSetLinkColor(decor1, green, ALL_SIDES);
                llSetLinkColor(decor2, green, ALL_SIDES);
                llSetLinkColor(decor3, green, ALL_SIDES);
                llSetLinkColor(decorring, green, Link_decorring_FACE);
                AdminMenuColor(_id);
            }
            else if ( _message == "Blue" ) {
                llSetLinkColor(decor1, blue, ALL_SIDES);
                llSetLinkColor(decor2, blue, ALL_SIDES);
                llSetLinkColor(decor3, blue, ALL_SIDES);
                llSetLinkColor(decorring, blue, Link_decorring_FACE);
                AdminMenuColor(_id);
            }
        }
    }

    timer()
    {
        string curAnimState = llGetAnimation(llGetOwner());
        if (curAnimState == "Sitting") {
            sitOverride = TRUE;
            if (sitOverride) {
                normal = FALSE;
                sitting();
            }
        }
        else
            sitOverride = FALSE;

        if (normal) {
            normal_tailwag();
            llSetTimerEvent(_tailwagTime + llFrand(_tailwagTimeRandom));
        }
    }
}