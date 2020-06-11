//SETTINGS YOU MAY CHANGE!

integer lowest_Tip  = 20;
integer tiptwo      = 50;
integer tipthree    = 100;
integer tipfour     = 200;

//PLEASE DO NOT CNAGE ANYTHING BELOW!!

default
{
    state_entry()
    {
        //PLEASE DO NOT CNAGE ANYTHING BELOW!!
    }

    link_message(integer n, integer num, string message, key id)
    {
        if(message == "signed in")
            llSetPayPrice(lowest_Tip, [lowest_Tip ,tiptwo, tipthree, tipfour]);
        else if(message == "signed out")
            llSetPayPrice(PAY_DEFAULT, [PAY_DEFAULT ,PAY_DEFAULT, PAY_DEFAULT, PAY_DEFAULT]);
    }
}
