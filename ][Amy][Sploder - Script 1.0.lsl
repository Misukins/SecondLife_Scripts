float ownersCut = 10;
float TimeLimit = 300;

integer pot = 0;
integer amountLimit = 5;
integer entrantsCount = 0;
integer flag = 0;
integer i;
integer result = 0;
integer amount;
integer min_pay = 0; //F minimum amount to pay ppl. Exemple, if you change this value to 2, everyone will receive at least 2 L$
integer gLine = 0; 

list entrantsKey = [];
list Admins = [];

key chave;
key gQueryID;

string Text = "";
string gName = "][Amy][Sploder - Settings";
string teste = "";

integer RandInt(integer lower, integer higher){
    integer Range = higher - lower;
    integer Result = llFloor(llFrand(Range + 1)) + lower;
    return Result;
}

MakeParticles()
{     
    llParticleSystem([
        PSYS_PART_FLAGS , 0 //Comment out any of the following masks to deactivate them
        | PSYS_PART_INTERP_COLOR_MASK       //Colors fade from start to end
        | PSYS_PART_INTERP_SCALE_MASK       //Scale fades from beginning to end
        | PSYS_PART_FOLLOW_VELOCITY_MASK    //Particles are created at the velocity of the emitter
        | PSYS_PART_EMISSIVE_MASK           //Particles are self-lit (glow)
        ,PSYS_SRC_PATTERN   
        ,PSYS_SRC_PATTERN_EXPLODE
        ,PSYS_SRC_TARGET_KEY,        llGetOwner() //F
        ,PSYS_SRC_TEXTURE,           "cifrao"     //UUID of the desired particle texture F
        ,PSYS_PART_MAX_AGE,          2.5                //Lifetime, in seconds, that a particle lasts
        ,PSYS_SRC_BURST_RATE,        .5            //How long, in seconds, between each emission
        ,PSYS_SRC_BURST_PART_COUNT,  10       //Number of particles per emission
        ,PSYS_SRC_BURST_RADIUS,      1.0                //Radius of emission
        ,PSYS_SRC_ACCEL,             <1.0,1.0,0.0>      //Acceleration of particles each second
        ,PSYS_PART_START_ALPHA,      1.0       //Starting transparency, 1 is opaque, 0 is transparent.
        ,PSYS_PART_END_ALPHA,        0.0                //Ending transparency
        ,PSYS_PART_START_SCALE,      <.35,.35,.35>      //Starting particle size
        ,PSYS_PART_END_SCALE,        <0.35,0.35,0.35>      //Ending particle size, if INTERP_SCALE_MASK is on
        ,PSYS_SRC_OMEGA,             <1.0,0.0,0.0>       //Rotation of ANGLE patterns, similar to llTargetOmega()
    ]);
}

start()
{
    llSetTimerEvent(0);
    entrantsKey = [];
    result = 0;
    entrantsCount = 0;
    flag = 0;
    llParticleSystem([]);
    Text = "Pay the sploder to begin the countdown! (minimun L$ "+ (string)amountLimit +")";
    llSetText(Text, <0, 1.0, 0>,  1); 
}

default
{
    on_rez(integer num)
    {
        llResetScript();
    }
    
    state_entry()
    {
        gQueryID = llGetNotecardLine(gName, gLine);
        //start(); //NOTE
        llListen(7, "", llGetOwner(), "");
        llRequestPermissions(llGetOwner(),PERMISSION_DEBIT);
    }
    
    dataserver(key query_id, string data)
    {      
        if (query_id == gQueryID){
            if (data != EOF){
                if (teste == "ownercut")
                    ownersCut = (integer)data;
                if (teste == "minimumpay")
                    amountLimit = (integer)data;
                if (teste == "timelimit")
                    TimeLimit = (float)data;
                if (teste == "admins")
                    Admins = (list)data;
                if (llToLower(data) == "[ownercut]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine);
                    teste = "ownercut";
                }
                else if (llToLower(data)== "[minimumpay]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine); 
                    teste = "minimumpay";
                }
                else if (llToLower(data) == "[timelimit]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine); 
                    teste = "timelimit";
                }
                else if (llToLower(data) == "[admins]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine); 
                    teste = "admins";
                }
                else{
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine);
                    teste = "";
                }
            }
            else
                start();
        }
    }  
    
    money(key giver, integer amount) 
    {
        if (amount < amountLimit){
            llSay(0, "The minimum amount is L$"+ (string)amountLimit+".");
            llGiveMoney(giver,amount);
        }
        else{
            if (llListFindList(entrantsKey, [giver]) == -1)        
                entrantsKey += giver;
            entrantsCount = llGetListLength(entrantsKey);
            pot += amount; 
            llSay(0, llKey2Name(giver) + " adds L$" + (string)amount + " to the SPLODER. Current pot is L$"+ (string)pot +".");
            if (entrantsCount >= 5){
                llSetText("Ready to explode!!! Current pot is L$ "+ (string)pot, <0, 1.0, 0>,  1);
                if (flag == 0){
                    llSay(0, "SPLODER'S COUNTDOWN BEGINS!");
                    llSay(0, (string)(llRound(TimeLimit)) + " seconds before it explodes!!!");
                    llSetText("Ready to explode!!! Current pot is L$ "+ (string)pot, <0, 1.0, 0>,  1);
                    llSetTimerEvent(TimeLimit);
                    flag = 1;
                }
                    
            }
            else{
                string message = ((string)(5 - entrantsCount)) +" more participants needed to begin countdown!"; 
                llSay(0, message);
                llSetText(Text + "\n" + message, <0, 1.0, 0>,  1);
            }
        }        
    }
    
    timer()
    {            
        for (i=9; i > 0; i--){
            llSay(0, "Exploding in "+ (string)i);
            llSleep(1.0);
        }
        list payment = [];
        integer cut_pot = 0;
        float cut = 0;        
        cut = ownersCut/100;
        cut = cut * pot;   
        cut_pot = pot - (integer)cut;
        for (i=0; i< entrantsCount; i++){
            payment += min_pay;
            cut_pot -= min_pay;                                                       
        }
            
        integer j=0;
        integer value = 0;
        
        while (cut_pot > 0){
            j = RandInt(0, (entrantsCount - 1));
            integer rand;
            rand = RandInt(1, cut_pot);
            value = ((integer)llList2String(payment, j));
            value += rand;            
            //NOTE llOwnerSay("value: " + (string)value + "  j:" + (string)j); //just for debugging
            payment = llListReplaceList(payment, [value], j, j);            
            cut_pot -= rand;                               
        }
            
        //pot = cut_pot;        
        pot = 0;
        MakeParticles(); 
        for (i=0; i< entrantsCount; i++){
            llSleep(0.5);
            result = (integer)llList2String(payment, i);    
            llSay(0, llKey2Name((key)llList2String(entrantsKey, i)) + " just won L$" + (string)result +" from the sploder!"); 
            llGiveMoney((key)llList2String(entrantsKey, i), result);                                 
        } 
        
        llSleep(3.0);
        start();   
    }
    
    no_sensor()
    {
        pot += result;
        llSay(0, llKey2Name((key)llList2String(entrantsKey, i)) + " won nothing for being out of range!");        
    }    
    
    listen(integer channel, string name, key id, string message)
    {
        if(id == Admins){
            if (channel == 7){
                if (llToLower(message) == "reset"){
                    llResetScript();
                    /*NOTE
                    //gQueryID = llGetNotecardLine(gName, gLine);
                    //start();
                    NOTE */
                }
            }
        }
    }
}
