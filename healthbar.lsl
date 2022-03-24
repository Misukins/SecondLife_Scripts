/* integer hit_value = 20;//How much health we loose each time we are hit.
integer health_value = 500;//Our total health

default
{
    state_entry()
    {
        llMessageLinked(LINK_SET,0,"full",NULL_KEY);
    }

    collision_start(integer total_number)
    {
        integer i;
        for( i = 0; i < total_number; i++ ){
            if(llDetectedType(i) & AGENT)
                return;
            health_value -= hit_value;
            if ( healt_value <= 0 )
                state collapse;
            else if ( healt_value <= 100 )
                llMessageLinked(LINK_SET,0,"100",NULL_KEY);
            else if ( healt_value <= 200 )
                llMessageLinked(LINK_SET,0,"200",NULL_KEY);
            else if ( healt_value <= 300 )
                llMessageLinked(LINK_SET,0,"300",NULL_KEY);
            else if ( healt_value <= 400 )
                llMessageLinked(LINK_SET,0,"400",NULL_KEY);
        }
    }
}
    
state collapse
{
    state_entry()
    {
        llSay(0, "You died.");
    }
}
 */
//
integer hit_value = 20;//How much health we loose each time we are hit.
integer health_value = 500;//Our total health

default
{
    state_entry()
    {
        llMessageLinked(LINK_SET,0,"full",NULL_KEY);
    }
    
    collision_start(integer total_number)
    {
        integer i;
        for( i = 0; i < total_number; i++ ){
            if(llDetectedType(i) & AGENT)
                return;
            health_value -= hit_value;
            if ( health_value <= 0 )
                state collapse;
            else if ( health_value <= 400 )
                llMessageLinked(LINK_SET,0,(string)(((health_value-1)/100+1)*100),NULL_KEY)
        }
    }
}
    
state collapse
{
    state_entry()
    {
        llSay(0, "You died.");
    }
}