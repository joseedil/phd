module SugarScape.SugarScapeModel where

-- Project-internal import first
import FrABS.Agent.Agent
import FrABS.Env.Environment

-- Project-specific libraries follow
import FRP.Yampa

-- System imports then
import System.Random
import Control.Monad.Random
import Control.Monad

-- TODO: export dynamics in a text file with matlab format of the data: wealth distribution, number of agents, mean vision/metabolism, mean age,

-- TODO random iteration in sequential
-- TODO implement rules as SF which can be turned on or off
-- TODO formalize rules in my EDSL
-- TODO problem of sugarscape trading in our functional approach: cannot reply immediately thus potentially violating budget constraints. need to solve this e.g. by having a temporary reserved amount "open for transaction"

------------------------------------------------------------------------------------------------------------------------
-- DOMAIN-SPECIFIC AGENT-DEFINITIONS
------------------------------------------------------------------------------------------------------------------------
data SugarScapeAgentGender = Male | Female deriving (Show, Eq)
data SugarScapeTribe = Red | Blue deriving (Show, Eq)

type SugarScapeCulturalTag = [Bool]

data SugarScapeMsg =
    MatingRequest SugarScapeAgentGender
    | MatingReplyNo
    | MatingReplyYes (Double, Double, Int, SugarScapeCulturalTag) -- Sugar-Contribution, Metabolism, Vision
    | MatingChild AgentId
    | MatingChildAck

    | InheritSugar Double

    | CulturalContact SugarScapeCulturalTag

    | KilledInCombat
    
    deriving (Show)

data SugarScapeAgentState = SugarScapeAgentState {
    sugAgMetabolism :: Double,              -- this amount of sugar will be consumed by the agent in each time-step
    sugAgVision :: Int,                     -- the vision of the agent: strongly depends on the type of the environment: Int because its 2d discrete

    sugAgSugarLevel :: Double,              -- the current sugar holdings of the agent, if 0 then the agent starves to death
    sugAgSugarInit :: Double,               -- agent is fertile only when its sugarlevel is GE than its initial endowment

    sugAgMaxAge :: Double,                  -- at this age the agent will die and create a single new random offspring

    sugAgGender :: SugarScapeAgentGender,   -- an agent is either male or female
    sugAgFertAgeRange :: (Double, Double),   -- an agent younger/older than this cannot bear children

    sugAgChildren :: [AgentId],             -- the ids of all the children this agent has born

    sugAgAge :: Double,                     -- the current age of the agent, could be calculated using time in the SF but we need it in the conversations as well, which are not running in the SF

    sugAgCulturalTag :: SugarScapeCulturalTag,  -- the agents cultural tag
    sugAgTribe :: SugarScapeTribe           -- the agents tribe it belongs to according to its cultural tag
} deriving (Show)

data SugarScapeEnvCellOccupier = SugarScapeEnvCellOccupier {
    sugEnvOccId :: AgentId,
    sugEnvOccTribe :: SugarScapeTribe,
    sugEnvOccWealth :: Double
} deriving (Show)

data SugarScapeEnvCell = SugarScapeEnvCell {
    sugEnvSugarCapacity :: Double,
    sugEnvSugarLevel :: Double,
    sugEnvPolutionLevel :: Double,
    sugEnvOccupier :: Maybe SugarScapeEnvCellOccupier
} deriving (Show)

type SugarScapeEnvironment = Environment SugarScapeEnvCell
type SugarScapeEnvironmentBehaviour = EnvironmentBehaviour SugarScapeEnvCell

type SugarScapeAgentDef = AgentDef SugarScapeAgentState SugarScapeMsg SugarScapeEnvCell
type SugarScapeAgentBehaviour = AgentBehaviour SugarScapeAgentState SugarScapeMsg SugarScapeEnvCell
type SugarScapeAgentIn = AgentIn SugarScapeAgentState SugarScapeMsg SugarScapeEnvCell
type SugarScapeAgentOut = AgentOut SugarScapeAgentState SugarScapeMsg SugarScapeEnvCell

type SugarScapeAgentConversation = AgentConversationReceiver SugarScapeAgentState SugarScapeMsg SugarScapeEnvCell
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- MODEL-PARAMETERS
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- CHAPTER II
------------------------------------------------------------------------------------------------------------------------
sugarGrowbackUnits :: Double
sugarGrowbackUnits = 1.0

summerSeasonGrowbackRate :: Double
summerSeasonGrowbackRate = 1.0

winterSeasonGrowbackRate :: Double
winterSeasonGrowbackRate = 8.0

seasonDuration :: Double
seasonDuration = 50.0

sugarCapacityRange :: (Double, Double)
sugarCapacityRange = (0.0, 4.0)

-- NOTE: this is specified in book page 33 where the initial endowments are set to 5-25
sugarEndowmentRange :: (Double, Double)
sugarEndowmentRange = (5.0, 25.0)

metabolismRange :: (Double, Double)
metabolismRange = (1.0, 4.0)

visionRange :: (Int, Int)
visionRange = (1, 6)

ageRange :: (Double, Double)
ageRange = (60, 100)


