string boatName="Kenzi's Keelboat (Mecca) ";
string versionNumber="1-00-0";

integer CONTROLS_MODULE=1;
integer SAIL_MODULE=2;

vector wind;
float windAngle;
float absWindAngle;
float seaLevel;

vector eulerRot;
vector currEuler;
rotation quatRot;
rotation currRot;

float zRotAngle;
vector fwdVec;
vector upVec;
vector leftVec;
float compass;

float heelAngle;
float heelTorque;
float heelAdd;

float currSpeed;
vector groundSpeed=ZERO_VECTOR;
float spdFactor=0.0;
float leeway;

float rotSpeed;
float rotDelta;
vector eulerTurnLeft;
vector eulerTurnRight;
rotation quatTurnLeft=ZERO_ROTATION;
rotation quatTurnRight=ZERO_ROTATION;

integer sailingAngle;
integer currBoomAngle=0;
integer delta;
integer incr;
float optBoomAngle;
float trimFactor;

integer spinAngle;
integer spindelta;
integer currSpinAngle=0;
integer SPIN_UP=FALSE;
integer CurJib;
integer CurSpin;
string Tack;

float timerFreq=1.0;
integer sheetAngle=5;
float maxWindSpeed=6.0;

key avatar;
integer lock=FALSE;
integer SAIL_UP=FALSE;
integer FLAG_UP=FALSE;
integer permSet=FALSE;
integer HUD_ON=TRUE;
string idStr;
integer numTouches=0;
integer sailing=TRUE;
float mpsToKts=1.944;
float convert=1.944;
string units=" Kts.";
integer showKnots=TRUE;
float time;
float offset;
float theta;
integer msgTypeModeChange=40001;
integer modeWind=0;
string helpString;
string visualAid;
vector hudcolour;
string currentString;
integer ADV_HUD=FALSE;

integer JIB;
integer SAIL;
integer BOOM;
integer HUD;
integer CREWMAN;
integer CREWMAN1;
integer POLE;
integer SPINNAKER;
integer FLAG;

float ironsAngle=31;
float slowingFactor=0.7;
float leewayTweak=1.50;
float rotTweak=0.8;
float speedTweak=1.0;

vector tmpwind;
float truewindDir;
float truewindSpeed;
float truewindAngle;
float appwindSpeed;
float appwindAngle;

float windDir=0;
string windRose="East ";
string windType="15 Knots";

float windSpeed=7.75;
float maxSpeed=5.5;
float heelTweak=0.85;

integer realAngle2LslAngle(integer realAngle){
    integer lslAngle= (realAngle-90)*-1; 
    while(lslAngle>=360) lslAngle-=360; 
    while(lslAngle<0) lslAngle+=360; 
    return lslAngle; 
}

calcTrueWindAngle(){
    currRot=llGetRot(); 
    currEuler=llRot2Euler(currRot); 
    zRotAngle=currEuler.z;
    leftVec=llRot2Left(currRot); 
    truewindAngle=windDir-zRotAngle; 
    while (truewindAngle>PI) truewindAngle-=TWO_PI; 
    while (truewindAngle<-PI) truewindAngle+=TWO_PI;
    if ((truewindAngle) < 0)
        truewindAngle = truewindAngle * -1;
}

calcAppWindAngle(){
    currRot=llGetRot(); 
    currEuler=llRot2Euler(currRot); 
    zRotAngle=currEuler.z;
    leftVec=llRot2Left(currRot); 
    windAngle=windDir-zRotAngle;
    while (windAngle>PI) windAngle-=TWO_PI;
    while (windAngle<-PI) windAngle+=TWO_PI;
    vector boatMovement=<currSpeed*llCos(currEuler.z),currSpeed*llSin(currEuler.z),0>;
    tmpwind=wind+boatMovement;
    float spd=llVecMag(llGetVel());
    appwindAngle=llAtan2(windSpeed*llSin(windAngle),(windSpeed*llCos(windAngle)+spd));
    while (appwindAngle>PI) spd=-spd;
    while (appwindAngle<-PI) spd=-spd;
    appwindSpeed=spd*llCos(llFabs(windAngle))-windSpeed*llCos(windAngle);
    if ((appwindSpeed) < 0)
        appwindSpeed = appwindSpeed * -1;
    if ((appwindSpeed) > 3)
        appwindSpeed = appwindSpeed -(TWO_PI-1.0);
    if ((appwindAngle) < 0)
        appwindAngle = appwindAngle * -1;
}

