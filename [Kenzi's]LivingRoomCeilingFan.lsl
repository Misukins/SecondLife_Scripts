default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_entry()
    {
        //
    }

    link_message(integer from,integer to,string msg,key id)
    {
        if (msg == "+VerySlow+")
            llTargetOmega(<0, 1, 0>, -0.4, -4.0);
        else if (msg == "+Slow+")
            llTargetOmega(<0, 4, 0>, -0.4, -4.0);
        else if (msg == "+Medium+")
            llTargetOmega(<0, 8, 0>, -0.4, -4.0);
        else if (msg == "+Fast+")
            llTargetOmega(<0, 10, 0>, -0.4, -4.0);
        else if (msg == "+VeryFast+")
            llTargetOmega(<0, 20, 0>, -0.4, -4.0);
        else if (msg == "+Off+")
            llTargetOmega(<0, 0, 0>, -0.4, -4.0);
    }
}