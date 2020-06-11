/* to use this program just sit on the seat and type:

++      adjust position up
--      adjust position down
+       adjust position forward
-       adjust position back 
*/

key pilot;
vector POSITION = <0,0,1>;

//Sets / Updates the sit target moving the avatar on it if necessary.
UpdateSitTarget(key requester)
{//Using this while the object is moving may give unpredictable results.
    llSitTarget(POSITION, ZERO_ROTATION);//Set the sit target
    key user = llAvatarOnSitTarget();
    if(user)//true if there is a user seated on the sittarget, if so update their position
    {
        vector size = llGetAgentSize(user);
        if(size)//This tests to make sure the user really exists.
        {
            //We need to make the position and rotation local to the current prim
            rotation localrot = ZERO_ROTATION;
            vector localpos = ZERO_VECTOR;
            if(llGetLinkNumber() > 1)//only need the local rot if it's not the root.
            {
                localrot = llGetLocalRot();
                localpos = llGetLocalPos();
            }
            integer linkNum = llGetNumberOfPrims();
            do
            {
                if(user == llGetLinkKey( linkNum ))//just checking to make sure the index is valid.
                {
                    //<0.008906, -0.049831, 0.088967> are the coefficients for a parabolic curve that best fits real avatars. It is not a perfect fit.
                    float fAdjust = ((((0.008906 * size.z) + -0.049831) * size.z) + 0.088967) * size.z;
                    llSetLinkPrimitiveParamsFast(linkNum,
                        [PRIM_POS_LOCAL, (POSITION + <0.0, 0.0, 0.4> - (llRot2Up(ZERO_ROTATION) * fAdjust)) * localrot + localpos,
                         PRIM_ROT_LOCAL, ZERO_ROTATION]);
                    jump end;//cheaper but a tad slower then return
                }
            }while( --linkNum );
        }
        else
        {//It is rare that the sit target will bork but it does happen, this can help to fix it.
            llUnSit(user);
        }
    }
    @end;
}


default
{
    state_entry()
    {
        llListen(0, "", llGetOwner(),"");
        pilot = llGetOwner();
        llSitTarget(POSITION, <0,0,0,0>);
    }
    
    on_rez(integer start_parm)
    {
        llListen(0, "", llGetOwner(),"");
        pilot = llGetOwner();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(message=="++" && id == pilot)
        {   
            POSITION.z += 0.025;
            UpdateSitTarget(id);
            return;
        } 
        else if(message =="--" && id == pilot)
        {   
            POSITION.z -= 0.025;
            UpdateSitTarget(id);
            return;
        } 
        else if( message=="+" && id == pilot)
        {   
            POSITION.x += 0.025;
            UpdateSitTarget(id);
            return;
        } 
        else if(message=="-" && id == pilot)
        {   
            POSITION.x -= 0.025;
            UpdateSitTarget(id);
            return;
        } 
    }
}
