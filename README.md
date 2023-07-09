# README

GMTK Game Jam 2023

Theme: Roles Reversed

https://yourwaifuisalie.itch.io/just-another-sad-visual-novel

Judging criteria
- Enjoyment - How enjoyable the game is to play
- Creativity - How interesting, original, creative, and inventive the underlying idea is
- Presentation - How the game looks and sounds 

Important rules:

>
> Anything that could traumatize and/or have a bad effect on children; younger people participate in this jam.
>
> Your game must not contain nudity, or hateful language or visuals. This could see your game being disqualified from being considered as a jam winner. Please consider avoiding extremely strong language and excessive gore, as the jam should be suitable for a general audience. If you’re uncertain, err on the side of being less gratuitous.
>
> Please don’t make games about or based on Mark Brown, the GMTK brand, or any Jam mods - it’s easy for parody and inside jokes to go wrong. 
>


## Initial thoughts

So many possibilities in terms of genre:
- Bullet heaven as the minion-spawner
- Escort quests as the target trying to get killed
- FPS as the mooks
- Dating Sim as the ignored, sad love interest

Role reversal can also be a mechanic:
- Like Mark's polarity-switching magnets

There's natural role reversals in games too:
- Tennis server switching
- Tactical FPS attacker/defender sides
- Mafia roles like the amnesiac 


## Goals

As always, the main goal is to get experience.

I would also like:
1. To actually upload a web build. So build & test, early & often this time.
   - Unity WebGL builds burned me last year, enough that I was excited to switch to Godot
2. To make something relatively polished. This means the tiniest scope possible.
   - I always over-scope. I'm sure this year won't change that.

Tiny scope = minimal "hard" things
- No fancy AI
- Nothing with lots of high-fidelity graphics (models, animations)
- No extensive systems/frameworks


## Iterating ideas

### Reverse bullet heaven

Player can pick 'n choose minions to spawn on the edges of the map
- Similar to clash or other things. Unit cards/number limits.
- Click to select, click to place, make sure it's in bounds

Minions can have the dumbest AI
- Move 'n slide towards the closest enemy

Collision with either units or bullets does damage

Enemies are PC-like characters. Content can come from behaviours/weapons
- 1st enemy doesn't move, shoots single bullets 
- 2nd enemy moves away
- 3rd enemy has bullet spray
- 4th enemy has lasers 
- etc.

Game screen > Victory screen + unit unlock > repeat

Game dev focus:
- assets and effects. All the juice
- in-engine pathing logic with simple behaviors should be pretty easy?

Ultimately it's not too different from already-existing mobile games. 
It's also probably going to be a popular genre/idea


### Reverse dating sim

What would the gameplay mechanics be?
- Old dating sims have management sim elements for training stats + events
- Targets randomly get moved from place-to-place and get interacted with

Mechanics would likely be "the same" (moving places, training stats, conversation, etc.). 
Role reversal would need to come from the story/setting

A very heavy, sad story makes a lot of sense:
- You just never see the PC after the first interaction because no interest
- And then it's yandere simulator? Off'ing the rivals
  - Can't quite do that since it's not kid-friendly for the jam...
  - Can probably head in that direction without getting too distressing

Game dev focus:
- Assets + menu'ing. It's a bunch of UI and systems
- There isn't much gameplay to this. But maybe that's a good thing for scope?


## Study

As a single-dev that works slowly, who also is creating all assets in-jam, there's a hard limit on what I can do. 
So **the dating sim idea seems good enough.** 
It also get's me used to cutscenes/dialogue trees which I will need in my personal projects. 
Mechanically simple means I can hopefully polish and make assets. Let's try it.

I'm looking at the greatest worst dating sim of all time for some quick inspiration: **Love Hina sim date RPG** from Newgrounds, 2004.

Character gen
- You generate the PC, who you don't play as
- Meaningless stats a'hoy

Map/navigation
- Locations/arrows to change scenes
- "Random" encounters at locations
- Clickable scenery things

Character interactions
- Standard character profile, dialogue boxes, choice selections
- Action choices
  - Leave, talk, gift, date, fight
  
Otherwise, there's all the general VN stuff: flags, routes, etc.
  
  
## Initial story idea

If the story is the role reversal we should plan it a bit
- Char gen
- Cut to actual character (love interest) waiting eagerly for something
- MC shows up, says something meme-y, abruptly leaves
- Stew in sadness and resolve to "do better"
- Open to map
- Encounters with other X love interests at each of Y locations
  - Quick, catty conversations. Start with 3
  - MC shows up and ignores player for the other ones
  - Jealous, wondering what's wrong with me
- After-hours visits, allowing actions
  - Simple stat gen
- Some N loops here of training
- Endings
  - Give up
    - Happy & bad end
  - Removal of other options
  - Kidnapping the MC
    - Both of these need to be presented properly/fade-to-black if included
  
