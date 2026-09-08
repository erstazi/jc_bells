--------------------------------------------------------
-- Minetest :: Bell Chimes Mod v1.2 (jc_bells)
--
-- See LICENSE.txt for licensing and other information.
-- Copyright (c) 2020, Leslie Ellen Krause
-- Copyright (c) 2026, erstazi
--
--------------------------------------------------------

jc_bells = {}

local is_ringing = false
local tick_count = 0

---------------------
-- Private Methods --
---------------------

local function set_ring_timeout( timeout )
  is_ringing = true
  core.after( timeout, function ( )
    is_ringing = false
  end )
end

----------------------
-- Registered Nodes --
----------------------

core.register_node("jc_bells:carillon_bell", {
  description = "Carillon Bell",
  drawtype = "mesh",
  mesh = "church_bell_small.obj",
  tiles = {
    "church_bell.png",
  },
  visual_scale = 1.0,
  paramtype = "light",
  inventory_image = "church_bell_inv.png",
  wield_image = "church_bell_inv.png",
  groups = {cracky = 2},
  selection_box = {
    type = "fixed",
    fixed = { -5/16, -0.5, -5/16, 5/16, 0.3, 5/16 },
  },
  collision_box = {
    type = "fixed",
    fixed = { -5/16, -0.5, -5/16, 5/16, 0.3, 5/16 },
  },
})

core.register_node( "jc_bells:church_bell", {
  description = "Church Bell",
  drawtype = "mesh",
  mesh = "church_bell.obj",
  tiles = {
    "church_bell.png",
  },
  visual_scale = 1.8,
  paramtype = "light",
  inventory_image = 'church_bell_inv.png',
  wield_image = 'church_bell_inv.png',
  groups = { cracky = 2 },
  stack_max = 1,
  -- selection_box = {
    -- type = "fixed",
    -- fixed = { -9 / 16, -0.5, -9 / 16, 9 / 16, 1.2, 9 / 16 },
  -- },
  selection_box = {
    type = 'fixed',
    fixed = {
      {-0.38, -0.31, -0.38, 0.38, 0.5, 0.38},
    }
  },
  on_timer = function( bell_pos, elapsed )
    local env_date = core.get_day_count( )
    local env_time = math.floor( core.get_timeofday( ) * 1440 )
    local mech_pos = vector.new( bell_pos.x, bell_pos.y - 6, bell_pos.z )

    local MM = math.floor( env_date % 360 / 30 )  -- elapsed months in year
    local DD = math.floor( env_date % 360 % 30 )  -- elapsed days in month
    local hh = math.floor( env_time / 60 )  -- elapsed hours in day
    local mm = math.floor( env_time % 60 )  -- elapsed minutes in hour

    if tick_count % 3 == 0 then
      core.sound_play( "bell_mechanism8", { pos = mech_pos, max_hear_distance = 8, gain = 0.5 } )
    end

    tick_count = tick_count + 1

    local function play_toll( )
      local ring_total = MM + 1
      for i = 1, ring_total do
        core.sound_play( "bell_mechanism1", { pos = mech_pos, max_hear_distance = 10, gain = 0.5 } )
        core.after( 2 * i, function ( )
          core.sound_play( "bell_stroke", { pos = bell_pos, max_hear_distance = 300, gain = 3.5 } )
          core.sound_play( "bell_mechanism2", { pos = mech_pos, max_hear_distance = 10, gain = 1.0 } )
        end )
      end
      core.after( 2 * ring_total + 0.5, function ( )
        core.sound_play( "bell_mechanism3", { pos = mech_pos, max_hear_distance = 10, gain = 1.0 } )
      end )
    end

    local function play_chime( is_full )
      core.sound_play( "bell_mechanism5", { pos = mech_pos, max_hear_distance = 10, gain = 4.0 } )
      core.after( 3, function ( )
        core.sound_play( "bell_chime2", { pos = bell_pos, max_hear_distance = 300, gain = 5.0 } )
        core.sound_play( "bell_mechanism6", { pos = mech_pos, max_hear_distance = 10, gain = 4.0 } )
        if is_full then
          core.after( 10, function ( )
            core.sound_play( "bell_chime1", { pos = bell_pos, max_hear_distance = 300, gain = 5.0 } )
            core.sound_play( "bell_mechanism6", { pos = mech_pos, max_hear_distance = 10, gain = 4.0 } )
          end )
          core.after( 20, function ( )
            core.sound_play( "bell_mechanism7", { pos = mech_pos, max_hear_distance = 10, gain = 4.0 } )
          end )
        else
          core.after( 10, function ( )
            core.sound_play( "bell_mechanism7", { pos = mech_pos, max_hear_distance = 10, gain = 4.0 } )
          end )
        end
      end )
    end

    local function play_carillon( )
      core.sound_play( "bell_carillon", { pos = bell_pos, max_hear_distance = 300, gain = 5.0 } )
    end

    if mm < 5 and not is_ringing then
      if MM == 0 and DD == 0 and hh == 0 then
        set_ring_timeout( 60 )
        play_carillon( )

      elseif DD == 0 and hh == 0 then
        set_ring_timeout( 60 )
        play_chime( true )
        core.after( 25, play_toll )

      elseif hh == 12 then
        set_ring_timeout( 60 )
        play_chime( false )

      elseif hh == 0 then
        set_ring_timeout( 60 )
        play_chime( true )
      end
    end

    return true
  end,
  can_dig = function ( pos, player )
    return not core.is_protected( pos, player:get_player_name( ) )
  end,
  after_place_node = function( pos, player )
    local player_name = player:get_player_name( )
    local meta = core.get_meta( pos )

    meta:set_string( "infotext", "Church Bell (placed by " .. player_name .. ")" )
    core.get_node_timer( pos ):start( 1.0 )
  end,
} )

