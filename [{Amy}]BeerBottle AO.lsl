string defaultNoteCard = "Drunk";

list animState = [ "Sitting on Ground", "Sitting", "Striding", "Crouching", "CrouchWalking",
                   "Soft Landing", "Standing Up", "Falling Down", "Hovering Down", "Hovering Up",
                   "FlyingSlow", "Flying", "Hovering", "Jumping", "PreJumping", "Running",
                   "Turning Right", "Turning Left", "Walking", "Landing", "Standing" ];

list autoDisableList = [
    "3147d815-6338-b932-f011-16b56d9ac18b",
    "ea633413-8006-180a-c3ba-96dd1d756720",
    "b5b4a67d-0aee-30d2-72cd-77b333e932ef",
    "46bb4359-de38-4ed8-6a22-f1f52fe8f506",
    "9a728b41-4ba0-4729-4db7-14bc3d3df741",
    "f3300ad9-3462-1d07-2044-0fef80062da0",
    "c8e42d32-7310-6906-c903-cab5d4a34656",
    "85428680-6bf9-3e64-b489-6f81087c24bd",
    "eefc79be-daae-a239-8c04-890f5d23654a"
];

list tokens = [
    "[ Sitting On Ground ]",    // 0
    "[ Sitting ]",              // 1
    "",                         // 2
    "[ Crouching ]",            // 3
    "[ Crouch Walking ]",       // 4
    "",                         // 5
    "[ Standing Up ]",          // 6
    "[ Falling ]",              // 7
    "[ Flying Down ]",          // 8
    "[ Flying Up ]",            // 9
    "[ Flying Slow ]",          // 10
    "[ Flying ]",               // 11
    "[ Hovering ]",             // 12
    "[ Jumping ]",              // 13
    "[ Pre Jumping ]",          // 14
    "[ Running ]",              // 15
    "[ Turning Right ]",        // 16
    "[ Turning Left ]",         // 17
    "[ Walking ]",              // 18
    "[ Landing ]",              // 19
    "[ Standing ]",             // 20
    "[ Swimming Down ]",        // 21
    "[ Swimming Up ]",          // 22
    "[ Swimming Forward ]",     // 23
    "[ Floating ]"              // 24
];

list multiAnimTokenIndexes = [ 0, 1, 18, 20 ];

integer noAnimIndex     = -1;
integer sitgroundIndex  = 0;
integer sittingIndex    = 1;
integer stridingIndex   = 2;
integer standingupIndex = 6;
integer hoverdownIndex  = 8;
integer hoverupIndex    = 9;
integer flyingslowIndex = 10;
integer flyingIndex     = 11;
integer hoverIndex      = 12;
integer walkingIndex    = 18;
integer standingIndex   = 20;
integer swimdownIndex   = 21;
integer swimupIndex     = 22;
integer swimmingIndex   = 23;
integer waterTreadIndex = 24;

list underwaterAnim = [ hoverIndex, flyingIndex, flyingslowIndex, hoverupIndex, hoverdownIndex ];
list underwaterOverride = [ waterTreadIndex, swimmingIndex, swimmingIndex, swimupIndex, swimdownIndex];
list autoStop = [ 5, 6, 19 ];

float autoStopTime = 1.5;

integer standTimeDefault = 20;

float timerEventLength = 0.25;
float minEventDelay = 0.25;

key typingAnim = "c541c47f-e0c0-058b-ad1a-d6ae3a4584d9";

integer listenChannel = -91234;

integer numStands;
integer randomStands = FALSE;
integer curStandIndex;
string curStandAnim = "";
string curSitAnim = "";
string curWalkAnim = "";
string curGsitAnim = "";
list overrides = [];
key notecardLineKey;
integer notecardIndex;
integer numOverrides;
string  lastAnim = "";
string  lastAnimSet = "";
integer lastAnimIndex = 0;
string  lastAnimState = "";
integer standTime = standTimeDefault;
integer animOverrideOn = FALSE;
integer gotPermission  = FALSE;
integer listenHandle;
integer haveWalkingAnim = FALSE;
integer sitOverride = TRUE;
integer listenState = 0;
integer loadInProgress = FALSE;
string notecardName = "";

key Owner = NULL_KEY;

string EMPTY = "";
string SEPARATOR = "|";
string TRYAGAIN = "Please correct the notecard and try again.";

