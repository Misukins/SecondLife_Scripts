string itemDataNotecard = "Item Data";

integer inventoryType = INVENTORY_OBJECT;
integer currentItem = 0;
vector textColor = <1,1,1>;

float changeTimer = 300.0;

list pictures   = [];
list items      = [];
list models     = [];
list prices     = [];
list authors    = [];

integer notecardLine;
key currentDataRequest;

InitializationStep1()
{
    llWhisper(0, "Reading item data...");
    notecardLine = 0;
    currentDataRequest = llGetNotecardLine(itemDataNotecard, notecardLine);
}

InitializationStep2()
{
    llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
}

SetCurrentItem(integer item)
{
    integer itemCount = llGetListLength(items) - 1;
    currentItem = item;
    if (currentItem == -1) {
        currentItem = itemCount;
    }
    else if (currentItem > itemCount){
        currentItem = 0;
    }
    string hoverText = "Item " + (string)(currentItem + 1) + " of " + (string)(itemCount + 1) + "\n" + llList2String(items, currentItem) + "\n$" + (string)llList2String(prices, currentItem);
    llSetText(hoverText, textColor, 1.0);
    //llWhisper(0, "Now Showing: " + llList2String(items, currentItem));
}

default
{
    state_entry()
    {
        llWhisper(0, "Starting up...");
        llSetText("", textColor, 1.0);
        InitializationStep1();
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_DEBIT) {
            state vend;
        }
        else {
            llWhisper(0, "You must grant debit permission for me to work properly.");
        }
    }

    dataserver(key query, string data)
    {
        if (query == currentDataRequest) {
            currentDataRequest = "";
            if (data != EOF) {
                list currentList = llCSV2List(data);
                string myItemPicture = llList2String(currentList, 0);
                string myItemName = llList2String(currentList, 1);
                string myModelName = llList2String(currentList, 2);
                integer myPrice = llList2Integer(currentList, 3);
                string myAuthorsAsString = llList2String(currentList, 4);
                pictures += [myItemPicture];
                items += [myItemName];
                models += [myModelName];
                prices += [myPrice];
                authors += [myAuthorsAsString];
                notecardLine++;
                currentDataRequest = llGetNotecardLine(itemDataNotecard, notecardLine);
            }
            else {
                InitializationStep2();
           }
        }
    }
}

state vend
{
    state_entry()
    {
        SetCurrentItem(currentItem);
        llSetTimerEvent(changeTimer);
        llWhisper(0, "Multiauthor Multivendor online.");
    }

    timer()
    {
        integer newItem = currentItem;
        if (llGetListLength(items) > 1) {
            while (newItem == currentItem) {
                newItem = (integer)(llFrand(llGetListLength(items)) + 1.0);
            }
            SetCurrentItem(newItem);
        }
    }

    touch(integer total)
    {
        //llWhisper(0, "I sell things! Use the left or right arrows to cycle through the items I am selling, then right-click and \"Pay\" me the displayed amount to purchase an item.");
    }

    money(key agentkey, integer amount)
    {
        string name = llKey2Name(agentkey);
        integer currentPrice = llList2Integer(prices, currentItem);
        integer sale;
        integer i;

        if(amount < currentPrice) {
            llWhisper(0, name +  " you Paid $" + (string)amount + " - thats not enough money for the current item! Refunding $" + (string)amount + "...");
            llGiveMoney(agentkey, amount);
            sale = FALSE;
        }
        else if(amount > currentPrice) {
            integer change = amount - currentPrice;
            llWhisper(0, name + " you Paid $" + (string)amount + " - your change is $" + (string)change + ".");
            llGiveMoney(agentkey, change);
            sale = TRUE;
        }
        else {
            sale = TRUE;
        }

        if (sale) {
            integer found = FALSE;
            for (i = 0; i < llGetInventoryNumber(inventoryType); i++) {
                if (llGetInventoryName(inventoryType, i) == llList2String(items, currentItem)) {
                    found = TRUE;
                }
            }
            if (!found) {
                llWhisper(0, "Erm, I am sorry " + name + ", but it seems that this item is Out of stock, so I am refunding the purchase price.");
                llGiveMoney(agentkey, currentPrice);
            }
            else {
                llWhisper(0, "Thank you for your purchase, " + name + "!");
                llGiveInventory(agentkey, llList2String(items, currentItem));
                llWhisper(0, "Please wait while I perform accounting activities...");
                list myAuthors = llParseString2List(llList2String(authors, currentItem), ["|"], []);
                if (llGetListLength(myAuthors) > 0) {
                    integer shareAmount = (integer)llList2Integer(prices, currentItem) / llGetListLength(myAuthors);
                    for (i = 0; i < llGetListLength(myAuthors); i++) {
                        llInstantMessage(llList2Key(myAuthors, i), name + " purchased " + llList2String(items, currentItem) + ". Your share is L$" + (string)shareAmount + ".");
                        if (llList2Key(myAuthors, i) == llGetOwner()) {
                            myAuthors = llDeleteSubList(myAuthors, i, i);
                        }
                    }
                    if (shareAmount > 0 && llGetListLength(myAuthors) > 0) {
                        for (i = 0; i < llGetListLength(myAuthors); i++) {
                            llGiveMoney(llList2Key(myAuthors, i), shareAmount);
                        }
                    }
                }
                llWhisper(0, "Accounting completed. Thanks again, " + name + "!");
            }
        }
    }

    link_message(integer sender, integer num, string message, key id)
    {
        if (message == "next") {
            llSetTimerEvent(changeTimer);
            SetCurrentItem(currentItem + 1);
            integer currentPrice = llList2Integer(prices, currentItem);
            llSetPayPrice(currentPrice, [PAY_HIDE ,PAY_HIDE, PAY_HIDE, PAY_HIDE]);
        }
        else if (message == "prev") {
            llSetTimerEvent(changeTimer);
            SetCurrentItem(currentItem - 1);
            integer currentPrice = llList2Integer(prices, currentItem);
            llSetPayPrice(currentPrice, [PAY_HIDE ,PAY_HIDE, PAY_HIDE, PAY_HIDE]);
        }
        else if (message == "info") {
            llWhisper(0, "I sell things! Use the left or right arrows to cycle through the items I am selling, then right-click and \"Pay\" me the displayed amount to purchase an item.");
        }
    }

    on_rez(integer startParam)
    {
        llResetScript();
    }
}