Maybe to make it family friendly we make it a self-worth/others care type story
- Ending 1 = enjoying own life, someone else happily dating MC
- Ending 2 = dump the MC it's friends day out
  
## Role reversal gameplay ideas

As much as possible we want more than just using "role reversal" as set dressing
- Player chooses topics to start talking about (instead of responses)
- Work a shitty day-job where random interactions/stat events occur? (instead of getting to choose your life)
- Getting your choices disrespected more often than not (rail-roaded by fate)

Overall, I'm not creative enough to think of a lot of gameplay differences. 
From either perspective, assuming NPC agency, it seems very similar to what a PC does. 

## Time tracking

All time in hours

**Day 0**

- 0.50: Making sure Godot4 web build works
- 1.00: Idea thinking + tea time
- 2.00: Starting with asset gen, characters. This was pretty slow...
- 1.50: Shop outfit + BGs + UI + menu concepts
- 1.00: Widget sheet + variations + atlas textures & finding a font
- 1.00: Main menu + options menu + buttons
- 0.75: Starting dialogue engine (layout, sprites) + scene transitions
- 0.50: Dialogue text drop

= 8.25 hours in

**Day 1**

- 1.00: Testing build (Image.load_from_file bug), config text speed, test text advance
- 1.00: Initial event json and loading
- 1.25: Character bodies + expressions, text speaker, flipping adjustments
- 1.50: Talking effect process, recording
- 1.00: Implement voice text for dialogue (variable sound, pitch, length)

= 8.25 + 5.75 = 14 hours in

- 0.25: Finding music, assessing & planing scope
- 1.00: Music play + event json, adjust credits
- 0.50: volume config
- 0.50: updating buttons and creating dialogue choices
- 0.75: choice signals + event branching

= 14 + 3 = 17 hours in 

Had some unexpected late-night (technically next-day) efforts

- 0130-0200 0.5: character creator
- 0200-0230 0.5: enter/exit animations

= 17 + 1 = 18 hours in 

**Day 2**

- 0.50: slight randomize pos, itch page submission, scene transition
- 2.50: building out event content, final cuts, final build & testing
- 0.50: cover image + screenshot upload

= 18 + 3.5 = 21.5 hour ins

Finished! 

**Total time:** 21.5 hours

(Underestimate. Also doesn't account for thoughts during down-time.)

## Cut ideas

I had a running task list of things I wanted to do, and regularly re-assesed what needed to be delayed/cut.

Just like with editing, there was a ton of cutting. Below is a list of things I would have liked to do but did not. 

The list is roughly in-order where the top is what I would have worked on next given more time.

- **Third cut on scope**. Abbreviated story. These are the elements that didn't make it.
  - One extra background (home)
  - Sad ice-cream ending still
  - Optional one extra character (trendy?) to show other interest getting the MC
- Button click noise
- Store enter noise
- More characters + expressions
  - Have the unused characters mill around in the store/on the streets
  - Tween'ing between positions 
- Fake actions menu
- Character animations
  - Simple shake, squash & stretch, etc.
- A happy ending :(
- sexy/villanous voice for mc  
- More cutscene still images
- Change text audio db based on bold/italics
- **Second cut on scope**. Abbreviated VN plan
  - Meet MC at your shitty job, ultimately fail the dialogue tree due to boredom
    - PC is crushing and is shocked at this turn of events
    - Self-doubt walking home
  - New day, still gloomy thinking about failure
  - Happen to run into MC, get excited
  - Crushed by the popular one
  - Devastation, back home and cry a lot. Ice cream time
  - THE END. Sad end.
    - Apology screen, the happy ending got de-scoped. Life is a nightmare.
- **Original cut on scope**. Cut the world map & game aspects, just a VN in worst case
  - Meet MC by chance, eventually grows bored because we can't yandere in a family-friendly gamejam
  - Meet friend at store, then MC, ignored again
  - In the dumps, meet MC, ignored in favor of other friend
  - Get pissed and pumped, makeover, seek out MC
  - Still ignored in favor of someone else
  - Cry a little
  - Friend talks about dating MC
  - Cry a lot  
  - More soul-less job work
  - Pep talk with friends
  - Be happy with yourself and resolve to be better
  - Turns out they all dumped MC anyway cuz MC is a two-timing asshole
  
## Post-jam thoughts

I'm happy with the effort and products. I'm getting a little faster in everything (coding, art, mental assessments, etc.) as I get more experience. Incremental progress is the goal.

I think the only obvious mistake was the front-loaded asset gen at the beginning. I created 5 characters and was only able to use 2 of them in the game and didn't have the extra background/stills I would have wanted.

Ultimately that just means I need to work on mood-switching better, which is a perennial problem. Often it "feels like" time to draw or "feels like" time to code which is fine for long-term development but not good with time constraints.
