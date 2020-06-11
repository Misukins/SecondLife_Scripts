list sheet_links;
list free_sheet_links;
list in_use_sheet_links;
list pos_sheet_links = [0,0,0,0];

integer pagenaming;
list pagetexturenames = [];

integer line;
key queryid;

key blank_texture = "5748decc-f629-461c-9a36-a35a221fe21f";
 
init()
{
    sheet_links = [];
    in_use_sheet_links = [];
    sheet_commands = [];
    llMessageLinked(LINK_ALL_OTHERS, 0,  "closed", NULL_KEY);
    llMessageLinked(LINK_ALL_OTHERS, 523, "init", NULL_KEY);  
}

open()
{
    llMessageLinked(LINK_ALL_OTHERS, 0,  "open", NULL_KEY);
    pos_sheet_links = [0,0,0,0];
}

close()
{
    llMessageLinked(LINK_ALL_OTHERS, 523, "init", NULL_KEY);
    pos_sheet_links = [0,0,0,0];
    llMessageLinked(LINK_ALL_OTHERS, 0,  "closed", NULL_KEY);   
}

integer findFreeSheet() {
    integer nb;
    if (llGetListLength(free_sheet_links) > 0) {
        nb = (integer)llList2Integer(free_sheet_links, 0);
        free_sheet_links = llDeleteSubList(free_sheet_links, 0, 0);
    } else {
        nb = (integer)llList2Integer(in_use_sheet_links, 0);
        in_use_sheet_links = llDeleteSubList(in_use_sheet_links, 0, 0);
        sheet_command(nb, "init");
    }
    in_use_sheet_links += [nb];
    return nb;
}

release_sheet(integer link_number) {
    if (link_number != 0) {
        sheet_command(link_number, "init");
        llSetLinkTexture(link_number, blank_texture, ALL_SIDES);
        free_sheet_links += [link_number];
        integer tmp = llListFindList(in_use_sheet_links, [link_number]);
        in_use_sheet_links = llDeleteSubList(in_use_sheet_links, tmp, tmp);
    }
}