--------------------
-- Public Methods --
--------------------

jc_bells.get_date_string = function( str, env_date )
  if not env_date then
    env_date = core.get_day_count( )
  end

  local months1 = { 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' }
  local months2 = { 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' }

  if str == nil then
    str = "%D Days, %M Months, %Y Years"
  end

  local y = math.floor( env_date / 360 )
  local m = math.floor( env_date % 360 / 30 )
  local d = math.floor( env_date % 360 % 30 )
  local j = math.floor( env_date % 360 )

  -- cardinal values
  str = string.gsub( str, "%%Y", y )        -- elapsed years in epoch
  str = string.gsub( str, "%%M", m )        -- elapsed months in year
  str = string.gsub( str, "%%D", d )        -- elapsed days in month
  str = string.gsub( str, "%%J", j )        -- elapsed days in year

  -- ordinal values
  str = string.gsub( str, "%%y", y + 1 )    -- current year of epoch
  str = string.gsub( str, "%%m", m + 1 )    -- current month of year
  str = string.gsub( str, "%%d", d + 1 )    -- current day of month
  str = string.gsub( str, "%%j", j + 1 )    -- current day of year

  str = string.gsub( str, "%%b", months1[ m + 1 ] )       -- current month long name
  str = string.gsub( str, "%%h", months2[ m + 1 ] )       -- current month short name

  str = string.gsub( str, "%%z", "%%" )

  return str
end

jc_bells.get_time_string = function( str, env_time )
  if not env_time then
    env_time = math.floor( core.get_timeofday( ) * 1440 )
  elseif env_time > 1440 then
    env_time = env_time % 1440      -- prevent overflow
  end

  if str == nil then
    str = "%cc:%mm %pp"
  end

  local pp = env_time < 720 and "AM" or "PM"
  local hh = math.floor( env_time / 60 )
  local mm = math.floor( env_time % 60 )
  local cc = hh

  if cc > 12 then
    cc = cc - 12
  elseif cc == 0 then
    cc = 12;
  end

  str = string.gsub( str, "%%pp", pp )          -- daypart as AM or PM
  str = string.gsub( str, "%%hh", string.format( "%02d", hh ) )   -- hours in 24 hour clock
  str = string.gsub( str, "%%cc", string.format( "%02d", cc ) )   -- hours in 12 hour clock
  str = string.gsub( str, "%%mm", string.format( "%02d", mm ) )   -- minutes

  return str
end

------------------------------
-- Registered Chat Commands --
------------------------------

core.register_chatcommand( "clock", {
  description = "Display the in-game date or time, or the server's local date and time by default.",
  func = function( name, param )
    if param == "date" then
      local env_date = core.get_day_count( )
      local yy = math.floor( env_date / 360 )
      local mm = math.floor( env_date % 360 / 30 )
      local dd = math.floor( env_date % 360 % 30 )
      return true, jc_bells.get_date_string( "Current Date: %D Days, %M Months, %Y Years" )

    elseif param == "time" then
      local env_time = math.floor( core.get_timeofday( ) * 1440 )
      local dp = env_time < 720 and "AM" or "PM"
      local hh = math.floor( env_time / 60 )
      local mm = math.floor( env_time % 60 )
      if hh > 12 then
        hh = hh - 12
      elseif hh == 0 then
        hh = 12
      end
      return true, jc_bells.get_time_string( "Current Time: %cc:%hh %pp" )

    else
      return true, os.date( "The server's local date and time is %c." )
    end
  end
} )
