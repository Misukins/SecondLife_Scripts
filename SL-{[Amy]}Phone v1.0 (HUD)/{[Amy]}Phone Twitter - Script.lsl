default
{
    touch_start(integer total_number)
    {
        key _id = llGetOwner();
        string info = "";
        string URL = "https://twitter.com/home?lang=en";
        llLoadURL(_id, info, URL);
    }
}