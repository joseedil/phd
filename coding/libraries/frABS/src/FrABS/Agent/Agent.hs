module FrABS.Agent.Agent where

import FrABS.Env.Environment

import FRP.Yampa


type AgentId = Int
type AgentMessage m = (AgentId, m)
type AgentBehaviour s m ec = SF (AgentIn s m ec) (AgentOut s m ec)
type MessageFilter m = (AgentMessage m -> Bool)

type AgentConversationReceiver s m ec = (AgentIn s m ec
                                            -> AgentMessage m
                                            -> Maybe (m, AgentIn s m ec)) -- NOTE: the receiver MUST reply, otherwise we could've used the normal messaging

type AgentConversationSender s m ec = (AgentOut s m ec
                                        -> Maybe (AgentMessage m)   -- NOTE: this will be Nothing in case the conversation with the target was not established e.g. id not found, target got no receiving handler
                                        -> AgentOut s m ec)


data AgentDef s m ec = AgentDef {
    adId :: AgentId,
    adState :: s,
    adBeh :: AgentBehaviour s m ec,
    adConversation :: Maybe (AgentConversationReceiver s m ec),
    adInitMessages :: Event [AgentMessage m],     -- AgentId identifies sender
    adEnvPos :: EnvCoord
}

data AgentIn s m ec = AgentIn {
    aiId :: AgentId,
    aiMessages :: Event [AgentMessage m],     -- AgentId identifies sender
    aiConversation :: Maybe (AgentConversationReceiver s m ec),
    aiStart :: Event (),
    aiState :: s,
    aiEnv :: Environment ec,
    aiEnvPos :: EnvCoord,
    aiRec :: Event ([AgentOut s m ec]),
    aiRecInitAllowed :: Bool
}

data AgentOut s m ec = AgentOut {
    aoId :: AgentId,
    aoKill :: Event (),
    aoCreate :: Event [AgentDef s m ec],
    aoMessages :: Event [AgentMessage m],     -- AgentId identifies receiver
    aoBeginConversation :: Event (AgentMessage m, AgentConversationSender s m ec),
    aoState :: s,
    aoEnv :: Environment ec,
    aoEnvPos :: EnvCoord,
    aoRec :: Event (),
    aoRecOthersAllowed :: Bool
}

recInitAllowed :: AgentIn s m ec -> Bool
recInitAllowed = aiRecInitAllowed

agentOutFromIn :: AgentIn s m ec -> AgentOut s m ec
agentOutFromIn ai = AgentOut{ aoId = (aiId ai),
                              aoKill = NoEvent,
                              aoCreate = NoEvent,
                              aoMessages = NoEvent,
                              aoBeginConversation = NoEvent,
                              aoState = (aiState ai),
                              aoEnv = (aiEnv ai),
                              aoRec = NoEvent,
                              aoEnvPos = (aiEnvPos ai),
                              aoRecOthersAllowed = True }

sendMessage :: AgentOut s m ec -> AgentMessage m -> AgentOut s m ec
sendMessage ao msg = ao { aoMessages = mergedMsgs }
    where
        newMsgEvent = Event [msg]
        existingMsgEvent = aoMessages ao
        mergedMsgs = mergeMessages existingMsgEvent newMsgEvent

hasConversation :: AgentOut s m ec -> Bool
hasConversation = isEvent . aoBeginConversation

beginConversation :: AgentOut s m ec
                        -> AgentMessage m
                        -> AgentConversationSender s m ec
                        -> AgentOut s m ec
beginConversation ao msg replyHdl = ao { aoBeginConversation = Event (msg, replyHdl)}

stopConversation :: AgentOut s m ec -> AgentOut s m ec
stopConversation ao = ao { aoBeginConversation = NoEvent }

sendMessages :: AgentOut s m ec -> [AgentMessage m] -> AgentOut s m ec
sendMessages ao msgs = foldr (\msg ao' -> sendMessage ao' msg ) ao msgs

broadcastMessage :: AgentOut s m ec -> m -> [AgentId] -> AgentOut s m ec
broadcastMessage ao m receiverIds = sendMessages ao msgs
    where
        n = length receiverIds
        ms = replicate n m
        msgs = zip receiverIds ms

