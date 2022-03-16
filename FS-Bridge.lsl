// HTTP Bridge script
// Firestorm
// Tozh Taurog, Arrehn Oberlander, Tonya Souther

//
// Global variables and CONSTANTS
//

    // Bridge platform
    string BRIDGE_VERSION = "2.27"; // This should match fslslbridge.cpp
    string gLatestURL;
    integer gViewerIsFirestorm;
    integer gTryHandshakeOnce = TRUE;
    key gOwner;

    // Teleport
    float TP_TARGET_DISTANCE = 1.0; // Distance to target when move to target should stop
    integer MAX_TIME_TO_TP = 10; // (seconds) Should be set to 10 for normal use
    float TP_TIMER_TICK = 0.05;
    vector gMttVector; // Target for llMoveToTarget() teleport
    integer gStartTPTimer;

    // Movelock
    integer gUseMoveLock;
    integer gRelockMoveLockAfterMovement;
    integer gRelockIsUserMoving;

    // Flight assist
    integer gIsFlyingNow;
    float FLIGHT_CHECK_NORMAL = 0.5;
    float FLIGHT_CHECK_SLOW = 3.0;
    float gFlightAssistPushForce;

    // OpenCollar/LockMeister AO interface
    integer gAO_EnabledOC;
    integer gAO_EnabledLM;
    integer gAO_ChannelOC;
    integer AO_CHANNEL_LM = -8888;
    integer gAO_ListenerOC;
    integer gAO_ListenerLM;
    key gAO_CollarKey;

//
// Bridge platform helper functions
//

    requestBridgeURL()
    {
        llReleaseURL(gLatestURL);
        gLatestURL = "";
        // llRequestSecureURL(); // Uncomment this line and comment next one for HTTPS instead of HTTP (experimental)
        llRequestURL();
    }

    detachBridge()
    {
        llReleaseURL(gLatestURL);
        llRequestPermissions(gOwner, PERMISSION_ATTACH);
    }

//
// OpenCollar/LockMeister AO interface functions
//

    aoListenOC(key collarid, integer enabled)
    {
        llListenRemove(gAO_ListenerOC);
        if (enabled)
        {
            gAO_ListenerOC = llListen(gAO_ChannelOC, "", collarid, "");
            gAO_CollarKey = collarid;
        }
        else
        {
            gAO_CollarKey = NULL_KEY;
        }
    }

    aoState(string newstate)
    {
        llOwnerSay("<clientAO state="+newstate+">");
    }

    integrationCheckOC()
    {
        if (gAO_EnabledOC)
        {
            if (gAO_ChannelOC != PUBLIC_CHANNEL)
            {
                aoListenOC(NULL_KEY, TRUE);
                llWhisper(gAO_ChannelOC, "OpenCollar?");
            }
        }
        else
        {
            aoListenOC(NULL_KEY, FALSE);
        }
    }

    integrationCheckLM()
    {
        if (gAO_EnabledLM)
        {
            gAO_ListenerLM = llListen(AO_CHANNEL_LM, "", NULL_KEY, "");
        }
        else
        {
            llListenRemove(gAO_ListenerLM);
        }
    }

//
// Teleport Helper functions
//

    setTimerEvent2(float time)
    {
        if (time <= 0)
        {
            llSensorRemove();
        }
        else
        {
            llSensorRepeat("set-Timer-Event-2", NULL_KEY, AGENT_BY_LEGACY_NAME, 0.001, 0.001, time);
        }
    }

//
// Flight Assist
//

    flightHover(integer yes)
    {
        if (yes)
        {
            llSetForce((<0.0, 0.0, 9.8> * llGetMass()), 0);
        }
        else
        {
            llSetForce(ZERO_VECTOR, 1);
        }
    }

//
// Movelock
//

    movelockMe(integer lock)
    {
        if (lock)
        {
            llMoveToTarget(llGetPos() - <0, 0, 0.1>, 0.05);
            llSetVehicleType(VEHICLE_TYPE_SLED);
            llSetVehicleFloatParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, 0.05);
            llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 0.05);
        }
        else
        {
            llStopMoveToTarget();
            llSetVehicleType(VEHICLE_TYPE_NONE);
        }
    }

//
// MAIN
//

