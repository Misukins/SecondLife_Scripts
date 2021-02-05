integer totaldonated;

//SETTING!!!!!!!!
integer lowest_Tip = 50; //CHANGE THIS FOR YOUR LIKING!!!!!!!
integer tiptwo = 100;    //CHANGE THIS FOR YOUR LIKING!!!!!!!
integer tipthree = 150;  //CHANGE THIS FOR YOUR LIKING!!!!!!!
integer tipfour = 200;   //CHANGE THIS FOR YOUR LIKING!!!!!!!
//SETTING!!!!!!!!

string imtext = "I'm the Alligator Alley's Donation Box! click and pay me to donate, as this supports the Alligator Alley Club and help keep the place open for you!";

integer updatetext(key id, integer amount)
{
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    totaldonated += amount;
    string str = "Alligator Alley Club Donation Box\n";
    str+= (string)totaldonated + " donated so far.\n" + (string)name + " donated L$" + (string)amount;
    llSetText(str, <.25,1,.65>, 1);
    llInstantMessage(llGetOwner(),(string)name +" donated $" + (string)amount);
    llInstantMessage(id,"On behalf of everyone who uses this place, thank you for the donation!");
    llSay(0,(string)name +" donated L$" + (string)amount + ". Thank you very much for supporting us, it is much appreciated!" );
    return 1;
}

default
{
    state_entry()
    {
        llSetClickAction(CLICK_ACTION_PAY);
        llSetText("Alligator Alley Donation Box",<.25,1,.65>,1);
        llSetPayPrice(lowest_Tip, [lowest_Tip ,tiptwo, tipthree, tipfour]);
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }

    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner()){
            llOwnerSay("Reporting script status, because you are recognised as the owner of this donation box.");
            llOwnerSay("Current TOTAL donations across all time: L$"+(string)totaldonated);
        }
        else{
            llInstantMessage(llDetectedKey(0),imtext);
        }
    }

    money(key _id, integer amount)
    {
        updatetext(_id,amount);
    }
}