integer new_sheet(integer number, integer open, string commands)
{
    if (!sheet_exists(number)) {
        return 0;
    }

    integer sheet_link = findFreeSheet();
    sheet_command(sheet_link, "init");
    setup_sheet(number, sheet_link);
    if (open) {
        sheet_command(sheet_link, "goto_open_standby_position");
        sheet_command(sheet_link, "show");
    } else {
        sheet_command(sheet_link, "goto_closed_standby_position");
        sheet_command(sheet_link, "show");
    }
    return sheet_link;
}
//hide a sheet that is no longer visible.
hide_sheet(integer number)
{
    sheet_command(number, "hide");
}
//setup sheet
setup_sheet(integer sheet_number, integer sheet_link_number)
{
    //llOwnerSay("setup sheet " + (string)sheet_number + " in link " + (string)sheet_link_number);
    //set texture
    list textures = textures_for_sheet(sheet_number);
    //front
    llSetLinkTexture(sheet_link_number, llList2String(textures, 0), 0);
    //back
    llSetLinkTexture(sheet_link_number, llList2String(textures, 1), 4);
    //send sheet number
    sheet_command(sheet_link_number, llList2CSV(["number",sheet_number]));
}
sheet_command(integer link_number, string command)
{
    if (link_number != 0) {
        //llOwnerSay("sheet command to " + (string)link_number + " " + command);
        llMessageLinked(link_number, 523, command, NULL_KEY);
    }
}
//Return texture name by its number
string texture_number(integer number) {
    if (pagenaming == 0) {
        //numeric order, pages are named "page1" "page2" etc.
        string tmp = "page"+(string)number;
        if (llGetInventoryType(tmp) == INVENTORY_TEXTURE) {
            return tmp;
        } else {
            return blank_texture;
        }
    } else {
        return alphabetical_texture_name(number - 1);
    }
}
//Read texture name for alphabetical mode
string alphabetical_texture_name(integer n) {
    integer nb = llGetInventoryNumber(INVENTORY_TEXTURE);
    if (n < nb) {
        return llGetInventoryName(INVENTORY_TEXTURE, n);
    } else {
        return blank_texture;
    }
}
//return texture names that are supposed to go into sheet
list textures_for_sheet(integer sheetnumber) {
    return [texture_number(sheetnumber * 2 - 1), texture_number(sheetnumber * 2)];
}
//Check inventory to see if sheet exists
integer sheet_exists(integer sheetnumber) {
    list textures = textures_for_sheet(sheetnumber);
    if ((llGetInventoryType(llList2String(textures, 0)) == INVENTORY_TEXTURE) || (llGetInventoryType(llList2String(textures, 1)) == INVENTORY_TEXTURE)) {
        //sheet exists
        //llOwnerSay((string)textures + " -> exist");
        return 1;
    } else {
        //sheet doesn't exist (no texture to display)
        //llOwnerSay((string)textures + " -> doesnt exist");
        return 0;
    }
}
//Ask for sheet links
get_sheet_links() {
    sheet_links = [];
    llMessageLinked(LINK_ALL_OTHERS, 523, "pingsheets", NULL_KEY);
}
//////////////////////
// Manage sheets
//////////////////////
append_sheet(integer link_number) {
    pos_sheet_links = llDeleteSubList(pos_sheet_links, 0, 0) + [link_number];
    //llOwnerSay("new psl: " + (string)pos_sheet_links);
}
prepend_sheet(integer link_number) {
    pos_sheet_links = [link_number] + llDeleteSubList(pos_sheet_links, 3, 3);
    //llOwnerSay("new psl: " + (string)pos_sheet_links);
}
open_to_standby() {
    integer tmp = open_sheet();
    release_sheet(open_standby_sheet());
    pos_sheet_links = [tmp, 0] + llList2List(pos_sheet_links, 2,3);
    sheet_command(tmp, "goto_open_standby_position");
    //llOwnerSay("new psl: " + (string)pos_sheet_links);
}
closed_to_standby() {
    integer tmp = closed_sheet();
    release_sheet(closed_standby_sheet());
    pos_sheet_links = llList2List(pos_sheet_links, 0,1) + [0, tmp];
    sheet_command(tmp, "goto_closed_standby_position");
    //llOwnerSay("new psl: " + (string)pos_sheet_links);
}
sheet_opened(integer link_number) {
    //a sheet opened, it can be either a closed or closed standby sheet
    integer pos = llListFindList(pos_sheet_links, [link_number]);
    //get rid of open standby in all case
    release_sheet(open_standby_sheet());
    if (pos == 2) {
        //closed sheet openned, move it to standby
        sheet_command(link_number, "goto_open_standby_position");
        //Put the closed_standby sheet in closed position
        sheet_command(closed_standby_sheet(), "goto_closed_position");   
        pos_sheet_links = [link_number, 0, closed_standby_sheet(), 0];
    } else if (pos == 3) {
        //closed standby sheet openned
        //it pushes old open sheet out of the way too
        release_sheet(open_sheet());
        //move it to standby
        sheet_command(link_number, "goto_open_standby_position");
        pos_sheet_links = [link_number, 0, 0, 0];
    }
}
sheet_closed(integer link_number) {
    //a sheet closed, it can be either a open or open standby sheet
    integer pos = llListFindList(pos_sheet_links, [link_number]);
    //get rid of closed standby in all case
    release_sheet(closed_standby_sheet());
    if (pos == 1) {
        //open sheet closed, move it to standby
        sheet_command(link_number, "goto_closed_standby_position");
        //Put the open_standby sheet in open position
        sheet_command(open_standby_sheet(), "goto_open_position");           
        pos_sheet_links = [0, open_standby_sheet(), 0, link_number];
    } else if (pos == 0) {
        //open standby sheet closed
        //it pushes old closed sheet out of the way too
        release_sheet(closed_sheet());
        //move it to standby
        sheet_command(link_number, "goto_closed_standby_position");
        pos_sheet_links = [0, 0, 0, link_number];
    }
}
set_closed_standby_sheet(integer link_number) {
    pos_sheet_links = llList2List(pos_sheet_links, 0, 2) + [link_number];
}
set_open_standby_sheet(integer link_number) {
    pos_sheet_links = [link_number] + llList2List(pos_sheet_links, 1, 3);
}
set_closed_sheet(integer link_number) {
    pos_sheet_links = llList2List(pos_sheet_links, 0, 1) + [link_number, closed_standby_sheet()];
}
set_open_sheet(integer link_number) {
    pos_sheet_links = [open_standby_sheet(), link_number] + llList2List(pos_sheet_links, 2, 3);
}
integer open_standby_sheet() {
    return llList2Integer(pos_sheet_links, 0);
}
integer open_sheet() {
    return llList2Integer(pos_sheet_links, 1);
}
integer closed_sheet() {
    return llList2Integer(pos_sheet_links, 2);
}
integer closed_standby_sheet() {
    return llList2Integer(pos_sheet_links, 3);
}
//////////////////////
// States
//////////////////////
default
{
    state_entry()
    {
       init();
       get_sheet_links();
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }
   
    link_message(integer sender, integer number, string s, key id) {
        if (s == "sheet") {
            //found sheet
            sheet_links += [sender];
        }
        if (llGetListLength(sheet_links) >= 3) {
            free_sheet_links = sheet_links;
            state readsettings;
        }
    }
}
state readsettings {
    state_entry() {
        if (llGetInventoryType("Settings") != INVENTORY_NOTECARD) {
            //No settings
            state closed;
        } else {
            line = 0;
            queryid = llGetNotecardLine("Settings", line);
        }
    }
   
    dataserver(key queryidarg, string data) {
        if (queryidarg == queryid) {
            if (data != EOF) {
                list settingline = llParseString2List(data,[":"],[]);
                if (llList2String(settingline, 0) == "PageNaming") {
                    //alternate page naming
                    string naming = llList2String(settingline, 1);
                    if (naming == "alphabetical") {
                        pagenaming = 1;
                    } else if (naming == "numerical") {
                        pagenaming = 0;
                    } else {
                        llOwnerSay("Unknown PageNaming: " + naming);
                    }
                }
                //read next
                line++;
                queryid = llGetNotecardLine("Settings", line);
            } else {
                //No more settings
                state closed;
            }
        }
    }
   
    on_rez(integer i) {
        llResetScript();
    }
}
state closed
{
    touch_start(integer total_number)
    {
        open();
        state opened;
    }
   
    link_message(integer sender_number, integer number, string message, key id)
    {
        if (message == "user clicked cover") {
            //the cover tells us user clicked: open book
            open();
            state opened;
        }
    }
   
    on_rez(integer i) {
        llResetScript();
    }
}
state opened
{
    state_entry()
    {
        //show new sheet
        integer tmp = new_sheet(1, FALSE, "");
        //put it in closed position
        sheet_command(tmp, "goto_closed_position");
        //prepare next sheet
        integer tmp2 = new_sheet(2, FALSE, "");
        append_sheet(tmp);
        append_sheet(tmp2);
    }
   
    touch_start(integer total_number)
    {
        //user clicked book, close
        close();
        state closed;
    }
   
    link_message(integer sender_number, integer number, string message, key id)
    {
        if (message == "user clicked cover") {
            //user clicked cover: close
            close();
            state closed;
        }
        integer tmpsheetnumber = (integer)llGetSubString(message, 10, -1);
        //llOwnerSay("sheet number: '" + llGetSubString(message, 10, -1)+"'");
        //one of our sheets tell us something
        if (llGetSubString(message, 0, 9) == "pageopened") {
            //The sheet has been flipped to the left
            sheet_opened(sender_number);
            integer tmpnextsheetnumber;
            integer tmp_next_sheet_link_number;
            if (closed_sheet() == 0) {
                //the closed standby sheet has been flipped
                //we need to fill the closed pos in addition
                //to the closed standby below
                tmpnextsheetnumber = tmpsheetnumber + 1;
                tmp_next_sheet_link_number = new_sheet(tmpnextsheetnumber, FALSE, "");
                //move it to closed pos
                sheet_command(tmp_next_sheet_link_number, "goto_closed_position");
                set_closed_sheet(tmp_next_sheet_link_number);
            }
            //put next next sheet in closed standby position
            tmpnextsheetnumber = tmpsheetnumber + 2;
            tmp_next_sheet_link_number = new_sheet(tmpnextsheetnumber, FALSE, "");
            //Update positions
            set_closed_standby_sheet(tmp_next_sheet_link_number);           
        } else if (llGetSubString(message, 0, 9) == "pageclosed") {
            //The sheet has been flipped to the right
            sheet_closed(sender_number);
            integer tmpprevioussheetnumber;
            integer tmp_previous_sheet_link_number;
            if (open_sheet() == 0) {
                //the open standby sheet has been flipped
                //we need to fill the open pos in addition
                //to the open standby below
                tmpprevioussheetnumber = tmpsheetnumber - 1;
                tmp_previous_sheet_link_number = new_sheet(tmpprevioussheetnumber, TRUE, "");
                //move it to open pos
                sheet_command(tmp_previous_sheet_link_number, "goto_open_position");
                set_open_sheet(tmp_previous_sheet_link_number);
            }
            //put previous previous sheet in open standby position
            tmpprevioussheetnumber = tmpsheetnumber - 2;
            tmp_previous_sheet_link_number = new_sheet(tmpprevioussheetnumber, TRUE, "");
            //Update positions
            set_open_standby_sheet(tmp_previous_sheet_link_number);           
        }
    }                                   
} 
 
