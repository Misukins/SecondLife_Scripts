integer health = 10;

string pList;
list zList = [];

vector color = <0,1,0>;

list Charsetx = ["[","█","█","█","█","█","█","█","█","█","]"];

default
{
    state_entry()
    {
        llSetText("Health: " + (string)health + " "  +  llDumpList2String(Charsetx,"" ), color, 1.0);
    }
    
    collision_start(integer num)
    {
        health -= num;
        llOwnerSay("health " + (string)health);
        if(health < 7)
            color = <1,1,0>;
        if(health < 4)
            color = <1,0,0>;
        if(health == 0){
            llOwnerSay("dead");
            health = 10;
            color = <0,1,0>;
        }
        zList = llList2List(Charsetx, 0, health);
        pList = llDumpList2String(zList, "");
        llSetText("Health: " + (string)health + " " + pList, color, 1.0);
    }
}