polutionEnabled :: Bool
polutionEnabled = False

polutionMetabolismFactor :: Double
polutionMetabolismFactor = 1.0

polutionHarvestFactor :: Double
polutionHarvestFactor = 1.0

diffusePolutionTime :: Int
diffusePolutionTime = 12

------------------------------------------------------------------------------------------------------------------------
-- CHAPTER III
------------------------------------------------------------------------------------------------------------------------
childBearingMinAgeRange :: (Double, Double)
childBearingMinAgeRange = (120, 150)

childBearingFemaleMaxAgeRange :: (Double, Double)
childBearingFemaleMaxAgeRange = (40, 50)

childBearingMaleMaxAgeRange :: (Double, Double)
childBearingMaleMaxAgeRange = (50, 60)

sexualReproductionInitialEndowmentRange :: (Double, Double)
sexualReproductionInitialEndowmentRange = (50, 100)

culturalTagLength :: Int
culturalTagLength = 10

combatReward :: Double
combatReward = 2.0 -- replace with huge number e.g. 10^7 for harvesting all the other agents sugar 
------------------------------------------------------------------------------------------------------------------------

cellOccupier :: AgentId -> SugarScapeAgentState -> SugarScapeEnvCellOccupier
cellOccupier aid s = SugarScapeEnvCellOccupier {
                        sugEnvOccId = aid,
                        sugEnvOccTribe = sugAgTribe s,
                        sugEnvOccWealth = sugAgSugarLevel s
                    }

calculateTribe :: SugarScapeCulturalTag -> SugarScapeTribe
calculateTribe tag
    | falseCount >= trueCount = Blue
    | otherwise = Red
    where
        falseCount = length $ filter (==False) tag 
        trueCount = length $ filter (==True) tag 
       
-- NOTE: the tags must have same length, this could be enforced statically through types if we had a dependent type-system
cultureContact :: SugarScapeCulturalTag 
                    -> SugarScapeCulturalTag 
                    -> Rand StdGen SugarScapeCulturalTag
cultureContact tagActive tagPassive = 
    do
        randIdx <- getRandomR (0, tagLength-1)
        return $ flipCulturalTag tagActive tagPassive randIdx
    where
        tagLength = length tagActive
        
-- NOTE: the tags must have same length, this could be enforced statically through types if we had a dependent type-system
flipCulturalTag :: SugarScapeCulturalTag 
                    -> SugarScapeCulturalTag 
                    -> Int 
                    -> SugarScapeCulturalTag
flipCulturalTag tagActive tagPassive idx = map (\(i, a, p) -> if i == idx then a else p) (zip3 [0..len-1] tagActive tagPassive) 
    where
        len = length tagActive

culturalCrossover :: SugarScapeCulturalTag 
                    -> SugarScapeCulturalTag 
                    -> Rand StdGen SugarScapeCulturalTag
culturalCrossover ts1 ts2 = 
    do
        randTags <- replicateM (length ts1) (getRandomR (True, False))
        return $ map (\(t1, t2, randT) -> if t1 == t2 then t1 else randT) (zip3 ts1 ts2 randTags)

crossover :: (a, a) -> Rand StdGen a
crossover (x, y) =
    do
        takeX <- getRandomR (True, False)
        if takeX then
            return x
            else
                return y



randomAgent :: (AgentId, EnvCoord)
                -> SugarScapeAgentBehaviour
                -> SugarScapeAgentConversation
                -> Rand StdGen SugarScapeAgentDef
randomAgent (agentId, coord) beh conv = 
    do
        randMeta <- getRandomR metabolismRange
        randVision <- getRandomR  visionRange
        randSugarEndowment <- getRandomR  sugarEndowmentRange
        randSugarEndowment <- getRandomR  sexualReproductionInitialEndowmentRange
        randMaxAge <- getRandomR  ageRange
        randMale <- getRandomR (True, False)
        randMinFert <- getRandomR childBearingMinAgeRange
        randCulturalTagInf <- getRandoms  
        let randCulturalTag = take culturalTagLength randCulturalTagInf

        let randGender = if randMale then Male else Female
        let fertilityMaxRange = if randMale then childBearingMaleMaxAgeRange else childBearingFemaleMaxAgeRange

        randMaxFert <- getRandomR fertilityMaxRange

        rng <- getSplit

        let s = SugarScapeAgentState {
            sugAgMetabolism = randMeta,
            sugAgVision = randVision,

            sugAgSugarLevel = randSugarEndowment,
            sugAgSugarInit = randSugarEndowment,

            sugAgMaxAge = randMaxAge,

            sugAgGender = randGender,
            sugAgFertAgeRange = (randMinFert, randMaxFert),

            sugAgChildren = [],

            sugAgAge = 0.0,

            sugAgCulturalTag = randCulturalTag,
            sugAgTribe = calculateTribe randCulturalTag
        }

        let adef = AgentDef {
           adId = agentId,
           adState = s,
           adEnvPos = coord,
           adConversation = Just conv,
           adInitMessages = NoEvent,
           adBeh = beh,
           adRng = rng }

        return adef