# luke-skills

A database-driven skill/XP system for qb-core (and compatible with other Luke Developments Scripts. This resource will be updated to ensure each resource is compatible with luke-skills).


## Installation

1. Download the resource and place it into your resource folder.
2. Import the provided SQL file into your server’s database (i.e. run the SQL file and ensure the database is set up).
3. Add the following line to your `server.cfg`:

   ensure luke-skills

   Alternatively, ensure that `luke-skills` is located within your `[qb]` folder.

## Using luke-skills

### A. Updating a Skill

To update a skill, use the following export:

exports["luke-skills"]:AddSkill(skill, amount)


For example, to update the "Searching" skill when engaging in bin-diving (as used with luke-bins):

exports["luke-skills"]:AddSkill("Searching", 1)


You can also randomize the amount of skill gained:

local anything = math.random(1, 3)
exports["luke-skills"]:AddSkill("Searching", anything)


### B. Checking a Skill Level

To check if a skill meets or exceeds a specific value, use:

exports["luke-skills"]:CheckSkill(skill, val)

For instance, to lock content behind a required skill level:


exports["luke-skills"]:CheckSkill("Searching", 100, function(hasskill)
    if hasskill then
        TriggerEvent('luke-bins:client:Reward')
    else
        QBCore.Functions.Notify('You need at least 100XP in Searching to do this.', "error", 3500)
    end
end)

### C. Retrieving the Current Skill Level

To obtain a player’s current skill for interactions with other scripts:

exports["luke-skills"]:GetCurrentSkill(skill)


## Radial Menu Integration

To add a radial menu entry for checking skills, insert the following snippet into your `qb-radialmenu/config.lua` (e.g., starting at line 296):

[3] = {
    id = 'skills',
    title = 'Check Skills',
    icon = 'triangle-exclamation',
    type = 'client',
    event = 'luke-skills:client:CheckSkills',
    shouldClose = true,
},

