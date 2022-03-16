integer holsterChan = -987544;
integer isHolstered;

integer Schlitten;
integer Glock;
integer Clip;
integer Clip1;
integer Abzug;
integer link_num;

string _Schlitten   = "Schlitten";
string _Glock       = "Glock";
string _Clip        = "Clip";
string _Clip1       = "Clip1";
string _Abzug       = "Abzug";

determine_display_links(){
    integer i = link_num;
    integer found = 0;
    do{
        if(llGetLinkName(i) == _Schlitten){
            Schlitten = i;
            found++;
        }
        else if(llGetLinkName(i) == _Glock){
            Glock = i;
            found++;
        }
        else if(llGetLinkName(i) == _Clip){
            Clip = i;
            found++;
        }
        else if(llGetLinkName(i) == _Clip1){
            Clip1 = i;
            found++;
        }
        else if(llGetLinkName(i) == _Abzug){
            Abzug = i;
            found++;
        }
    }
    while (i-- && found < 5);
}

HolsteredON()
{
    isHolstered = TRUE;
    llSetLinkAlpha(Schlitten,   0.0, ALL_SIDES);
    llSetLinkAlpha(Glock,       0.0, ALL_SIDES);
    llSetLinkAlpha(Clip,        0.0, ALL_SIDES);
    llSetLinkAlpha(Clip1,       0.0, ALL_SIDES);
    llSetLinkAlpha(Abzug,       0.0, ALL_SIDES);
}

HolsteredOFF()
{
    isHolstered = FALSE;
    llSetLinkAlpha(Schlitten,   1.0, ALL_SIDES);
    llSetLinkAlpha(Glock,       1.0, ALL_SIDES);
    llSetLinkAlpha(Clip,        1.0, ALL_SIDES);
    llSetLinkAlpha(Clip1,       1.0, ALL_SIDES);
    llSetLinkAlpha(Abzug,       1.0, ALL_SIDES);
}

init()
{
    link_num = llGetNumberOfPrims();
    llListen(holsterChan, "", "", "");
    determine_display_links();
    if(isHolstered)
        isHolstered = TRUE;
    else
        isHolstered = FALSE;

}

default
{
    state_entry() 
    {
        init();
    }

    /* touch_start(integer _num)
    {
        if(!isHolstered)
            HolsteredON();
        else
            HolsteredOFF();
    } */

    listen(integer chan, string name, key id, string msg)
    {
        if(msg == "holstered"){
            if(!isHolstered)
                HolsteredON();
            else
                HolsteredOFF();
        }
    }
}
 