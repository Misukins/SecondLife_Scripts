list    gLstChoices = [ "Show Admin", "Add Admin", "Del Admin", "Show White", "Add White", "Del White", "Turn On", "Turn Off", "Orb Status", "More", "Cancel"];
list    gLstChoicesMore = [ "ShowTitle", "HideTitle", "ShowEjected", "DelEject", "ClearEject", "Warn Time", "SetRange", "<< Back", "Group Mode", "Scan Rate" ];
list    gLstChoiceGroup = ["Group On", "Group Off"];
list    gLstOwnerName = [];
list    gLstAdminNames = [];
list    gLstIgnore = [];
list    gLstEjected = [];
list    gLstEjectR = [];

key     gKeyToucherID;

float   gFltRange = 30.0;
float   gFltWarnTime = 30;
float   gFltScanRate = 30;

integer gIntChannel_Dialog;
integer gIntChannel_Chat;
integer gIntListen_Id;
integer gIntListen_Id_Chat;
integer gIntWhite_LstLen = 25;
integer gIntEject_LstLen = 50;
integer gIntAdmin_LstLen = 6;
integer gIntRange = 30;
integer gIntBanTime;
integer gIntMasterRW = TRUE;
integer gIntWhiteAD;
integer gIntActive;
integer gIntEjected;
integer gIntSetRange;
integer gIntWarnTime;
integer gIntSetWarnTime;
integer gIntSetScanRate;
integer gIntVectorX;
integer gIntGroupSet = 0;
integer hidetitletext = FALSE;

string  gStrWarnTime = "30";
string  gStrRange = "96";
string  gStrScanRate = "30";
string  gParcelName;
string  gStrToucherName;
string  gStrNewOwnerName;

vector redstate = <1.0, 0.695, 0.695>;
vector greenstate = <0.695, 1.0, 0.695>;

string parcelName(vector p)
{
    return llList2String(llGetParcelDetails(p, [PARCEL_DETAILS_NAME]) , 0);
}

string agentUsername(string agentLegacyName)
{
    return llDumpList2String(llParseString2List(llToLower(agentLegacyName)+" ", [" resident ", " "],[]), ".");
}

string title = "Trinity Rental Security Orb";

integer updatetext()
{
    if (hidetitletext == FALSE){
        if (gIntActive == 1){
            llSetText(title + ".\nStatus: Security Orb is active.\nScanning at " + (string)gStrRange + " meters in eject mode.\nScan Rate is set at " + (string)gStrScanRate + " seconds.\nWarning time is set at " + (string)gStrWarnTime + " seconds.\nAccess: " + (string)gIntGroupSet + ".", <.25, 1, .65> ,1);
            return 1;
        }
        else{
            llSetText(title + ".\nStatus: Security Orb is turned off.", <.25, 1, .65> ,1);
            return 1;
        }
    }
    else{
        llSetText("", <.25, 1, .65> ,1);
        return 0;
    }
}