default
{

    on_rez(integer i)
    {
        // We don't want to be rezzed without being attached. Insure we don't create litter.
        llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_TEMP_ON_REZ, TRUE]);
    }

    attach(key k)
    // Initialize bridge functionality when worn as an attachment
    {
        if (k)
        {

            // Set owner and request control perms
            gOwner = llGetOwner();
            llRequestPermissions(gOwner, PERMISSION_TAKE_CONTROLS);

            // Assume everything is disabled for now and synchronize later with the viewer via HTTP
            gUseMoveLock = FALSE;
            gFlightAssistPushForce = 0.0;
            gIsFlyingNow = -1;
            gAO_EnabledOC = FALSE;
            gAO_EnabledLM = FALSE;

            // Disable all secondary stateful services
            setTimerEvent2(0);
            llSetTimerEvent(0);
            flightHover(FALSE);
            movelockMe(FALSE);

            // Check VM version
            if (llGetMemoryLimit() <= 16384)
            {
                llOwnerSay("<bridgeError error=wrongvm>");
            }

            // Set the channel for the AO OC interface
            gAO_ChannelOC = (integer)("0x" + llGetSubString(gOwner, 30, -1));
            if (gAO_ChannelOC > 0)
            {
                gAO_ChannelOC = -gAO_ChannelOC;
            }

            // Remove previous AO listeners if present
            integrationCheckOC();
            integrationCheckLM();

            // Assume the worst and let the viewer convince us otherwise
            gTryHandshakeOnce = TRUE;
            gViewerIsFirestorm = FALSE;
            requestBridgeURL();

        }
    }

    run_time_permissions(integer i)
    {
        if (i & PERMISSION_TAKE_CONTROLS)
        {
            // This also cause the script to work in no-script parcels
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_UP | CONTROL_DOWN, TRUE, TRUE);
        }
        else if (i & PERMISSION_ATTACH)
        {
            llDetachFromAvatar();
        }
    }

    control(key id, integer level, integer edge)
    {

        if (gUseMoveLock && gRelockMoveLockAfterMovement)
        {
            if (level & (CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_UP | CONTROL_DOWN))
            {
                if (!gRelockIsUserMoving)
                {
                    gRelockIsUserMoving = TRUE;
                    movelockMe(FALSE);
                }
            }
            else if (gRelockIsUserMoving)
            {
                gRelockIsUserMoving = FALSE;
                movelockMe(TRUE);
            }
        }

        if (gFlightAssistPushForce > 0 && gIsFlyingNow)
        {
            if (level & edge & (CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_UP | CONTROL_DOWN))
            {
                vector pushingForce = ZERO_VECTOR;
                // Forward / back
                if (level & CONTROL_FWD)
                {
                    pushingForce += <gFlightAssistPushForce, 0, 0>;
                }
                else if (level & CONTROL_BACK)
                {
                    pushingForce += <-gFlightAssistPushForce, 0, 0>;
                }
                // Left / right
                if (level & CONTROL_LEFT)
                {
                    pushingForce += <0, gFlightAssistPushForce, 0>;
                }
                else if (level & CONTROL_RIGHT)
                {
                    pushingForce += <0, -gFlightAssistPushForce, 0>;
                }
                // Up / down
                if (level & CONTROL_UP)
                {
                    pushingForce += <0, 0, gFlightAssistPushForce>;
                }
                else if (level & CONTROL_DOWN)
                {
                    pushingForce += <0, 0, -gFlightAssistPushForce>;
                }
                llSetForce(llGetMassMKS() * pushingForce, 1);
            }
            else if (~level & edge & (CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_UP | CONTROL_DOWN))
            {
                flightHover(TRUE);
            }
        }

    }

    changed(integer change)
    {
        if (change & CHANGED_REGION)
        {
            requestBridgeURL();
        }
        else if (change & (CHANGED_INVENTORY | CHANGED_ALLOWED_DROP))
        {
            // Try and resist "accidental" damage from other scripts
            // Reset persistent prim attributes frequently set via scripts, try and stop other scripts
            string myName = llGetScriptName();
            integer n = llGetInventoryNumber(INVENTORY_SCRIPT);
            if (n > 1)
            {
                llOwnerSay("<bridgeError error=injection>");
                llSleep(1.0);
                while (n)
                {
                    string s = llGetInventoryName(INVENTORY_SCRIPT, --n);
                    if (s != myName)
                    {
                        llSetScriptState(s, FALSE);
                    }
                }
            }
            llParticleSystem([]);
            llSetTextureAnim(FALSE, ALL_SIDES, 1, 1, 1.0, 1.0, 1.0);
            llAllowInventoryDrop(FALSE);
            llSetTorque(ZERO_VECTOR, 0);
            flightHover(FALSE);
            gIsFlyingNow = -1;
            movelockMe(gUseMoveLock);
        }
        else if (change & CHANGED_OWNER)
        {
            llResetScript();
        }
    }

    timer()
    {
        if (llGetAgentInfo(gOwner) & AGENT_FLYING)
        {
            if (gIsFlyingNow != TRUE)
            {
                gIsFlyingNow = TRUE;
                flightHover(TRUE);
                llSetTimerEvent(FLIGHT_CHECK_NORMAL);
            }
        }
        else if (gIsFlyingNow != FALSE)
        {
            gIsFlyingNow = FALSE;
            flightHover(FALSE);
            llSetTimerEvent(FLIGHT_CHECK_SLOW);
        }
    }

    no_sensor()
    {

        // Used for TP timer only
        // no_sensor() is used as a second timer() along with setTimerEvent2(), because lightweight llSensorRepeat() query is using impossible to meet requirements

        vector loc = llGetPos();
        vector targ = gMttVector - loc;
        float dist = llVecMag(targ);

        // llOwnerSay("current: " + (string)loc + " target: " + (string)targ + " tp distance: " + (string)dist);

        // If we are out of time or distance - stop
        if (dist < TP_TARGET_DISTANCE || llGetUnixTime() - MAX_TIME_TO_TP > gStartTPTimer || gMttVector == loc)
        {
            setTimerEvent2(0);
            movelockMe(gUseMoveLock); // llStopMoveToTarget() if FALSE, lock on place if TRUE
        }
        else
        {
            if (dist < 65)
            {
                // llOwnerSay("One jump to :" + (string)gMttVector);
                llMoveToTarget(gMttVector, TP_TIMER_TICK);
            }
            else
            {
                // llOwnerSay("Multiple jump to :" + (string)(loc + llVecNorm(targ) * 60));
                llMoveToTarget(loc + llVecNorm(targ) * 60, TP_TIMER_TICK);
            }
        }

    }

    http_request(key httpReqID, string Method, string Body)
    {
        // llOwnerSay("Received HTTP " + Method + " message. Command body: " + Body);
        if (Method == URL_REQUEST_GRANTED)
        {
            gLatestURL = Body;
            if (gViewerIsFirestorm || gTryHandshakeOnce)
            {
                // Firestorm viewer and handshake
                llOwnerSay("<bridgeURL>" + gLatestURL + "</bridgeURL><bridgeAuth>ab0bc844-336e-f8b6-cb8d-d6bfcea1d65a</bridgeAuth><bridgeVer>" + BRIDGE_VERSION + "</bridgeVer>");
                gTryHandshakeOnce = FALSE;
            }
            else
            {
                // We're in a wrong viewer, just sit quietly and call llDetachFromAvatar();
                // This place is reached via CHANGED_REGION - when gViewerIsFirestorm is still not Firestorm and handshake was already done (gTryHandshakeOnce is FALSE)
                detachBridge();
            }
        }
        else if (Method == URL_REQUEST_DENIED)
        {
            // No URLs free! Keep trying?
            llOwnerSay("<bridgeRequestError/>");
            llSleep(5);
            requestBridgeURL();
        }
        else if (Method == "GET" || Method == "POST")
        {

            // Remove the <llsd><string> ... </string></llsd> wrapper
            list commandList = llParseString2List(llGetSubString(Body, 14, llStringLength(Body) - 18), ["|"], []);
            string cmd = llList2String(commandList, 0);

            // Large If statement for command processing. Shame on you, LSL!
            if (cmd == "getZOffsets")
            {

                // Radar-specific command to get high-rez altitude data.
                // Input is list of UUIDs to query, output is list of UUID:Altitude pairs.

                // Get parameters
                list tUUIDs = llCSV2List(llList2String(commandList, 1));
                commandList = []; // Free memory
                integer tLength = llGetListLength(tUUIDs);
                key tUUID; // Key for llGetobjectDetails()
                vector tPos;
                integer i = 0;
                list responses;

                for (i = 0; i < tLength; ++i)
                {
                    tUUID = (key)llList2String(tUUIDs, i);
                    tPos = llList2Vector(llGetObjectDetails(tUUID, ([OBJECT_POS])), 0);
                    if (tPos.z > 1023) // We only care about results at higher altitudes.
                    {
                        responses = responses + tUUID + tPos.z; // Optimized for Mono-LSL
                    }
                }
                tUUIDs = []; // Free memory
                string body = "<llsd><string>" + llList2CSV(responses) + "</string></llsd>";
                responses = []; // Free memory
                llHTTPResponse(httpReqID, 200, body);
                return;

            }

            else if (cmd == "UseMoveLock")
            {
                gUseMoveLock = llList2Integer(commandList, 1);
                movelockMe(gUseMoveLock);
                if (llList2String(commandList, 2) != "noreport")
                {
                    llOwnerSay("<bridgeMovelock state=" + (string)gUseMoveLock + ">");
                }
            }

            else if (cmd == "llMoveToTarget")
            {

                if (llList2String(commandList, 2) == "1")
                {
                    // llMoveToTarget teleports are disabled for Second Life grids
                    llHTTPResponse(httpReqID, 200, "<llsd><string>ok</string></llsd>");
                    return;
                }

                // Pause movelock for now, if present
                if (gUseMoveLock)
                {
                    movelockMe(FALSE);
                }

                // Get parameters
                gMttVector = (vector)("<" + llList2String(commandList, 1) + ">");
                float groundLevel = llGround(gMttVector - llGetPos());
                if (gMttVector.z < groundLevel) // Trying to go underground? I think not!
                {
                    gMttVector.z = groundLevel + 1;
                }
                gStartTPTimer = llGetUnixTime();

                // TP commands immediately configure a TP timer consumer
                setTimerEvent2(TP_TIMER_TICK);

            }

            else if (cmd == "getScriptInfo")
            {

                key targetkey = llList2Key(commandList, 1);
                integer extended = llList2Integer(commandList, 2);
                integer elements;
                list details;
                vector currentPosition;

                if (extended)
                {
                    currentPosition = llGetPos();
                    details = llGetObjectDetails(targetkey, ([OBJECT_NAME, OBJECT_RUNNING_SCRIPT_COUNT, OBJECT_TOTAL_SCRIPT_COUNT, OBJECT_SCRIPT_MEMORY, OBJECT_SCRIPT_TIME, OBJECT_CHARACTER_TIME, OBJECT_DESC, OBJECT_ROOT, OBJECT_PRIM_COUNT, OBJECT_PRIM_EQUIVALENCE, OBJECT_TOTAL_INVENTORY_COUNT, OBJECT_VELOCITY, OBJECT_POS, OBJECT_ROT, OBJECT_OMEGA, OBJECT_CREATOR, OBJECT_OWNER, OBJECT_LAST_OWNER_ID, OBJECT_REZZER_KEY, OBJECT_GROUP, OBJECT_CREATION_TIME, OBJECT_PATHFINDING_TYPE, OBJECT_ATTACHED_POINT, OBJECT_TEMP_ATTACHED]));
                    details = details + [currentPosition, targetkey];
                    elements = 26;
                }
                else
                {
                    details = llGetObjectDetails(targetkey, ([OBJECT_NAME, OBJECT_RUNNING_SCRIPT_COUNT, OBJECT_TOTAL_SCRIPT_COUNT, OBJECT_SCRIPT_MEMORY, OBJECT_SCRIPT_TIME, OBJECT_CHARACTER_TIME]));
                    elements = 6;
                }

                if (llGetListLength(details) == elements)
                {
                    list returnedList = [llStringToBase64(llStringTrim(llList2String(details, 0), STRING_TRIM)), llList2String(details, 1), llList2String(details, 2), llList2Integer(details, 3) / 1024, llList2Float(details, 4) * 1000.0, llList2Float(details, 5) * 1000.0];
                    if (extended)
                    {
                        returnedList = returnedList + [llStringToBase64(llStringTrim(llList2String(details, 6), STRING_TRIM)), llList2String(details, 7), llList2Integer(details, 8), llList2Integer(details, 9), llList2Integer(details, 10), llStringToBase64(llList2String(details, 11)), llStringToBase64(llList2String(details, 12) + " (" + (string)llVecDist(llList2Vector(details, 12), currentPosition) + " m)"), llStringToBase64(llList2String(details, 13) + " (" + (string)(RAD_TO_DEG * llRot2Euler(llList2Rot(details, 13))) + ")"), llStringToBase64(llList2String(details, 14)), llList2Key(details, 15), llList2Key(details, 16), llList2Key(details, 17), llList2Key(details, 18), llList2Key(details, 19), llList2String(details, 20), llList2Integer(details, 21), llList2Integer(details, 22), llList2Integer(details, 23), llStringToBase64(llList2String(details, 24)), llList2Key(details, 25)];
                    }
                    llOwnerSay("<bridgeGetScriptInfo>" + llList2CSV(returnedList) + "</bridgeGetScriptInfo>");
                }
                else
                {
                    llOwnerSay("<bridgeError error=scriptinfonotfound>");
                }

            }

            else if (cmd == "UseLSLFlightAssist")
            {
                float speed = llList2Float(commandList, 1);
                if (speed != gFlightAssistPushForce)
                {
                    gFlightAssistPushForce = speed;
                    if (gFlightAssistPushForce > 0)
                    {
                        if (gFlightAssistPushForce > 15.0)
                        {
                            // No lightspeed please!
                            gFlightAssistPushForce = 15.0;
                        }
                        llSetTimerEvent(FLIGHT_CHECK_NORMAL);
                    }
                    else
                    {
                        llSetTimerEvent(0);
                        flightHover(FALSE);
                    }
                }
            }

            else if (cmd == "RelockMoveLockAfterMovement")
            {
                gRelockMoveLockAfterMovement = llList2Integer(commandList, 1);
            }

            else if (cmd == "ExternalIntegration")
            {
                integer integrationOpenCollar = llList2Integer(commandList, 1);
                if (integrationOpenCollar != gAO_EnabledOC)
                {
                    gAO_EnabledOC = integrationOpenCollar;
                    integrationCheckOC();
                }
                integer integrationLockMeister = llList2Integer(commandList, 2);
                if (integrationLockMeister != gAO_EnabledLM)
                {
                    gAO_EnabledLM = integrationLockMeister;
                    integrationCheckLM();
                }
            }

            else if (cmd == "URL Confirmed")
            {
                // We're in the right viewer, go on.
                gViewerIsFirestorm = TRUE;
            }

            else if (cmd == "DetachBridge")
            {
                // HTTP request from the viewer to immediately detach LSL-Client Bridge
                // This can be passed as a response to llOwnerSay("<bridgeURL> ... </bridgeVer>") handshake right after granting URL by a region
                // If bridge doesn't receive "URL Confirmed" message as a reply to handshake it'll automatically detach after next region change anyway
                detachBridge();
            }

            // Acknowledgment of receipt for all commands, which are not sending back HTTP response for FSLSLBridgeRequestResponder
            llHTTPResponse(httpReqID, 200, "<llsd><string>ok</string></llsd>");

        }
    }

    listen(integer fromChan, string senderName, key senderID, string msg)
    {

        // OpenCollar AO interface listen handler
        if (fromChan == gAO_ChannelOC)
        {
            integer zhaoPos;
            if ((gAO_CollarKey == NULL_KEY) &&    // No collar paired yet
                (msg == "OpenCollar=Yes"))      // A collar is saying hello
            {
                aoListenOC(senderID, TRUE);     // Pair with it
            }
            else if (msg == "OpenCollar=No")    // Collar signing off
            {
                aoListenOC(NULL_KEY, TRUE);     // Unpair with it
            }
            else if ((zhaoPos = llSubStringIndex(msg, "ZHAO_")) >= 0)
            {
                zhaoPos += 5;               // Skip past prefix
                if (llGetSubString(msg, zhaoPos, zhaoPos + 4) == "AOOFF")
                {
                    aoState("off");
                }
                else if (llGetSubString(msg, zhaoPos, zhaoPos + 3) == "AOON")
                {
                    aoState("on");
                }
                else if (llGetSubString(msg, zhaoPos, zhaoPos + 7) == "STANDOFF")
                {
                    aoState("standoff");
                }
                else if (llGetSubString(msg, zhaoPos, zhaoPos + 6) == "STANDON")
                {
                    aoState("standon");
                }
            }
        }

        // LockMeister AO interface listen handler
        else if (fromChan == AO_CHANNEL_LM &&
                 (key)llGetSubString(msg, 0, 35) == gOwner &&
                 llList2Key(llGetObjectDetails(senderID, [OBJECT_ROOT]), 0) != gAO_CollarKey)
        {
            string command = llList2String(llParseStringKeepNulls(llGetSubString(msg, 36, -1), [ "|" ], []), 0);
            if (command == "booton")
            {
                aoState("on");
            }
            else if (command == "bootoff")
            {
                aoState("off");
            }
        }

    }

}
