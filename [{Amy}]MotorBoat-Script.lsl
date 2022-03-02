key BoatStartSound  = "fdda899b-28fa-271f-ccb0-b3cc1c4d0ad6";
key BoatIdleSound   = "42107f16-0281-7c31-0a26-8eff95202f51";
key BoatRunSound    = "32ae0d2b-535e-e9e0-634d-a31514e12128";

//1st Gear
float forward_power = 15;
//2nd Gear
float VERTICAL_THRUST  = 10;

float reverse_power = -5;
float turning_ratio = 5.0;

string sit_message = "Ride";
string not_owner_message = "You are not the owner of this vehicle ...";

vector sit_rot = <0.0, 0.0, 180.0>;
vector sit_pos = <1.0, 0, 0.25>;

default
{
    state_entry()
    {
        llSetSitText(sit_message);
        llSitTarget(sit_pos, llEuler2Rot(sit_rot*DEG_TO_RAD));
        llSetCameraEyeOffset(<-12, 0.0, 5.0>);
        llSetCameraAtOffset(<1.0, 0.0, 2.0>);
        llPreloadSound(BoatStartSound);
        llPreloadSound(BoatIdleSound);
        llPreloadSound(BoatRunSound);
        llSetVehicleFlags(0);
        llSetVehicleType(VEHICLE_TYPE_BOAT);
        llSetVehicleFlags(VEHICLE_FLAG_HOVER_UP_ONLY | VEHICLE_FLAG_HOVER_WATER_ONLY);
        llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <1, 1, 1> );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, 2 );
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0>);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.05);
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 1 );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 5 );
        llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 0.15);
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
        llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, ZERO_ROTATION );
    }

    changed(integer change)
    {
        if (change & CHANGED_LINK){
            key agent = llAvatarOnSitTarget();
            if (agent){
                if (agent != llGetOwner()){
                    llSay(0, not_owner_message);
                    llUnSit(agent);
                    llPushObject(agent, <0, 0, 50>, ZERO_VECTOR, FALSE);
                }
                else{
                    llTriggerSound(BoatStartSound, 1);
                    llMessageLinked(LINK_ALL_CHILDREN , 0, "start", NULL_KEY);
                    llSleep(.4);
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    llSleep(.1);
                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
                    llLoopSound(BoatIdleSound, 1);
                }
            }
            else{
                llStopSound();
                llSetStatus(STATUS_PHYSICS, FALSE);
                llSleep(.1);
                llMessageLinked(LINK_ALL_CHILDREN , 0, "stop", NULL_KEY);
                llSleep(.4);
                llReleaseControls();
                llTargetOmega(<0, 0, 0>, PI, 0);
                llResetScript();
            }
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm){
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | 
            CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, 
            TRUE, FALSE);
        }
    }

    control(key id, integer level, integer edge)
    {
        integer reverse = 1;
        vector angular_motor;
        vector vel = llGetVel();
        float speed = llVecMag(vel);
        if(level & CONTROL_FWD){
            llLoopSound(BoatRunSound, 1);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <-forward_power, 0, 0>);
            reverse = 1;
        }
        else
            llLoopSound(BoatIdleSound, 1);
        if(level & CONTROL_BACK){
            llLoopSound(BoatIdleSound, 1);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <-reverse_power, 0, 0>);
            reverse = -1;
        }
        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)){
            angular_motor.z -= speed / turning_ratio * reverse;
            angular_motor.x += 15;
        }
        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT)){
            angular_motor.z += speed / turning_ratio * reverse;
            angular_motor.x -= 15;
        }
        if(level & CONTROL_UP) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, VERTICAL_THRUST>);
        }
        else if(edge & CONTROL_UP) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0>);
        }
        if(level & CONTROL_DOWN) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, -VERTICAL_THRUST>);
            llSay(0, "1st Gear.");
        }
        else if(edge & CONTROL_DOWN) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0>);
            llSay(0, "2nd Gear.");
        }
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
    }
}