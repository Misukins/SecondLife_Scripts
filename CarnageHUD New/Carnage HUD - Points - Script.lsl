string desc_          = "(c)Vanessa (meljonna Resident) - ";

default
{
    state_entry()
    {
        llSetObjectDesc(desc_);
        //!TODO
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    touch_start(integer total_number)
    {
        //!TODO
        llOwnerSay("...Coming Soon...");
    }
}