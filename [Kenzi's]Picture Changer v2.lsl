key owner;
key FRAME_TEXTURE       = TEXTURE_BLANK;

string  confirmedSound      = "69743cb2-e509-ed4d-4e52-e697dc13d7ac";
string  accessDeniedSound   = "58da0f9f-42e5-8a8f-ee51-4fac6c247c98";

string DISPLAY_1        = "display1";
string DISPLAY_2        = "display2";

integer STYLE_FRAME     = FALSE;
integer Group_Only      = FALSE;
integer Owner_Only      = TRUE;
integer Public_Access   = FALSE;
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
integer num_pics;
integer next_pic;

float step_size;
float sleep_time;
float DISPLAY_TIME      = 15.0;
float FADE_TIME         = 2.0;

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
    info("Setting up the slideshow.");
    owner = llGetOwner();
    link_num = llGetNumberOfPrims();
    direction = 0;

    style_frame();
    determine_display_links();
    calculate_step_values();
    scan_pictures();
    setup_displays();
    info("Finished setting up the slideshow.");
}

style_frame()
{
    if (STYLE_FRAME == TRUE){
        integer i = link_num;
        do {
            llSetLinkTexture(i, FRAME_TEXTURE, ALL_SIDES);
        } while (i--);
    }
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
        }
    } while (i-- && found < 2);
}

calculate_step_values()
{
    step_size = 100.0 / NUM_STEPS;
    sleep_time = FADE_TIME / NUM_STEPS;
}

scan_pictures()
{
    info("Scanning inventory for images.");
    pictures = [];
    num_pics = 0;
    integer count_pics = llGetInventoryNumber(INVENTORY_TEXTURE);
    if (count_pics > 0) {
        integer i = 0;
        integer no_copy = FALSE;
        for (i; i < count_pics; i++){
            string name = llGetInventoryName(INVENTORY_TEXTURE, i);
            if (llGetInventoryPermMask(name, MASK_OWNER) & PERM_COPY){
                pictures += [llGetInventoryKey(name)];
            }
            else{
                no_copy = TRUE;
            }
        }
        num_pics = llGetListLength(pictures);

        if (no_copy == TRUE){
            llInstantMessage(owner, "This frame contains no-copy images. Those cannot be displayed.");
        }
    }
    info("Finished scanning inventory for images.");
}

setup_displays()
{
    llSetLinkAlpha(display1, 1.0, FACE);
    if(num_pics > 0){
        llSetLinkTexture(display1, llList2Key(pictures, 0), FACE);
        if(num_pics > 1){
            llSetLinkTexture(display2, llList2Key(pictures, 1), FACE);
            next_pic = 2;
        }
        else{
            llSetLinkTexture(display2, TEXTURE_BLANK, FACE);
            next_pic = 1;
        }
    }
    else{
        llSetLinkTexture(display1, TEXTURE_BLANK, FACE);
        llSetLinkTexture(display2, TEXTURE_BLANK, FACE);
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
    }

    on_rez(integer num)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_INVENTORY || change & CHANGED_ALLOWED_DROP){
            info("Inventory changed, reloading pictures.");
            llSetTimerEvent(0.0);
            scan_pictures();
            if (num_pics < 2){
                setup_displays();
            }
            else{
                llSetTimerEvent(DISPLAY_TIME);
            }
        }
        else if (change & CHANGED_OWNER){
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
        else if (Public_Access == TRUE)
            doMenu(_id);
    }

    listen(integer _chan, string n, key _id, string _message)
    {
        if(_chan != chan){
            llSetPrimMediaParams(DISPLAY_ON_SIDE, [
                PRIM_MEDIA_ALT_IMAGE_ENABLE, TRUE, 
                PRIM_MEDIA_CURRENT_URL, _message, 
                PRIM_MEDIA_CONTROLS, 0, 
                PRIM_MEDIA_AUTO_PLAY, TRUE,
                PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_ANYONE,
                PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_ANYONE
            ]);
            llSay(0, "Connecting...\n" + (string)_message + "\nPlease wait...");
            llSetTimerEvent(0);
        }
        if(_chan == chan){
            if(_message == "Open TV"){
                llSay(0, "Please type: /" + (string)_channel_ + "URL (Youtube video id or namy URL)");
                listenid = llListen(_channel_, "", "","");
                TVOn = TRUE;
                llSetLinkAlpha(display2, 0, ALL_SIDES);
                llSetLinkAlpha(display1, 0, ALL_SIDES);
                llSetLinkColor(LINK_THIS, <1,1,1>, DISPLAY_ON_SIDE);
                llSetTimerEvent(0);
            }
            else if(_message == "Close TV"){
                llSetPrimMediaParams(DISPLAY_ON_SIDE, [
                    PRIM_MEDIA_ALT_IMAGE_ENABLE, FALSE, 
                    PRIM_MEDIA_CURRENT_URL, "", 
                    PRIM_MEDIA_CONTROLS, 0, 
                    PRIM_MEDIA_AUTO_PLAY, FALSE,
                    PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_ANYONE,
                    PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_ANYONE
                ]);
                llSay(0, "Turning TV off...");
                llListenRemove(listenid);
                llSetLinkAlpha(display2, 100, ALL_SIDES);
                llSetLinkAlpha(display1, 100, ALL_SIDES);
                llSetLinkColor(LINK_THIS, <0,0,0>, DISPLAY_ON_SIDE);
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