integer hasIntersection( list _list1, list _list2 ) {
    list bigList;
    list smallList;
    integer smallListLength;
    integer i;

    if (  llGetListLength( _list1 ) <= llGetListLength( _list2 ) ) {
        smallList = _list1;
        bigList = _list2;
    }
    else {
        bigList = _list1;
        smallList = _list2;
    }
    smallListLength = llGetListLength( smallList );

    for ( i=0; i<smallListLength; i++ ) {
        if ( llListFindList( bigList, llList2List(smallList,i,i) ) != -1 ) {
            return TRUE;
        }
    }

    return FALSE;
}

startAnimationList( string _csvAnims ) {
    list anims = llCSV2List( _csvAnims );
    integer i;
    for( i=0; i<llGetListLength(anims); i++ )
        llStartAnimation( llList2String(anims,i) );
}

stopAnimationList( string _csvAnims ) {
    list anims = llCSV2List( _csvAnims );
    integer i;
    for( i=0; i<llGetListLength(anims); i++ )
        llStopAnimation( llList2String(anims,i) );
}

startNewAnimation( string _anim, integer _animIndex, string _state ) {
    if ( _anim != lastAnimSet ) {
        string newAnim;
        if ( lastAnim != EMPTY )
            stopAnimationList( lastAnim );
        if ( _anim != EMPTY ) {
             list newAnimSet = llParseStringKeepNulls( _anim, [SEPARATOR], [] );
             newAnim = llList2String( newAnimSet, (integer)llFloor(llFrand(llGetListLength(newAnimSet))) );
             startAnimationList( newAnim );
            if ( llListFindList( autoStop, [_animIndex] ) != -1 ) {
                if ( lastAnim != EMPTY ) {
                   stopAnimationList( lastAnim );
                   lastAnim = EMPTY;
                }
                llSleep( autoStopTime );
                stopAnimationList( _anim );
            }
        }
        lastAnim = newAnim;
        lastAnimSet = _anim;
    }
    lastAnimIndex = _animIndex;
    lastAnimState = _state;
}

animOverride() {
    string  curAnimState = llGetAnimation( Owner );
    integer curAnimIndex;
    integer underwaterAnimIndex;
    if ( curAnimState == "Striding" ) {
        curAnimState = "Walking";
    } else if ( curAnimState == "Soft Landing" ) {
        curAnimState = "Landing";
    }
    if ( curAnimState == "CrouchWalking" ) {
      if ( llVecMag(llGetVel()) < .5 )
         curAnimState = "Crouching";
    }

    if ( curAnimState == lastAnimState ) {
        return;
    }

    curAnimIndex        = llListFindList( animState, [curAnimState] );
    underwaterAnimIndex = llListFindList( underwaterAnim, [curAnimIndex] );
    if ( curAnimIndex == standingIndex ) {
        startNewAnimation( curStandAnim, standingIndex, curAnimState );
    }
    else if ( curAnimIndex == sittingIndex ) {
        if (( sitOverride == FALSE ) && ( curAnimState == "Sitting" )) {
            startNewAnimation( EMPTY, noAnimIndex, curAnimState );
        }
        else {
            startNewAnimation( curSitAnim, sittingIndex, curAnimState );
        }
    }
    else if ( curAnimIndex == walkingIndex ) {
        startNewAnimation( curWalkAnim, walkingIndex, curAnimState );
    }
    else if ( curAnimIndex == sitgroundIndex ) {
        startNewAnimation( curGsitAnim, sitgroundIndex, curAnimState );
    }
    else {
        if ( underwaterAnimIndex != -1 ) {
            vector curPos = llGetPos();
            if ( llWater(ZERO_VECTOR) > curPos.z ) {
                curAnimIndex = llList2Integer( underwaterOverride, underwaterAnimIndex );
            }
        }
        startNewAnimation( llList2String(overrides, curAnimIndex), curAnimIndex, curAnimState );
    }
}

doNextStand(integer fromUI) {
    if ( numStands > 0 ) {
        if ( randomStands ) {
            curStandIndex = llFloor( llFrand(numStands) );
        } else {
            curStandIndex = (curStandIndex + 1) % numStands;
        }

        curStandAnim = findMultiAnim( standingIndex, curStandIndex );
        if ( lastAnimState == "Standing" )
            startNewAnimation( curStandAnim, standingIndex, lastAnimState );

        if ( fromUI == TRUE ) {
            llOwnerSay( "Switching to stand '" + curStandAnim + "'." );
        }
    } else {
        if ( fromUI == TRUE ) {
            llOwnerSay( "No stand animations configured." );
        }
    }

    llResetTime();
}