default
{
    state_entry()
    {
        gLstOwnerName = [gStrNewOwnerName = llGetUsername (llGetOwner ())] + gLstOwnerName;
        gLstIgnore = [gStrNewOwnerName] + gLstIgnore;
        gIntChannel_Dialog = ( -1 * (integer)("0x"+llGetSubString((string)llGetKey(),-5,-1)) );
        gIntChannel_Chat = 701;
        gParcelName = parcelName(llGetPos());        updatetext();
    }
    
    touch_start(integer total_number)
    {
        gKeyToucherID = llDetectedKey(0);
        gStrToucherName = llGetUsername(llDetectedKey(0));
        list vOwnerAdminNames = gLstOwnerName + gLstAdminNames;
        if(~llListFindList(vOwnerAdminNames, [gStrToucherName]))
        {
            gKeyToucherID = llDetectedKey(0);
            llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
            gIntListen_Id = llListen(gIntChannel_Dialog, "", gKeyToucherID, "");
            gIntChannel_Chat = 701;
            llSetTimerEvent(20);
        }
        else
            llSay (0, "You are not authorized");
    }
    
    listen(integer channel, string name, key id, string choice)
    {
        if(channel == gIntChannel_Dialog)
        {
            if (~llListFindList(gLstChoices, [choice]))
            {
                if (choice == "Cancel")
                    llListenRemove(gIntListen_Id);
                else if (choice == "More")
                    llDialog(gKeyToucherID, "Pick an option!", gLstChoicesMore, gIntChannel_Dialog);
                else if (choice == "Orb Status")
                {
                    if (gIntActive == 1)
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Security Orb is active and scanning at " + gStrRange + " meters in eject mode" + " Scan Rate is set at " + gStrScanRate + " seconds.");
                        llRegionSayTo(gKeyToucherID, 0, "Warning time is set at " + gStrWarnTime + " seconds");
                    }
                    else
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Security Orb is turned off"  + " Scan Rate is set at " + gStrScanRate + " seconds" );
                        llRegionSayTo(gKeyToucherID, 0, "Warning time is set at " + gStrWarnTime + " seconds");
                    }
                    updatetext();
                    llListenRemove(gIntListen_Id);
                }
                else if (choice == "Turn On")
                {
                    if (gIntActive == 1)
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Security Orb is already armed and scanning at " + gStrRange + " meters. I will eject anyone I can find unless they're in your White list." );
                        llRegionSayTo(gKeyToucherID, 0, "Warning time is set at " + gStrWarnTime + " seconds" + " Scan Rate is set at " + gStrScanRate + " seconds.");
                    }
                    else
                    {
                        gIntActive = 1;
                        llRegionSayTo(gKeyToucherID, 0, "Security Orb is armed and scanning at " + gStrRange + " meters. I will eject anyone I can find unless they're in your White list." );
                        llRegionSayTo(gKeyToucherID, 0, "Warning time is set at " + gStrWarnTime + " seconds" + " Scan Rate is set at " + gStrScanRate + " seconds.");
                        llSensorRepeat( "", "", AGENT, gFltRange, PI, gFltScanRate );
                    }
                    llSetColor(greenstate, ALL_SIDES);
                    updatetext();
                    llListenRemove(gIntListen_Id);
                }
                else if (choice == "Turn Off")
                {
                    llSensorRemove();
                    gIntActive = 0;
                    llRegionSayTo(gKeyToucherID, 0, " Security Orb is turned off");
                    llSetColor(redstate, ALL_SIDES);
                    llListenRemove(gIntListen_Id);                    updatetext();
                }
                else if (choice == "Show White")
                {
                    llRegionSayTo(gKeyToucherID, 0, "Here's your White list");
                    integer i;
                    integer s = llGetListLength(gLstIgnore);
                    do
                        llRegionSayTo(gKeyToucherID, 0, llList2String(gLstIgnore,i));
                    while(s>++i);
                    llListenRemove(gIntListen_Id);
                }
                if (choice == "Add White")
                {
                    if (llGetListLength(gLstIgnore) >= (gIntWhite_LstLen + gIntAdmin_LstLen + llGetListLength(gLstOwnerName)))
                    {
                        llRegionSayTo(gKeyToucherID, 0, " You have reached the maximum allowed in the White List.");
                        llRegionSayTo(gKeyToucherID, 0, " If you want to the White List, you will need to delete one first");
                    }
                    else
                    {
                        gIntWhiteAD = 1;
                        if(gIntWhiteAD == 1)
                        {
                            llRegionSayTo(gKeyToucherID, 0, "Please Enter name to Add in chat window on Channel /701");
                            gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
                            llListenRemove(gIntListen_Id);
                        }
                    }
                }
                else if (choice == "Del White")
                {
                    gIntWhiteAD = 2;
                    llRegionSayTo(gKeyToucherID, 0, "Please Enter name to Delete in chat window on Channel /701");
                    gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
                    llListenRemove(gIntListen_Id);
                }
                else if (choice == "Add Admin")
                {
                    if (llGetListLength(gLstAdminNames) >= gIntAdmin_LstLen)
                    {
                        llRegionSayTo(gKeyToucherID, 0, " You have reached the maximum allowed Administrators.");
                        llRegionSayTo(gKeyToucherID, 0, " If you want to add another Administrator, you will need to delete one first");
                    }
                    else if(~llListFindList(gLstOwnerName, [gStrToucherName]))
                    {
                        gIntWhiteAD = 3;
                        llRegionSayTo(gKeyToucherID, 0, "Please Enter name of the Administrator to Add in chat window on Channel /701");
                        gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
                    }
                    else
                        llSay (0, "You are not authorized to add to the administrators list");
                    llListenRemove(gIntListen_Id);
                }
                else if (choice == "Show Admin")
                {
                    if (gLstAdminNames == [])
                        llRegionSayTo(gKeyToucherID, 0, " The Administrators list is empty");
                    else
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Here's your Administrators list");
                        llRegionSayTo(gKeyToucherID, 0, llList2CSV(gLstAdminNames));
                    }
                    llListenRemove(gIntListen_Id);
                }
                else if (choice == "Del Admin")
                {
                    if(~llListFindList(gLstOwnerName, [gStrToucherName]))
                    {
                        if (gLstAdminNames == [])
                            llRegionSayTo(gKeyToucherID, 0, " The Administrators list is empty");
                        else if (gLstAdminNames)
                        {
                            gIntWhiteAD = 4;
                            llRegionSayTo(gKeyToucherID, 0, "Please Enter name of the Admin to Delete in chat window on Channel /701");
                            gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
                        }
                        else
                            llRegionSayTo(gKeyToucherID, 0, "You are not authorized to remove from the administrators list");
                    }
                    llListenRemove(gIntListen_Id);
                }
            }
            if (~llListFindList(gLstChoicesMore, [choice]))
            {
                if (choice == "Warn Time")
                {
                    gIntSetWarnTime = 1;
                    llRegionSayTo(gKeyToucherID, 0, "Please enter the new warning time on Channel /701");
                    gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
                    llListenRemove(gIntListen_Id);                    updatetext();
                }
                else if (choice == "Scan Rate")
                {
                    gIntSetScanRate = 1;
                    llRegionSayTo(gKeyToucherID, 0, "Please enter a Scan Rate from 5 to 60 seconds in the chat window on Channel /701");
                    gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
                    llListenRemove(gIntListen_Id);                    updatetext();
                }
                else if (choice == "SetRange")
                {
                    gIntSetRange = 1;
                    llRegionSayTo(gKeyToucherID, 0, "Please enter the new scan range on Channel /701");
                    gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
                    llListenRemove(gIntListen_Id);                    updatetext();
                }
                else if (choice == "ShowEjected")
                {
                    if (gLstEjected == [])
                        llRegionSayTo(gKeyToucherID, 0, " The ejected list is empty");
                    else
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Here's your ejected list");
                        integer i;
                        integer s = llGetListLength(gLstEjected);
                        do
                            llRegionSayTo(gKeyToucherID, 0, llList2String(gLstEjected,i));
                        while(s>++i);
                    }
                    llListenRemove(gIntListen_Id);
                }
                else if (choice == "DelEject")
                {
                    if (gLstEjected == [])
                        llRegionSayTo(gKeyToucherID, 0, " The ejected list is empty");
                    else
                    {
                        gIntEjected = 1;
                        llRegionSayTo(gKeyToucherID, 0, "Please enter name to delete in chat window on Channel /701");
                        gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
                    }
                    llListenRemove(gIntListen_Id);
                }
                else if (choice == "ClearEject")
                {
                    if (gLstEjected == [])
                        llRegionSayTo(gKeyToucherID, 0, " The ejected list is already empty");
                    else
                    {
                        gIntEjected = 2;
                        llRegionSayTo(gKeyToucherID, 0, "This will clear the Ejected List. Do you wish to proceeed? Enter y or n on Channel /701");
                        gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
                    }
                    llListenRemove(gIntListen_Id);
                }
                else if (choice == "ShowTitle"){
                    hidetitletext = FALSE;
                    updatetext();
                }
                else if (choice == "HideTitle"){
                    hidetitletext = TRUE;
                    updatetext();
                }
            }
            if (~llListFindList(gLstChoiceGroup, [choice]))
            {
                if (choice == "Group On")
                {
                    gIntGroupSet = 1;
                    llRegionSayTo(gKeyToucherID, 0, "Group Mode protection is activated");
                    llListenRemove(gIntListen_Id);
                    updatetext();
                }
                else if (choice == "Group Off")
                {
                    gIntGroupSet = 0;
                    llRegionSayTo(gKeyToucherID, 0, "Group Mode protection is de-activated");
                    llListenRemove(gIntListen_Id);
                    updatetext();
                }
            }
        }
        if(channel == gIntChannel_Chat)
        {
            if (gIntMasterRW = TRUE)
            {
                if(~llListFindList([1,2,3,4],[gIntWhiteAD]))
                {
                    choice = agentUsername (choice);
                    if (gIntWhiteAD == 1)
                    {
                        if(~llListFindList(gLstIgnore, [choice]))
                            llRegionSayTo(gKeyToucherID, 0, choice + " is already in the White List");
                        else if(~llListFindList(gLstEjected, [choice]))
                        {
                            integer i = llListFindList(gLstEjected, [choice]);
                            gLstEjected = llDeleteSubList(gLstEjected, i,i);
                            llRegionSayTo(gKeyToucherID, 0, choice + " was in the Ejected list " + choice + "  has been removed from the Ejected list" );
                            gLstIgnore = gLstIgnore + [choice];
                            }
                            else
                            {
                                gLstIgnore = gLstIgnore + [choice];
                                llRegionSayTo(gKeyToucherID, 0, choice + " has been added to the White List");
                            }
                            llListenRemove(gIntListen_Id_Chat);
                            llListenRemove(gIntListen_Id);
                            gIntWhiteAD = 0;
                        }
                        else if (gIntWhiteAD == 2)
                        {
                            if(~llListFindList(gLstOwnerName, [choice]))
                                llRegionSayTo(gKeyToucherID, 0, "You can not remove the owner name from the White list!");
                            else
                            {
                                integer j = llListFindList(gLstIgnore, [choice]);
                                if (j == -1)
                                {
                                    gIntWhiteAD = 0;
                                    llRegionSayTo(gKeyToucherID, 0, choice + " isn't in the White list");
                                    llListenRemove(gIntListen_Id_Chat);
                                    llListenRemove(gIntListen_Id_Chat);
                                    return;
                                }
                                else
                                {
                                    gLstIgnore = llDeleteSubList(gLstIgnore, j,j);
                                    llRegionSayTo(gKeyToucherID, 0, choice + " has been removed from the White list");
                                }
                            }
                            llListenRemove(gIntListen_Id_Chat);
                        }
                        else if (gIntWhiteAD == 3)
                        {
                            if(~llListFindList(gLstAdminNames, [choice]))
                                llRegionSayTo(gKeyToucherID, 0, choice + " is already in the Admin List");
                            else if(~llListFindList(gLstIgnore, [choice]))
                            {
                                gLstAdminNames = gLstAdminNames + [choice];
                                llRegionSayTo(gKeyToucherID, 0, choice + " has been added to the Administrators list");
                            }
                            else if(~llListFindList(gLstEjected, [choice]))
                            {
                                integer j = llListFindList(gLstEjected, [choice]);
                                gLstEjected = llDeleteSubList(gLstEjected, j,j);
                                llRegionSayTo(gKeyToucherID, 0, choice + " was in the Ejected list " + choice + "  has been removed from the Ejected list" );
                                gLstAdminNames = gLstAdminNames + [choice];
                                gLstIgnore = gLstIgnore + [choice];
                                llRegionSayTo(gKeyToucherID, 0, choice + " has been added to the Administrators list");
                            }
                            else
                            {
                                gLstAdminNames = gLstAdminNames + [choice];
                                gLstIgnore = gLstIgnore + [choice];
                                llRegionSayTo(gKeyToucherID, 0, choice + " has been added to the Administrators list");
                            }
                            gIntWhiteAD = 0;
                            llListenRemove(gIntListen_Id_Chat);
                        }
                        else if (gIntWhiteAD == 4)
                        {
                            integer j = llListFindList(gLstAdminNames, [choice]);
                            if ( j == -1)
                                llRegionSayTo(gKeyToucherID, 0, choice + " isn't in the Administrators list");
                            else
                            {
                                gLstAdminNames = llDeleteSubList(gLstAdminNames, j,j);
                                llRegionSayTo(gKeyToucherID, 0, choice + " has been removed from the Administators list");
                            }
                            gIntWhiteAD = 0;
                            llListenRemove(gIntListen_Id_Chat);
                        }
                    }
                    else if (gIntSetRange == 1)
                    {
                        gIntRange = (integer) choice;
                        if (gIntRange)
                        {
                            gStrRange = choice;
                            gFltRange = (float) gIntRange;
                            llSensorRemove();
                            llSensorRepeat("", "", AGENT, gFltRange, PI, gFltScanRate);
                            gIntActive = 1;
                            llRegionSayTo(gKeyToucherID, 0, "Changed range to: " + gStrRange + " meters and restarted the scanner");
                            llRegionSayTo(gKeyToucherID, 0, "Warning time is set at " + gStrWarnTime + " seconds" + " Scan Rate is set at " + gStrScanRate + " seconds.");
                        }
                        else
                            llRegionSayTo(gKeyToucherID, 0, "Invalid entry. Please enter an integer in meters up to 96 meters.");
                        llListenRemove(gIntListen_Id_Chat);
                        gIntSetRange = 0;
                    }
                    else if (gIntSetWarnTime == 1)
                    {
                        gIntWarnTime = (integer) choice;
                        if (gIntWarnTime)
                        {
                            gStrWarnTime = choice;
                            gFltWarnTime = (integer) gIntWarnTime;
                            llRegionSayTo(gKeyToucherID, 0, "Warning time has been changed to " + gStrWarnTime + " seconds");
                        }
                        else
                            llRegionSayTo(gKeyToucherID, 0, "Invalid entry. Please try again!");
                        llListenRemove(gIntListen_Id_Chat);
                        gIntSetWarnTime = 0;
                    }
                    else if (gIntEjected == 1)
                    {
                        integer j = llListFindList(gLstEjected, [choice]);
                        if ( j == -1)
                        {
                            llRegionSayTo(gKeyToucherID, 0, choice + " isn't in the Ejected list");
                            llListenRemove(gIntListen_Id_Chat);
                            gIntEjected = 0;
                            return;
                        }
                        gLstEjected = llDeleteSubList(gLstEjected, j,j);
                        llRegionSayTo(gKeyToucherID, 0, choice + " has been removed from the Ejected list");
                        gIntEjected = 0;
                        llListenRemove(gIntListen_Id_Chat);
                    }
                    else if (gIntEjected == 2)
                    {
                        if (choice == "y")
                        {
                            llRegionSayTo(gKeyToucherID, 0, "Resetting the Ejected List");
                            gLstEjected = [];
                        }
                        if (choice == "n")
                            llRegionSayTo(gKeyToucherID, 0, "Aborting");
                        gIntEjected = 0;
                        llListenRemove(gIntListen_Id_Chat);
                    }
                    else if (gIntSetScanRate == 1)
                    {
                        gFltScanRate = (float) choice;
                        if (gFltScanRate)
                        {
                            gStrScanRate = choice;
                            llRegionSayTo(gKeyToucherID, 0, "ScanRate set to " + gStrScanRate + " seconds. Restarted the scanner");
                            llSensorRemove();
                            llSensorRepeat("", "", AGENT, gFltRange, PI, gFltScanRate);
                            gIntActive = 1;
                            llRegionSayTo(gKeyToucherID, 0, "Security Orb is active and scanning at " + gStrRange + " meters in eject mode" + " Scan Rate is set at " + gStrScanRate + " seconds.");
                            llRegionSayTo(gKeyToucherID, 0, "Warning time is set at " + gStrWarnTime + " seconds");
                        }
                    else
                        llRegionSayTo(gKeyToucherID, 0, "Invalid Entry. Please enter a Scan Rate between 10 and 60 seconds. i.e /7 30");
                    gIntSetScanRate = 0;
                    llListenRemove(gIntListen_Id_Chat);
                }
            }
        }
    }
   
    timer()
    {
        llListenRemove(gIntListen_Id_Chat);
        llListenRemove(gIntListen_Id);
        gIntMasterRW = FALSE;
        //llRegionSayTo(gKeyToucherID, 0, "Times is up to make changes");
        llSetTimerEvent(0);
    }
    
    sensor(integer nr)
    {
        if (gIntActive == 1)
        {
            integer i;
            do
            {
                integer found = FALSE;
                if (gIntGroupSet == 1)
                {
                    if (llSameGroup(llDetectedKey(i)))
                        found = TRUE;
                }
                string vNameTest = llGetUsername(llDetectedKey(i));
                if(~llListFindList(gLstIgnore,[vNameTest]))
                    found = TRUE;
                vector pos = llDetectedPos(i);
                string pname = parcelName(pos);
                if (pname == gParcelName)
                    gIntVectorX = 1;
                if (found == FALSE && gIntVectorX == 1 && llOverMyLand(llDetectedKey(i)) && (llDetectedKey(i) != llGetOwner()))
                {
                    if (~llListFindList (gLstEjectR, [vNameTest]))
                    {
                        integer index = llListFindList(gLstEjectR, [vNameTest]);
                        integer BOOT_TIME_TEST = llList2Integer(gLstEjectR, index + 1);
                        integer BOOT_TIME = llGetUnixTime();
                        integer timetest = (BOOT_TIME - BOOT_TIME_TEST);
                        if (timetest  <=  gIntBanTime )
                        {
                            llInstantMessage(llDetectedKey(i), "You are on private property. This is the second time you have been detected. If you are detected again you will be teleported home with no warning!");
                            if (llOverMyLand(llDetectedKey(i)))
                            {
                                llInstantMessage(llDetectedKey(i), "GOODBYE!");
                                llInstantMessage(llGetOwner(), "Ejecting from our home: "+ vNameTest);
                                llEjectFromLand(llDetectedKey(i));
                                gLstEjectR = llDeleteSubList(gLstEjectR,index,index + 1 );
                            }
                        }
                        if (timetest  >=  gIntBanTime )
                            gLstEjectR = llDeleteSubList(gLstEjectR,index,index + 1 );
                        if (llGetListLength(gLstEjectR) > gIntEject_LstLen)
                            gLstEjectR = llDeleteSubList(gLstEjectR, 0, 1 );
                    }
                    else
                    {
                        llInstantMessage(llDetectedKey(i), "You are on private property. You will be ejected from this parcel in " + gStrWarnTime + " seconds.");
                        llSleep(gFltWarnTime);
                        if (llOverMyLand(llDetectedKey(i)))
                        {
                            llInstantMessage(llDetectedKey(i), "GOODBYE!");
                            llInstantMessage(llGetOwner(), "Ejecting from our home: "+vNameTest);
                            llEjectFromLand(llDetectedKey(i));
                            gLstEjectR = gLstEjectR + [vNameTest, llGetUnixTime()];
                            if (~llListFindList(gLstEjected, [vNameTest]))
                                return;
                            else
                                gLstEjected = gLstEjected + vNameTest;
                        }
                        if (llGetListLength(gLstEjected) > gIntEject_LstLen)
                            gLstEjected = llDeleteSubList(gLstEjected, 0, 1 );
                    }
                }
            }
            while ((++i) < nr);
        }
    }
    
    on_rez (integer startup)
    {
        llResetScript();
    }
}
