default
{
    link_message(integer n, integer num, string message, key id)
    {
        if(message == "signed in")
            llSetPayPrice(20, [20 ,50, 75, 100]);
        else if(message == "signed out")
            llSetPayPrice(PAY_DEFAULT, [PAY_DEFAULT ,PAY_DEFAULT, PAY_DEFAULT, PAY_DEFAULT]);
    }
}