createAgent :: AgentOut s m ec -> AgentDef s m ec -> AgentOut s m ec
createAgent ao newDef = ao { aoCreate = createEvt }
    where
        oldCreateEvt = aoCreate ao
        createEvt = mergeBy (\leftCreate rightCreate -> leftCreate ++ rightCreate) (Event [newDef]) oldCreateEvt

kill :: AgentOut s m ec -> AgentOut s m ec
kill ao = ao { aoKill = Event () }

isDead :: AgentOut s m ec -> Bool
isDead = isEvent . aoKill

onStart :: AgentIn s m ec -> (AgentOut s m ec -> AgentOut s m ec) -> AgentOut s m ec -> AgentOut s m ec
onStart ai evtHdl ao = onEvent startEvt evtHdl ao
    where
        startEvt = aiStart ai

onEvent :: Event () -> (AgentOut s m ec -> AgentOut s m ec) -> AgentOut s m ec -> AgentOut s m ec
onEvent evt evtHdl ao = if isEvent evt then
                            evtHdl ao
                            else
                                ao

onMessage :: MessageFilter m -> AgentIn s m ec -> (AgentOut s m ec -> AgentMessage m -> AgentOut s m ec) -> AgentOut s m ec -> AgentOut s m ec
onMessage msgFilter ai evtHdl ao
    | not hasMessages = ao
    | otherwise = foldr (\msg ao'-> evtHdl ao' msg ) ao filteredMsgs
    where
        msgsEvt = aiMessages ai
        hasMessages = isEvent msgsEvt
        msgs = fromEvent msgsEvt
        filteredMsgs = filter msgFilter msgs

onAnyMessage :: AgentIn s m ec -> (AgentOut s m ec -> AgentMessage m -> AgentOut s m ec) -> AgentOut s m ec -> AgentOut s m ec
onAnyMessage ai evtHdl ao = onMessage noMsgFilter ai evtHdl ao
    where
        noMsgFilter = (\_ -> True)

onMessageFrom :: AgentId -> AgentIn s m ec -> (AgentOut s m ec -> AgentMessage m -> AgentOut s m ec) -> AgentOut s m ec -> AgentOut s m ec
onMessageFrom senderId ai evtHdl ao = onMessage filterBySender ai evtHdl ao
    where
        filterBySender = (\(senderId', _) -> senderId == senderId' )

onMessageType :: (Eq m) => m -> AgentIn s m ec -> (AgentOut s m ec -> AgentMessage m -> AgentOut s m ec) -> AgentOut s m ec -> AgentOut s m ec
onMessageType m ai evtHdl ao = onMessage filterByMsgType ai evtHdl ao
    where
        filterByMsgType = (\(_, m') -> m == m' )

updateState :: AgentOut s m ec -> (s -> s) -> AgentOut s m ec
updateState ao sfunc = ao { aoState = s' }
    where
        s = aoState ao
        s' = sfunc s

allowsRecOthers :: AgentOut s m ec -> Bool
allowsRecOthers = aoRecOthersAllowed

recursive :: AgentOut s m ec -> Bool -> AgentOut s m ec
recursive aout allowOthers = aout { aoRec = Event (), aoRecOthersAllowed = allowOthers }

unrecursive :: AgentOut s m ec -> AgentOut s m ec
unrecursive aout = aout { aoRec = NoEvent }

isRecursive :: AgentIn s m ec -> Bool
isRecursive ain = isEvent $ aiRec ain

createStartingAgentIn :: [AgentDef s m ec] -> Environment ec -> [AgentIn s m ec]
createStartingAgentIn as env = map (startingAgentInFromAgentDef env) as

startingAgentInFromAgentDef :: Environment ec -> AgentDef s m ec -> AgentIn s m ec
startingAgentInFromAgentDef env a = AgentIn { aiId = adId a,
                                                aiMessages = adInitMessages a,
                                                aiConversation = adConversation a,
                                                aiStart = Event (),
                                                aiState = adState a,
                                                aiEnv = env,
                                                aiEnvPos = adEnvPos a,
                                                aiRec = NoEvent,
                                                aiRecInitAllowed = True }

mergeMessages :: Event [AgentMessage m] -> Event [AgentMessage m] -> Event [AgentMessage m]
mergeMessages l r = mergeBy (\msgsLeft msgsRight -> msgsLeft ++ msgsRight) l r