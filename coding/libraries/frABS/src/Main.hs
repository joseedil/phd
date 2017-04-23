module Main where

import SIRS.RunSIRS
import Segregation.SegregationRun
import RecursiveABS.RecursiveABSRun
import SugarScape.SugarScapeRun
import Conversation.ConversationRun
import MessageSampling.MessageSamplingRun

main :: IO ()
main = runSugarScapeWithRendering
{-}
    do
        let ret = testMaybeMonad "Default"
        putStrLn $ show ret
-}
    -- runSugarScapeWithRendering

    -- runMessageSamplingAndPrint
    -- runConversationStepsAndPrint
    -- runSugarScapeWithRendering
    -- runMetaABSStepsAndPrint
    -- runSIRSWithRendering
    -- runSegWithRendering
    -- runSegStepsAndRender
    -- test
    -- testGloss

testMaybeMonad :: String -> Maybe String
testMaybeMonad d =
    do
        i <- maybeFunc1
        b <- maybeFunc2
        s <- maybeFunc3
        return s

maybeFunc1 :: Maybe Int
maybeFunc1 = Just 42

maybeFunc2 :: Maybe Bool
maybeFunc2 = Nothing

maybeFunc3 :: Maybe String
maybeFunc3 = Just "Jonathan"