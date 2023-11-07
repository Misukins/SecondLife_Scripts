default
{
    touch_start(integer total_number)
    {
        key _id = llGetOwner();
        string info = "";
        string URL = "https://www.reddit.com/";
        llLoadURL(_id, info, URL);
    }
}