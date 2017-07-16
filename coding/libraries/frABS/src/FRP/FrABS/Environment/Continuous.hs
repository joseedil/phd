module FRP.FrABS.Environment.Continuous (
    Continuous2DDimension,
    Continuous2DCoord,

    Continuous2d (..), -- TODO: hide data-constructor
    Continuous2dNetwork (..),
    
    agentCoordCont2D,
    updateAgentCoordCont2D,
    environmentDimensionsCont2D,

    distanceManhattanCont2D,
    distanceEuclideanCont2D,

    wrapCont2D
  ) where

import FRP.FrABS.Agent.Agent
import FRP.FrABS.Environment.Definitions
import FRP.FrABS.Environment.Network

import Data.List
import Data.Array.IArray
import Control.Monad.Random
import Control.Monad.Trans.State
import qualified Data.Map as Map

type Continuous2DDimension = (Double, Double)
type Continuous2DCoord = Continuous2DDimension

data Continuous2d = Continuous2d {
    envCont2dBehaviour :: Maybe (EnvironmentBehaviour Continuous2d),
    envCont2dDims :: Continuous2DDimension,
    envCont2dWrapping :: EnvironmentWrapping,
    envCont2dRng :: StdGen,
    envCont2dAgentPositions :: Map.Map AgentId Continuous2DCoord
}

data Continuous2dNetwork l = Continuous2dNetwork {
    envCombCont2dNetwork :: Network l,
    envCombCont2d :: Continuous2d
}

createContinuous2d :: Maybe (EnvironmentBehaviour Continuous2d) 
                            -> Continuous2DDimension
                            -> EnvironmentWrapping
                            -> StdGen
                            -> Continuous2d
createContinuous2d beh d w rng = Continuous2d {
                                    envCont2dBehaviour = beh,
                                    envCont2dDims = d,
                                    envCont2dWrapping = w,
                                    envCont2dRng = rng,
                                    envCont2dAgentPositions = Map.empty 
                                }

agentCoordCont2D :: AgentId -> Continuous2d -> Continuous2DCoord
agentCoordCont2D aid e = (0, 0) -- TODO: implement

updateAgentCoordCont2D :: AgentId -> Continuous2DCoord -> Continuous2d -> Continuous2d
updateAgentCoordCont2D aid coord e = e -- TODO: implement

environmentDimensionsCont2D :: Continuous2d -> Continuous2DCoord
environmentDimensionsCont2D e = envCont2dDims e

distanceManhattanCont2D :: Continuous2DCoord -> Continuous2DCoord -> Double
distanceManhattanCont2D (x1, y1) (x2, y2) = (abs (x1 - x2)) + (abs (y1 - y2))

distanceEuclideanCont2D :: Continuous2DCoord -> Continuous2DCoord -> Double
distanceEuclideanCont2D (x1, y1) (x2, y2) = sqrt (xDelta*xDelta + yDelta*yDelta)
    where
        xDelta = x2 - x1
        yDelta = y2 - y1

wrapCont2D :: Continuous2DDimension -> EnvironmentWrapping -> Continuous2DCoord -> Continuous2DCoord
wrapCont2D (maxX, maxY) ClipToMax (x, y) = (max 0 (min x maxX), max 0 (min y maxY))
wrapCont2D l@(maxX, _) WrapHorizontal (x, y)
    | x < 0 = wrapCont2D l WrapHorizontal (x + maxX, y)
    | x >= maxX = wrapCont2D l WrapHorizontal (x - maxX, y)
    | otherwise = (x, y)
wrapCont2D l@(_, maxY) WrapVertical (x, y)
    | y < 0 = wrapCont2D l WrapVertical (x, y + maxY)
    | y >= maxY = wrapCont2D l WrapVertical (x, y - maxY)
    | otherwise = (x, y)
wrapCont2D l WrapBoth coord = wrapCont2D l WrapHorizontal $ wrapCont2D l WrapVertical coord