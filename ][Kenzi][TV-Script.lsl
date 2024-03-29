key owner;
key _TEXTURE_BLANK       = "dc94c34e-1ae6-f263-ab99-52001300524d";

string  confirmedSound      = "69743cb2-e509-ed4d-4e52-e697dc13d7ac";
string  accessDeniedSound   = "58da0f9f-42e5-8a8f-ee51-4fac6c247c98";

string DISPLAY_1        = "display1";
string DISPLAY_2        = "display2";
string LED_LIGHT        = "led1";

integer DEBUG           = FALSE;

integer Group_Only      = FALSE;
integer Owner_Only      = FALSE;
integer Public_Access   = TRUE;
integer TVOn            = FALSE;
integer NUM_STEPS       = 20;
integer FACE            = ALL_SIDES;
integer DISPLAY_ON_SIDE = 3;
integer random          = TRUE;
integer duplicatecheck  = TRUE;
integer _channel_       = 66;

integer listenid;
integer chan;
integer hand;
integer link_num;
integer direction;
integer display1;
integer display2;
integer led1;
integer num_pics;
integer next_pic;

float step_size;
float sleep_time;
float DISPLAY_TIME      = 30.0;
float FADE_TIME         = 4.0;

list pictures;
list main_buttons       = [];
list main_admin_buttons = [];
list AccessList_Menu    = [];

vector originalPosition;

doAccessListMenu(key _id)
{
    llListenRemove(hand);
    list AccessList_Menu =          [ "Group", "Private", "Public", "◄", "▼" ];
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", _id, "");
    llDialog(_id, (string)owner_name + "'s TV Menu\nChoose an option! " + (string)name + "?", AccessList_Menu, chan);
}

doMenu(key _id)
{
    if(TVOn){
        main_buttons =         [ "Close TV", "▼" ];
        main_admin_buttons =   [ "Close TV", "Access", "Reset", "▼" ];
    }
    else{
        main_buttons =         [ "Open TV", "▼" ];
        main_admin_buttons =   [ "Open TV", "Access", "Reset", "▼" ];
    }
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(hand);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", _id, "");
    if ( _id == llGetOwner())
        llDialog(_id, (string)owner_name + "'s TV Menu\nChoose an option! " + (string)name + "?", main_admin_buttons, chan);
    else
        llDialog(_id, (string)owner_name + "'s TV Menu\nChoose an option! " + (string)name + "?", main_buttons, chan);
}

info(string message)
{
    llOwnerSay("[INFO] " + message);
}

init()
{
    if(DEBUG == TRUE)
        info("Setting up the slideshow.");
    owner = llGetOwner();
    link_num = llGetNumberOfPrims();
    direction = 0;
    determine_display_links();
    calculate_step_values();
    scan_pictures();
    setup_displays();
    if(DEBUG == TRUE)
        info("Finished setting up the slideshow.");
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

calculate_step_values()
{
    step_size = 100.0 / NUM_STEPS;
    sleep_time = FADE_TIME / NUM_STEPS;
}

scan_pictures()
{
    if(DEBUG == TRUE)
        info("Scanning inventory for images.");
    pictures = [];
    num_pics = 0;
    integer count_pics = llGetInventoryNumber(INVENTORY_TEXTURE);
    if (count_pics > 0) {
        integer i = 0;
        integer no_copy = FALSE;
        integer no_trans = FALSE;
        for (i; i < count_pics; i++){
            string name = llGetInventoryName(INVENTORY_TEXTURE, i);
            if (llGetInventoryPermMask(name, MASK_OWNER) & PERM_COPY){
                pictures += [llGetInventoryKey(name)];
            }
            else{
                no_copy = TRUE;
            }
        }
        for (i; i < count_pics; i++){
            string name = llGetInventoryName(INVENTORY_TEXTURE, i);
            if (llGetInventoryPermMask(name, MASK_OWNER) & PERM_TRANSFER){
                pictures += [llGetInventoryKey(name)];
            }
            else{
                no_trans = TRUE;
            }
        }
        num_pics = llGetListLength(pictures);
        if (no_copy == TRUE){
            llWhisper(0, "This frame contains no-copy images. Those cannot be displayed.");
        }
        if (no_trans == TRUE){
            llWhisper(0, "This frame contains no-trans images. Those cannot be displayed.");
        }
    }
    if(DEBUG == TRUE)
        info("Finished scanning inventory for images.");
}

setup_displays()
{
    llSetLinkAlpha(display1, 1.0, FACE);
    if(num_pics > 0){
        llSetLinkTexture(display1, llList2Key(pictures, 1), FACE);
        if(num_pics > 1){
            llSetLinkTexture(display2, llList2Key(pictures, 2), FACE);
            next_pic = 2;
        }
        else{
            llSetLinkTexture(display2, _TEXTURE_BLANK, FACE);
            next_pic = 1;
        }
    }
    else{
        llSetLinkTexture(display1, _TEXTURE_BLANK, FACE);
        llSetLinkTexture(display2, _TEXTURE_BLANK, FACE);
        next_pic = 0;
    }
}

fade()
{
    llSetTimerEvent(0.0);
    float step;
    float current;
    if (direction == 0) {
        current = 0.0;
        step = step_size;
        direction = 1;
    }
    else {
        current = 100.0;
        step = step_size * -1;
        direction = 0;
    }
    integer i = 0;
    for (i; i < NUM_STEPS; i++){
        current += step;
        llSetLinkAlpha(display1, current / 100.0, 0);
        llSleep(sleep_time);
    }
    prepare_next_pic();
    llSetTimerEvent(DISPLAY_TIME);
}

prepare_next_pic()
{
    next_pic++;
    if (next_pic >= num_pics){
        next_pic = 0;
    }

    integer display;
    if (direction == 0){
        display = display1;
    }
    else{
        display = display2;
    }
    llSetLinkTexture(display, llList2Key(pictures, next_pic), FACE);
}

default
{
    state_entry()
    {
        llAllowInventoryDrop(TRUE);
        init();
        if (num_pics > 1){
            fade();
        }
        llWhisper(0, "I found " + (string)num_pics + " pictures!");
    }

    on_rez(integer num)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_INVENTORY || change & CHANGED_ALLOWED_DROP){
            if(DEBUG == TRUE)
                info("Inventory changed, reloading pictures.");
            llSetTimerEvent(0.0);
            scan_pictures();
            if (num_pics < 2){
                setup_displays();
            }
            else{
                llSetTimerEvent(DISPLAY_TIME);
            }
            llWhisper(0, "I found " + (string)num_pics + " pictures!");
        }
        else if (change & CHANGED_OWNER){
            if(DEBUG == TRUE)
                info("Owner changed, reloading slideshow.");
            init();
        }
    }

    touch_start(integer total_number)
    {
        key _id = llDetectedKey(0);
        key owner = llGetOwner();
        integer sameGroup = llSameGroup(_id);
        if (Group_Only == TRUE){
            if (sameGroup || _id == owner)
                doMenu(_id);
            else{
                llWhisper(0, "Access Denied!");
                llTriggerSound(accessDeniedSound, 1.0);
            }
        }
        else if (Owner_Only == TRUE){
            if(_id == owner)
                doMenu(_id);
            else{
                llWhisper(0, "Access Denied!");
                llTriggerSound(accessDeniedSound, 1.0);
            }
        }
        else if (Public_Access == TRUE){
            if(!TVOn)
                llTriggerSound(confirmedSound, 1.0);
            doMenu(_id);
        }
    }

    listen(integer _chan, string n, key _id, string _message)
    {
        if(_chan != chan){
            llSetPrimMediaParams(DISPLAY_ON_SIDE, [
                PRIM_MEDIA_ALT_IMAGE_ENABLE, TRUE,
                PRIM_MEDIA_CURRENT_URL, _message,
                PRIM_MEDIA_CONTROLS, 0,
                PRIM_MEDIA_AUTO_PLAY, TRUE,
                PRIM_MEDIA_AUTO_ZOOM, TRUE,
                PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_ANYONE,
                PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_ANYONE
            ]);
            llWhisper(0, "Connecting...\n" + (string)_message + "\nPlease wait...");
            llSetTimerEvent(0);
        }
        if(_chan == chan){
            if(_message == "Open TV"){

                llWhisper(0, "Hello secondlife:///app/agent/" + (string)_id + "/about\nPlease type: /" + (string)_channel_ + "URL (Youtube video id or any URL)");
                listenid = llListen(_channel_, "", "","");
                TVOn = TRUE;
                llSetLinkPrimitiveParams(display1, [PRIM_POS_LOCAL, <0.107263, 0.000000, 0.054375>]);
                llSetLinkPrimitiveParams(display2, [PRIM_POS_LOCAL, <0.100998, 0.000000, 0.054049>]);
                llSetLinkColor(LINK_THIS, <1,1,1>, DISPLAY_ON_SIDE);

                //llSetLinkAlpha(led1, 0.0, ALL_SIDES);
                llSetLinkColor(led1, <0,0.45,0>, ALL_SIDES);
                llSetLinkPrimitiveParams(led1, [PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
                llSetLinkPrimitiveParams(led1, [PRIM_GLOW, ALL_SIDES, 0.55]);

                llSetTimerEvent(0);
            }
            else if(_message == "Close TV"){
                llSetPrimMediaParams(DISPLAY_ON_SIDE, [
                    PRIM_MEDIA_ALT_IMAGE_ENABLE, FALSE,
                    PRIM_MEDIA_CURRENT_URL, "",
                    PRIM_MEDIA_CONTROLS, 0,
                    PRIM_MEDIA_AUTO_PLAY, FALSE,
                    PRIM_MEDIA_AUTO_ZOOM, FALSE,
                    PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_ANYONE,
                    PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_ANYONE
                ]);
                llWhisper(0, "Turning TV off...");
                llWhisper(0, "Bye Bye secondlife:///app/agent/" + (string)_id + "/about");
                llListenRemove(listenid);
                llSetLinkPrimitiveParams(display1, [PRIM_POS_LOCAL, <0.137263, 0.000000, 0.054375>]);
                llSetLinkPrimitiveParams(display2, [PRIM_POS_LOCAL, <0.130998, 0.000000, 0.054049>]);
                llSetLinkColor(LINK_THIS, <0,0,0>, DISPLAY_ON_SIDE);

                //llSetLinkAlpha(led1, 1.0, ALL_SIDES);
                llSetLinkColor(led1, <0.45,0,0>, ALL_SIDES);
                llSetLinkPrimitiveParams(led1, [PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
                llSetLinkPrimitiveParams(led1, [PRIM_GLOW, ALL_SIDES, 0.55]);

                init();
                if (num_pics > 1){
                    fade();
                }
                TVOn = FALSE;
                return;
            }
            else if(_message == "Access"){
                if (_id == llGetOwner())
                    doAccessListMenu(_id);
                else
                    return;
            }
            else if (_message == "Group"){
                Group_Only      = TRUE;
                Owner_Only      = FALSE;
                Public_Access   = FALSE;
                llWhisper(0, "Group mode has been set!");
                return;
            }
            else if (_message == "Private"){
                Group_Only      = FALSE;
                Owner_Only      = TRUE;
                Public_Access   = FALSE;
                llWhisper(0, "Private mode has been set!");
                return;
            }
            else if (_message == "Public"){
                Group_Only      = FALSE;
                Owner_Only      = FALSE;
                Public_Access   = TRUE;
                llWhisper(0, "Public mode has been set!");
                return;
            }
            else if(_message == "◄")
                doMenu(_id);
            else if(_message == "Reset")
                llResetScript();
            else if(_message == "▼")
                return;
        }
    }

    timer()
    {
        if(random){
            integer randomtexture;
            if(duplicatecheck){
                do{
                    randomtexture= llRound(llFrand(num_pics - 1));
                }
                while(randomtexture == next_pic);
            }
            else
                randomtexture = llRound(llFrand(num_pics - 1));
            next_pic = randomtexture;
            fade();
        }
        else
            fade();
    }
}