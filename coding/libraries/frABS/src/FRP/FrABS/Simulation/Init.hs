module FRP.FrABS.Simulation.Init (
    initSimulation,
    initSimNoEnv,
    newAgentId
  ) where

import FRP.FrABS.Agent.Agent
import FRP.FrABS.Simulation.Simulation
import FRP.FrABS.Simulation.Internal
import FRP.FrABS.Environment.Definitions

import Control.Monad.Random
import Control.Concurrent.STM.TVar

initSimulation :: UpdateStrategy
                    -> Maybe (EnvironmentBehaviour e)
                    -> Maybe (EnvironmentCollapsing e)
                    -> Bool
                    -> Maybe Int
                    -> IO (SimulationParams e)
initSimulation updtStrat beh collFunc shuffAs rngSeed = 
    do
        initRng rngSeed

        rng <- getSplit
        agentIdVar <- newTVarIO 0

        return SimulationParams {
            simStrategy = updtStrat,
            simEnvBehaviour = beh,
            simEnvCollapse = collFunc,
            simShuffleAgents = shuffAs,
            simRng = rng,
            simIdGen = agentIdVar
        }

initSimNoEnv :: UpdateStrategy
                -> Bool
                -> Maybe Int
                -> IO (SimulationParams e)
initSimNoEnv updtStrat shuffAs rngSeed = initSimulation updtStrat Nothing Nothing shuffAs rngSeed

newAgentId :: SimulationParams e -> AgentId
newAgentId SimulationParams { simIdGen = idGen } = incrementAtomicallyUnsafe idGen

initRng :: Maybe Int -> IO ()
initRng Nothing = return ()
initRng (Just seed) = setStdGen $ mkStdGen seed