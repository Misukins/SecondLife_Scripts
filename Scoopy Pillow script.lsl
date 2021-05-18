key _texture1 = "a62f59ca-135b-8f38-5568-b94850834277";
key _texture2 = "f7f0cdc3-f372-ec5f-1d9d-1cc17c30a98a";
key _texture3 = "217f3b1b-75e2-ff85-8e7c-6b6dd8104301";
key _texture4 = "7a60e8b8-3bed-9ecb-29ee-2751f6ba4642";

string gAnim = "pillowHold";

integer chan;
integer hand;

list main_admin_buttons =   [ "Texture1", "Texture2", "Texture3", "Texture4", "Close" ];

menu(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llListenRemove( hand );
    chan = llRound(llFrand(99999)+10);
    hand = llListen(chan, "", id, "");
    if ( id == llGetOwner())
        llDialog(id, (string)owner_name + "'s BodyPillow Menu", main_admin_buttons, chan);
}

default
{
    attach(key id)
    {
        if (id == llGetOwner())
            llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
        else if (id == NULL_KEY && (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION))
            llStopAnimation(gAnim);
    }

    run_time_permissions(integer perms)
    {
        if (perms & PERMISSION_TRIGGER_ANIMATION)
            llStartAnimation(gAnim);
    }

    touch_start(integer total_number)
    {
        key toucher_key = llDetectedKey(0);
        if (toucher_key == llGetOwner())
            menu(toucher_key);
    }

    listen(integer channel, string name, key id, string str)
    {
        if ( str == "Close")
            return;
        else if ( str == "Texture1")
            llSetTexture(_texture1, ALL_SIDES);
        else if ( str == "Texture2")
            llSetTexture(_texture2, ALL_SIDES);
        else if ( str == "Texture3")
            llSetTexture(_texture3, ALL_SIDES);
        else if ( str == "Texture4")
            llSetTexture(_texture4, ALL_SIDES);
    }
}