doMultiAnimMenu( integer _animIndex, string _animType, string _currentAnim )
{
    list anims = llParseString2List( llList2String(overrides, _animIndex), [SEPARATOR], [] );
    integer numAnims = llGetListLength( anims );
    if ( numAnims > 12 ) {
        llOwnerSay( "Too many animations, cannot generate menu. " + TRYAGAIN );
        return;
    }

    list buttons = [];
    integer i;
    string animNames = EMPTY;
    for ( i=0; i<numAnims; i++ ) {
        animNames += "\n" + (string)(i+1) + ". " + llList2String( anims, i );
        buttons += [(string)(i+1)];
    }
    if ( animNames == EMPTY ) {
        animNames = "\n\nNo overrides have been configured.";
    }
    llListenControl(listenHandle, TRUE);
    llDialog( Owner, "Select the " + _animType + " animation to use:\n\nCurrently: " + _currentAnim + animNames, 
              buttons, listenChannel );
}

string findMultiAnim( integer _animIndex, integer _multiAnimIndex )
{
    list animsList = llParseString2List( llList2String(overrides, _animIndex), [SEPARATOR], [] );
    return llList2String( animsList, _multiAnimIndex );
}

checkMultiAnim( integer _animIndex, string _animName )
{
    list animsList = llParseString2List( llList2String(overrides, _animIndex), [SEPARATOR], [] );
    if ( llGetListLength(animsList) > 12 )
        llOwnerSay( "You have more than 12 " + _animName + " animations. Please correct this." );
}

checkAnimInInventory( string _csvAnims )
{
    list anims = llCSV2List( _csvAnims );
    integer i;
    for( i=0; i<llGetListLength(anims); i++ ) {
        string animName = llList2String( anims, i );
        if ( llGetInventoryType( animName ) != INVENTORY_ANIMATION ) {
            llOwnerSay( "Warning: Couldn't find animation '" + animName + "' in inventory." );
        }
    }
}

integer checkAndOverride() {
    if ( animOverrideOn && gotPermission ) {
        if ( hasIntersection( autoDisableList, llGetAnimationList(Owner) ) ) {
            startNewAnimation( EMPTY, noAnimIndex, EMPTY );
            return FALSE;
        }
        animOverride();
        return TRUE;
    }
    return FALSE;
}

loadNoteCard() {
    if ( llGetInventoryKey(notecardName) == NULL_KEY ) {
        llOwnerSay( "Notecard '" + notecardName + "' does not exist, or does not have full permissions." );
        loadInProgress = FALSE;
        notecardName = EMPTY;
        return;
    }
    llMinEventDelay( 0 );
    overrides = [];
    integer i;
    for ( i=0; i<numOverrides; i++ )
        overrides += [EMPTY];
    curStandIndex = 0;
    curStandAnim = EMPTY;
    curSitAnim = EMPTY;
    curWalkAnim = EMPTY;
    curGsitAnim = EMPTY;
    notecardIndex = 0;
    notecardLineKey = llGetNotecardLine( notecardName, notecardIndex );
}

endNotecardLoad()
{
    loadInProgress = FALSE;
    notecardName = EMPTY;
    llMinEventDelay( minEventDelay );
}

initialize() {
    Owner = llGetOwner();
    if ( animOverrideOn )
        llSetTimerEvent( timerEventLength );
    else
        llSetTimerEvent( 0 );
    lastAnim = EMPTY;
    lastAnimSet = EMPTY;
    lastAnimIndex = noAnimIndex;
    lastAnimState = EMPTY;
    gotPermission = FALSE;
    if ( listenHandle )
        llListenRemove( listenHandle );
    listenHandle = llListen( listenChannel, EMPTY, Owner, EMPTY );
    llListenControl( listenHandle, FALSE );
}

