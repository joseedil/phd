module Main where

import           AgentZero.Run
import           Conversation.Run
import           DoubleAuction.Run
import           FrSIRSNetwork.Run
import           FrSIRSSpatial.Run
import           HeroesCowards.Run
import           PolicyEffects.Run
import           PrisonersDilemma.Run
import           RecursiveABS.Run
import           Segregation.Run
import           SIRS.Run
import           SysDynSIR.Run
import           Wildfire.Run

{-
import           SugarScape.Run
-}

{-
    TODOs
    - write a agentBehaviour SF which can 'freeze' the state of an agent so we don't have do drag it always in AgentIn/Out around?
        -> what happens then in the case of a conversation? the receiving agent cannot change the state? We would need to run the conversation within the original agentbehaviour 
    - instead of generic sequential-iteration implement specific for FrABS: this can prevent forwarding environments to all (but is this really expensive? due to haskells lazyness this should never matter)
    
    - implement Graph-Renderer
    - run all rendering-stuff in IO?
    - AgentRenderer: Circle/Rectangle as shapes
    - GlossSimulator: pass Background-color as additional parameters (use currying)

    - clean-up
        - imports: no unused imports
        - lint: must be clear of warnings
        - warnings: compilation with -w must show no warnings at all
        
    - comment haskell code
-}

main :: IO ()
main = runAgentZeroWithRendering
    -- runPolicyEffectsWithRendering
    -- runFrSIRSNetworkStepsAndWriteToFile -- runFrSIRSNetworkWithRendering -- runFrSIRSNetworkReplicationsAndWriteToFile
    -- runSysDynSIRStepsAndWriteToFile
    -- runFrSIRSSpatialWithRendering -- runFrSIRSSpatialStepsAndPrint -- runFrSIRSSpatialStepsAndWriteToFile
    -- runDoubleAuctionSteps
    -- runSIRSWithRendering
    -- runPDWithRendering
    -- runWildfireWithRendering
    -- runAgentZeroWithRendering
    -- runSugarScapeWithRendering
    -- runConversationSteps
    -- runMetaABSStepsAndPrint
    -- runSegWithRendering
