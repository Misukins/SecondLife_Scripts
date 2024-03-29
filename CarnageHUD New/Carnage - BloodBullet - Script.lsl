integer listenChannel   = -458790;
integer DynamicChannel()
{
    integer dyn;
    dyn = (integer)("0x" + llGetSubString((string)llDetectedKey(0),0,7));
    return dyn;
}

string WeaponType       = "bloodball";
string DamageType       = "bloodball";
string SubDamageType    = "sword";
string desc_          = "(c)Vanessa (meljonna Resident) - ";

particle()
{
    llParticleSystem([
        PSYS_PART_FLAGS, (0|256|1|2|16|32|64),
        PSYS_SRC_TARGET_KEY, llGetKey(),
        PSYS_PART_START_COLOR, <1.00000, 0.00000, 0.00000>,
        PSYS_PART_END_COLOR, <0.65000, 0.00000, 0.00000>,
        PSYS_PART_START_ALPHA, 0.300000,
        PSYS_PART_END_ALPHA, 0.000000,
        PSYS_PART_START_GLOW, 0.000000,
        PSYS_PART_END_GLOW, 0.000000,
        PSYS_PART_START_SCALE, <1.55000, 1.40000, 0.00000>,
        PSYS_PART_END_SCALE, <2.80000, 1.70000, 0.00000>,
        PSYS_PART_MAX_AGE, 4.000000,
        PSYS_SRC_ACCEL, <0.00000, 0.00000, 0.00000>,
        PSYS_SRC_PATTERN, 2,
        PSYS_SRC_TEXTURE, "447d0bd2-bad6-b7ac-352c-366ef7d02dff",
        PSYS_SRC_BURST_RATE, 1.000000,
        PSYS_SRC_BURST_PART_COUNT, 12,
        PSYS_SRC_BURST_RADIUS, 0.550000,
        PSYS_SRC_BURST_SPEED_MIN, 1.500000,
        PSYS_SRC_BURST_SPEED_MAX, 1.500000,
        PSYS_SRC_MAX_AGE, 0.000000,
        PSYS_SRC_OMEGA, <5.00000, 5.00000, 5.00000>,
        PSYS_SRC_ANGLE_BEGIN, 0.0*PI,
        PSYS_SRC_ANGLE_END, 0.0*PI
    ]);
}

default
{
    state_entry()
    {
        llSetObjectDesc(desc_);
        particle();
        llTargetOmega(<-20, 20, 20>, -0.4, -4.0);
        //llSetTimerEvent(5.0); //NOTE - closed for now 
    }
    
    on_rez(integer param)
    {
        particle();
        llTargetOmega(<-20, 20, 20>, -0.4, -4.0);
        //llSetDamage(5); //NOTE - wait what? why---
    }

    collision_start(integer num)
    {
        string struck = llDetectedName(0);
        string attacker = llKey2Name(llGetOwner());
        llShout(DynamicChannel(), DamageType + "," + attacker + "," + struck + "," + SubDamageType);
    }

    collision_end(integer num_detected)
    {
        llShout(listenChannel, "give_exp50");
    }
    
    timer()
    {
        //llDie(); //NOTE - closed for now 
    }
}

