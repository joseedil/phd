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
import           SugarScape.Run
import           SysDynSIR.Run
import           Wildfire.Run

{-
    TODOs
    - sugarscape 
        -> explore unit-testing using HUnit and property/specification testing using quickcheck and smallcheck. as testing-framework use tasty
        -> need a mechanism to run chapters / rules separately
        -> reproduce results of all chapters

    - environments
        implement an genericobject-to-position map in continuous2d
            -> supply standard implementations for AgentId:
                -> add / remove / update
                -> find within distance
                -> update by move

        implement standard-cells in discrete2d:
            -> empty / non-empty with single / multiple occupier
            -> supply helper-functions
                -> occupy / unoccupy / isoccupied
                -> allOccupiers
            -> supply functions which construct these discrete2d with standard-cells

    - clean-up
        - imports: no unused imports
        - lint: must be clear of warnings
        - warnings: compilation with -w must show no warnings at all
        
    - comment haskell code
-}

main :: IO ()
main = runSugarScapeWithRendering
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
