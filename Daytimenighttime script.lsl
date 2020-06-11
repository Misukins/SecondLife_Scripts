// Daytime/nighttime script
// Ordinal Malaprop
// 2006-03-29

integer daytime()
{
   vector pos = llGetSunDirection();
   if (pos.z > 0) return TRUE;
   else return FALSE;
}

default
{
   state_entry()
   {
      if (!daytime()) state night;
      llSetTimerEvent(300.0);
      // then your daytime code here
   }

   timer()
   {
      if (!daytime()) state night;
   }
}

state night
{
   state_entry()
   {
      if (daytime()) state default;
      llSetTimerEvent(300.0);
      // then your nighttime code here
   }

   timer()
   {
      if (daytime()) state default;
   }
}