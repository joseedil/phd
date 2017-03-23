module Segregation.RunSegregation where

import FrABS.Agent.Agent
import FrABS.Simulation.Simulation
import Segregation.Segregation

import FRP.Yampa
import qualified FrABS.Rendering.Agents2DDiscrete as Front
import qualified Graphics.Gloss as GLO
import Graphics.Gloss.Interface.IO.Animate

import Data.IORef
import System.IO
import System.Random

winSize = (800, 800)
winTitle = "Schelling Segregation MetaABS"
renderCircles = True

rngSeed = 42
cells = (50, 50)
parallelStrategyFlag = False -- NOTE: segregation will not give correct result when run with parallel update-strategy


runSegWithRendering :: IO ()
runSegWithRendering = do
                        hSetBuffering stdout NoBuffering
                        hSetBuffering stderr NoBuffering
                        initRng rngSeed
                        (as, env) <- createSegAgentsAndEnv cells

                        putStrLn "dynamics = ["
                        outRef <- (newIORef ([], False)) :: (IO (IORef ([SegAgentOut], Bool)))
                        hdl <- processIOInit as env parallelStrategyFlag (nextIteration outRef)

                        simulateAndRender hdl outRef

nextIteration :: IORef ([SegAgentOut], Bool)
                    -> ReactHandle [AgentIn s m ec] [SegAgentOut]
                     -> Bool
                     -> [SegAgentOut]
                     -> IO Bool
nextIteration outRef _ _ aouts = do
                                    printDynamics outRef aouts
                                    let allHappy = all isHappy aouts
                                    writeIORef outRef (aouts, allHappy)
                                    return allHappy

printDynamics :: IORef ([SegAgentOut], Bool) -> [SegAgentOut] -> IO ()
printDynamics outRef aoutsCurr = do
                                    (aoutsPrev, _) <- readIORef outRef

                                    let maxSimilarity = fromInteger $ fromIntegral totalCount -- NOTE: an agent can reach a maximum of 1.0
                                    let currSimilarity = totalCurrentSimliarity aoutsCurr
                                    let prevSimilarity = totalCurrentSimliarity aoutsPrev
                                    let similarityDelta = currSimilarity - prevSimilarity

                                    let currSimilarityNormalized = currSimilarity / maxSimilarity
                                    let similarityDeltaNormalized = similarityDelta / maxSimilarity


                                    putStrLn (show unhappyFract
                                                ++ "," ++ show currSimilarityNormalized
                                                ++ "," ++ show similarityDeltaNormalized
                                                ++ ";" )
                                    where
                                        (totalCount, happyCount, unhappyCount, unhappyFract) = calculateHappinessStats aoutsCurr

runSegStepsAndRender :: IO ()
runSegStepsAndRender = do
                            hSetBuffering stdout NoBuffering
                            initRng rngSeed
                            (as, env) <- createSegAgentsAndEnv cells

                            let steps = 500
                            let ass = processSteps as env parallelStrategyFlag 1.0 steps
                            let as' = last ass

                            pic <- modelToPicture as'
                            GLO.display (Front.display winTitle winSize) GLO.white pic
                            --mapM (putStrLn . show . aoState) as'

                            return ()

initRng :: Int -> IO StdGen
initRng seed = do
                let g = mkStdGen seed
                setStdGen g
                return g

simulateAndRender :: ReactHandle [AgentIn s m ec] [SegAgentOut] -> IORef ([SegAgentOut], Bool) -> IO ()
simulateAndRender hdl outRef = animateIO (Front.display winTitle winSize)
                                            GLO.black -- GLO.white
                                            (nextFrame hdl outRef)
                                            (\controller -> return () )

nextFrame :: ReactHandle [AgentIn s m ec] [SegAgentOut] -> IORef ([SegAgentOut], Bool) -> Float -> IO Picture
nextFrame hdl outRef dt = do
                            react hdl (1.0, Nothing)  -- NOTE: will result in call to nextIteration
                            (aouts, _) <- readIORef outRef
                            modelToPicture aouts

modelToPicture :: [SegAgentOut] -> IO GLO.Picture
modelToPicture as = do
                        let rcs = map (sirsAgentToRenderCell cells) as
                        return (Front.renderFrame renderCircles rcs winSize cells)

sirsAgentToRenderCell :: (Int, Int) -> SegAgentOut -> Front.RenderCell
sirsAgentToRenderCell (xDim, yDim) a = Front.RenderCell { Front.renderCellCoord = (ax, ay),
                                                        Front.renderCellColor = ss }
    where
        s = aoState a
        (ax, ay) = (segCoord s)
        ss = case (segAgentType s) of
                        Red -> (0.0, 0.6, 0.0)
                        Green -> (0.6, 0.0, 0.0)