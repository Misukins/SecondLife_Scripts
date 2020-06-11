//SETTINGS YOU MAY CHANGE!

integer lowest_Tip  = 20;
integer tiptwo      = 50;
integer tipthree    = 100;
integer tipfour     = 200;

//PLEASE DO NOT CNAGE ANYTHING BELOW!!

default
{
    state_entry()
    {
        //PLEASE DO NOT CNAGE ANYTHING BELOW!!
    }
    
    link_message(integer n, integer num, string message, key id)
    {
        if(message == "signed in"){
            llSetLinkTextureAnim(LINK_THIS, ANIM_ON | SMOOTH | LOOP, ALL_SIDES, 1, 0, 1.0, 1, 0.15);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_GLOW, ALL_SIDES, 0.15]);
            llTargetOmega(<0, 0, 3>, 0.1, 1.0);
            llSetLinkColor(LINK_THIS, <0.969, 0.608, 0.890>, ALL_SIDES);
            llSetPayPrice(lowest_Tip, [lowest_Tip ,tiptwo, tipthree, tipfour]);
        }
        else if(message == "signed out"){
            llSetLinkTextureAnim(LINK_THIS, FALSE | SMOOTH | LOOP, ALL_SIDES, 1, 0, 1.0, 1, 0.05);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_GLOW, ALL_SIDES, 0.0]);
            llTargetOmega(<0, 0, 0>, 0.0, 0.0);
            llSetLinkColor(LINK_THIS, <0, 0, 0>, ALL_SIDES);
            llSetPayPrice(PAY_DEFAULT, [PAY_DEFAULT ,PAY_DEFAULT, PAY_DEFAULT, PAY_DEFAULT]);
        }
    }
}