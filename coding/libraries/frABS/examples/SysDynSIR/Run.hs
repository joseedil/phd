module SysDynSIR.Run ( 
    runSysDynSIRStepsAndWriteToFile
  ) where

import SysDynSIR.Init
import SysDynSIR.Model

import Utils.Sirs

import FRP.FrABS

import Data.List

samplingTimeDelta = 0.1
steps = 1000

runSysDynSIRStepsAndWriteToFile :: IO ()
runSysDynSIRStepsAndWriteToFile =
    do
        -- SystemDynamics MUST NOT rely on RNGs at all, so no need to initialize it
        -- SystemDynamics MUST ABSOLUTELY only run Parllel and there is no need to shuffle the agents (=stocks)
        params <- initSimNoEnv Parallel False Nothing

        (initAdefs, initEnv) <- createSysDynSIR
        
        let asenv = processSteps initAdefs initEnv params samplingTimeDelta steps
        let dynamics = map (calculateDynamics . fst) asenv
        let fileName = "sysDynSIRDynamics_" 
                        ++ show totalPopulation ++ "population_"
                        ++ show steps ++ "steps_" 
                        ++ show samplingTimeDelta ++ "dt.m"

        writeSirsDynamicsFile fileName steps samplingTimeDelta 0 dynamics

-------------------------------------------------------------------------------
-- UTILS
-------------------------------------------------------------------------------
-- NOTE: here we rely on the fact the we have exactly three stocks and sort them by their id to access them
--          stock id 0: Susceptible
--          stock id 1: Infectious
--          stock id 2: Recovered
--          the remaining items are the flows
calculateDynamics :: [SysDynSIRObservable] -> (Double, Double, Double)
calculateDynamics unsortedStocks = (susceptibleCount, infectedCount, recoveredCount) -- (susceptibleRatio, infectedRatio, recoveredRatio)
    where
        stocks = sortBy (\s1 s2 -> compare (fst s1) (fst s2)) unsortedStocks
        (susceptibleStock : infectiousStock : recoveredStock : remainingFlows) = stocks

        susceptibleCount = snd susceptibleStock
        infectedCount = snd infectiousStock
        recoveredCount = snd recoveredStock

        totalCount = susceptibleCount + infectedCount + recoveredCount 

        susceptibleRatio = susceptibleCount / totalCount
        infectedRatio = infectedCount / totalCount 
        recoveredRatio = recoveredCount / totalCount