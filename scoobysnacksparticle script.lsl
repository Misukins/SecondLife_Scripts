SpawnParticles(){
    llParticleSystem(
    [
        PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE,
        PSYS_SRC_BURST_RADIUS,0,
        PSYS_SRC_ANGLE_BEGIN,0,
        PSYS_SRC_ANGLE_END,0,
        PSYS_SRC_TARGET_KEY,llGetKey(),
        PSYS_PART_START_COLOR,<1.000000,1.000000,1.000000>,
        PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
        PSYS_PART_START_ALPHA,1,
        PSYS_PART_END_ALPHA,1,
        PSYS_PART_START_GLOW,0.01,
        PSYS_PART_END_GLOW,0.05,
        PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
        PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
        PSYS_PART_START_SCALE,<0.050000,0.050000,0.000000>,
        PSYS_PART_END_SCALE,<0.500000,0.500000,0.000000>,
        PSYS_SRC_TEXTURE,"04ee22f6-17fb-4342-a2e1-04a5d3171f6a",
        PSYS_SRC_MAX_AGE,0,
        PSYS_PART_MAX_AGE,5,
        PSYS_SRC_BURST_RATE,0.1,
        PSYS_SRC_BURST_PART_COUNT,1,
        PSYS_SRC_ACCEL,<0.000000,0.000000,0.000000>,
        PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
        PSYS_SRC_BURST_SPEED_MIN,0.5,
        PSYS_SRC_BURST_SPEED_MAX,0.1,
        PSYS_PART_FLAGS,
            0 |
            PSYS_PART_BOUNCE_MASK |
            PSYS_PART_EMISSIVE_MASK |
            PSYS_PART_WIND_MASK
    ]);
    llSetTimerEvent(20);
}

PauseParticles(){
    llParticleSystem([]);
    llSleep(120.0);
    SpawnParticles();
}

default
{
    state_entry()
    {
        SpawnParticles();
        llSetTimerEvent(20);
    }
    
    timer()
    {
        PauseParticles();
    }
}
