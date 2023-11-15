integer PH_Enabled = FALSE;

default
{
    state_entry(){
        llSetLinkAlpha(LINK_THIS, 0, ALL_SIDES);
    }
    
    touch_start(integer total_number){
        if (PH_Enabled){
            key _id = llGetOwner();
            string info = "";
            string URL = "https://www.pornhub.com/";
            llLoadURL(_id, info, URL);
        }
    }

    link_message(integer from,integer to,string msg,key id){
        if (msg == "PHON"){
            llSetLinkAlpha(LINK_THIS, 1, ALL_SIDES);
            PH_Enabled = TRUE;
        }
        else if (msg == "PHOFF"){
            llSetLinkAlpha(LINK_THIS, 0, ALL_SIDES);
            PH_Enabled = FALSE;
        }
        !PH_Enabled = PH_Enabled;
    }
}