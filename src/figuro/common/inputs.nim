import std/[unicode, sequtils]
import pkg/vmath
import pkg/patty

import nodes/basics
import nodes/render
import uimaths, keys
export uimaths, keys

type
  FrameStyle* {.pure.} = enum
    DecoratedResizable, DecoratedFixedSized, Undecorated, Transparent

  AppWindow* = object
    box*: Box ## Screen size in logical coordinates.
    running*, focused*, minimized*, fullscreen*: bool
    pixelRatio*: float32 ## Multiplier to convert from screen coords to pixels

variantp RenderCommands:
  RenderQuit
  RenderUpdate(n: Renders, window: AppWindow)
  RenderSetTitle(name: string)

variantp SystemEvent:
  # System Events without data
  SysCloseRequest             # Window close requested
  # SysGotFocus                 # Window gained focus
  # SysLostFocus                # Window lost focus
  # SysMinimized                # Window was minimized
  # SysRestored                 # Window was restored (from minimized/maximized)
  # SysMaximized                # Window was maximized (Optional, may be covered by Resized/Restored)
  # # System Events with data
  # SysWindowMoved(pos: Position) # Window moved to new position
  # SysWindowResized(size: Size)  # Window resized to new size

type AppInputs* = object
  empty*: bool
  mouse*: Mouse
  keyboard*: Keyboard

  buttonPress*: UiButtonView
  buttonDown*: UiButtonView
  buttonRelease*: UiButtonView
  buttonToggle*: UiButtonView

  window*: Option[AppWindow]

proc click*(inputs: AppInputs): bool =
  when defined(clickOnDown):
    return MouseButtons * inputs.buttonDown != {}
  else:
    return MouseButtons * inputs.buttonRelease != {}

proc down*(inputs: AppInputs): bool =
  return MouseButtons * inputs.buttonDown != {}

proc release*(inputs: AppInputs): bool =
  return MouseButtons * inputs.buttonRelease != {}

proc scrolled*(inputs: AppInputs): bool =
  inputs.mouse.wheelDelta.x != 0.0'ui

proc dragging*(inputs: AppInputs): bool =
  return MouseButtons * inputs.buttonDown != {}
  return MouseButtons * inputs.buttonRelease != {}