default {
    state_entry() {
        integer i;
        Owner = llGetOwner();
        if ( listenHandle )
            llListenRemove( listenHandle );
        listenHandle = llListen( listenChannel, EMPTY, Owner, EMPTY );
        if ( llGetAttached() )
            llRequestPermissions( llGetOwner(), PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS );
        numOverrides = llGetListLength( tokens );
        for ( i=0; i<llGetListLength(autoDisableList); i++ ) {
            key k = llList2Key( autoDisableList, i );
            autoDisableList = llListReplaceList ( autoDisableList, [ k ], i, i );
        }
        overrides = [];
        for ( i=0; i<numOverrides; i++ ) {
            overrides += [ EMPTY ];
        }
        randomStands = FALSE;
        initialize();
        notecardName = defaultNoteCard;
        loadInProgress = TRUE;
        loadNoteCard();
        if ( autoStopTime == 0 )
            autoStop = [];
        llResetTime();
    }

    on_rez( integer _code ) {
        initialize();
    }

    changed(integer change)
    {
      if (change & CHANGED_OWNER)
          llResetScript();
    }

    attach( key _k ) {
        if ( _k != NULL_KEY )
            llRequestPermissions( llGetOwner(), PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS );
    }

    run_time_permissions( integer _perm ) {
      if ( _perm != (PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS) )
         gotPermission = FALSE;
      else {
         llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );
         gotPermission = TRUE;
      }
    }

    link_message( integer _sender, integer _num, string _message, key _id) {
        if ( _message == "BEER_RESET" ) {
            llOwnerSay( "Resetting..." );
            llResetScript();
        } else if ( _message == "BEER_AOON" ) {
            llSetTimerEvent( timerEventLength );
            animOverrideOn = TRUE;
            checkAndOverride();
        } else if ( _message == "BEER_AOOFF" ) {
            llSetTimerEvent( 0 );
            animOverrideOn = FALSE;
            startNewAnimation( EMPTY, noAnimIndex, lastAnimState );
            lastAnim = EMPTY;
            lastAnimSet = EMPTY;
            lastAnimIndex = noAnimIndex;
            lastAnimState = EMPTY;
        } else if ( _message == "BEER_SITON" ) {
            sitOverride = TRUE;
            llOwnerSay( "Sit override: On" );
            if ( lastAnimState == "Sitting" )
                startNewAnimation( curSitAnim, sittingIndex, lastAnimState );
        } else if ( _message == "BEER_SITOFF" ) {
            sitOverride = FALSE;
            llOwnerSay( "Sit override: Off" );
            if ( lastAnimState == "Sitting" )
                startNewAnimation( EMPTY, noAnimIndex, lastAnimState );
        } else if ( _message == "BEER_RANDOMSTANDS" ) {
            randomStands = TRUE;
            llOwnerSay( "Stand cycling: Random" );
        } else if ( _message == "BEER_SEQUENTIALSTANDS" ) {
            randomStands = FALSE;
            llOwnerSay( "Stand cycling: Sequential" );
        } else if ( _message == "BEER_SETTINGS" ) {
            if ( sitOverride == TRUE ) {
                llOwnerSay( "Sit override: On" );
            } else {
                llOwnerSay( "Sit override: Off" );
            }
            if ( randomStands == TRUE ) {
                llOwnerSay( "Stand cycling: Random" );
            } else {
                llOwnerSay( "Stand cycling: Sequential" );
            }
            llOwnerSay( "Stand cycle time: " + (string)standTime + " seconds" );
        } else if ( _message == "BEER_NEXTSTAND" ) {
            doNextStand( TRUE );
        } else if ( llGetSubString(_message, 0, 14) == "BEER_STANDTIME|" ) {
            // Stand time change
            standTime = (integer)llGetSubString(_message, 15, -1);
            llOwnerSay( "Stand cycle time: " + (string)standTime + " seconds" );
        
        } else if ( llGetSubString(_message, 0, 9) == "BEER_LOAD|" ) {
            if ( loadInProgress == TRUE ) {
                llOwnerSay( "Cannot load new notecard, still reading notecard '" + notecardName + "'" );
                return;
            }
            loadInProgress = TRUE;
            notecardName = llGetSubString(_message, 10, -1);
            loadNoteCard();
        } else if ( _message == "BEER_SITS" ) {
            doMultiAnimMenu( sittingIndex, "Sitting", curSitAnim );
            listenState = 1;
        } else if ( _message == "BEER_WALKS" ) {
            doMultiAnimMenu( walkingIndex, "Walking", curWalkAnim );
            listenState = 2;
        } else if ( _message == "BEER_GROUNDSITS" ) {
            doMultiAnimMenu( sitgroundIndex, "Sitting On Ground", curGsitAnim );
            listenState = 3;
        }
    }

    listen( integer _channel, string _name, key _id, string _message) {
        llListenControl(listenHandle, FALSE);
        if ( listenState == 1 ) {
            curSitAnim = findMultiAnim( sittingIndex, (integer)_message - 1 );
            if ( lastAnimState == "Sitting" ) {
                startNewAnimation( curSitAnim, sittingIndex, lastAnimState );
            }
            llOwnerSay( "New sitting animation: " + curSitAnim );

        } else if ( listenState == 2 ) {
            curWalkAnim = findMultiAnim( walkingIndex, (integer)_message - 1 );
            if ( lastAnimState == "Walking" ) {
                startNewAnimation( curWalkAnim, walkingIndex, lastAnimState );
            }
            llOwnerSay( "New walking animation: " + curWalkAnim );

        } else if ( listenState == 3 ) {
            curGsitAnim = findMultiAnim( sitgroundIndex, (integer)_message - 1 );
            if ( lastAnimState == "Sitting on Ground" ) {
                startNewAnimation( curGsitAnim, sitgroundIndex, lastAnimState );
            }
            llOwnerSay( "New sitting on ground animation: " + curGsitAnim );
        }
    }

    dataserver( key _query_id, string _data ) {

        if ( _query_id != notecardLineKey ) {
            llOwnerSay( "Error in reading notecard. Please try again." );

            endNotecardLoad();
            return;
        }

        if ( _data == EOF ) {
            if ( llList2String(overrides, walkingIndex) != EMPTY ) {
                 haveWalkingAnim = TRUE;
            }
            checkMultiAnim( walkingIndex, "walking" );
            checkMultiAnim( sittingIndex, "sitting" );
            checkMultiAnim( sitgroundIndex, "sitting on ground" );
            curStandIndex = 0;
            numStands = llGetListLength( llParseString2List(llList2String(overrides, standingIndex), 
                                         [SEPARATOR], []) );
            curStandAnim = findMultiAnim( standingIndex, 0 );
            curWalkAnim = findMultiAnim( walkingIndex, 0 );
            curSitAnim = findMultiAnim( sittingIndex, 0 );
            curGsitAnim = findMultiAnim( sitgroundIndex, 0 );
            startNewAnimation( EMPTY, noAnimIndex, lastAnimState );
            lastAnim = EMPTY;
            lastAnimSet = EMPTY;
            lastAnimIndex = noAnimIndex;
            lastAnimState = EMPTY;
            endNotecardLoad();
            return;
        }

        if (( _data == EMPTY ) || ( llGetSubString(_data, 0, 0) == "#" )) {
            notecardLineKey = llGetNotecardLine( notecardName, ++notecardIndex );
            return;
        }

        integer i;
        integer found = FALSE;
        for ( i=0; i<numOverrides; i++ ) {
            string token = llList2String( tokens, i );
            if (( token != EMPTY ) && ( llGetSubString( _data, 0, llStringLength(token) - 1 ) == token )) {
                found = TRUE;
                if ( _data != token ) {
                    string animPart = llGetSubString( _data, llStringLength(token), -1 );
                    if ( llListFindList( multiAnimTokenIndexes, [i] ) != -1 ) {
                        list anims2Add = llParseString2List( animPart, [SEPARATOR], [] );
                        integer j;
                        for ( j=0; j<llGetListLength(anims2Add); j++ ) {
                            checkAnimInInventory( llList2String(anims2Add,j) );
                        }
                        list currentAnimsList = llParseString2List( llList2String(overrides, i), [SEPARATOR], [] );
                        currentAnimsList += anims2Add;
                        overrides = llListReplaceList( overrides, [llDumpList2String(currentAnimsList, SEPARATOR)], i, i );
                    } else {
                        if ( llSubStringIndex( animPart, SEPARATOR ) != -1 ) {
                            llOwnerSay( "Cannot have multiple animations for " + token + ". " + TRYAGAIN );

                            endNotecardLoad();
                            return;
                        }
                        checkAnimInInventory( animPart );
                        overrides = llListReplaceList( overrides, [animPart], i, i );
                    }
                }
                jump done;

            }
        }

        @done;
        
        if ( !found ) {
            llOwnerSay( "Invalid data in notecard on line " + (string)notecardIndex + ": " + 
                        _data + ". " + TRYAGAIN );

            endNotecardLoad();
            return;
        }
        notecardLineKey = llGetNotecardLine( notecardName, ++notecardIndex );
        return;
    }

    collision_start( integer _num ) {
        checkAndOverride();
    }

    collision( integer _num ) {
        checkAndOverride();
    }

    collision_end( integer _num ) {
        checkAndOverride();
    }

    control( key _id, integer _level, integer _edge ) {
        if ( _edge ) {
            if ( llGetAnimation(Owner) == "Walking" ) {
                if ( _level & _edge & ( CONTROL_BACK | CONTROL_FWD ) ) {
                    if ( haveWalkingAnim ) {
                        llStopAnimation( "walk" );
                        llStopAnimation( "female_walk" );
                    }
                }
            }

            checkAndOverride();
            }
        }

    timer() {
        if ( checkAndOverride() ) {
            if ( (standTime != 0) && (llGetTime() > standTime) ) {
                if ( llListFindList(llGetAnimationList(Owner), [typingAnim]) == -1 )
                    doNextStand( FALSE );
            }
        }
    }
}
