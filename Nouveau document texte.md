# 🕹️ Adding hero classes feature

![Godot](https://img.shields.io/badge/Godot-Engine-478CBF?logo=godot-engine&logoColor=white)
![GDScript](https://img.shields.io/badge/GDScript-Language-FFDB4D?logo=godot-engine&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

A scalable, modular player architecture for Godot, designed for multiple
classes and abilities with zero logic duplication.

---

## Table of Contents

- [Overview](#-overview) - [Folder Structure](#-folder-structure) -
[PlayerBase](#-playerbase-shared-logic-only) - [Ability
Manager](#-ability-manager-critical) - [Abilities as
Scenes](#-abilities-as-scenes) - [Class
Data](#-class-data-stats--abilities) - [Class
Scenes](#-class-scenes-thin-wrappers) - [Character
Selection](#-character-selection) - [Adding a New
Class](#-adding-a-new-class) - [Best Practices](#-best-practices) -
[Verdict](#-verdict)

---

## 🏗 Overview

PlayerBase (scene + script)
│
├── Movement (shared)
├── Jump / Gravity (shared)
├── Health (shared)
├── State machine (shared)
│
├── AbilityManager
│ ├── Primary ability
│ ├── Secondary ability
│
└── ClassData (stats & abilities)

---

## 📁 Folder Structure

res:// ├── player/ │ ├── PlayerBase.tscn │ ├── player_base.gd │ ├──
classes/ │ ├── wizard/ │ │ ├── Wizard.tscn │ │ └── wizard.gd │ ├──
rogue/ │ │ ├── Rogue.tscn │ │ └── rogue.gd │ ├── abilities/ │ ├──
wind_slash/ │ ├── fireball/ │ ├── dash/ │ ├── data/ │ ├── class_data.gd
│ ├── wizard_data.tres │ ├── rogue_data.tres

markdown Copy code

> Organizing early prevents chaos later.

---

## 🧍 PlayerBase (Shared Logic Only)

`PlayerBase` is **class-agnostic**.

**Responsibilities:**

- Movement & speed - Jumping (jump counter) - Gravity - Facing
direction - State machine - Health - Input routing

**What NOT to include:**

- Class-specific attacks - Wizard/Rogue logic

**Ability hooks:**

```gdscript func primary_attack(): if ability_manager:
ability_manager.use_primary()

func secondary_attack(): if ability_manager:
ability_manager.use_secondary() 🧩 Ability Manager (Critical) Scene:
AbilityManager.tscn Script: ability_manager.gd

gdscript Copy code class_name AbilityManager extends Node

var primary_ability var secondary_ability

func use_primary(): if primary_ability: primary_ability.activate()

func use_secondary(): if secondary_ability: secondary_ability.activate()
Abilities are scenes, not functions.

🔥 Abilities as Scenes Example: WindSlash.tscn

scss Copy code WindSlash (Node2D / Area2D) ├── Sprite2D ├──
CollisionShape2D Script handles:

Movement

Damage

Lifetime

Direction

gdscript Copy code func activate(origin: Node, direction: int):
global_position = origin.global_position set_direction(direction)
Abilities do not know about classes.

📊 Class Data (Stats & Abilities) Use Resources (.tres) instead of
scripts.

class_data.gd

gdscript Copy code extends Resource class_name ClassData

@export var max_health := 100 @export var speed := 130 @export var
primary_ability_scene: PackedScene @export var secondary_ability_scene:
PackedScene Example: wizard_data.tres

ini Copy code max_health = 70 speed = 110 primary_ability =
Fireball.tscn secondary_ability = Blink.tscn 🧙 Class Scenes (Thin
Wrappers) Example: Wizard.tscn inherits from PlayerBase.tscn

wizard.gd

gdscript Copy code extends "res://player/player_base.gd"

@export var class_data: ClassData

func _ready(): apply_class_data()

func apply_class_data(): max_health = class_data.max_health SPEED =
class_data.speed

ability_manager.primary_ability =
class_data.primary_ability_scene.instantiate()
add_child(ability_manager.primary_ability) Class scenes only define
visuals, stats, and abilities.

🎮 Character Selection gdscript Copy code var chosen_class_scene:
PackedScene var player = chosen_class_scene.instantiate()
add_child(player) Zero duplication, fully modular.

🔁 Adding a New Class Steps to add Paladin:

Duplicate ClassData

Create a new sprite

Assign abilities

Done --- no PlayerBase edits required

❌ Best Practices Bad Practice Why Big if/else in Player Unmaintainable
Hardcoding abilities Inflexible Classes inside abilities Tight coupling
Copy-pasting Player Bug nightmare

🏆 Verdict This architecture:

✅ Scales to 10+ classes

✅ Keeps PlayerBase clean

✅ Separates logic from data

✅ Matches professional Godot workflows
