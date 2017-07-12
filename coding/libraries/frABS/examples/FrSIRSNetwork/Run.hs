module FrSIRSNetwork.Run ( 
    runFrSIRSNetworkWithRendering,
    runFrSIRSNetworkStepsAndRender,

    runFrSIRSNetworkStepsAndWriteToFile,
    runFrSIRSNetworkReplicationsAndWriteToFile
  ) where

import FrSIRSNetwork.Init
import FrSIRSNetwork.Model
import FrSIRSNetwork.Renderer as Renderer
import Utils.Sirs

import FRP.FrABS

winSize = (800, 800)
winTitle = "FrSIRS Network (2D Rendering)"
frequency = 0

updateStrat = Parallel
shuffleAgents = False

rngSeed = 42

agentDimensions = (32, 32)
agentCount = fst agentDimensions * snd agentDimensions

numInfected = 1

samplingTimeDelta = 0.1
steps = 1000

replCfg = ReplicationConfig {
    replCfgCount = 8,
    replCfgAgentReplicator = defaultAgentReplicator,
    replCfgEnvReplicator = defaultEnvReplicator
}

completeNetwork = Complete agentCount
erdosRenyiNetwork = ErdosRenyi agentCount 0.2
barbasiAlbertNetwork = BarbasiAlbert barbasiAlbertM0 barbasiAlbertM agentCount
barbasiAlbertM0 = 3
barbasiAlbertM = 1

network = barbasiAlbertNetwork

runFrSIRSNetworkWithRendering :: IO ()
runFrSIRSNetworkWithRendering =
    do
        params <- initSimulation updateStrat Nothing shuffleAgents (Just rngSeed)
        
        (initAdefs, initEnv) <- createFrSIRSNetworkNumInfected agentDimensions numInfected network
        -- (initAdefs, initEnv) <- createFrSIRSNetworkRandInfected agentDimensions initialInfectionProb network
        
        simulateAndRender initAdefs
                            initEnv
                            params
                            samplingTimeDelta
                            frequency
                            winTitle
                            winSize
                            Renderer.renderFrame
                            Nothing

runFrSIRSNetworkStepsAndRender :: IO ()
runFrSIRSNetworkStepsAndRender =
    do
        params <- initSimulation updateStrat Nothing shuffleAgents (Just rngSeed)
        
        (initAdefs, initEnv) <- createFrSIRSNetworkNumInfected agentDimensions numInfected network
        --(initAdefs, initEnv) <- createFrSIRSNetworkRandInfected agentDimensions initialInfectionProb network
        
        simulateStepsAndRender initAdefs
                            initEnv
                            params
                            samplingTimeDelta
                            steps
                            winTitle
                            winSize
                            Renderer.renderFrame

runFrSIRSNetworkStepsAndWriteToFile :: IO ()
runFrSIRSNetworkStepsAndWriteToFile =
    do
        params <- initSimulation updateStrat Nothing shuffleAgents (Just rngSeed)
        
        (initAdefs, initEnv) <- createFrSIRSNetworkNumInfected agentDimensions numInfected network
        --(initAdefs, initEnv) <- createFrSIRSNetworkRandInfected agentDimensions initialInfectionProb network

        let asenv = processSteps initAdefs initEnv params samplingTimeDelta steps
        let dynamics = map (calculateDynamics . fst) asenv
        let fileName = "frSIRSNetworkDynamics_" 
                        ++ show agentDimensions ++ "agents_" 
                        ++ show steps ++ "steps_" 
                        ++ show samplingTimeDelta ++ "dt.m"

        writeSirsDynamicsFile fileName steps samplingTimeDelta 0 dynamics

runFrSIRSNetworkReplicationsAndWriteToFile :: IO ()
runFrSIRSNetworkReplicationsAndWriteToFile =
    do
        params <- initSimulation updateStrat Nothing shuffleAgents (Just rngSeed)
        
        (initAdefs, initEnv) <- createFrSIRSNetworkNumInfected agentDimensions numInfected network
        --(initAdefs, initEnv) <- createFrSIRSNetworkRandInfected agentDimensions initialInfectionProb network

        let assenv = runReplications initAdefs initEnv params samplingTimeDelta steps replCfg
        let replicationDynamics = map calculateSingleReplicationDynamic assenv
        let dynamics = sirsDynamicsReplMean replicationDynamics


        let fileName = "frSIRSNetworkDynamics_" 
                        ++ show agentDimensions ++ "agents_" 
                        ++ show steps ++ "steps_" 
                        ++ show samplingTimeDelta ++ "dt_" 
                        ++ show (replCfgCount replCfg) ++ "replications.m"

        writeSirsDynamicsFile fileName steps samplingTimeDelta (replCfgCount replCfg) dynamics

-------------------------------------------------------------------------------
-- UTILS
-------------------------------------------------------------------------------
calculateDynamics :: [FrSIRSNetworkAgentOut] -> (Double, Double, Double)
calculateDynamics aos = (susceptibleCount, infectedCount, recoveredCount)
    where
        susceptibleCount = fromIntegral $ length $ filter ((Susceptible==) . aoState) aos
        infectedCount = fromIntegral $ length $ filter ((Infected==) . aoState) aos
        recoveredCount = fromIntegral $ length $ filter ((Recovered==) . aoState) aos

        totalCount = susceptibleCount + infectedCount + recoveredCount :: Double

        susceptibleRatio = susceptibleCount / totalCount
        infectedRatio = infectedCount / totalCount 
        recoveredRatio = recoveredCount / totalCount

calculateSingleReplicationDynamic :: [([FrSIRSNetworkAgentOut], FrSIRSNetworkEnvironment)] -> [(Double, Double, Double)]
calculateSingleReplicationDynamic = map (calculateDynamics . fst)