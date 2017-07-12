module Wildfire.Init (
    initWildfire
  ) where

import Wildfire.Model
import Wildfire.Agent

import FRP.FrABS

import System.Random
import Control.Monad.Random

initWildfire :: (Int, Int) -> IO ([WildfireAgentDef], WildfireEnvironment)
initWildfire dims@(maxX, maxY) = 
  do
    let coords = [ (x, y) | x <- [0..maxX-1], y <- [0..maxY-1] ]
    let agentCount = maxX * maxY

    let aids = [0..agentCount-1]

    let aidCoordPairs = zip aids coords

    let cells = zip coords aids

    let centerX = floor $ (fromIntegral maxX) * 0.5
    let centerY = floor $ (fromIntegral maxY) * 0.5

    adefs <- mapM (runCreateWildfireIO (centerX, centerY)) aidCoordPairs

    envRng <- newStdGen 
    let env = createEnvironment
                          Nothing
                          dims
                          neumann
                          ClipToMax
                          cells
                          envRng
                          Nothing

    return (adefs, env)

runCreateWildfireIO :: (Int, Int)
                      -> (AgentId, EnvCoord) 
                      -> IO WildfireAgentDef
runCreateWildfireIO center aidCoord@(_, coord) = 
  do
    std <- getStdGen

    let initIgnite = center == coord

    let (adef, std') = runRand (createWildFireAgent
                                    aidCoord
                                    (wildfireAgentLivingBehaviour std)
                                    initIgnite)
                                    std
    setStdGen std'
    return adef