// ---------------------------------
// sheet script
// 
//!rotation initialRot = ZERO_ROTATION;
//!vector initialPos;
//!vector scale;
//!integer isopen = FALSE;
//!
//!integer sheet_number = 0;
//!
//!integer version = 1;
//!
//!init()
//!{
//!    //hide
//!    llSetAlpha(0.0, ALL_SIDES);
//!    scale = llGetScale();
//!    initialRot = <0,0,0,1>;
//!    initialPos = llGetLocalPos();
//!    //force correct position   
//!    initialPos.z = 0;
//!    llSetPos(initialPos);
//!    llSetLocalRot(initialRot);
//!    //For script updates from root prim
//!    llSetRemoteScriptAccessPin(1234);
//!}
//!
//!
//!open()
//!{
//!    //flip the page to the left
//!    llSetLocalRot(llEuler2Rot(<0, -PI_BY_TWO, 0>)*initialRot);
//!    llSetLocalRot(llEuler2Rot(<0, -PI, 0>)*initialRot);
//!    isopen = TRUE;
//!    //tells the book about what happened so it can rez next page
//!    llMessageLinked(LINK_ROOT, 102, "pageopened " + (string)sheet_number, NULL_KEY);
//!}
//!
//!close()
//!{
//!    //flip page to the right
//!    llSetLocalRot(llEuler2Rot(<0, -PI_BY_TWO, 0>)*initialRot);
//!    llSetLocalRot(initialRot);
//!    isopen = FALSE;
//!    //tells the book about what happened so it can rez next page
//!    llMessageLinked(LINK_ROOT, 102, "pageclosed " + (string)sheet_number, NULL_KEY);
//!}
//!
//!standby() {
//!    //go just below shown pages
//!    llSetPos(initialPos + <0,0,(scale.z / 2)>);
//!}
//!
//!unstandby() {
//!    llSetPos(initialPos + <0, 0, (scale.z)>);
//!}
//!
//!goto_open() {
//!    llSetLocalRot(llEuler2Rot(<0, -PI, 0>)*initialRot);
//!    isopen = TRUE;
//!}
//!
//!goto_closed() {
//!    llSetLocalRot(initialRot);
//!    isopen = FALSE;
//!}
//!
//!goto_backcover() {
//!    //hide in backcover
//!    llSetLocalRot(initialRot);
//!    llSetPos(initialPos);
//!}
//!
//!hide() {
//!    llSetAlpha(0, ALL_SIDES);
//!}
//!
//!show() {
//!    llSetAlpha(1, ALL_SIDES);
//!}
//!
//!default
//!{
//!    state_entry()
//!    {
//!        init();
//!    }
//!
//!    link_message(integer sender, integer num, string s, key id) {
//!        if (num != 523) {
//!            return;
//!        }
//!        //receive commands       
//!        list commandline = llCSV2List(s);
//!        string command = llList2String(commandline, 0);
//!        if (command == "pingsheets") {
//!            //books want to know which links are sheets, reply
//!            llMessageLinked(LINK_ROOT, version, "sheet", NULL_KEY);
//!        } else if (command == "init") {
//!            //reinitialise
//!            hide();
//!            goto_backcover();
//!        } else if (command == "goto_open_standby_position") {
//!            standby();
//!            goto_open();
//!        } else if (command == "goto_closed_standby_position") {
//!            standby();
//!            goto_closed();         
//!        } else if (command == "goto_open_position") {
//!            unstandby();
//!            goto_open();
//!        } else if (command == "goto_closed_position") {           
//!            unstandby();
//!            goto_closed();
//!        } else if (command == "show") {
//!            show();
//!        } else if (command == "number") {
//!            sheet_number = llList2Integer(commandline, 1);
//!        }
//!    }
//!
//!    changed(integer change) {
//!        if ((change & CHANGED_SCALE) == CHANGED_SCALE) {
//!            scale = llGetScale();
//!        }
//!    }
//! 
//!    touch_start(integer total_number) {
//!        if (isopen == FALSE) {
//!            open();
//!        } else {
//!            close();
//!        }
//!    }
//!}
rotation initialRot = ZERO_ROTATION;
vector initialPos;
vector scale;
integer isopen = FALSE;
integer sheet_number = 0;
integer version = 1;
init(){
 llSetAlpha(0.0,ALL_SIDES);
 scale=llGetScale();
 initialRot=<0, 0, 0, 1>;
 initialPos=llGetLocalPos();
 initialPos.z=0;
 llSetPos(initialPos);
 llSetLocalRot(initialRot);
 llSetRemoteScriptAccessPin(1234);
}
open(){
 llSetLocalRot(llEuler2Rot(<0, -PI_BY_TWO, 0>)*initialRot);
 llSetLocalRot(llEuler2Rot(<0, -PI, 0>)*initialRot);
 isopen=TRUE;
 llMessageLinked(LINK_ROOT,102,"pageopened "+(string)sheet_number,NULL_KEY);
}
close(){
 llSetLocalRot(llEuler2Rot(<0, -PI_BY_TWO, 0>)*initialRot);
 llSetLocalRot(initialRot);
 isopen=FALSE;
 llMessageLinked(LINK_ROOT,102,"pageclosed "+(string)sheet_number,NULL_KEY);
}
standby(){
 llSetPos(initialPos+<0, 0, (scale.z/2)>);
}
unstandby(){
 llSetPos(initialPos+<0, 0, (scale.z)>);
}
goto_open(){
 llSetLocalRot(llEuler2Rot(<0, -PI, 0>)*initialRot);
 isopen=TRUE;
}
goto_closed(){
 llSetLocalRot(initialRot);
 isopen=FALSE;
}
goto_backcover(){
 llSetLocalRot(initialRot);
 llSetPos(initialPos);
}
hide(){
 llSetAlpha(0,ALL_SIDES);
}
show(){
 llSetAlpha(1,ALL_SIDES);
}
default {
 state_entry(){
  init();
 }
 link_message(integer sender,integer num,string s,key id){
  if (num!=523){
   return;
  }
  list commandline = llCSV2List(s);
  string command = llList2String(commandline,0);
  if (command=="pingsheets"){
   llMessageLinked(LINK_ROOT,version,"sheet",NULL_KEY);
  } else if (command=="init"){
   hide();
   goto_backcover();
  } else if (command=="goto_open_standby_position"){
   standby();
   goto_open();
  } else if (command=="goto_closed_standby_position"){
   standby();
   goto_closed();
  } else if (command=="goto_open_position"){
   unstandby();
   goto_open();
  } else if (command=="goto_closed_position"){
   unstandby();
   goto_closed();
  } else if (command=="show"){
   show();
  } else if (command=="number"){
   sheet_number=llList2Integer(commandline,1);
  }
 }
 changed(integer change){
  if ((change&CHANGED_SCALE)==CHANGED_SCALE){
   scale=llGetScale();
  }
 }
 touch_start(integer total_number){
  if (isopen==FALSE){
   open();
  } else {
   close();
  }
 }
}
//--------------------------------
// update_sheet script
//
list sheet_links;
get_sheet_links() {
    sheet_links = [];
    llMessageLinked(LINK_ALL_OTHERS, 523, "pingsheets", NULL_KEY);
}
default
{
    state_entry()
    {
        llListen(1,"",llGetOwner(),"update");
    }
    listen(integer c, string n, key id, string m)
    {
        llOwnerSay("Updating...");
        state getlinks;
    }
}
state getlinks {
    state_entry() {
        get_sheet_links();
    }
   
    link_message(integer sender, integer number, string s, key id) {
        if (s == "sheet") {
            //found sheet
            sheet_links += [sender];
        }
        if (llGetListLength(sheet_links) >= 3) {
            state update;
        }
    }
}
state update {
    state_entry() {
        integer i = llGetListLength(sheet_links) - 1;
        for (; i >= 0; i--) {
            llRemoteLoadScriptPin(llGetLinkKey(llList2Integer(sheet_links, i)), "sheet", 1234, TRUE, 0);
            llOwnerSay("Updated sheet " + (string)i);
        }
        llOwnerSay("done");
        state default;
    }
}
// -----------------------------------------------------
// Settings notecard
PageNaming:numerical
// ---------
