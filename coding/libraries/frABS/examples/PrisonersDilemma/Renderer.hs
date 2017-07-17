module PrisonersDilemma.Renderer (
    renderPDFrame
  ) where

import FRP.FrABS

import PrisonersDilemma.Model

import qualified Graphics.Gloss as GLO

type PDRenderFrame = RenderFrame PDAgentState PDMsg PDEnvironment
type PDAgentColorer = AgentCellColorer PDAgentState

renderPDFrame :: PDRenderFrame
renderPDFrame = render2dDiscreteFrame 
                    (defaultAgentRenderer pdAgentColor pdCoord)
                    voidEnvironmentRenderer

pdAgentColor :: PDAgentColorer
pdAgentColor PDAgentState { pdCurrAction = curr, pdPrevAction = prev } = agentActionsToColor prev curr

agentActionsToColor :: PDAction -> PDAction -> GLO.Color
agentActionsToColor Cooperator Cooperator = GLO.makeColor (realToFrac 0.0) (realToFrac 0.0) (realToFrac 0.7) 1.0
agentActionsToColor Defector Defector = GLO.makeColor (realToFrac 0.7) (realToFrac 0.0) (realToFrac 0.0) 1.0
agentActionsToColor Defector Cooperator = GLO.makeColor (realToFrac 0.0) (realToFrac 0.4) (realToFrac 0.0) 1.0
agentActionsToColor Cooperator Defector = GLO.makeColor (realToFrac 1.0) (realToFrac 0.9) (realToFrac 0.0) 1.0