calcHeelAngle(){
    heelAngle=llAsin(leftVec.z);
    if (SAIL_UP)
        if (llFabs(windAngle+sailingAngle)>3*DEG_TO_RAD)
            heelTorque=SAIL_UP*llSin(windAngle)*llCos(heelAngle)*PI_BY_TWO*(windSpeed/maxWindSpeed)*llCos(sailingAngle*DEG_TO_RAD)*heelTweak;
        else
            heelTorque=0;
    else
        heelTorque=0;
    heelAdd=heelTorque-heelAngle;
    eulerRot=<heelAdd,0,0>;
    quatRot=llEuler2Rot(eulerRot);
}

calcBoomDelta(){
    if (sheetAngle<=0) sheetAngle=5;
    if (sheetAngle>=79) sheetAngle=79;
    sailingAngle=sheetAngle;
    if (sailingAngle>llFabs(windAngle*RAD_TO_DEG)) sailingAngle=llRound(llFabs(windAngle*RAD_TO_DEG));
    if (windAngle<0) sailingAngle*=-1;
    delta=sailingAngle-currBoomAngle;
    currBoomAngle=sailingAngle;
    if (currBoomAngle < 0) Tack="Starb'd";
    if (currBoomAngle > 0) Tack="Port";
    currBoomAngle=sailingAngle;
    llMessageLinked(SAIL,delta,"",NULL_KEY);
    llMessageLinked(JIB,delta,"",NULL_KEY);
    llMessageLinked(BOOM,delta,"",NULL_KEY);
}

calcSpeed(){
    groundSpeed=llGetVel();
    absWindAngle=llFabs(windAngle);
    if (llFabs(absWindAngle*RAD_TO_DEG-llFabs(sailingAngle))<10)
        trimFactor=0;
    else{
        optBoomAngle=0.5*absWindAngle*RAD_TO_DEG;
        trimFactor=(90.-llFabs(optBoomAngle-llFabs(sailingAngle)))/90.;
    }
    if (appwindAngle<ironsAngle*DEG_TO_RAD)
        currSpeed*=slowingFactor;
    else{
        if (SAIL_UP)
            currSpeed=speedTweak*(llSin(llFabs(windAngle)/2)+llCos(llFabs(windAngle)/2.75) - 0.75)*windSpeed*trimFactor;
        else 
            currSpeed*=0.8;
    }
}

calcLeeway(){
    leeway=SAIL_UP*-llSin(appwindAngle)*llSin(heelAngle)*windSpeed*leewayTweak;
}

calcTurnRate(){
    spdFactor=llVecMag(groundSpeed)/(maxSpeed);
    rotSpeed=0.5+(spdFactor)/2.0;
}

getLinkNums(){
    integer i;
    integer linkcount=llGetNumberOfPrims();  
    for (i=1;i<=linkcount;++i){
        string str=llGetLinkName(i);
        if (str=="jib") JIB=i;
        if (str=="sail") SAIL=i;
        if (str=="boom") BOOM=i;
        if (str=="pole") POLE=i;
        if (str=="spinnaker") SPINNAKER=i;
        if (str=="hud") HUD=i;
    }
}

