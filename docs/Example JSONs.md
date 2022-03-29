# Example JSONs

The jsons folder contains a few json files with examples of (almost) every type of JSON found within Psych Engine (and by extension, Emo Engine).

### Included JSONs

== Week JSON ==

- Includes all fields

- The `"REMOVE_THIS_BEFORE_YOU_SAVE"` field at the bottom of the file can be removed safely. It is not in the game.

== Character JSON ==

- Includes all fields

- I suggest setting up offsets *in-game* after saving the JSON. This way you can accurately offset the animations you add.

- For each animation you add, set it up like this:

```json
    {
        "offsets": [
            0,
            0
        ],
        "indices": [],
        "fps": 24,
        "anim": "idle",
        "loop": true,
        "name": "idle like ya mom"
    },
```

**It is important to include the comma after the `}`, unless the animation is at the end of the `animations` array!**

## OST JSON

- This includes all *required* fields. Optional fields are in this file.

- At the moment, this JSON needs to be placed in `mods/ost`, or `mods/Your Mod/ost` to be registered. You can find your OSTs by going to Options > Extra > Listen to OST.

Example JSON with all fields:
```json
{
    "songName": "No Phones",
    "displayName": "No Phones?!",
    "defaultOpponent": "bandu",
    "defaultBf": "dave",
    "dadIcon": "bandu",
    "bfIcon": "dave",
    "hasVoices": true,
    "songColorInfo": {
        "red": 0,
        "green": 255,
        "blue": 0
    },
    "iconChanges": [
        {
            "time_ms": 12000,
            "changeTarget": "bf",
            "newIcon": "expunged-3d"
        }
    ]
}
```

(Note: This does not include the `songColor` array variable mentioned in the typedef. The songColorInfo field can be swapped with songColor if you prefer, but songColorInfo will give you a better chance of the colour you want being shown in the menu.)

== Profile JSON ==

- This includes all fields.

- I'd actually suggest using the in-game profile setup for the profile JSONs.

Example JSON:

```json
{
    "profileName": "Tesla Cvm",
    "saveName": "queenOfRap",
    "profileIcon": "sus",
    "playerBirthday": [
        12,
        8
    ],
    "comment": "GIRL YES!! YOU'RE INVITED TO JIAFEI'S HAUNTED CVM HOUSE! BRING YOUR FAMILY, YOUR OCS, HELL, JUST BRING THE ENTIRE WORLD!!"
}
```