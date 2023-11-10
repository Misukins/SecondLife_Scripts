

string author   = "][Vanessa][";
string project  = "Phone-Background";
string version  = "Version 1.0";
string copy     = "(c)Vanessa (meljonna Resident)";

list emcList;

init(){
    llSetObjectDesc(copy);
    llSetObjectName((string)author + (string)project + " - " + (string)version + ".");
}

default{
    state_entry(){
        //TODO
    }

    touch_start(integer total_number){
        //TODO
    }
    
    listen(integer channel, string name, key id, string message){
        //TODO
    }
}
