key user;

integer listenChannel = -458790;
float blood;

/*REVIEW
PLEASE DONT CHANGE minOffset/maxOffset..
*/
float minOffset =  0.12000;
float maxOffset = -0.17000;

/* NOTE these are just for the changing things easily */
key default_texture_DIFF    = "3451a41f-2e97-357c-d742-5a9bba858f70";
key default_texture_NORM    = "8c1b9a03-8b91-2854-41e6-1284f8ec3b00";
key default_texture_SPEC    = "d3799e28-dee1-51bb-0ebc-0bfc5a07625c";
/*NOTE 
Textures included!
less lag if i do them this way
*/
integer bloodBarFace = ALL_SIDES;
integer bloodBarLink = LINK_THIS;

vector bloodBar = <1.0, 0.098, 0.114>;
/* ------------------------------------------ */

/*
NOTE = 
*/

default
{
    state_entry()
    {
        llListen(listenChannel, "", "", "");
        //NOTE just for default color
        llSetLinkColor(bloodBarLink, bloodBar, bloodBarFace);
        //NOTE TEXTURE + POSITION
        llSetPrimitiveParams([PRIM_TEXTURE, bloodBarLink, default_texture_DIFF, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0]);
        llSetPrimitiveParams([PRIM_TEXTURE, bloodBarLink, default_texture_NORM, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0]);
        llSetPrimitiveParams([PRIM_TEXTURE, bloodBarLink, default_texture_SPEC, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0]);
        llRotateTexture(PI_BY_TWO, ALL_SIDES);
    }

    listen(integer channel, string name, key id, string message)
    {
        if(channel == listenChannel){
            if(message == "bloodupdate " + currentBlood){
                string newTexturePOS = llGetSubString(message, 5,-1);
                llSetPrimitiveParams([PRIM_TEXTURE, bloodBarLink, default_texture_DIFF, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0]);
                llSetPrimitiveParams([PRIM_TEXTURE, bloodBarLink, default_texture_NORM, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0]);
                llSetPrimitiveParams([PRIM_TEXTURE, bloodBarLink, default_texture_SPEC, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0]);
                llRotateTexture(PI_BY_TWO, ALL_SIDES);
                //FIX C# ATM
                /* integer i;
                for( i = 1; i < 100; i++ ){
                    blood = minOffset + .1;
                    llOffsetTexture((float)minOffset, (float)minOffset, i);
                } */
                llOwnerSay("here iam! -- " + (string)newTexturePOS);
            }
        }
    }
}
