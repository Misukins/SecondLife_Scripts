integer STYLE_FRAME = TRUE;

key FRAME_TEXTURE = "8e54c739-513a-d957-fbcd-eedcdf5221f4";

float DISPLAY_TIME = 15.0;
float FADE_TIME = 2.0;

integer NUM_STEPS = 20;

string DISPLAY_1 = "display1";
string DISPLAY_2 = "display2";

integer FACE = 0;

key owner;
integer link_num;
integer direction;
integer display1;
integer display2;
float step_size;
float sleep_time;
list pictures;
integer num_pics;
integer next_pic;

info(string message)
{
    llOwnerSay("[INFO] " + message);
}

debug(string message)
{
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
    debug("style_frame()");
    if (STYLE_FRAME == TRUE) {
        integer i = link_num;
        do {
            llSetLinkTexture(i, FRAME_TEXTURE, ALL_SIDES);
        } while (i--);
    }
}

determine_display_links()
{
    debug("determine_display_links()");
    integer i = link_num;
    integer found = 0;
    do {
        if(llGetLinkName(i) == DISPLAY_1) {
            display1 = i;
            found++;
            debug("Found display 1.");
        } else if (llGetLinkName(i) == DISPLAY_2) {
            display2 = i;
            found++;
            debug("Found display 2.");
        }
    } while (i-- && found < 2);
}

calculate_step_values()
{
    debug("calculate_step_values()");
    step_size = 100.0 / NUM_STEPS;
    sleep_time = FADE_TIME / NUM_STEPS;
}

scan_pictures()
{
    debug("scan_pictures()");
    info("Scanning inventory for images.");
    pictures = [];
    num_pics = 0;
    integer count_pics = llGetInventoryNumber(INVENTORY_TEXTURE);
    if (count_pics > 0) {
        integer i = 0;
        integer no_copy = FALSE;
        for (i; i < count_pics; i++) {
            string name = llGetInventoryName(INVENTORY_TEXTURE, i);
            if (llGetInventoryPermMask(name, MASK_OWNER) & PERM_COPY) {
                pictures += [llGetInventoryKey(name)];
            } else {
                no_copy = TRUE;
            }
        }
        num_pics = llGetListLength(pictures);

        if (no_copy == TRUE) {
            llInstantMessage(owner, "This frame contains no-copy images. Those cannot be displayed.");
        }
    }
    info("Finished scanning inventory for images.");
}

setup_displays()
{
    debug("setup_displays()");
    llSetLinkAlpha(display1, 1.0, FACE);
    if(num_pics > 0) {
        llSetLinkTexture(display1, llList2Key(pictures, 0), FACE);
        if(num_pics > 1) {
            llSetLinkTexture(display2, llList2Key(pictures, 1), FACE);
            next_pic = 2;
        } else {
            llSetLinkTexture(display2, TEXTURE_BLANK, FACE);
            next_pic = 1;
        }
    } else {
        llSetLinkTexture(display1, TEXTURE_BLANK, FACE);
        llSetLinkTexture(display2, TEXTURE_BLANK, FACE);
        next_pic = 0;
    }
}

fade()
{
    debug("fade()");
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
    for (i; i < NUM_STEPS; i++) {
        current += step;
        llSetLinkAlpha(display1, current / 100.0, 0);
        llSleep(sleep_time);
    }
    prepare_next_pic();
    llSetTimerEvent(DISPLAY_TIME);
}

prepare_next_pic()
{
    debug("prepare_next_pic()");
    next_pic++;
    if (next_pic >= num_pics) {
        next_pic = 0;
    }
    debug("next_pic: " + (string) next_pic);

    integer display;
    if (direction == 0) {
        display = display1;
    } else {
        display = display2;
    }
    llSetLinkTexture(display, llList2Key(pictures, next_pic), FACE);
}

default
{
    state_entry()
    {
        debug("state_entry()");
        init();
        if (num_pics > 1) {
            fade();
        }
    }

    touch_start(integer num_detected)
    {
        debug("touch_start(integer num_detected)");
        if (num_pics > 1){
            fade();
        }
    }

    changed(integer change)
    {
        debug("changed(integer change)");
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
        } else if (change & CHANGED_OWNER) {
            info("Owner changed, reloading slideshow.");
            init();
        }
    }

    timer()
    {
        debug("timer()");
        fade();
    }
}