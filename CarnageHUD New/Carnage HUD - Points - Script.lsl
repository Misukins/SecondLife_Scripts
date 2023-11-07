string desc_          = "(c)Vanessa (meljonna Resident) - ";

default
{
    state_entry()
    {
        llSetObjectDesc(desc_);
        //!TODO
    }

    touch_start(integer total_number)
    {
        //!TODO
        llOwnerSay("...Coming Soon...");
    }
}