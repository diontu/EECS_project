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

			-- player command classes
			create abort_command.make
			create play_command.make
			create status_command.make
			create test_command.make
			create turn_commands.make

			-- variables used for msgs
			entities_moved := false
			entities_died := false

			-- states
			state := 0
			mini_state := 0
			mode := "none"
			ok_or_error := "ok"

			-- game properties
			create galaxy.placeholder
			shared_info := shared_info_access.shared_info

			-- initial state
			states_msg_append ("%N")
			states_msg_append ("  ")
			states_msg_append ("Welcome! Try test(3,5,7,15,30)")
			output_states
		end

feature -- player commands classes
	abort_command: ABORT
	play_command: PLAY
	status_command: STATUS
	test_command: TEST
	turn_commands: TURN


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
	galaxy: GALAXY
	shared_info: SHARED_INFORMATION
	shared_info_access: SHARED_INFORMATION_ACCESS

feature -- update states
		-- Could use: (outside of class)
		-- 1. update_state
		-- 2. update_mini_state
		-- 3. ok_state
		-- 4. error_state
		-- 5. play_mode -- (when player enters play)
		-- 6. test_mode -- (when player enters test)

	update_state
		do
			state := state + 1
			mini_state := 0
		end

	update_mini_state
		do
			mini_state := mini_state + 1
		end

	ok_state
		do
			ok_or_error := "ok"
		end

	error_state
		do
			ok_or_error := "error"
		end

	play_mode
		do
			mode := "play"
		end

	test_mode
		do
			mode := "test"
		end

--	set_galaxy (g: GALAXY)
--		do
--			galaxy := g
--		end


feature -- update variables used for output
		-- Could use: (outside of class)
		-- 1. an_entity_moved
		-- 2. an_entity_died

	an_entity_moved
		do
			entities_moved := true
		end

	an_entity_died
		do
			entities_died := true
		end


feature -- states -- MUST MANUALLY UPDATE THE STATE AND MINI_STATE
		-- Could use: (outside of class)
		-- 1. new_turn_state
		-- 2. new_game_state

	-- cannot remove reset
	reset
		do
			make
		end

	new_turn_state
			-- Reset turn state
		do
			-- states
			ok_or_error := "ok"

			-- variables used for output
			entities_moved := false
			entities_died := false

			-- clear output and msgs
			clear_output_and_msgs
		end

	new_game_state
			-- Reset game state.
		do
			-- states
			-- state and mini_state are manually adjusted wrt player commands
			mode := "none"
			ok_or_error := "ok"

			-- variables used for outputs
			entities_moved := false
			entities_died := false

			-- clear output and msgs
			clear_output_and_msgs
		end


feature -- player commands -- ************* in each of the execute commands, remember to add the new_turn_state or new_game_state ***********
		-- new_game_state only used for the abort command
	abort
		do
			abort_command.execute
		end

	play
		do
			play_command.execute
		end

	status
		do
			status_command.execute
		end

	test (a_threshold: INTEGER; j_threshold: INTEGER;  m_threshold: INTEGER; b_threshold: INTEGER; p_threshold: INTEGER)
		do
			test_command.add_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)
			test_command.execute
		end

	turn (action: ACTION)
		do
			turn_commands.execute (action)
		end

feature -- game properties
	make_new_galaxy
		do
			create galaxy.make
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

feature {NONE} -- states_msg, movements_msg, sectors_msg, descriptions_msg, deaths_msg, (galaxy_msg not needed)
		--@@@@@@@@@@@@ make all of these empty before each player command@@@@@@@@@@@@@@
	states_msg: STRING
	movements_msg: STRING
	sectors_msg: STRING
	descriptions_msg: STRING
	deaths_msg: STRING

feature -- clear msgs and output variable
	clear_output_and_msgs
		do
			create output.make_empty
			create movements_msg.make_empty
			create states_msg.make_empty
			create sectors_msg.make_empty
			create descriptions_msg.make_empty
			create deaths_msg.make_empty
		end


feature -- append commands
	states_msg_append (s: STRING)
		do
			states_msg.append (s)
		end

	movements_msg_append (s: STRING)
		do
			movements_msg.append (s)
		end

	sectors_msg_append (s: STRING)
		do
			sectors_msg.append (s)
		end

	descriptions_msg_append (s: STRING)
		do
			descriptions_msg.append (s)
		end

	deaths_msg_append (s: STRING)
		do
			deaths_msg.append (s)
		end

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
			output.append ("%N")
			output.append ("  ")
			output.append ("Movements:")
			if not entities_moved then
				output.append ("none")
			else
				output.append (movements_msg)
			end
		end

	output_sectors -- prints the entities at each sectors (going through each column row-by-row)
			-- requires:
			-- 1. write entities of each sectors to sectors_msg
			--		- row 1, col 2
			--		"    [1,2]->-,-,[-3,*],-"
		local
			sector : SECTOR
			contents: ARRAYED_LIST [detachable ENTITY_ALPHABET]
			contents_counter: INTEGER
			printed_symbols_counter: INTEGER
			occupant: ENTITY_ALPHABET
			loop_counter: INTEGER
			do_not_add: BOOLEAN
		do
			output.append ("%N")
			output.append ("  ")
			output.append ("Sectors:")
--			output.append (sectors_msg)
			across 1 |..| shared_info.number_rows as row loop
				across 1 |..| shared_info.number_columns as column loop
					output.append ("%N")
					sector := galaxy.grid[row.item, column.item]
					contents := sector.contents
					loop_counter := 1
					do_not_add := false
					output.append ("    ")
					output.append ("[")
					output.append (row.item.out)
					output.append (",")
					output.append (column.item.out)
					output.append ("]")
					output.append ("->")
--					across 1 |..| shared_info.max_capacity as contents_index loop
					from
						contents_counter := 1
						printed_symbols_counter := 0
					until
						contents_counter > contents.count
					loop
--						if attached {ENTITY_ALPHABET} contents.item as content then
--							occupant := content
--						end
						occupant := contents[contents_counter]
						if attached occupant then
							output.append ("[")
							output.append_integer (occupant.id)
							output.append (",")
							output.append_character (occupant.item)
							output.append ("]")
							do_not_add := true
						else
							output.append ("-")
						end
						if loop_counter <= 3 then
							output.append (",")
							loop_counter := loop_counter + 1
						end
						printed_symbols_counter:=printed_symbols_counter+1
						contents_counter := contents_counter + 1
					end

					from

					until
						(shared_info.max_capacity - printed_symbols_counter)=0
					loop
						output.append("-")
						printed_symbols_counter:=printed_symbols_counter+1
						if loop_counter <= 3 then
							output.append (",")
							loop_counter := loop_counter + 1
						end
					end
--						contents.forth
				end
			end
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
			output.append ("%N")
			output.append ("  ")
			output.append ("Descriptions:")
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
			output.append ("%N")
			output.append ("  ")
			output.append ("Deaths This Turn:")
			if not entities_died then
				output.append ("none")
			else
				output.append (deaths_msg)
			end
		end

	output_galaxy -- outputs the galaxy
			-- requires:
			-- 1. galaxy
		do
			output.append (galaxy.out)
		end

end




