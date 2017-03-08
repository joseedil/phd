{-# LANGUAGE Arrows #-}
module Agent.YampaSwitchTest where

import FRP.Yampa
import FRP.Yampa.Switches
import qualified Data.Map as Map
import Data.List

type TestInput = Int
type TestOutput = String

testSF_0 = simpleSF 0
testSF_col = map simpleSF [0..10]

------------------------------------------------------------------------------------------------------------------------
-- SEQ-TEST: running a collection of signalfunctions sequentially
------------------------------------------------------------------------------------------------------------------------
seqTest :: IO ()
seqTest = do
            let sts = take 10 $ samplingTimes 0.0 1.0
            let finalMap = embed seqRunSfs (0, sts)
            mapM putStrLn []
            return ()

seqRunSfs :: SF Int (Map.Map Int (SF TestInput TestOutput, TestInput, TestOutput))
seqRunSfs = seqRunSfs' seqMap
    where
        n = length testSF_col
        indices = [0..n-1]
        initInputs = [0..n-1]
        initOutputs = replicate n "Nothing"
        zipQuadruple = zip4 indices testSF_col initInputs initOutputs
        seqMap = foldl (\accMap (idx, sf, i, o) -> Map.insert idx (sf, i, o) accMap) Map.empty zipQuadruple

seqRunSfs' :: Map.Map Int (SF TestInput TestOutput, TestInput, TestOutput) -> SF Int (Map.Map Int (SF TestInput TestOutput, TestInput, TestOutput))
seqRunSfs' seqMap = proc idx ->
                        do
                            kSwitch
                                (sfs !! idx)
                                (seqRunSfsTrigger seqMap idx >>> notYet)
                                (seqRunSfsContinuation seqMap idx) -< (is !! idx)

seqRunSfsTrigger :: Map.Map Int (SF TestInput TestOutput, TestInput, TestOutput) -> Int -> SF (TestInput, TestOutput) (Event [TestOutput])
seqRunSfsTrigger seqMap idx = proc (i, o) ->
                                do
                                    let e = Event (o : osAcc)
                                    returnA -< e

-- TODO: replace executedSf at
seqRunSfsContinuation :: Map.Map Int (SF TestInput TestOutput, TestInput, TestOutput) -> Int -> SF TestInput TestOutput -> [TestOutput] -> SF [TestInput] [TestOutput]
seqRunSfsContinuation seqMap idx executedSf evtData = seqRunSfs' allSfs
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- SWITCH TEST
------------------------------------------------------------------------------------------------------------------------
testSwitch :: IO ()
testSwitch = do
                let sts = take 10 $ samplingTimes 0.0 1.0
                let os = embed (kSwitchTest testSF_0) (42, sts)
                mapM putStrLn os
                return ()

samplingTimes :: Double -> Double -> [(DTime, Maybe a)]
samplingTimes t dt = (t', Nothing) : (samplingTimes t' dt)
    where
        t' = t + dt


simpleSF :: Int -> SF TestInput TestOutput
simpleSF offset = proc i ->
                    do
                        let i' = i + offset
                        t <- time -< 0
                        let o = "i = " ++ (show i') ++ " at t = " ++ (show t)
                        returnA -< (show o)
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- d/SWITCH
------------------------------------------------------------------------------------------------------------------------
-- NOTE: a d/ does not prevent one from recurring when using initial SF as function to switch into
-- NOTE: to be able to switch back into the same original SF use >>> notYet
switchTest :: SF TestInput TestOutput
switchTest = dSwitch
                switchTrigger
                switchContinuation

switchTrigger:: SF TestInput (TestOutput, Event String)
switchTrigger = proc i ->
                        do
                            t <- time -< 0
                            let o = show t
                            returnA -< (o, Event "Event Occured")

switchContinuation :: String -> SF TestInput TestOutput
switchContinuation evtData = proc i ->
                                  do
                                    let o = evtData ++ " with input: " ++ (show i)
                                    returnA -< o
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- d/rSwitch
------------------------------------------------------------------------------------------------------------------------
-- NOTE: to be able to switch back into the same original SF use >>> notYet
rSwitchTest :: SF TestInput TestOutput
rSwitchTest = proc i ->
                do
                    let iTup = (i+1, NoEvent) -- Event simpleSF)
                    drSwitch testSF_0 -< iTup
------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------
-- d/kSwitch
------------------------------------------------------------------------------------------------------------------------
-- NOTE: to be able to switch back into the same original SF use >>> notYet
kSwitchTest :: SF TestInput TestOutput -> SF TestInput TestOutput
kSwitchTest sf = proc i ->
                do
                    let i' = i + 1
                    kSwitch
                        sf
                        (kSwitchTrigger >>> notYet)
                        kSwitchContinuation -< i'

kSwitchTrigger :: SF (TestInput, TestOutput) (Event String)
kSwitchTrigger = proc (i, o) ->
                        do
                            let e = Event ("Event Switch with input = " ++ (show i) ++ " and output " ++ o)
                            returnA -< e

kSwitchContinuation :: SF TestInput TestOutput -> String -> SF TestInput TestOutput
kSwitchContinuation oldSf evtData = kSwitchTest oldSf
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- parB
------------------------------------------------------------------------------------------------------------------------
parBTest :: SF TestInput [TestOutput]
parBTest = proc i ->
                do
                    os <- parB testSF_col -< i
                    returnA -< os
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- d/pSwitchB
------------------------------------------------------------------------------------------------------------------------
pSwitchBTest :: SF TestInput [TestOutput]
pSwitchBTest = proc i ->
                    do
                        pSwitchB
                            testSF_col
                            (pSwitchBTrigger >>> notYet)
                            pSwitchBContinuation -< i

pSwitchBTrigger :: SF (TestInput, [TestOutput]) (Event String)
pSwitchBTrigger = proc (i, os) ->
                    do
                        returnA -< Event "pSwitchBTrigger"

pSwitchBContinuation :: [SF TestInput TestOutput] -> String -> SF TestInput [TestOutput]
pSwitchBContinuation sfs evtData = proc i ->
                                        do
                                            pSwitchBTest -< i
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- par
------------------------------------------------------------------------------------------------------------------------
parTest :: SF TestInput [TestOutput]
parTest = proc i ->
            do
                par
                    parRoute
                    testSF_col -< i

parRoute :: TestInput -> [sf] -> [(TestInput, sf)]
parRoute i sfs = zip is sfs
    where
        n = length sfs
        is = replicate n i
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- d/pSwitch
------------------------------------------------------------------------------------------------------------------------
pSwitchTest :: SF TestInput [TestOutput]
pSwitchTest = proc i ->
                do
                    pSwitch
                        pSwitchRoute
                        testSF_col
                        (pSwitchTrigger >>> notYet)
                        pSwitchContinuation -< i

pSwitchRoute :: TestInput -> [sf] -> [(TestInput, sf)]
pSwitchRoute = parRoute

pSwitchTrigger :: SF (TestInput, [TestOutput]) (Event String)
pSwitchTrigger = proc (i, os) ->
                    do
                        returnA -< Event "pSwitchTrigger"

pSwitchContinuation :: [SF TestInput TestOutput] -> String -> SF TestInput [TestOutput]
pSwitchContinuation sfs evtData = pSwitchTest
------------------------------------------------------------------------------------------------------------------------