key passenger;
key driver;
key BoatStartSound  = "fdda899b-28fa-271f-ccb0-b3cc1c4d0ad6";
key BoatIdleSound   = "42107f16-0281-7c31-0a26-8eff95202f51";
key BoatRunSound    = "32ae0d2b-535e-e9e0-634d-a31514e12128";

float speed     = 0;
float lift      = 0.03;
float tilt      = 10;
float turn      = 0.5;
float turbo     = 0.02;
float volume    = 1.0;

integer turnnow = FALSE;
integer sit     = FALSE;
integer handle;
integer menuchan;

list MenuOwn    = [ "TODO", "TODO", "Help", "Exit" ]; //"Back",

string Bname;

vector angular_motor;
vector moving;
vector velocity     = <0,0,0>;
vector impulse;

menu(key id){
    llListenRemove(handle); 
    menuchan  = llRound(llFrand(13649725)) + 7;
    handle = llListen(menuchan, "", "", "");
    llDialog(id, Bname + " Options Menu.", MenuOwn, menuchan);
}

help(){
    llWhisper(0,"Key Actions:");
    llWhisper(0,"Right click and 'Ride' <-- Starts " + Bname);
    llWhisper(0,"Click STAND UP button <-- Stops " + Bname + " and returns contols");
    llWhisper(0,"W or Forward <-- Accelerates or goes faster forwards");
    llWhisper(0,"S or Backwards <-- Slows or goes faster backwards");
    llWhisper(0,"W or Forward & S or Backwards <-- Brakes or stops the " + Bname);
    llWhisper(0,"A or Left <-- Turns left");
    llWhisper(0,"D or Right <-- Turns right");
}

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        Bname=llGetObjectName();
        llWhisper(0,"Preparing " + Bname);
        llMessageLinked(LINK_ALL_CHILDREN, 0, "stop", NULL_KEY);
        llSetStatus(STATUS_PHYSICS, FALSE);
        llStopSound();
        llSetTimerEvent(0.0);
        velocity = <0, 0, 0>;
        turnnow = FALSE;
        llCollisionSound("", 0.0);
        vector input = <90.0, 180.0, 0.0> * DEG_TO_RAD;
        llSetSitText("Ride");
        llSetVehicleFlags(0);
        llSetVehicleType(VEHICLE_TYPE_BOAT);
        llSetVehicleFlags(VEHICLE_FLAG_HOVER_UP_ONLY |VEHICLE_FLAG_HOVER_WATER_ONLY);
        llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE,<1, 1, 1> );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, 2 );
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0>);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.05);
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 1 );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 5 );
        llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 0.01);
        llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY,.5 );
        llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, 2.0 );
        llSetVehicleFloatParam( VEHICLE_BUOYANCY, 1 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.5 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 3 );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.5 );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 10 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.5 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 2 );
        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1 );
        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 0.1 );
        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, .5 );
        llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, llEuler2Rot(<90, 0, 0> * DEG_TO_RAD ) );
        llWhisper(0,Bname + " is now ready to ride");
    }
    
    touch_start(integer total_number)
    {
        if (sit == TRUE)
            menu(llDetectedKey(0));
        else
            llWhisper(0,"Sorry you must be in the driver position to change any options.");
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if (sit==TRUE){
            if (msg == "Help"){
                help();
                return;
            }
            if (msg == "Exit"){
                return;
            }
            if (msg == "Back"){
                menu(id);
                return;
            }
        }
        else
            llWhisper(0,"Sorry you must be in the driver position to change any options.");
        menu(llDetectedKey(0));
    }
    
    changed(integer change)
    {
        if (change & CHANGED_LINK){
            key id = llDetectedKey(0);
            driver = llAvatarOnSitTarget();
            integer sameGroup = llSameGroup(id);
            if (driver){
                if (sameGroup)
                    llSetTimerEvent(0.1);
                else{
                    llSetTimerEvent(0.0);
                    llMessageLinked(LINK_ALL_CHILDREN, 0, "stop", NULL_KEY);
                    llSetStatus(STATUS_PHYSICS, FALSE);
                    llReleaseControls();
                    llStopSound();
                    sit = FALSE;
                    llPushObject(llDetectedKey(0), <0,0,10>, ZERO_VECTOR, FALSE);
                    llWhisper(0,"Sorry, No Permission.(Wrong Active Group?)");
                }
            }
        }
    }
    
    run_time_permissions(integer perm)
    {
        if (perm){
            sit = TRUE;
            speed = 0;
            llTakeControls(
                CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT
                | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_UP
                | CONTROL_DOWN, TRUE, FALSE);
        }
        
    }
    
    control(key id, integer level, integer edge)
    {
        if(level & CONTROL_FWD){
            if(velocity.x < 100){
                velocity.x += (turbo * 1);
                speed = 0;
            }
            else{
                if(speed < 35)
                    speed += 0.5;
                else
                    speed += 0.1;
            }
        }

        if(level & CONTROL_BACK){
            if(velocity.x > 0){
                velocity.x -= turbo;
            }
            else{
                velocity.x = 0;
                speed = 0;
            }
            if(speed > -15 && velocity.x < 1){
                speed -= 0.3;
            }
        }

        if((level & CONTROL_BACK) && (level & CONTROL_FWD)){
            speed = 0;
            velocity = <0,0,0>;
        }
        
        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)){
            turnnow = TRUE;
            angular_motor.x += tilt;
            angular_motor.z -= turn;
        }

        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT)){
            turnnow = TRUE;
            angular_motor.x -= tilt;
            angular_motor.z += turn;
        }

        if(edge & CONTROL_UP){
            //TODO
        }

        if(edge & CONTROL_DOWN){
            //TODO
        }
    }

    timer()
    {
        if (sit==FALSE){
            llSetStatus(STATUS_PHYSICS, TRUE);
            llRequestPermissions(driver,PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
            llLoopSoundMaster("Ducati Idle",volume);
            llMessageLinked(LINK_ALL_CHILDREN, 0, "start", NULL_KEY);
        }
        else if(sit){
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, ZERO_VECTOR);
            if(turnnow){
                llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
                angular_motor = ZERO_VECTOR;
                turnnow = FALSE;
            }
            if((velocity.x > 9) || (speed > 1))
                llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, <0, lift, 0, 1> );
            else
                llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, <0, 0, 0, 1> );
            llApplyImpulse( velocity, TRUE );
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <speed,0,0>);
            moving=llGetVel();
            float total = llVecMag(moving);
            if (total < 0.1){
                llLoopSound("Ducati Idle",volume);
                llMessageLinked(LINK_ALL_CHILDREN, 0, "stop", NULL_KEY);
            }
            else if (total < 0.3){
                llMessageLinked(LINK_ALL_CHILDREN, 0, "start", NULL_KEY);
                llPlaySound("D0",volume);
            }
            else if (total < 0.6)
                llPlaySound("D1",volume);
            else if (total < 0.9)
                llPlaySound("D2",volume);
            else if (total < 0.12)
                llPlaySound("D3",volume);
            else if (total < 0.15)
                llPlaySound("D4",volume);
            else if (total < 0.18)
                llPlaySound("D5",volume);
            else if (total > 0.17)
               llPlaySound("D6",volume);
        }
    }
}