raiseSail(){
    SAIL_UP=TRUE;
    llWhisper(0, "Ready to sail... ");
    llMessageLinked(SAIL,1002,"",NULL_KEY);
    llMessageLinked(JIB,1002,"",NULL_KEY);
    llMessageLinked(BOOM,1002,"",NULL_KEY);
    llMessageLinked(CREWMAN,1000,"",NULL_KEY);
    llMessageLinked(CREWMAN1,1000,"",NULL_KEY);
    llSetTimerEvent(timerFreq);
    llLoopSound("sailing", 1.0);       

}

lowerSail(){
    llWhisper(0, "Lowering sails... ");
    llMessageLinked(SAIL,1000,"",NULL_KEY);
    llMessageLinked(JIB,1000,"",NULL_KEY);
    llMessageLinked(BOOM,1000,"",NULL_KEY);
    llMessageLinked(POLE,1000,"",NULL_KEY);
    llMessageLinked(SPINNAKER,1000,"",NULL_KEY);
    sailingAngle = 0;
    llStopSound();
    llMessageLinked(LINK_ALL_CHILDREN , 0, "stop", NULL_KEY);
    currBoomAngle=0;
    sheetAngle=5;
    SAIL_UP=FALSE; 
    llSetObjectDesc ("Kenzi's Keelboat (Mecca)");
}

HoistSpin(){
    if ((sheetAngle > 50)){
        llWhisper(0, "Hoisting Spinnaker");
        llMessageLinked(SPINNAKER,1002,"",NULL_KEY);
        if (-sailingAngle > 0) llMessageLinked(POLE,1002,"",NULL_KEY);
        if (-sailingAngle < 0) llMessageLinked(POLE,1004,"",NULL_KEY);
        llMessageLinked(JIB,1001,"",NULL_KEY);
        SPIN_UP=TRUE;
        CurJib=0;
    }
    if ((sheetAngle < 50))
        llWhisper(0, "Sheet too close to Hoist Spin");
}

DropSpin(){
    llWhisper(0, "Dropping Spinnaker");
    llMessageLinked(SPINNAKER,1000,"",NULL_KEY);
    llMessageLinked(POLE,1000,"",NULL_KEY);
    llMessageLinked(JIB,1002,"",NULL_KEY);
    CurSpin=0;
    CurJib=0;
    currSpinAngle=0;
    spinAngle=0;
    SPIN_UP=FALSE;
}

TrimSpinPlus(){
    if (CurSpin < 37){
        llMessageLinked(SPINNAKER,(delta+3),"",NULL_KEY);
        llMessageLinked(POLE,(delta+3),"",NULL_KEY);
        CurSpin=CurSpin+3;
    } 
    
}

TrimSpinMinus(){
    if (CurSpin > -37){
        llMessageLinked(SPINNAKER,(delta-3),"",NULL_KEY);
        llMessageLinked(POLE,(delta-3),"",NULL_KEY);
        CurSpin=CurSpin-3;
    }
}

