{-# LANGUAGE Arrows #-}
module SugarScape.SugarScapeAgent where

-- Project-internal import first
import SugarScape.SugarScapeModel
import SugarScape.SugarScapeEnvironment
import Utils.Utils

import FrABS.Env.Environment
import FrABS.Agent.Agent
import FrABS.Agent.AgentUtils

-- Project-specific libraries follow
import FRP.Yampa

-- System imports then
import Data.Maybe
import Data.List
import System.Random
import Control.Monad.Random
import Control.Monad
import Control.Monad.IfElse
import Control.Monad.Trans.State

-- debugging imports finally, to be easily removed in final version
import Debug.Trace


------------------------------------------------------------------------------------------------------------------------
-- DOMAIN-STATE FUNCTIONS not used for manipulating the state
------------------------------------------------------------------------------------------------------------------------
metabolismAmount :: SugarScapeAgentState -> (Double, Double)
metabolismAmount s = (sugarMetab + inc, spiceMetab + inc)
    where
        sugarMetab = sugAgSugarMetab s
        spiceMetab = sugAgSpiceMetab s
        inc = if isDiseased s then diseasedMetabolismIncrease else 0 

type BestCellMeasureFunc = (SugarScapeEnvCell -> Double) 

selectBestCells :: BestCellMeasureFunc
                    -> EnvCoord
                    -> [(EnvCoord, SugarScapeEnvCell)]
                    -> [(EnvCoord, SugarScapeEnvCell)]
selectBestCells measureFunc refCoord cs = bestShortestdistanceManhattanCells
    where
        cellsSortedByMeasure = sortBy (\c1 c2 -> compare (measureFunc $ snd c2) (measureFunc $ snd c1)) cs
        bestCellMeasure = measureFunc $ snd $ head cellsSortedByMeasure
        bestCells = filter ((==bestCellMeasure) . measureFunc . snd) cellsSortedByMeasure

        shortestdistanceManhattanBestCells = sortBy (\c1 c2 -> compare (distanceManhattan refCoord (fst c1)) (distanceManhattan refCoord (fst c2))) bestCells
        shortestdistanceManhattan = distanceManhattan refCoord (fst $ head shortestdistanceManhattanBestCells)
        bestShortestdistanceManhattanCells = filter ((==shortestdistanceManhattan) . (distanceManhattan refCoord) . fst) shortestdistanceManhattanBestCells

bestMeasureSugarLevel :: BestCellMeasureFunc
bestMeasureSugarLevel c = sugEnvSugarLevel c

bestMeasureSugarAndSpiceLevel :: SugarScapeAgentState -> BestCellMeasureFunc
bestMeasureSugarAndSpiceLevel s c = agentWelfareChange s (x1, x2)
    where
        x1 = sugEnvSugarLevel c
        x2 = sugEnvSpiceLevel c

bestMeasureSugarPolutionRatio :: BestCellMeasureFunc
bestMeasureSugarPolutionRatio c = sugLvl / (1 + polLvl)
    where
        sugLvl = sugEnvSugarLevel c
        polLvl = sugEnvPolutionLevel c
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- AGENT-BEHAVIOUR MONADIC 
------------------------------------------------------------------------------------------------------------------------
agentDiesM :: State SugarScapeAgentOut ()
agentDiesM = unoccupyPositionM >> killM

unoccupyPositionM :: State SugarScapeAgentOut ()
unoccupyPositionM = 
    do
        (cellCoord, cell) <- agentCellOnPosM
        let cellUnoccupied = cell { sugEnvOccupier = Nothing }
        runEnvironmentM $ changeCellAtM cellCoord cellUnoccupied

passWealthOnM :: State SugarScapeAgentOut ()
passWealthOnM =
    do
        sugarLevel <- domainStateFieldM sugAgSugarLevel
        childrenIds <- domainStateFieldM sugAgChildren

        let hasChildren = (not . null) childrenIds

        when hasChildren $
            do 
                let childrenCount = length childrenIds
                let childrenSugarShare = sugarLevel / (fromRational $ toRational $ fromIntegral childrenCount)
                broadcastMessageM (InheritSugar childrenSugarShare) childrenIds

starvedToDeathM :: State SugarScapeAgentOut Bool
starvedToDeathM = 
    do
        sugar <- domainStateFieldM sugAgSugarLevel
        spice <- domainStateFieldM sugAgSpiceLevel
        return $ (sugar <= 0) || (spice <= 0)


agentMetabolismM :: State SugarScapeAgentOut ()
agentMetabolismM =
    do
        s <- getDomainStateM
        let (sugarMetab, spiceMetab) = metabolismAmount s

        sugarLevel <- domainStateFieldM sugAgSugarLevel
        spiceLevel <- domainStateFieldM sugAgSpiceLevel

        let newSugarLevel = max 0 (sugarLevel - sugarMetab)
        let newSpiceLevel = max 0 (spiceLevel - spiceMetab)

        updateDomainStateM (\s -> s { sugAgSugarLevel = newSugarLevel, sugAgSpiceLevel = newSpiceLevel })

        -- NOTE: for now the metabolism (and harvest) of spice does not cause any polution
        let pol = sugarMetab * polutionMetabolismFactor
        
        cell <- agentCellOnPosM
        agentPoluteCellM pol cell

        whenM starvedToDeathM agentDiesM

agentPoluteCellM :: Double -> (EnvCoord, SugarScapeEnvCell) -> State SugarScapeAgentOut ()
agentPoluteCellM polutionIncrease (cellCoord, cell)
    | polutionEnabled = 
        do
            let cellAfterPolution = cell { sugEnvPolutionLevel = polutionIncrease + (sugEnvPolutionLevel cell) }
            runEnvironmentM $ changeCellAtM cellCoord cellAfterPolution
    | otherwise = return ()

agentNonCombatMoveM :: State SugarScapeAgentOut ()
agentNonCombatMoveM = 
    do
        cellsInSight <- agentLookoutM
        pos <- environmentPositionM

        let unoccupiedCells = filter (cellUnoccupied . snd) cellsInSight
        let bestCells = selectBestCells bestMeasureSugarLevel pos unoccupiedCells

        (cellCoord, _) <- agentPickRandomM bestCells

        ifThenElse (null unoccupiedCells)
                    agentStayAndHarvestM
                    (agentMoveAndHarvestCellM cellCoord)

agentLookoutM :: State SugarScapeAgentOut [(EnvCoord, SugarScapeEnvCell)]
agentLookoutM = 
    do
        vis <- domainStateFieldM sugAgVision
        pos <- environmentPositionM 
        runEnvironmentM $ neighboursDistanceM pos vis

agentStayAndHarvestM :: State SugarScapeAgentOut ()
agentStayAndHarvestM = 
    do
        (cellCoord, _) <- agentCellOnPosM
        agentHarvestCellM cellCoord

agentMoveAndHarvestCellM :: EnvCoord -> State SugarScapeAgentOut ()
agentMoveAndHarvestCellM cellCoord = 
    do
        agentHarvestCellM cellCoord
        agentMoveToM cellCoord

agentMoveToM :: EnvCoord -> State SugarScapeAgentOut ()
agentMoveToM cellCoord = 
    do
        unoccupyPositionM

        s <- getDomainStateM
        aid <- agentIdM
        cell <- runEnvironmentM $ cellAtM cellCoord

        let cellOccupied = cell { sugEnvOccupier = Just (cellOccupier aid s) }

        runEnvironmentM $ changeCellAtM cellCoord cellOccupied
        changeEnvironmentPositionM cellCoord

agentHarvestCellM :: EnvCoord -> State SugarScapeAgentOut ()
agentHarvestCellM cellCoord = 
    do
        cell <- runEnvironmentM $ cellAtM cellCoord

        sugarLevelAgent <- domainStateFieldM sugAgSugarLevel
        spiceLevelAgent <- domainStateFieldM sugAgSpiceLevel

        let sugarLevelCell = sugEnvSugarLevel cell
        let spiceLevelCell = sugEnvSpiceLevel cell

        let newSugarLevelAgent = sugarLevelCell + sugarLevelAgent
        let newSpiceLevelAgent = spiceLevelCell + spiceLevelAgent

        updateDomainStateM (\s -> s { sugAgSugarLevel = newSugarLevelAgent, sugAgSpiceLevel = newSpiceLevelAgent })

        let cellHarvested = cell { sugEnvSugarLevel = 0.0, sugEnvSpiceLevel = 0.0 }
        runEnvironmentM $ changeCellAtM cellCoord cellHarvested
       
        -- NOTE: at the moment harvesting SPICE does not influence the polution
        let pol = sugarLevelCell * polutionHarvestFactor 
        agentPoluteCellM pol (cellCoord, cellHarvested)

agentAgeingM :: Double -> State SugarScapeAgentOut ()
agentAgeingM newAge =
    do
        updateDomainStateM (\s -> s { sugAgAge = newAge })

        whenM dieFromAgeM $ 
            do
                -- birthNewAgentM
                passWealthOnM
                agentDiesM

birthNewAgentM :: State SugarScapeAgentOut ()
birthNewAgentM = 
    do
        newAgentId <- agentIdM -- NOTE: we keep the old id
        newAgentCoord <- findUnoccpiedRandomPositionM
        newAgentDef <- runAgentRandomM $ randomAgent (newAgentId, newAgentCoord) sugarScapeAgentBehaviour sugarScapeAgentConversation
        createAgentM newAgentDef

    where
        findUnoccpiedRandomPositionM :: State SugarScapeAgentOut EnvCoord
        findUnoccpiedRandomPositionM =
            do
                env <- environmentM
                (c, coord) <- runAgentRandomM $ (randomCell env)

                ifThenElse (cellOccupied c) findUnoccpiedRandomPositionM (return coord)
                
dieFromAgeM :: State SugarScapeAgentOut Bool
dieFromAgeM = 
    do
        age <- domainStateFieldM sugAgAge
        maxAge <- domainStateFieldM sugAgMaxAge
        return $ age > maxAge
------------------------------------------------------------------------------------------------------------------------
-- AGENT-BEHAVIOUR NON-MONADIC 
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Chapter II: Life And Death On The Sugarscape
------------------------------------------------------------------------------------------------------------------------
agentDies :: SugarScapeAgentOut -> SugarScapeAgentOut
agentDies = unoccupyPosition . kill

passWealthOn :: SugarScapeAgentOut -> SugarScapeAgentOut
passWealthOn a
    | null childrenIds = a
    | otherwise = broadcastMessage a (InheritSugar childrenSugarShare) childrenIds
    where
        s = aoState a
        sugarLevel = sugAgSugarLevel s

        childrenIds = sugAgChildren s
        childrenCount = length childrenIds
        childrenSugarShare = sugarLevel / (fromRational $ toRational $ fromIntegral childrenCount)

unoccupyPosition ::  SugarScapeAgentOut -> SugarScapeAgentOut
unoccupyPosition a = a { aoEnv = env' }
    where
        (cellCoord, cell) = agentCellOnPos a
        cellUnoccupied = cell { sugEnvOccupier = Nothing }
        env' = changeCellAt (aoEnv a) cellCoord cellUnoccupied

starvedToDeath :: SugarScapeAgentOut -> Bool
starvedToDeath a = noSugar || noSpice
    where
        noSugar = (sugAgSugarLevel $ aoState a) <= 0
        noSpice = (sugAgSpiceLevel $ aoState a) <= 0

agentMetabolism :: SugarScapeAgentOut -> SugarScapeAgentOut
agentMetabolism a 
    | starvedToDeath a1 = agentDies a1
    | otherwise = a1
    where
        s = aoState a
        (sugarMetab, spiceMetab) = metabolismAmount s

        newSugarLevel = max 0 ((sugAgSugarLevel s) - sugarMetab)
        newSpiceLevel = max 0 ((sugAgSpiceLevel s) - spiceMetab)

        a0 = updateDomainState a (\s -> s { sugAgSugarLevel = newSugarLevel,
                                        sugAgSpiceLevel = newSpiceLevel })

        -- NOTE: for now the metabolism (and harvest) of spice does not cause any polution
        pol = sugarMetab * polutionMetabolismFactor
        cell = agentCellOnPos a0
        a1 = agentPoluteCell pol cell a0

agentNonCombatMove :: SugarScapeAgentOut -> SugarScapeAgentOut
agentNonCombatMove a
    | null unoccupiedCells = agentStayAndHarvest a
    | otherwise = agentMoveAndHarvestCell a' cellCoord
    where
        cellsInSight = agentLookout a
        unoccupiedCells = filter (cellUnoccupied . snd) cellsInSight

        refCoord = aoEnvPos a
        bestCells = selectBestCells bestMeasureSugarLevel refCoord unoccupiedCells
        ((cellCoord, _), a') = agentPickRandom a bestCells

agentMoveAndHarvestCell :: SugarScapeAgentOut -> EnvCoord -> SugarScapeAgentOut
agentMoveAndHarvestCell a cellCoord = a1
    where
        a0 = agentHarvestCell a cellCoord
        a1 = agentMoveTo a0 cellCoord

agentStayAndHarvest :: SugarScapeAgentOut -> SugarScapeAgentOut
agentStayAndHarvest a = agentHarvestCell a cellCoord
    where
        (cellCoord, _) = agentCellOnPos a

agentPoluteCell :: Double -> (EnvCoord, SugarScapeEnvCell) -> SugarScapeAgentOut -> SugarScapeAgentOut
agentPoluteCell polutionIncrease (cellCoord, cell) a 
    | polutionEnabled = a { aoEnv = env }
    | otherwise = a
    where
        cellAfterPolution = cell {
            sugEnvPolutionLevel = polutionIncrease + (sugEnvPolutionLevel cell)
        }
        env = changeCellAt (aoEnv a) cellCoord cellAfterPolution

agentHarvestCell  :: SugarScapeAgentOut -> EnvCoord -> SugarScapeAgentOut
agentHarvestCell a cellCoord = a2
    where
        cell = cellAt (aoEnv a) cellCoord

        sugarLevelCell = sugEnvSugarLevel cell
        sugarLevelAgent = sugAgSugarLevel $ aoState a
        newSugarLevelAgent = sugarLevelCell + sugarLevelAgent

        spiceLevelCell = sugEnvSpiceLevel cell
        spiceLevelAgent = sugAgSpiceLevel $ aoState a
        newSpiceLevelAgent = spiceLevelCell + spiceLevelAgent

        a0 = updateDomainState a (\s -> s { sugAgSugarLevel = newSugarLevelAgent,
                                        sugAgSpiceLevel = newSpiceLevelAgent })

        cellHarvested = cell { sugEnvSugarLevel = 0.0,
                                 sugEnvSpiceLevel = 0.0 }
        env = changeCellAt (aoEnv a0) cellCoord cellHarvested
        a1 = a0 { aoEnv = env }

        -- NOTE: at the moment harvesting SPICE does not influence the polution
        pol = sugarLevelCell * polutionHarvestFactor 
        a2 = agentPoluteCell pol (cellCoord, cellHarvested) a1

agentMoveTo :: SugarScapeAgentOut -> EnvCoord -> SugarScapeAgentOut
agentMoveTo a cellCoord = a0 { aoEnvPos = cellCoord, aoEnv = env }
    where
        a0 = unoccupyPosition a
        cell = cellAt (aoEnv a0) cellCoord
        cellOccupied = cell { sugEnvOccupier = Just (cellOccupier (aoId a0) (aoState a0))}
        env = changeCellAt (aoEnv a0) cellCoord cellOccupied


agentLookout :: SugarScapeAgentOut -> [(EnvCoord, SugarScapeEnvCell)]
agentLookout a = zip visionCoordsWrapped visionCells
    where
        env = aoEnv a
        aPos = aoEnvPos a
        n = envNeighbourhood env
        vis = sugAgVision $ aoState a

        -- TODO: put this logic into environment.hs
        visionCoordsDeltas = foldr (\v acc -> acc ++ (neighbourhoodScale n v)) [] [1 .. vis]
        visionCoords = neighbourhoodOf aPos visionCoordsDeltas
        visionCoordsWrapped = wrapCells (envLimits env) (envWrapping env) visionCoords
        visionCells = cellsAt env visionCoordsWrapped

agentAgeing :: Double -> SugarScapeAgentOut -> SugarScapeAgentOut
agentAgeing newAge a
    | dieFromAge a = agentDies $ passWealthOn a' -- $ birthNewAgent a
    | otherwise = a'
    where
        a' = updateDomainState a (\s -> s { sugAgAge = newAge })

birthNewAgent :: SugarScapeAgentOut -> SugarScapeAgentOut
birthNewAgent a = createAgent a1 newAgentDef
    where
        newAgentId = aoId a                                 -- NOTE: we keep the old id
        (newAgentCoord, a0) = findUnoccpiedRandomPosition a
        (newAgentDef, a1) = runAgentRandom a0
            (randomAgent (newAgentId, newAgentCoord) sugarScapeAgentBehaviour sugarScapeAgentConversation)

        findUnoccpiedRandomPosition :: SugarScapeAgentOut -> (EnvCoord, SugarScapeAgentOut)
        findUnoccpiedRandomPosition a
            | cellOccupied c = findUnoccpiedRandomPosition a'
            | otherwise = (coord, a')
            where
                ((c, coord), a') = runAgentRandom a (randomCell (aoEnv a))
                
dieFromAge :: SugarScapeAgentOut -> Bool
dieFromAge a = age > maxAge
    where
        s = aoState a
        age = sugAgAge s
        maxAge = sugAgMaxAge s
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- CHAPTER III: Sex, Culture, And Conflict: The Emergence Of History
------------------------------------------------------------------------------------------------------------------------
agentSex :: SugarScapeAgentOut -> SugarScapeAgentOut
agentSex a
    | isFertile s = agentMatingConversation nids nncsUnoccupied a
    | otherwise = a
    where
        s = aoState a
        pos = aoEnvPos a
        env = aoEnv a

        neighbourCells = neighbours env pos
        nids = neighbourIds a

        -- NOTE: this calculates the cells which are in the initial neighbourhood and in the neighbourhood of all the neighbours
        nncsDupl = foldr (\(coord, _) acc -> (neighbours env coord) ++ acc) neighbourCells neighbourCells
        -- NOTE: the nncs are not unique, remove duplicates
        nncsUnique = nubBy (\(coord1, _) (coord2, _) -> (coord1 == coord2)) nncsDupl
        nncsUnoccupied = filter (isNothing . sugEnvOccupier . snd) nncsUnique

        agentMatingConversation :: [AgentId]
                                        -> [(EnvCoord, SugarScapeEnvCell)]
                                        -> SugarScapeAgentOut
                                        -> SugarScapeAgentOut
        agentMatingConversation [] _ a = conversationEnd a
        agentMatingConversation _ [] a = conversationEnd a
        agentMatingConversation (receiverId:otherAis) allCoords@((coord, cell):cs) a
            | satisfiesWealthForChildBearing s = conversation a (receiverId, m) agentMatingConversationsReply
            | otherwise = conversationEnd a
            where
                s = aoState a
                m =  MatingRequest (sugAgGender $ s) --trace ("MatingRequest to " ++ (show receiverId)) MatingRequest (sugAgGender $ s)

                agentMatingConversationsReply :: SugarScapeAgentOut
                                                    -> Maybe (AgentMessage SugarScapeMsg)
                                                    -> SugarScapeAgentOut
                agentMatingConversationsReply a Nothing = agentMatingConversation otherAis allCoords a  -- NOTE: the target was not found or does not have a handler, continue with the next
                agentMatingConversationsReply a (Just (_, MatingReplyNo)) = agentMatingConversation otherAis allCoords a
                agentMatingConversationsReply a (Just (senderId, (MatingReplyYes otherTup))) = 
                    conversation a3 (receiverId, (MatingChild newBornId)) (\a' _ -> agentMatingConversation otherAis cs a')
                    
                    where
                        s = aoState a
                        initialSugarEndow = sugAgSugarInit s
                        sugarLevel = sugAgSugarLevel s

                        mySugarContribution = initialSugarEndow / 2.0
                        mySugarMetab = sugAgSugarMetab s
                        mySpiceMetab = sugAgSpiceMetab s
                        myVision = sugAgVision s
                        myCulturalTag = sugAgCulturalTag s
                        myImmuneSysBorn = sugAgImmuneSysBorn s

                        newBornId = senderId * aoId a   -- TODO: this is a real problem: which ids do we give our newborns?

                        (newBornDef, a0) = runAgentRandom a
                            (createNewBorn 
                                (newBornId, coord)
                                (mySugarContribution, mySugarMetab, mySpiceMetab, myVision, myCulturalTag, myImmuneSysBorn)
                                otherTup)

                        env = aoEnv a0
                        cell' = cell { sugEnvOccupier = Just (cellOccupier newBornId (adState newBornDef))}
                        env' = changeCellAt env coord cell'

                        a1 = a0 { aoEnv = env' }
                        a2 = updateDomainState a1 (\s -> s { sugAgSugarLevel = sugarLevel - mySugarContribution,
                                                        sugAgChildren = newBornId : (sugAgChildren s)})
                        a3 = createAgent a2 newBornDef

                agentMatingConversationsReply a (Just (_, _)) = agentMatingConversation otherAis allCoords a  -- NOTE: unexpected/MatingChildAck reply, continue with the next

createNewBorn :: (AgentId, EnvCoord)
                    -> (Double, Double, Double, Int, SugarScapeCulturalTag, SugarScapeImmuneSystem)
                    -> (Double, Double, Double, Int, SugarScapeCulturalTag, SugarScapeImmuneSystem)
                    -> Rand StdGen SugarScapeAgentDef
createNewBorn idCoord
                (sugEndowFather, sugarMetabFather, spiceMetabFather, visionFather, cultureFather, immuneSysBornFather)
                (sugEndowMother, sugarMetabMother, spiceMetabMother, visionMother, cultureMother, immuneSysBornMother) =
    do
        newBornSugarMetab <- crossover (sugarMetabFather, sugarMetabMother)
        newBornSpiceMetab <- crossover (spiceMetabFather, spiceMetabMother)
        newBornVision <- crossover (visionFather, visionMother)
        newBornCulturalTag <- crossoverBools cultureFather cultureMother
        newBornImmuneSystem <- crossoverBools immuneSysBornFather immuneSysBornMother

        let newBornSugarEndow = sugEndowFather + sugEndowMother

        newBornDef <- randomAgent
                            idCoord
                            sugarScapeAgentBehaviour
                            sugarScapeAgentConversation

        let newBornState' = (adState newBornDef) { sugAgSugarMetab = newBornSugarMetab,
                                                   sugAgSpiceMetab = newBornSpiceMetab,
                                                   sugAgVision = newBornVision,
                                                   sugAgSugarInit = newBornSugarEndow,
                                                   sugAgCulturalTag = newBornCulturalTag,
                                                   sugAgTribe = calculateTribe newBornCulturalTag,
                                                   sugAgImmuneSys = newBornImmuneSystem,
                                                   sugAgImmuneSysBorn = newBornImmuneSystem,
                                                   sugAgDiseases = [] }

        return newBornDef { adState = newBornState' }

excessAmountToChildBearing :: SugarScapeAgentState -> Double
excessAmountToChildBearing s = currSugar - initSugar
    where
        currSugar = sugAgSugarLevel s
        initSugar = sugAgSugarInit s

satisfiesWealthForChildBearing :: SugarScapeAgentState -> Bool
satisfiesWealthForChildBearing s = excessAmount >= 0
    where
        excessAmount = excessAmountToChildBearing s

isFertile :: SugarScapeAgentState -> Bool
isFertile s = withinRange age fertilityAgeRange
    where
        age = sugAgAge s
        fertilityAgeRange = sugAgFertAgeRange s

tooOldForChildren :: SugarScapeAgentState -> Bool
tooOldForChildren s = age > fertilityAgeMax 
    where
        age = sugAgAge s
        (_, fertilityAgeMax) = sugAgFertAgeRange s

withinRange :: (Ord a) => a -> (a, a) -> Bool
withinRange a (l, u) = a >= l && a <= u

inheritSugar :: SugarScapeAgentIn -> SugarScapeAgentOut -> SugarScapeAgentOut
inheritSugar ain a = onMessage ain inheritSugarAction a
    where
        inheritSugarAction :: SugarScapeAgentOut -> AgentMessage SugarScapeMsg -> SugarScapeAgentOut
        inheritSugarAction a (_, (InheritSugar sug)) = updateDomainState a (\s -> s { sugAgSugarLevel = (sugAgSugarLevel s) + sug})
        inheritSugarAction a _ = a

handleMatingConversation :: (SugarScapeAgentGender)
                                -> SugarScapeAgentIn
                                -> (SugarScapeMsg, SugarScapeAgentIn)
handleMatingConversation otherGender ain 
    | isFertile s &&
        satisfiesWealthForChildBearing s &&
        differentGender = (MatingReplyYes (mySugarContribution, mySugarMetab, mySpiceMetab, myVision, myCulturalTag, myImmuneSysBorn), ain')
    | otherwise = (MatingReplyNo, ain)
    where
        s = aiState ain
        myGender = sugAgGender s
        differentGender = myGender /= otherGender

        -- NOTE: to be fertile an agent must have at least as much sugar as initially endowed, therefore it cannot go negative
        initialSugarEndow = sugAgSugarInit s
        sugarLevel = sugAgSugarLevel s
        mySugarContribution = initialSugarEndow / 2.0
        mySugarMetab = sugAgSugarMetab s
        mySpiceMetab = sugAgSpiceMetab s
        myVision = sugAgVision s
        myCulturalTag = sugAgCulturalTag s
        myImmuneSysBorn = sugAgImmuneSysBorn s

        s' = s { sugAgSugarLevel = sugarLevel - mySugarContribution }
        ain' = ain { aiState = s'}



agentCultureContact :: SugarScapeAgentIn -> SugarScapeAgentOut -> SugarScapeAgentOut
agentCultureContact ain a = broadcastMessage a' (CulturalContact culturalTag) nids 
    where
        a' = onMessage ain cultureContactAction a
        nids = neighbourIds a'
        culturalTag = sugAgCulturalTag $ aoState a'

        cultureContactAction :: SugarScapeAgentOut -> AgentMessage SugarScapeMsg -> SugarScapeAgentOut
        cultureContactAction a (_, (CulturalContact tagActive)) = 
                updateDomainState a' (\s -> s { sugAgCulturalTag = agentTag',
                                            sugAgTribe = tribe})
            where
                s = aoState a
                agentTag = sugAgCulturalTag s
                (agentTag', a') = runAgentRandom a (cultureContact tagActive agentTag)
                tribe = calculateTribe agentTag'
        cultureContactAction a _ = a

agentKilledInCombat :: SugarScapeAgentIn -> SugarScapeAgentOut -> SugarScapeAgentOut
agentKilledInCombat ain a = onMessage ain killedInCombatAction a
    where
        killedInCombatAction :: SugarScapeAgentOut -> AgentMessage SugarScapeMsg -> SugarScapeAgentOut
        killedInCombatAction a (_, KilledInCombat) = kill a -- NOTE: don't unoccupie position (as in agentdies) because it is occupied by the killer already
        killedInCombatAction a _ = a

agentCombatMove :: SugarScapeAgentOut -> SugarScapeAgentOut
agentCombatMove a 
    | null targetCells = agentStayAndHarvest a
    | otherwise = if vulnerableToRetaliation payoff a' then agentStayAndHarvest a' else moveAndHarvestBestCell bestCell a'
    where
        s = aoState a
        agentPos = aoEnvPos a
        myTribe = sugAgTribe s
        myWealth = sugAgSugarLevel s 

        cellsInSight = agentLookout a
        targetCells = filter (filterTargetCell occupierCombatable) cellsInSight
        targeCellsWithPayoff = map cellPayoff targetCells

        cellsSortedByPayoff = sortBy (\c1 c2 -> compare (snd c2) (snd c1)) targeCellsWithPayoff
        bestCellPayoff = snd $ head cellsSortedByPayoff
        bestCells = filter ((==bestCellPayoff) . snd) cellsSortedByPayoff

        shortestdistanceManhattanBestCells = sortBy (\c1 c2 -> compare (distanceManhattan agentPos (fst . fst $ c1)) (distanceManhattan agentPos (fst . fst $ c2))) bestCells
        shortestdistanceManhattan = distanceManhattan agentPos (fst . fst $ head shortestdistanceManhattanBestCells)
        bestShortestdistanceManhattanCells = filter ((==shortestdistanceManhattan) . (distanceManhattan agentPos) . fst . fst) shortestdistanceManhattanBestCells

        (bestCell@((_,_), payoff), a') = agentPickRandom a bestShortestdistanceManhattanCells
        
        -- NOTE: calculate if retalion is possible: is there an agent of the other tribe in my vision which is wealthier AFTER i have preyed on the current one?
        -- TODO: this is not very well specified in the SugarScape book. we don't know the vision of the other agent, and its information we should not have access to
        vulnerableToRetaliation :: Double -> SugarScapeAgentOut -> Bool
        vulnerableToRetaliation payoff a = (not . null) retaliatingCells
            where
                sugarLevelAgent = sugAgSugarLevel $ aoState a
                futureSugarLevel = (payoff + sugarLevelAgent)

                cellsInSight = agentLookout a
                retaliatingCells = filter (filterTargetCell (occupierRetaliator futureSugarLevel)) cellsInSight

        moveAndHarvestBestCell :: ((EnvCoord, SugarScapeEnvCell), Double) -> SugarScapeAgentOut -> SugarScapeAgentOut
        moveAndHarvestBestCell ((cellCoord, cell), payoff) a 
            | cellOccupied cell = killOccupierOfCell a'' cell
            | otherwise = a''
                where
                    sugarLevelAgent = sugAgSugarLevel $ aoState a
                    newSugarLevelAgent = (payoff + sugarLevelAgent)

                    a' = unoccupyPosition $ updateDomainState a (\s -> s { sugAgSugarLevel = newSugarLevelAgent })

                    cellHarvestedAndOccupied = cell {
                            sugEnvSugarLevel = 0.0,
                            sugEnvOccupier = Just (cellOccupier (aoId a') (aoState a')),
                            sugEnvPolutionLevel = 0
                    }
                            
                    env = changeCellAt (aoEnv a') cellCoord cellHarvestedAndOccupied
                    a'' = a' { aoEnvPos = cellCoord, aoEnv = env }

        killOccupierOfCell :: SugarScapeAgentOut -> SugarScapeEnvCell -> SugarScapeAgentOut
        killOccupierOfCell a cell = sendMessage a (occupierId, KilledInCombat)
            where
                occupier = fromJust $ sugEnvOccupier cell
                occupierId = sugEnvOccId occupier 

        filterTargetCell :: (SugarScapeEnvCellOccupier -> Bool) -> (EnvCoord, SugarScapeEnvCell) -> Bool
        filterTargetCell f (coord, cell) = maybe True f mayOccupier
            where
                mayOccupier = sugEnvOccupier cell

        occupierCombatable :: SugarScapeEnvCellOccupier -> Bool
        occupierCombatable occupier = differentTribe && lessWealthy
            where
                otherTribe = sugEnvOccTribe occupier
                otherWealth = sugEnvOccWealth occupier
                differentTribe = otherTribe /= myTribe
                lessWealthy = otherWealth <myWealth 

        occupierRetaliator :: Double -> SugarScapeEnvCellOccupier -> Bool
        occupierRetaliator referenceWealth occupier = differentTribe && moreWealthy
            where
                otherTribe = sugEnvOccTribe occupier
                otherWealth = sugEnvOccWealth occupier
                differentTribe = otherTribe /= myTribe
                moreWealthy = otherWealth > referenceWealth 

        cellPayoff :: (EnvCoord, SugarScapeEnvCell) -> ((EnvCoord, SugarScapeEnvCell), Double)
        cellPayoff (c, cell) = ((c, cell), payoff)
            where
                mayOccupier = sugEnvOccupier cell
                sugarLevel = sugEnvSugarLevel cell
                payoff = maybe sugarLevel (\occupier -> sugarLevel + (min combatReward (sugEnvOccWealth occupier))) mayOccupier
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- Chapter IV: Sugar and Spice - Trade Comes to the Sugarscape
------------------------------------------------------------------------------------------------------------------------
agentTrading :: SugarScapeAgentOut -> SugarScapeAgentOut
agentTrading a = agentTradingConversation nids a
    where
        nids = neighbourIds a

        agentTradingConversation :: [AgentId]
                                    -> SugarScapeAgentOut
                                    -> SugarScapeAgentOut
        agentTradingConversation [] a = conversationEnd a
        agentTradingConversation (receiverId:otherAis) a = conversation a (receiverId, m) agentTradingConversationsReply
            where
                mrsSelf = agentMRS $ aoState a
                m = TradingOffer mrsSelf

                agentTradingConversationsReply :: SugarScapeAgentOut
                                                    -> Maybe (AgentMessage SugarScapeMsg)
                                                    -> SugarScapeAgentOut
                agentTradingConversationsReply a Nothing = agentTradingConversation otherAis a 
                agentTradingConversationsReply a (Just (_, TradingRefuse)) = agentTradingConversation otherAis a
                agentTradingConversationsReply a (Just (_, (TradingTransact _))) = agentTradingConversation otherAis a -- NOTE: other agent has transacted, continue with next
                agentTradingConversationsReply a (Just (senderId, (TradingAccept mrsOther))) 
                    | welfareIncreases = conversation aAfterTrade (senderId, TradingTransact mrsSelf) agentTradingConversationsReply
                    | otherwise = agentTradingConversation otherAis a 
                    where
                        welfareIncreases = agentTradeIncreaseWelfare s mrsOther
                        s = aoState a
                        s' = agentTradeExchange s mrsOther
                        aAfterTrade = a { aoState = s' }

-- NOTE: we ignore cross-over trades which is forbidden in the SugarScape-Book. We claim in our implementation it is not a problem as it works different.
--       also agents move on in the next step and won't be neighbours anyway, so a cross-over would not really become a problem in a way as Epstein and Axtell said it would create infinite recursion
--       which probably would occur in their oo-implementation because of direct method-calls
handleTradingOffer :: Double
                        -> SugarScapeAgentIn
                        -> (SugarScapeMsg, SugarScapeAgentIn)
handleTradingOffer mrsOther ain 
    | welfareIncreases = (TradingAccept mrsSelf, ain)     -- This makes the agent better off
    | otherwise = (TradingRefuse, ain)                      -- This trade would make the agent worse off, refuse the trade
    where
        s = aiState ain
        mrsSelf = agentMRS s
        welfareIncreases = agentTradeIncreaseWelfare s mrsOther

handleTradingTransact :: Double
                            -> SugarScapeAgentIn
                            -> (SugarScapeMsg, SugarScapeAgentIn)
handleTradingTransact mrsOther ain = (TradingTransact mrsOther, ainAfterTrade) -- NOTE: simply reply with the same transaction-message
    where
        s = aiState ain
        s' = agentTradeExchange s mrsOther
        ainAfterTrade = ain { aiState = s' }

agentTradeIncreaseWelfare :: SugarScapeAgentState -> Double -> Bool
agentTradeIncreaseWelfare s mrsOther = (newWelfare > currentWelfare)
    where
        mrsSelf = agentMRS s
        exchangeTup = sugarSpiceExchange mrsOther mrsSelf
        currentWelfare = agentWelfare s
        newWelfare = agentWelfareChange s exchangeTup

agentTradeExchange :: SugarScapeAgentState -> Double -> SugarScapeAgentState
agentTradeExchange s mrsOther = sAfterTrade -- trace ("Trade: mrsSelf = " ++ (show mrsSelf) ++ " mrsOther = " ++ (show mrsOther) ++ ", sugarChange = " ++ (show sugarChange) ++ " spiceChange = " ++ (show spiceChange) ) 
    where
        mrsSelf = agentMRS s
        (sugarChange, spiceChange) = sugarSpiceExchange mrsOther mrsSelf

        sugarLevel = sugAgSugarLevel s
        spiceLevel = sugAgSpiceLevel s

        sAfterTrade  = s { sugAgSugarLevel = sugarLevel + sugarChange, sugAgSpiceLevel = spiceLevel + spiceChange }
 
agentMRS :: SugarScapeAgentState -> Double
agentMRS s = (w2 * m1) / (w1 * m2)
    where
        m1 = sugAgSugarMetab s
        m2 = sugAgSpiceMetab s

        w1 = sugAgSugarLevel s
        w2 = sugAgSpiceLevel s

-- NOTE: this returns the sugar-to-spice exchanges from the view-point of self
sugarSpiceExchange :: Double -> Double -> (Double, Double)
sugarSpiceExchange mrsOther mrsSelf 
    -- NOTE: if mrsOther is larger than mrsSelf then Other values sugar more and is willing to exchange it for spice
        -- Other takes (+) sugar and gives spice
        -- Self takes (+) spice and gives (-) sugar
    | (mrsOther > mrsSelf) && (price > 1) = ((-1.0), price)
    | (mrsOther > mrsSelf) && (price <= 1) = ((-invPrice), 1.0)

    -- NOTE: if mrsSelf is larger than mrsOther then Self values sugar more and is willing to exchange it for spice
        -- Self takes sugar and gives spice
        -- Other takes spice and gives sugar
    | (mrsOther <= mrsSelf) && (price > 1) = (1.0, (-price)) 
    | (mrsOther <= mrsSelf) && (price <= 1) = (invPrice, (-1.0))
    where
        price = tradingPrice mrsOther mrsSelf
        invPrice = 1 / price

tradingPrice :: Double -> Double -> Double
tradingPrice mrsA mrsB = sqrt $ mrsA * mrsB

agentWelfare :: SugarScapeAgentState -> Double
agentWelfare s = agentWelfareChange s (0, 0)

agentWelfareChange :: SugarScapeAgentState -> (Double, Double) -> Double
agentWelfareChange s (sugarChange, spiceChange) = ((w1 + sugarChange)**(m1/mT)) * ((w2 + spiceChange)**(m2/mT))
    where
        m1 = sugAgSugarMetab s
        m2 = sugAgSpiceMetab s
        mT = m1 + m2

        w1 = sugAgSugarLevel s
        w2 = sugAgSpiceLevel s

agentCredit :: SugarScapeAgentIn -> SugarScapeAgentOut -> SugarScapeAgentOut
agentCredit ain a = agentRequestCredit $ agentCheckCreditPaybackDue $ agentCreditPaybackIncoming ain $ agentCreditDeathIncoming ain a

-- NOTE: for now only sugar is lended & borrowed, no spice
agentRequestCredit :: SugarScapeAgentOut -> SugarScapeAgentOut
agentRequestCredit a
    | hasNeighbours = agentCreditConversation nids a
    | otherwise = a
    where
        s = aoState a
        nids = neighbourIds a
        hasNeighbours = (not $ null nids)

        agentCreditConversation :: [AgentId]
                                    -> SugarScapeAgentOut
                                    -> SugarScapeAgentOut
        agentCreditConversation [] a = conversationEnd a
        agentCreditConversation (receiverId:otherAis) a 
            | isPotentialBorrower s = conversation a (receiverId, CreditRequest) agentCreditConversationsReply
            | otherwise = conversationEnd a
            where
                agentCreditConversationsReply :: SugarScapeAgentOut
                                                    -> Maybe (AgentMessage SugarScapeMsg)
                                                    -> SugarScapeAgentOut
                agentCreditConversationsReply a Nothing = agentCreditConversation otherAis a
                agentCreditConversationsReply a (Just (_, CreditRequestRefuse)) = agentCreditConversation otherAis a 
                agentCreditConversationsReply a (Just (lenderId, CreditOffer credit)) = agentCreditConversation otherAis aAfterBorrowing
                    where
                        s = aoState a
                        age = sugAgAge s

                        (faceValue, creditDuration, creditInterestRate) = credit
                        creditDueAge = age + creditDuration 

                        creditInfo = (lenderId, creditDueAge, credit)
                        aAfterBorrowing = updateDomainState a (\s -> s { sugAgSugarLevel = sugAgSugarLevel s + faceValue,
                                                                    sugAgBorrowingCredits = creditInfo : sugAgBorrowingCredits s })

-- NOTE: if a borrower dies: notify the lenders so they know they take a loss (remove it from open credits)
-- NOTE: if a lender dies: notify the borrowers so they know they don't have to pay back
-- NOTE that we don't implement the inheritance-rule for loans
agentDeathHandleCredits :: SugarScapeAgentOut -> SugarScapeAgentOut
agentDeathHandleCredits a = aNotifiedBorrowers
    where
        s = aoState a
        lenderIds = map (\(lid, _, _) -> lid) (sugAgBorrowingCredits s)
        borrowerIds = sugAgLendingCredits s
        
        aNotifiedLenders = broadcastMessage a CreditBorrowerDied lenderIds
        aNotifiedBorrowers = broadcastMessage aNotifiedLenders CreditLenderDied borrowerIds

agentCreditDeathIncoming :: SugarScapeAgentIn -> SugarScapeAgentOut -> SugarScapeAgentOut
agentCreditDeathIncoming ain a = onMessage ain creditDeathAction a
    where
        creditDeathAction :: SugarScapeAgentOut -> AgentMessage SugarScapeMsg -> SugarScapeAgentOut
        creditDeathAction a (borrowerId, CreditBorrowerDied) = borrowerDied a borrowerId
        creditDeathAction a (lenderId, CreditLenderDied) = lenderDied a lenderId
        creditDeathAction a _ = a

        -- NOTE: the borrower could have borrowed multiple times from this lender, remove ALL ids
        borrowerDied :: SugarScapeAgentOut -> AgentId -> SugarScapeAgentOut
        borrowerDied a borrowerId = a' 
            where
                s = aoState a
                borrowers = sugAgLendingCredits s
                borrowersRemoved = filter (/=borrowerId) borrowers
                a' = updateDomainState a (\s -> s { sugAgLendingCredits = borrowersRemoved } )

        -- NOTE: the lender could have lended multiple times to this borrower, remove ALL credits
        lenderDied :: SugarScapeAgentOut -> AgentId -> SugarScapeAgentOut
        lenderDied a lenderId = a' 
            where
                s = aoState a
                borrowedCredits = sugAgBorrowingCredits s
                borrowersRemoved = filter (\(lId, _, _) -> lId /= lenderId) borrowedCredits
                a' = updateDomainState a (\s -> s { sugAgBorrowingCredits = borrowersRemoved } )

agentCreditPaybackIncoming :: SugarScapeAgentIn -> SugarScapeAgentOut -> SugarScapeAgentOut
agentCreditPaybackIncoming ain a = onMessage ain creditPaybackAction a
    where
        creditPaybackAction :: SugarScapeAgentOut -> AgentMessage SugarScapeMsg -> SugarScapeAgentOut
        creditPaybackAction a (_, (CreditPaybackHalf amount)) = halfCreditPayback a amount
        creditPaybackAction a (borrowerId, (CreditPaybackFull amount)) = fullCreditPayback a borrowerId amount
        creditPaybackAction a _ = a

        -- NOTE: in this case we don't remove the borrower because it has not yet payed back the whole credit
        halfCreditPayback :: SugarScapeAgentOut -> Double -> SugarScapeAgentOut
        halfCreditPayback = agentChangeSugarWealth 

        -- NOTE: in this case we just remove the first borrower-id we find. It is possible that this lender has lended multiple times to the borrower but this doesnt matter in this case
        fullCreditPayback :: SugarScapeAgentOut -> AgentId -> Double -> SugarScapeAgentOut
        fullCreditPayback a borrowerId amount = agentChangeSugarWealth a' amount
            where
                s = aoState a
                borrowers = sugAgLendingCredits s
                borrowersFirstRemoved = delete borrowerId borrowers
                a' = updateDomainState a (\s -> s { sugAgLendingCredits = borrowersFirstRemoved } )

agentChangeSugarWealth :: SugarScapeAgentOut -> Double -> SugarScapeAgentOut
agentChangeSugarWealth a amount = updateDomainState a (\s -> s { sugAgSugarLevel = newWealth } )
    where
        s = aoState a
        wealth = sugAgSugarLevel s 
        newWealth = wealth + amount

agentCheckCreditPaybackDue :: SugarScapeAgentOut -> SugarScapeAgentOut
agentCheckCreditPaybackDue a = aAfterPayback
    where
        s = aoState a
        borrowingCredits = sugAgBorrowingCredits s 

        (a', borrowingCredits') = foldr agentCheckCreditPaybackAux (a, []) borrowingCredits
        aAfterPayback = updateDomainState a' (\s -> s { sugAgBorrowingCredits = borrowingCredits'})

        agentCheckCreditPaybackAux :: SugarScapeCreditInfo -> (SugarScapeAgentOut, [SugarScapeCreditInfo]) -> (SugarScapeAgentOut, [SugarScapeCreditInfo])
        agentCheckCreditPaybackAux creditInfo@(lenderId, ageDue, credit) (a, accCredits) 
            | creditDue = (a, accCredits)
            | otherwise = (a, creditInfo : accCredits)
            where
                s = aoState a
                age = sugAgAge s
                creditDue = ageDue >= age

                paybackCredit :: (SugarScapeAgentOut, [SugarScapeCreditInfo])
                paybackCredit 
                    | fullPaybackPossible = (aAfterPayback, accCredits)
                    | otherwise = (aAfterPayback, newCreditInfo : accCredits)
                    where
                        (faceValue, creditDuration, creditInterestRate) = credit

                        wealth = sugAgSugarLevel s
                        dueAmount = faceValue + (faceValue * (creditInterestRate / 100))
                        fullPaybackPossible = wealth >= paybackAmount

                        paybackAmount = if fullPaybackPossible then paybackAmount else wealth * 0.5
                        paybackMessage = if fullPaybackPossible then (CreditPaybackFull paybackAmount) else (CreditPaybackHalf paybackAmount)

                        newCredit = (faceValue - paybackAmount, creditDuration, creditInterestRate)
                        newCreditInfo = (lenderId, age + creditDuration, newCredit)

                        aReducedWealth = agentChangeSugarWealth a paybackAmount
                        aAfterPayback = sendMessage aReducedWealth (lenderId, paybackMessage)

handleCreditRequest :: SugarScapeAgentIn -> AgentId -> (SugarScapeMsg, SugarScapeAgentIn)
handleCreditRequest ain borrowerId
    | isLender = (CreditOffer credit, ainAfterCreditOffer)
    | otherwise = (CreditRequestRefuse, ain)
    where
        mayFaceValue = potentialLender s
        isLender = isJust mayFaceValue
        
        faceValue = fromJust mayFaceValue
        credit = (faceValue, lendingCreditDuration, lendingCreditInterestRate)

        s = aiState ain
        s' = s { sugAgSugarLevel = (sugAgSugarLevel s) - faceValue,
                sugAgLendingCredits = borrowerId : (sugAgLendingCredits s) }
        ainAfterCreditOffer = ain { aiState = s' }

potentialLender :: SugarScapeAgentState -> Maybe Double
potentialLender s
    | tooOldForChildren s = Just $ half (sugAgSugarLevel s)
    | isFertile s = fertileLending s
    | otherwise = Nothing
    where
        fertileLending :: SugarScapeAgentState -> Maybe Double
        fertileLending s 
            | excessAmount > 0 = Just excessAmount
            | otherwise = Nothing
            where
                excessAmount = excessAmountToChildBearing s

        half x = x * 0.5

isPotentialBorrower :: SugarScapeAgentState -> Bool
isPotentialBorrower s 
    | isFertile s && (not $ satisfiesWealthForChildBearing s) = True
    | otherwise = False

-- NOTE: haven't implemented "On the Evolution of Foresight"
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- Chapter V: Disease Processes
------------------------------------------------------------------------------------------------------------------------
isDiseased :: SugarScapeAgentState -> Bool
isDiseased s = not $ null (sugAgDiseases s)

agentDiseaseContact :: SugarScapeAgentIn -> SugarScapeAgentOut -> SugarScapeAgentOut
agentDiseaseContact ain a = onMessage ain diseaseContactAction a
    where
        diseaseContactAction :: SugarScapeAgentOut -> AgentMessage SugarScapeMsg -> SugarScapeAgentOut
        diseaseContactAction a (_, (DiseaseContact d)) = updateDomainState a (\s -> s { sugAgDiseases = d : (sugAgDiseases s) } )
        diseaseContactAction a _ = a

agentDiseasesTransmit :: SugarScapeAgentOut -> SugarScapeAgentOut
agentDiseasesTransmit a  
    | (isDiseased s) && hasNeighbours = sendMessages a msgs
    | otherwise = a
    where
        s = aoState a
        nids = neighbourIds a
        hasNeighbours = not $ null nids

        neighbourCount = length nids
        diseases = sugAgDiseases $ aoState a
        (randDisease, a') = agentPickRandomMultiple a diseases neighbourCount
        msgs = map (\(receiverId, disease) -> (receiverId, DiseaseContact disease)) (zip nids randDisease)

agentImmunize :: SugarScapeAgentOut -> SugarScapeAgentOut
agentImmunize a = updateDomainState a (\s -> s { sugAgImmuneSys = immuneSystem',
                                            sugAgDiseases = diseases' })
    where
        s = aoState a
        immuneSystem = sugAgImmuneSys s
        diseases = sugAgDiseases s

        (immuneSystem', diseases') = foldr agentImmunizeAux (immuneSystem, []) diseases

        agentImmunizeAux :: SugarScapeDisease -> (SugarScapeImmuneSystem, [SugarScapeDisease]) -> (SugarScapeImmuneSystem, [SugarScapeDisease])
        agentImmunizeAux disease (imSys, accDis) 
            | minHam == 0 = (imSys, accDis)
            | otherwise = (imSys', disease : accDis)
            where
                dLen = length disease

                hd = calculateHammingDistances imSys disease
                mi@(minHam, minHamIdx) = findMinWithIdx hd
 
                minSubImmSys = take dLen (drop minHamIdx imSys)

                tagIdx = findFirstDiffIdx minSubImmSys disease
                globalIdx = minHamIdx + tagIdx
                imSys' = flipBoolAtIdx imSys globalIdx

agentDiseaseProcesses :: SugarScapeAgentIn -> SugarScapeAgentOut -> SugarScapeAgentOut
agentDiseaseProcesses ain a = agentImmunize $ agentDiseasesTransmit $ agentDiseaseContact ain a
------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------
-- GENERAL AGENT-RELATED
------------------------------------------------------------------------------------------------------------------------
sugarScapeAgentConversation :: SugarScapeAgentConversation

sugarScapeAgentConversation ain (_, (MatingRequest tup)) = Just $ handleMatingConversation tup ain
sugarScapeAgentConversation ain (_, (MatingChild childId)) = Just (MatingChildAck, ain')
    where
        s = aiState ain
        s' = s { sugAgChildren = childId : (sugAgChildren s)}
        ain' = ain { aiState = s' }

sugarScapeAgentConversation ain (_, (TradingOffer mrs)) = Just $ handleTradingOffer mrs ain
sugarScapeAgentConversation ain (_, (TradingTransact mrs)) = Just $ handleTradingTransact mrs ain

sugarScapeAgentConversation ain (borrowerId, CreditRequest) = Just $ handleCreditRequest ain borrowerId

sugarScapeAgentConversation _ _ = Nothing


neighbourIds :: SugarScapeAgentOut -> [AgentId]
neighbourIds a = map (sugEnvOccId . fromJust . sugEnvOccupier . snd) occupiedCells
    where
        env = aoEnv a
        pos = aoEnvPos a
        neighbourCells = neighbours env pos
        occupiedCells = filter (isJust . sugEnvOccupier . snd) neighbourCells

sugarScapeAgentBehaviourFunc :: Double -> SugarScapeAgentIn -> SugarScapeAgentOut -> SugarScapeAgentOut 
sugarScapeAgentBehaviourFunc age ain a = do     
                                            let a0 = agentKilledInCombat ain a 
                                            if isDead a0 then
                                                agentDeathHandleCredits a0
                                                else
                                                    do
                                                        let a1 = agentAgeing age a0
                                                        if isDead a1 then
                                                            agentDeathHandleCredits a1
                                                            else
                                                                do
                                                                    let a2 = agentMetabolism a1
                                                                    if isDead a2 then
                                                                        agentDeathHandleCredits a2
                                                                        else 
                                                                            do
                                                                                let a3 = agentNonCombatMove a2
                                                                                let a4 = inheritSugar ain a3
                                                                                -- let a5 = agentCultureContact ain a4
                                                                                -- let a6 = agentSex a5
                                                                                -- let a7 = agentTrading a5
                                                                                let a8 = agentCredit ain a4
                                                                                --let a9 = agentDiseaseProcesses ain a4
                                                                                a8


sugarScapeAgentBehaviour :: SugarScapeAgentBehaviour
sugarScapeAgentBehaviour = proc ain ->
    do
        age <- time -< 0

        let a = agentOutFromIn ain
        returnA -< sugarScapeAgentBehaviourFunc age ain a

------------------------------------------------------------------------------------------------------------------------