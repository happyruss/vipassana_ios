vipassana_ios
=============

This is the actual code used by the Vipassana App from Guided Meditation Treks! Info about the background of the Vipassana App can be found at http://www.guidedmeditationtreks.com/vipassana.html The only thing not included in this code is the actual audio assets, which are copyright © by the Author, Russell Eric Dobda.

However, this code is open source for a reason -- it allows other meditation practitioners to use it to create their own guided meditation apps. This app provides you with a framework where you can "plug and play" your own audio tracks into it and present your own guided meditations.

Besides providing your own audio, and your own graphics, these are the only code changes you need to do to make this app your own.

1. Pull down the code locally
2. Open it in Xcode
3. Dump your audio assets in the /AudioAssets/ folder in the root (you can have 1 or 2 parts for each meditation... see below for details)
3. Make modifications to TrackTemplateFactory.swift like so:

```
    public static var shared = TrackTemplateFactory()

    let appName = "Vipassana". //<<<< Change this to your own app name
    let requireMeditationsBeDoneInOrder = true //<< true if you want to enforce users go in order
    let appUrl = "http://www.guidedmeditationtreks.com/vipassana" //<< change to your URL
```

Then, do not touch these next few lines of code. The first template is related to the "meditation timer." You will need to provide your own IntroBell.m4a and ClosingBell.m4a files for the timer button, which is not in the list of meditations, but appears next to the title and is meant to give users a 'silent meditation'. All apps should have this:

```
    var trackTemplates = [TrackTemplate]()
    var minimumTrackDuration = 0
    
    public init() {

        trackTemplates.append(TrackTemplate(shortName: "Timer", name: "Timer", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "IntroBell", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "ClosingBell", ofType: "m4a")!)))
```


After the intro bell, you just need to provide track templates for each of your assets, replacing the others that are currently there. 

If your meditation has only one part and is of a fixed length, it looks like the introduction track:

```
        trackTemplates.append(TrackTemplate(shortName: "Introduction", name: "Introduction", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "Introduction", ofType: "m4a")!), part2Url: nil))
```

If you can make your meditation 2 parts, then this allows the user to select the length of their meditation session, and a blank space will be inserted between the two parts. These templates look like this:

```
        trackTemplates.append(TrackTemplate(shortName: "Shamatha", name: "Shamatha", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "01_Shamatha", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "01_Shamatha2", ofType: "m4a")!)))
```

The fields are pretty self explanatory:
- shortName: the name that appears in the button
- name: the name that appears on the meditation screen
- part1Url: the first part
- part2Url: the second part, if applicable.

As far as functionality, that's all you need to change. However...

Please use your own graphics and intro screen!!!!
=================================================

If you decide to use this open source code, DO NOT make it look like it is from Guided Meditation Treks. Make it your own! If you want to give a shout out that you used my code, that's great, but the audio assets are all yours, and if it looks like it's from me, I'll submit a complaint for infringement. This also goes for the assets and the use of the GMT logo. This means, 
1. You should change ALL of the assets located within Assets.xcassets folder to use your own, and change the storyboard to point to YOUR assets, not mine!
2. You MUST change the LaunchScreen.storyboard to make your own splash screen.

If you like the graphic design and UX design in this app, contact their maker, Daniel Boros at http://www.danielboros.com to have him create some assets for you! Please do not re-use the ones in this project, as they are copyright for this project.

Feel free to use any of this code as you see fit, but ....

Failure to respect my copyrights, logos, or designs will result in bad karma!
=============================================================================