setVehicleParams(){
    llSetVehicleType         (VEHICLE_TYPE_BOAT);
    llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME,ZERO_ROTATION);
    llSetVehicleFlags        (VEHICLE_FLAG_NO_DEFLECTION_UP|VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT|VEHICLE_FLAG_LIMIT_MOTOR_UP ); 
    llSetVehicleVectorParam  (VEHICLE_LINEAR_FRICTION_TIMESCALE,<50.0,2.0,0.5>);;
    llSetVehicleVectorParam  (VEHICLE_LINEAR_MOTOR_DIRECTION,ZERO_VECTOR);
    llSetVehicleFloatParam   (VEHICLE_LINEAR_MOTOR_TIMESCALE,10.0);
    llSetVehicleFloatParam   (VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE,60);
    llSetVehicleFloatParam   (VEHICLE_LINEAR_DEFLECTION_EFFICIENCY,0.85);
    llSetVehicleFloatParam   (VEHICLE_LINEAR_DEFLECTION_TIMESCALE,1.0); 
    llSetVehicleVectorParam  (VEHICLE_ANGULAR_FRICTION_TIMESCALE,<5,0.1,0.1>);
    llSetVehicleVectorParam  (VEHICLE_ANGULAR_MOTOR_DIRECTION,ZERO_VECTOR);
    llSetVehicleFloatParam   (VEHICLE_ANGULAR_MOTOR_TIMESCALE,0.1);
    llSetVehicleFloatParam   (VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE,3);
    llSetVehicleFloatParam   (VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY,1.0);
    llSetVehicleFloatParam   (VEHICLE_ANGULAR_DEFLECTION_TIMESCALE,1.0);
    llSetVehicleFloatParam   (VEHICLE_VERTICAL_ATTRACTION_TIMESCALE,3.0);
    llSetVehicleFloatParam   (VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY,0.8);
    llSetVehicleFloatParam   (VEHICLE_BANKING_EFFICIENCY,0.0);
    llSetVehicleFloatParam   (VEHICLE_BANKING_MIX,1.0);
    llSetVehicleFloatParam   (VEHICLE_BANKING_TIMESCALE,1.2);
    llSetVehicleFloatParam   (VEHICLE_HOVER_HEIGHT,seaLevel);
    llSetVehicleFloatParam   (VEHICLE_HOVER_EFFICIENCY,2.0);
    llSetVehicleFloatParam   (VEHICLE_HOVER_TIMESCALE,1.0);
    llSetVehicleFloatParam   (VEHICLE_BUOYANCY,1.0);
}

setCamera(){
    llSetCameraEyeOffset(<-5.4,0.0,1.4>);
    llSetCameraAtOffset(<3.0,0.0,1.0>);
}

setInitialPosition(){
    vector pos = llGetPos();
    float groundHeight = llGround(ZERO_VECTOR);
    float waterHeight = llWater(ZERO_VECTOR);
    seaLevel = llWater(ZERO_VECTOR);
    upright();
    if (groundHeight <= waterHeight){
        pos.z = waterHeight + 0.1;
        while (llVecDist(llGetPos(),pos)>.001) llSetPos(pos);
    }
}

setSitTarget(){
    llSetSitText("Sail !");
    llSetText("",ZERO_VECTOR,1.0);
}

upright(){
    currRot=llGetRot();
    currEuler=llRot2Euler(currRot);
    leftVec=llRot2Left(currRot);
    heelAngle=llAsin(leftVec.z);
    eulerRot=<-heelAngle,0,0>;
    quatRot=llEuler2Rot(eulerRot);
    llRotLookAt(quatRot*currRot,0.2,0.2);
}

moor(){
    llMessageLinked(LINK_THIS,SAIL_MODULE,"moor",NULL_KEY);{
        llSetTimerEvent(timerFreq);
        sailing=TRUE;
    }
    llWhisper(0, "Mooring.");
    upright();
    llReleaseControls();
    llSetStatus(STATUS_PHYSICS,TRUE);
    llSetTimerEvent(0);
    currSpeed=0;
}

startup(){
    llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Z | STATUS_ROTATE_Y,TRUE);
    llSetStatus(STATUS_PHYSICS,FALSE);
    llSetStatus(STATUS_PHANTOM,FALSE);
    llSetStatus(STATUS_BLOCK_GRAB,TRUE);
    llSetTimerEvent(0);
    setInitialPosition();
    setVehicleParams();
    setSitTarget();
    getLinkNums();                               
    llMessageLinked(SAIL,1000,"",NULL_KEY);
    llMessageLinked(JIB,1000,"",NULL_KEY);
    llMessageLinked(BOOM,1000,"",NULL_KEY);
    llMessageLinked(POLE,1000,"",NULL_KEY);
    llMessageLinked(SPINNAKER,1000,"",NULL_KEY);
    setCamera();
    currSpeed=0;
    llListen(0,"",avatar,"");
    llMessageLinked(LINK_ALL_CHILDREN , 0, "stop", NULL_KEY);
}

