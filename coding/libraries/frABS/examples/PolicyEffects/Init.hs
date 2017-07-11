module PolicyEffects.Init (
    createPolicyEffects
  ) where

import PolicyEffects.Model
import PolicyEffects.Agent

import FRP.Yampa

import FRP.FrABS

import System.Random
import Control.Monad.Random

createPolicyEffects :: (Int, Int) 
                        -> Double 
                        -> NetworkType
                        -> IO ([PolicyEffectsAgentDef], PolicyEffectsEnvironment)
createPolicyEffects dims@(maxX, maxY) initWealth network =  
    do
        rng <- newStdGen
        gr <- evalRandIO $ createAgentNetwork network

        let agentIds = nodesOfNetwork gr
        adefs <- mapM (policyEffectsAgent initWealth) (zip coords agentIds)

        let env = (createEnvironment
                        Nothing
                        dims
                        moore
                        ClipToMax
                        []
                        rng
                        (Just gr))

        return (adefs, env)

    where
        agentCount = maxX * maxY
        coords = [ (x, y) | x <- [0..maxX - 1], y <- [0..maxY - 1]]

policyEffectsAgent :: Double
                        -> (EnvCoord, AgentId)
                        -> IO PolicyEffectsAgentDef
policyEffectsAgent initWealth (coord, agentId) = 
    do
        rng <- newStdGen

        return AgentDef { adId = agentId,
                                adState = initWealth,
                                adBeh = policyEffectsAgentBehaviour,
                                adInitMessages = NoEvent,
                                adConversation = Nothing,
                                adEnvPos = coord,
                                adRng = rng }
------------------------------------------------------------------------------------------------------------------------