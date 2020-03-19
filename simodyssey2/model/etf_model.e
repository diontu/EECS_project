note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
		do
			-- output string
			create output.make_empty
			-- msgs for respective commands
			create states_msg.make_empty
			create movements_msg.make_empty
			create sectors_msg.make_empty
			create descriptions_msg.make_empty
			create deaths_msg.make_empty

			-- variables used for msgs
			entities_moved := false
			entities_died := false

			-- states
			state := 0
			mini_state := 0
			mode := "none"
			ok_or_error := "ok"

			-- game properties
--			create galaxy.placeholder

		end

feature -- model attributes
	-- variables used for msgs
	entities_moved: BOOLEAN
	entities_died: BOOLEAN

	-- states
	state: INTEGER
	mini_state: INTEGER
	mode: STRING
	ok_or_error: STRING

	-- game properties
--	galaxy: GALAXY

feature -- states
	-- cannot remove reset
	reset
		do
			make
		end

	new_game_state
			-- Reset model state.
		do
			-- states
			-- state and mini_state are manually adjusted wrt player commands
			mode := "none"
			ok_or_error := "ok"

			-- variables used for outputs
			entities_moved := false
			entities_died := false
		end

	test
		do
			output_states
		end

--------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------- OUTPUTS -------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- We will use the commands to display our outputs:
-- 		output_states, output_movements, output_sectors, output_descriptions, output_deathts, output_galaxy
-- To get the proper output, we will have to write the proper strings to the following variables respectively (except output_galaxy):
--		states_msg, movements_msg, sectors_msg, descriptions_msg, deaths_msg

-- Once we finish writing the proper strings to the variables, we then call the respective command to display it.

feature -- output to the screen
		-- write output
	output: STRING

	out : STRING
		do
			create Result.make_empty
			Result := output
		end

feature -- states_msg, movements_msg, sectors_msg, descriptions_msg, deaths_msg, (galaxy_msg not needed)
		--@@@@@@@@@@@@ make all of these empty before each player command@@@@@@@@@@@@@@
	states_msg: STRING
	movements_msg: STRING
	sectors_msg: STRING
	descriptions_msg: STRING
	deaths_msg: STRING

feature -- output_states, output_movements, output_sectors, output_descriptions, output_deaths, output_galaxy
		-- states_msg, movements_msg, sectors_msg, descriptions_msg, deaths_msg, (galaxy_msg not needed)

	output_states -- prints state of the system at the current moment
				-- requires:
				-- 1. state, mini_state
				-- 2. mode -> "play" or "test" or "none"
				-- 3. ok_or_error -> "ok" or "error" or "none"
				-- 4. write message to the states_msg
		do
			output.append ("  ")
			output.append ("state:")
			output.append (state.out)
			output.append (".")
			output.append (mini_state.out)
			output.append (", ")
			if not mode.is_equal ("none") then
				output.append ("mode:")
				output.append (mode.out)
				output.append (", ")
			end
			output.append (ok_or_error)
			output.append ("%N")
			output.append (states_msg)
		end

	output_movements -- prints the movements of the entities
			-- requires:
			-- 1. entities_moved -> true/false
			--		if true -> display movements
			--		if false -> display "none"
			-- 2. write movements to the movements_msg
			--		row 1, col 2, quadrant 2 -> row 2, col 2, quadrant 1
			--			- "    [0,E]:[1,2,2]->[2,2,1]"
			--		if explorer passes -> don't show their movements, turn is used
			-- 		if planet moves to a full planet,
			--			- "    [2,P]:[1,3,2]->"
			-- *** NEW ***
			---- "    [4,M]->fuel:3/3, actions_left_until_reproduction:1/1, turns_left:2"
			---- "    [4,B]->fuel:3/3, actions_left_until_reproduction:1/1, turns_left:2"
		do
			output.append ("  ")
			output.append ("Movements:")
			if not entities_moved then
				output.append ("none")
			else
				output.append ("%N")
				output.append (movements_msg)
			end
		end

	output_sectors -- prints the entities at each sectors (going through each column row-by-row)
			-- requires:
			-- 1. write entities of each sectors to sectors_msg
			--		- row 1, col 2
			--		"    [1,2]->-,-,[-3,*],-"
		do
			output.append ("  ")
			output.append ("Sectors:")
			output.append ("%N")
			output.append (sectors_msg)
		end

	output_descriptions -- prints the descriptions of each entity (in ascending order of id)
			-- requires:
			-- 1. descriptions_msg
			-- 		if star "    [-5,*]->Luminosity:5"
			--			- in STAR, requires:
			--				a. Luminosity
			--		if not star "    [-3, W]->"
			-- 		if explorer "    [0,E]->fuel:3/3, life:3/3, landed?:F"
			--			- in EXPLORER, requires:
			--				a. fuel
			--				b. life
			--				c. landed
			--		if planet "    [3,P]->attached?:F, support_life?:F, visited?:F, turns_left:2
			--			- in PLANET, requires:
			--				a. attached
			--				b. support_life
			--				c. visited
			--				d. turns_left
			--			- if attached, turns_left:N/A
		do
			output.append ("  ")
			output.append ("Descriptions:")
			output.append ("%N")
			output.append (descriptions_msg)
		end

	output_deaths -- outputs the deaths of planets and explorer
			-- requires:
			-- 1. entities_died
			--		if no entities_died -> "none"
			-- 		if entities_died -> deaths_msg
			-- 2. deaths_msg
			--		- custom msg on explorer death?
			--		if death of planets
			--			- "    [19,P]->attached?:F, support_life?:F, visited?:F, turns_left: N/A,"
			--			- "      Planet got devoured by blackhole (id: -1) at Sector:3:3"
			--		- removed entity from the sectors and descriptions
		do
			output.append ("  ")
			output.append ("Deaths This Turn:")
			if not entities_died then
				output.append ("none")
			else
				output.append ("%N")
				output.append (deaths_msg)
			end
		end

	output_galaxy -- outputs the galaxy
			-- requires:
			-- 1. galaxy
		do
--			output.append (galaxy.out)
		end

end