updateHUD()
{
    string dataString;
    float compass=PI_BY_TWO-zRotAngle;
    float effcoeff;
    string rgn = llGetRegionName();
    string blank = " ";
    float efficiency;
    string ratio;
    float derivatesheetAngle=sheetAngle;
    if (Tack=="Starb'd")
        derivatesheetAngle+=(CurSpin/3);
    if (Tack=="Port")
        derivatesheetAngle-=(CurSpin/3);
    efficiency = appwindAngle*RAD_TO_DEG/derivatesheetAngle;
    if ((efficiency) < 0)
        efficiency = efficiency * -1;
    compass=PI_BY_TWO-zRotAngle;
    while (compass<0) compass+=TWO_PI;
    dataString = " ";
    currentString = " ";
    float hudcompass =((integer)(compass*RAD_TO_DEG));
    string huddirection;
    if ((hudcompass) <= 360)
        huddirection="North";
    if ((hudcompass) <= 315)
        huddirection="Northwest";
    if ((hudcompass) <= 275)
        huddirection="West";
    if ((hudcompass) <= 230)
        huddirection="Southwest";
    if ((hudcompass) <= 185)
        huddirection="South";
    if ((hudcompass) <= 140)
        huddirection="SouthEeast";
    if ((hudcompass) <= 95)
        huddirection="East";
    if ((hudcompass) <= 50)
        huddirection="Northeast";
    if ((hudcompass) <= 5)
        huddirection="North";
    if (ADV_HUD==FALSE){
        if ((efficiency) < 0)
            efficiency = efficiency * -1;
        ratio = llGetSubString ((string)efficiency, 0, 3);   
        vector hudcolour=<1.0,1.0,1.0>;
        dataString+="-> "+huddirection+" ";
        dataString+="( " +(string)((integer)(compass*RAD_TO_DEG))+"° )\n ";    
        dataString+="| "+visualAid+" | Speed "+llGetSubString((string)(llVecMag(groundSpeed*convert)),0,3)+units+"\n";
        dataString+=(windType)+" "+(windRose)+"Wind\n";
        dataString+=blank+"\n";
        dataString+=blank+"\n";
    }
    if (ADV_HUD==TRUE){
        if ((efficiency) < 0)
            efficiency = efficiency * -1;
        vector hudcolour=<1.0,1.0,1.0>;
        dataString+="-> "+huddirection+" ";
        dataString+="( " +(string)((integer)(compass*RAD_TO_DEG))+"° )\n ";         
        dataString+="| "+visualAid+" | Speed "+llGetSubString((string)(llVecMag(groundSpeed*convert)),0,3)+units+" - ";
        dataString+=(windType)+" "+(windRose)+"Wind\n";
        dataString+="True Wind Angle " +(string)((integer)(truewindAngle*RAD_TO_DEG))+"° - ";
        dataString+="App. Wind Angle " +(string)((integer)(appwindAngle*RAD_TO_DEG))+"°\n";
        ratio = llGetSubString ((string)efficiency, 0, 3);
        dataString+="Wind/Sheet ratio " +ratio+ " - Sheet Angle "+((string)(sheetAngle))+"°\n";
        dataString+=blank+"\n";
        dataString+=blank+"\n";
    }
    if ((efficiency) < 25.0){
        hudcolour=<0.0,1.0,1.0>;
        dataString==currentString;
        visualAid="<>";
        speedTweak=0.3;
    }
    if ((efficiency) < 2.5){
        hudcolour=<0.0,1.0,0.0>;
        dataString==currentString;
        visualAid="=";
        speedTweak=1.0;
        if (SPIN_UP==TRUE){
            if ((sheetAngle < 65))
                speedTweak+=0.3;
            if ((sheetAngle > 65))
                speedTweak+=0.0;
            if ((sheetAngle < 50)){
                speedTweak-=1.0;
                if (speedTweak < 0)
                    speedTweak = 0.00001;
            }
        }  
    }
    if ((efficiency) < 1.7){
        hudcolour=<1.0,1.0,0.0>;
        dataString==currentString;
        visualAid="><";
        speedTweak=0.7;
    }
    if ((efficiency) < 1.2){
        hudcolour=<1.0,0.0,0.0>;
        dataString==currentString;
        visualAid=">><<";
        speedTweak=0.3;
    }
    llSetText(dataString,hudcolour,1.0);
    currentString == dataString;
}

