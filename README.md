# Cluckabunga
KFD Customization Tool for iOS 16.2-16.5 & 16.6b1

IPA available in the [Releases](https://github.com/leminlimez/Cluckabunga/releases/latest) section.

Support me on [Ko-Fi](https://ko-fi.com/leminlimez).

## Features
- Springboard
    - Hide dock
    - Hide home bar
    - Hide folder backgrounds

- Locks
    - Importing locks from TrollLock
    - Custom number of frames + custom animation speeds (see below)
 
- Explore
    - Find and download themes for locks and passcodes!
    - If you would like to submit your own works, please [join the discord](https://discord.gg/Cowabunga)
 
- Other Tools
    - Custom Fonts
    - Settings App Customizer
    - Apple Cards Changer
    - Passcode Key Changer
 
## Installing
You can install through AltStore, Sideloadly, or Xcode

## Creating Custom Lock Animations
Lock animations are very simple to make. For the frames, each image must be named "trollformation" with a number afterwards (ie. trollformation1.png, trollformation2.png, trollformation3.png...). You can use up to 120 frames, though I am not sure of the exact size limit, which is probably much less.
**If your animation is not exactly 40 frames or you want to customize the display length of each frame, you need to define the animations.** This is very simple to do:
1. Create a json file named `animations.json`
2. Define the values. Format: `"Frame Number": Time Interval`
Example:
```
{
    "1": 0,
    "2": 0.025,
    "10": 0.01,
    "15": 0.025
}
```
**Explanation:**
You do not need to state the length of each frame. The only time that absolutely needs to be defined is the first frame. If you did not set a time for the frame, Cowabunga will use the time from the last frame.
The `Time Interval` is how long the frame stays on the screen for.
**Important:** The frame number must be a string (meaning in quotes) because of how json decoding works.

## Building
Just build like a normal Xcode project. Sign using your own team and bundle identifier. You can also build the IPA file with `ipabuild.sh`.

## Credits
- [Cowabunga](https://github.com/leminlimez/Cowabunga) for a lot of the code.
- [Cardinal](https://github.com/leminlimez/Cardinal) for Card Changer.
- Misaka for offsets.

## Suggestions and support
You can either create an issue on this GitHub repo, or join our [Discord server](https://discord.gg/Cowabunga) where us, or other members, might help you.
