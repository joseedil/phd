module AgentZero.Run (
    runAgentZeroWithRendering
  ) where

import AgentZero.Init
import AgentZero.Environment
import AgentZero.Renderer as Renderer

import FRP.FrABS

winSize = (800, 800)
winTitle = "Agent_Zero"
updateStrat = Sequential -- NOTE: agent-zero works BOTH for parallel and sequential, parallel is slower because collapsing the environments is a very expensive operation 
envCollapsing = Just agentZeroEnvironmentsCollapse
shuffleAgents = True
rngSeed = 42
samplingTimeDelta = 1.0
frequency = 0

runAgentZeroWithRendering :: IO ()
runAgentZeroWithRendering = 
    do
        params <- initSimulation updateStrat envCollapsing shuffleAgents (Just rngSeed)
        (initAdefs, initEnv) <- initAgentZeroEpstein
        
        simulateAndRender initAdefs
                            initEnv
                            params
                            samplingTimeDelta
                            frequency
                            winTitle
                            winSize
                            Renderer.renderFrame
                            Nothing