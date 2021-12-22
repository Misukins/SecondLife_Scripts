key owner;

integer listenChannel = -64849782;

default
{
    state_entry()
    {
        llSay(listenChannel, "Yeast");
    }

    on_rez(integer num)
    {
        llOwnerSay("i wont work like this.. you have to wear me!");
    }

    touch_start(integer total_number)
    {
        llOwnerSay("hello");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        //
    }
}