module SugarScape.SugarScapeRun (
    runSugarScapeWithRendering
  ) where

import SugarScape.SugarScapeInit
import SugarScape.SugarScapeRenderer as Renderer

import FrABS.Simulation.Simulation
import FrABS.Simulation.SimulationUtils
import FrABS.Rendering.GlossSimulator

import System.Random

winSize = (800, 800)
winTitle = "SugarScape"
rngSeed = 42
agentCount = 400
envSize = (50, 50)
updateStrat = Sequential    -- Sugarscape works ONLY with Sequential AND must be shuffled
envCollapsing = Nothing
shuffleAgents = True        -- Sugarscape works ONLY with Sequential AND must be shuffled
samplingTimeDelta = 1.0
frequency = 0


runSugarScapeWithRendering :: IO ()
runSugarScapeWithRendering = 
    do
        initRng rngSeed
        params <- initSimParams updateStrat envCollapsing shuffleAgents
        (initAdefs, initEnv) <- createSugarScape agentCount envSize params
        
        simulateAndRender initAdefs
                            initEnv
                            params
                            samplingTimeDelta
                            frequency
                            winTitle
                            winSize
                            Renderer.renderFrame
                            Nothing