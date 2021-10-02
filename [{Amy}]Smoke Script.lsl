key texture = "5de058da-95f0-2736-b0e0-e218184ddece";   // whispy smoke

float age = 16.0;                    // particle lifetime
float rate = 0.5;                    // particle burst rate
integer count = 3;                   // particle count
vector startColor = <0.5, 0.5, 0.5>; // particle start color
vector endColor = <0.5, 0.5, 0.5>;   // particle end color
float startAlpha = 1.0;              // particle start alpha
float endAlpha = 0.0;                // particle end alpha
vector startScale = <0.1, 0.1, 0>;   // particle start size (100%)
vector endScale = <4, 4, 0>;         // particle end size (100%)
float minSpeed = 0.0;                // particle min. burst speed (100%)
float maxSpeed = 0.1;                // particle max. burst speed (100%)
float burstRadius = 0.1;             // particle burst radius (100%)
vector partAccel = <0, 0, 0.2>;      // particle accelleration (100%)

default
{
    state_entry()
    {
        llParticleSystem([
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
            PSYS_SRC_TEXTURE, texture,
            PSYS_PART_START_COLOR, startColor,
            PSYS_PART_END_COLOR, endColor,
            PSYS_PART_START_ALPHA, startAlpha,
            PSYS_PART_END_ALPHA, endAlpha,
            PSYS_PART_START_SCALE, startScale,
            PSYS_PART_END_SCALE, endScale,
            PSYS_PART_MAX_AGE, age,
            PSYS_SRC_BURST_RATE, rate,
            PSYS_SRC_BURST_PART_COUNT, count,
            PSYS_SRC_BURST_SPEED_MIN, minSpeed,
            PSYS_SRC_BURST_SPEED_MAX, maxSpeed,
            PSYS_SRC_BURST_RADIUS, burstRadius,
            PSYS_SRC_ACCEL, partAccel,
            PSYS_PART_FLAGS,
            0 |
            PSYS_PART_EMISSIVE_MASK |
            PSYS_PART_FOLLOW_VELOCITY_MASK |
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_INTERP_SCALE_MASK
        ]);
    }
}