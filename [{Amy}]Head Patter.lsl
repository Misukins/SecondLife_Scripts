//★ ᴛʜᴀɴᴋ ʏᴏᴜ ꜰᴏʀ ᴘᴇᴛᴛɪɴɢ ᴍᴇ, Ѧɱץ ѴeđЯℹŋα ★
key toucher_key;

integer Count = 0;

string toucher_Name;
string objectname;

vector titleColor = <0.905, 0.686, 0.924>;

dispString(string value)
{
    llSetText(value, titleColor, 1);
}

saveData()
{
    list saveData;
    saveData += (string)Count + " times";
    saveData += (key)toucher_key;
    saveData += (string)toucher_Name;
    llSetObjectDesc(llDumpList2String(saveData, ","));
}

updateTimeDisp()
{
    key toucher_key = llDetectedKey(0);
    list userName = llParseString2List(llGetDisplayName(toucher_key), [""], []);
    toucher_Name = llKey2Name(toucher_key);
    dispString("Times i've been petted (" + (string)Count + ")\n" + (string)userName + " (" + (string)toucher_Name + ")");
}

default
{
    state_entry()
    {
        llSetText("", titleColor, 1);
    }

    touch_start(integer total_number)
    {
        key toucher_key = llDetectedKey(0);
        list username = llParseString2List(llGetDisplayName(toucher_key), [""], []);
        toucher_Name = llKey2Name(toucher_key);
        string origName = llGetObjectName();
        llSetObjectDesc("");
        llSay(0, "★ ᴛʜᴀɴᴋ ʏᴏᴜ ꜰᴏʀ ᴘᴇᴛᴛɪɴɢ ᴍᴇ, " + (string)username + " (" + (string)toucher_Name + ") ★");
        llSetObjectName(origName);
        Count++;
        updateTimeDisp();
    }
}
