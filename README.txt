Bell Chimes Mod v1.2
By Leslie E. Krause and erstazi

Bell Chimes adds a set of church bells that are chimed automatically at different periods
to audibly denote the passage of time in world. The bells are non-craftable and intended
for placement by an administrator in a conspicuous location, like a bell tower at spawn.

 - At noon each day the half Westminster chimes are played.
 - At midnight each day the full Westminster chimes are played.
 - At midnight on the first day of a new month the full Westminster chimes are played
   followed by a succession of tolls for the current month.
 - At midnight on the first day of a new year the full Westminster chimes are played
   followed by a 30-second carillon.

Generally speaking, if your time speed is set to the standard 20-minutes per in-game day,
then you will hear the monthly tolls about twice per real-world day. Likewise, you will
hear the carillon chimes about six times per real-world month.

Both the great bell and quarter bells are sounded by means of a mechanical rack-and-snail
actuator that strikes each bell with a hammer on the side. For the time being (no pun
intended), this is only a sound-effect, but in the next version a model of the physical
device will be included. For now you, are welcome to construct the turret clock striking
mechanism to scale for added realism in your world. Here are some useful references:

 *  How the Rack and Snail Bell Striking Mechanism on a Tower Clock Works
    https://www.youtube.com/watch?v=MOe5WthyTgA

 *  Lampasas County Courthouse Tower Clock
    https://www.youtube.com/watch?v=sx_w62HZf-E

Also included is an API for custom formatting of the in-game date and time without the
need for cumbersome mathematical calculations. I published the source code on the forums
a couple years ago, but I decided it might be more useful within a standalone mod.

Two helper functions are available for converting the time and date into strings. These
can be useful in formspecs, chat commands, HUD elements, etc. Both accept a tokenized
input string for customization.

 * minetest.get_date_string( str, env_date )
   Returns the game date as a human-readable string

    * str - an optional tokenized string to represent the game date
    * env_date - an optional game date specifier, or the current date if nil

   The tokenized string may include one or more date specifiers:

      Cardinal values:
      %Y - elapsed years in epoch
      %M - elapsed months in year
      %D - elapsed days in month
      %J - elapsed days in year

      Ordinal values:
      %y - current year of epoch
      %m - current month of year
      %d - current day of month
      %j - current day of year

 * minetest.get_time_string( str, env_time )
   Returns the game time as a human-readable string

    * str - an optional tokenized string to represent the game time
    * env_date - an optional game time specifier, or the current time if nil

   The tokenized string may include one or more time specifiers:
      %pp - daypart as AM or PM
      %hh - hours in 24-hour clock
      %cc - hours in 12-hour clock
      %mm - minutes

Even though there is no formal calendar convention in Minetest games, I settled on months
having 30 days and years having 360 days -- a suitable homage to the geometric simplicity
of the voxel world.

And lastly, there is a new chat command for obtaining the in-game date or time, as well
as the server's local date and time. Simply type "/clock" followed by "date" or "time".

Compatability
----------------------

Luanti 5.17+ required


Installation
----------------------

  1) Unzip the archive into the mods directory of your game
  2) Make sure to name the directory as "jc_bells"

