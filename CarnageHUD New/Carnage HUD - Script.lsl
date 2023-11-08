string desc_ = "(c)Vanessa (meljonna Resident) - ";
string _title_ = "HUD is subject to be changed!! Please be patient... TY <3<3<3\n\n\n(c)Vanessa (meljonna Resident)\n\n\n"; // !TEMP!

default
{
    state_entry()
    {
        llSetObjectDesc(desc_);
        llOwnerSay(_title_);
    }
    
    attach(key attached)
    {
        if(attached != NULL_KEY)
            llSetObjectDesc(desc_);
    }
}
