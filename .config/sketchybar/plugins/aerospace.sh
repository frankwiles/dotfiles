#!/bin/sh

WORKSPACE="$(aerospace list-workspaces --focused)"
sketchybar --set "$NAME" label="Workspace: $WORKSPACE"
