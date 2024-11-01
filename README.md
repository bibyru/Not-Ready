## 📔 Game Description
![Gif of Not Ready gameplay](https://github.com/bibyru/bibyru/blob/main/Gifs/NotReady.gif)

In **Not Ready**, players must secure a location where bad guys exist.

**Not Ready** is a 3D FPS game that’s intended to be the low-poly version of Ready or Not.

Download game [here](https://github.com/bibyru/Not-Ready/releases/).


<br/>

## 🎮 Game Controls
This game uses mouse and keyboard as inputs.
| **Key binding** | **Action** |
| :- | :- |
| Esc | Restart level |
| W, A, S, D | Move |
| Mouse | Aim |
| LMB, C, V | Shoot |
| RMD | ADS |
| E, Mouse Thumb 1 | Interact |
| R | Reload |
| MMB | Flashlight |
| Space | Ready/unready gun |
| F | Yell at enemy |
| X | Change fire mode |
| Alt + W, A, S, D | Freelean |


<br/>

## 📝 Project Info
This project was developed using Godot v4.2.2.
| **Role** | **Credit** | **Development Time** |
| :- | :- | :- |
| Game programmer | bibyru (Ruby) | 4 days |
| Project lead | bibyru (Ruby) | 7 days |
| Visual designer | bibyru (Ruby) | 2 day |
| Game designer | bibyru (Ruby) | 1 day |
| Sound designer | bibyru (Ruby) | 1 day |


<br/>

## ⭐ Scripts and Features
| **Script** | **Description** |
| :- | :- |
| `Enemy.gd` | Script for enemy mechanics, such as alerting other enemies, aim and shoot player, and surrender chances. |
| `Enemy_Alerted.gd` | Script for enemy's collision when detecting player. |
| `Enemy_Interact.gd` | Script for when player interacts with enemy. |
| `Gun.gd` | Script for gun to run animations. |
| `GunMag.gd` | Script for gun to set gun position. |
| `Interact_Animation.gd` | Script for animating door icons. |
| `Interact_Door.gd` | Script for doors to opening door and icon visibility. |
| `Interact_Prompt.gd` | Script for icons to call functions. |
| `Manager.gd` | Singleton script to pause the game, initialize the display, and restart level. |
| `Object_Light.gd` | Script for light to change emission material on and off. |
| `Rigid_Shot.gd` | Script for bullet. |
| `Script_Freelean.gd` | Script for player to lean. |
| `Script_Gun.gd` | Script for gun to manage itself, like changing fire mode and reloading. |
| `Script_Interact.gd` | Script for player to interact with other objects. |
| `Script_Player.gd` | Script for player to manage itself, like changing hand position, subtracting hp, and manage inputs. |
| `Script_PlayVoice.gd` | Script for player to emit sound. |
| `Script_UI.gd` | Script for UI to animate labels for gun ammo count and gun fire mode |
| `Trajectory.gd` | Script for bullet trajectory. |


<br/>

## 📁 File Description
```
├── Not-Ready
    ├── Bread      # for level lightning bake
    ├── Prefabs    # for prefabs used in a level
    ├── Sauce      # for all game assets
        ├── Animations    # stores all game animations
        ├── Meshes        # stores all meshes in the game
        ├── MP3           # stores all sounds in the game
        ├── Stuff2D       # stores all 2D assets in the game
    ├── Scene      # for all game levels
    ├── Scripts    # for all game scripts
    ├── db40d04acc3ee29e754f91b8881dcfe4b516ef15  # godot addon folder: Godot Jolt v12
```


<br/>

## 💿 How to open in Game Engine
1. Download all files.
2. Extract to **Folder A** (an empty folder).
3. Launch Godot v4.2.2.
4. Press **Import** and select `project.godot` in **Folder A**.
