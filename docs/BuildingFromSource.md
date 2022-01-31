# Building *Friday Night Brocken* from source
So you want to build this from source, eh? Aight, bet. Just follow the instructions below to get started.

## What you'll need
- The most recent version of [Haxe](https://haxe.org/download/). 4.1.5 misses some features used by engines like Psych Engine
- [HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/)
- A PC with at least ~30GB of free space. (This is necessary if you're planning to compile for Windows, as Microsoft's SDKs are large).
- [git-scm](https://git-scm.com/downloads) (Necessary for installing libraries for this shit)
- (Optional, but recommended for ease of editing the dependencies) [Visual Studio Code](https://code.visualstudio.com/)

# Let's get started!
Alright, got everything you need? Great. Let's begin.

## Step 0: Install Haxe/HaxeFlixel
To get started, let's install Haxe and HaxeFlixel. If you already have these installed, skip this step.
Download the latest version of Haxe for your platform.

![](docs/img/haxePage.png)

Once that's installed, get HaxeFlixel installed with the following commands:
```
haxelib setup
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib run lime setup flixel
haxelib run lime setup
haxelib install flixel-tools
haxelib run flixel-tools setup
haxelib install linc_luajit
```

##Step 1: CLONE THIS FUCKIN REPOSITORY IF YOU HAVEN'T LMAO
I'M NOT EVEN JOKING. **CLONE IT!**