# Quake Rerelease QuakeC Source Code

This repository contains the QuakeC source code for the six codebases that were used in the 2021 re-release of Quake: the base campaign, Scourge of Armagon, Dissolution of Eternity, Dimension of the Machine, Capture the Flag, and Dawn of the Machine. Dimension of the Past shares the same codebase as Dimension of the Machine.

In comparison with the original QuakeC, these codebases have been updated to replace all instances of strings with placeholder strings that can be used for localization. This requires some support on the engine side in order to handle printing messages correctly. There have also been bug fixes and modifications to behaviors from the original game.

These progs also use some advanced QuakeC features that are only available in modern compilers. We recommend using [FTEQCC](https://www.fteqcc.org) for compiling this release.

This code is released under the GPLv2 license. See `COPYING.txt` for more details.

id Software is unable to provide support for this release, however we urge you to take advantage of the depth of community-driven resources already available.