default
{
    state_entry()
    {
        getLinkNums();
        llSetText("",ZERO_VECTOR,1.0);
        startup();
        llSetStatus(STATUS_BLOCK_GRAB,TRUE);
    }

    on_rez(integer param)
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        avatar = llAvatarOnSitTarget();
        if (change & CHANGED_LINK){
            if (avatar == NULL_KEY){
                if (!(llGetAgentInfo(avatar) & AGENT_ON_OBJECT)){
                    if (SAIL_UP)
                        lowerSail();
                    if (permSet)
                        llReleaseControls();
                    permSet=FALSE;
                    llMessageLinked(LINK_SET, 70400, "", NULL_KEY);
                    llSetTimerEvent(600);
                }
           }
           else{
                llWhisper(0,"Say raise to start sailing, help for sailing commands...");
                llWhisper(0,"System defaults to East Wind, 15 Knots...");
                if (llAvatarOnSitTarget() == avatar)
                    llRequestPermissions(avatar,PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
            }
        }
    }    

    run_time_permissions(integer perms)
    {
        if (perms & (PERMISSION_TAKE_CONTROLS)){
            llTakeControls(CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT |
            CONTROL_ROT_LEFT | CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP,TRUE,FALSE);
            permSet=TRUE;
            llMessageLinked(LINK_SET, 70400, "", avatar); 
        }
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (channel==0){
            if (avatar == id & llAvatarOnSitTarget() == avatar){
                if (llGetAgentInfo(avatar) & AGENT_ON_OBJECT){
                    if (llGetSubString(msg,0,4)=="sheet"){
                        incr=(integer)llDeleteSubString(msg,0,4);
                        sheetAngle+=incr;
                        if (sheetAngle>90)
                            sheetAngle=90;
                    }
                    else if (msg=="raise" | msg=="r" ){
                        llMessageLinked(LINK_ALL_CHILDREN , 0, "start", NULL_KEY);
                        sailing=TRUE;
                        if (!permSet)
                            llRequestPermissions(avatar,PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                        permSet=TRUE;
                        llSetStatus(STATUS_PHYSICS,TRUE);
                        raiseSail();
                        llSetTimerEvent(timerFreq);
                    }
                    else if (msg=="spin" | msg=="s" && SPIN_UP)
                        DropSpin();
                    else if (msg=="spin" | msg=="s" && !SPIN_UP)
                        HoistSpin();
                    else if (msg=="spin+")
                        TrimSpinPlus();
                    else if (msg=="spin-")
                        TrimSpinMinus();
                    else if (msg=="gybe" | msg=="g" ){
                        if (SPIN_UP==TRUE){
                            llMessageLinked(SPINNAKER,1004,"",NULL_KEY);
                            if (-sailingAngle > 0) llMessageLinked(POLE,1003,"",NULL_KEY);
                            if (-sailingAngle < 0) llMessageLinked(POLE,1004,"",NULL_KEY);
                            CurSpin=0;
                        }
                    }
                    else if (msg=="lower" | msg=="l" )
                        lowerSail();
                    else if (msg=="moor" | msg=="m" ){
                        llMessageLinked(LINK_ALL_CHILDREN , 0, "stop", NULL_KEY);
                        moor();
                        llSetTimerEvent(0);
                        if (SAIL_UP)
                            lowerSail();
                    }
                }
            }
            if (lock==FALSE){
                if (msg=="n"){
                    windRose ="North ";
                    windDir=(90*DEG_TO_RAD);
                    llWhisper(0,"Wind now blowing from North");
                }
                if (msg=="nw"){
                    windRose ="Northwest ";
                    windDir=(135*DEG_TO_RAD);
                    llWhisper(0,"Wind now blowing from Northwest");
                }
                if (msg=="ne"){
                    windRose ="Northeast ";
                    windDir=(45*DEG_TO_RAD);
                    llWhisper(0,"Wind now blowing from Northeast");
                }
                if (msg=="e"){
                    windRose ="East ";
                    windDir=(0*DEG_TO_RAD);
                    llWhisper(0,"Wind now blowing from East");
                }
                if (msg=="s"){
                    windRose ="South ";
                    windDir=(270*DEG_TO_RAD);
                    llWhisper(0,"Wind now blowing from South");
                }
                if (msg=="sw"){
                    windRose ="Southwest ";
                    windDir=(225*DEG_TO_RAD);
                    llWhisper(0,"Wind now blowing from Southwest");
                }
                if (msg=="se"){
                    windRose ="Southeast ";
                    windDir=(315*DEG_TO_RAD);
                    llWhisper(0,"Wind now blowing from Southeast");
                }
                if (msg=="w"){
                    windRose ="West ";
                    windDir=(180*DEG_TO_RAD);;
                    llWhisper(0,"Wind now blowing from West");   
                }
                if (msg=="8"){
                    windSpeed=4.12;              
                    maxSpeed=4.0;
                    heelTweak=0.7;
                    llWhisper(0,"Wind speed set to 8 Knots");
                    windType="8 Knots";
                }
                if (msg=="11"){
                    windSpeed=5.70;
                    maxSpeed=4.5;
                    heelTweak=0.8;
                    llWhisper(0,"Wind speed set to 11 Knots");
                    windType="11 Knots";
                }
                if (msg=="15"){
                    windSpeed=7.75;
                    maxSpeed=5.5;
                    heelTweak=0.85;
                    llWhisper(0,"Wind speed set to 15 Knots");
                    windType="15 Knots";
                }
                if (msg=="18"){
                    windSpeed=9.30;
                    maxSpeed=6.5;
                    heelTweak=0.95;
                    llWhisper(0,"Wind speed set to 18 Knots");
                     windType="18 Knots";
                }
                if (msg=="21"){
                    windSpeed=9.5;
                    maxSpeed=7.0;
                    heelTweak=1.0;
                    llWhisper(0,"Wind speed set to 21 Knots");
                    windType="21 Knots";
                }
                if (msg=="25"){
                    windSpeed=11.3;
                    maxSpeed=7.5;
                    heelTweak=1.1;
                    llWhisper(0,"Wind speed set to 25 Knots");
                    windType="25 Knots";
                }
            }
            if (msg=="help"){
                helpString = " ";
                helpString+="SAY IN CHAT...\n";
                helpString+="------------------------------------------------------------------------------------------------\n";
                helpString+="raise - start sailing\n";
                helpString+="lower - lower sails (press arrow keys to move around)\n";
                helpString+="moor - stop sailing\n";
                helpString+="------------------------------------------------------------------------------------------------\n";
                helpString+="n,s,e,w,nw,ne,sw,se - set Wind direction\n";
                helpString+="8,11,15,18,21,25 - set Wind speed\n";
                helpString+="hud - hud switch (standard/advanced)\n";
                helpString+="spin - hoist/drop Spinnaker (press PgUp & PgDn to trim)\n";
                helpString+="gybe - gybe Spinnaker's pole upon tack\n";
                helpString+="------------------------------------------------------------------------------------------------\n";
                helpString+="HUD colour shows trim settings :\n";
                helpString+="|>><<| red = too loose - |><| yellow = off optimum - \n";
                helpString+="|=| green = optimum - |<>| cyan = too tight\n";
                helpString+="------------------------------------------------------------------------------------------------\n";
                llWhisper(0,helpString);
            }
            else if (msg=="hud" && ADV_HUD)
                ADV_HUD=FALSE;
            else if (msg=="hud" && !ADV_HUD)
                ADV_HUD=TRUE;
        }
    }    
    
    control(key id, integer held, integer change)
    {
        if ( (change & held & CONTROL_LEFT) || (held & CONTROL_LEFT) || (change & held & CONTROL_ROT_LEFT) || (held & CONTROL_ROT_LEFT) ){
            if (sailing)
                llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<rotSpeed/2.0,0.0,rotSpeed>);
            else
                llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<-rotSpeed,0.0,rotSpeed/1.5>);
        }
        else if ( (change & held & CONTROL_RIGHT) || (held & CONTROL_RIGHT) || (change & held & CONTROL_ROT_RIGHT) || (held & CONTROL_ROT_RIGHT) ){
            if (sailing)
                llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<-rotSpeed/2.0,0.0,-rotSpeed>);
            else
                llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<rotSpeed,0.0,-rotSpeed/1.5>);
        }
        else if ( (change & ~held & CONTROL_LEFT) || (change & ~held & CONTROL_ROT_LEFT) )
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<0.0,0.0,0.0>);
        else if ( (change & ~held & CONTROL_RIGHT) || (change & ~held & CONTROL_ROT_RIGHT) )
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<0.0,0.0,0.0>);
        if ( (held & CONTROL_FWD) && (held & CONTROL_UP) ){
            if (sailing){
                sheetAngle+=7;
                if (sheetAngle>90)
                    sheetAngle=90;     
            }
            else
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<5.0,0.0,0.0>);
        }
        else if ( (held & CONTROL_FWD) || (change & held & CONTROL_FWD) ){
            if (sailing){
                sheetAngle+=2;
                if (sheetAngle>90)
                    sheetAngle=90;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<5.0,0.0,0.0>);
            }
            else
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<5.0,0.0,0.0>);
        }
        else if ( (held & CONTROL_BACK) && (held & CONTROL_UP) ){
            if (sailing){
                sheetAngle-=7;
                if (sheetAngle<5)
                    sheetAngle=5;   
            }
            else{
                currSpeed-=0.3;
                if (currSpeed<-2)
                    currSpeed=-2;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<currSpeed,0,0>);
            }
        }
        else if ( (held & CONTROL_BACK) || (change & held & CONTROL_BACK) ){
            if (sailing){
                sheetAngle-=2;
                if (sheetAngle<5)
                    sheetAngle=5;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<-5.0,0.0,0.0>);           
            }
            else{
                currSpeed-=0.3;
                if (currSpeed<-2)
                    currSpeed=-2;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<currSpeed,0,0>);
            }
        }
        else if (change & held & CONTROL_UP){
            if (sailing)
                TrimSpinPlus();
            else
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<5.0,0.0,0.0>);
        }
        else if (change & held & CONTROL_DOWN){
            if (sailing)
                TrimSpinMinus();
            else
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<-5.0,0.0,0.0>);
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "deleteMe")
            llDie();
    }
    
    timer()
    {
        calcTrueWindAngle();
        calcAppWindAngle();
        if (SAIL_UP)
            calcBoomDelta();
        calcHeelAngle();
        calcSpeed();
        calcLeeway();
        calcTurnRate();
        if (HUD_ON)
            updateHUD();
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<currSpeed,leeway,0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<heelTorque,0.0,0.0>);
        if (!(llGetAgentInfo(avatar) & AGENT_ON_OBJECT))
            llMessageLinked(LINK_ROOT, 0, "deleteMe", NULL_KEY);
    }
}
