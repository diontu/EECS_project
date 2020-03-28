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
			create deaths_by_asteroid_msg.make_empty

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

			-- final state
			is_gameover := false

			-- game properties
			create galaxy.placeholder
			shared_info := shared_info_access.shared_info
			entity_ids := entity_ids_access.entity_ids

			-- explorer
			explorer_ent_alpha := entity_ids.get_entity_alphabet (0)

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

	-- final state
	is_gameover: BOOLEAN

	-- game properties
	galaxy: GALAXY
	shared_info: SHARED_INFORMATION
	shared_info_access: SHARED_INFORMATION_ACCESS
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS

	-- explorer
	explorer_ent_alpha: ENTITY_ALPHABET

feature -- update states
		-- Could use: (outside of class)
		-- 1. update_state
		-- 2. update_mini_state
		-- 3. ok_state
		-- 4. error_state
		-- 5. play_mode -- (when player enters play)
		-- 6. test_mode -- (when player enters test)
		-- 7. none_mode -- (when game ends)
		-- 8. gameover -- (when the game needs to end)
		-- 9. not_gameover -- (when the game is back at it's non-gameover state)

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

	not_in_game_mode
		do
			mode := "none"
		end

	gameover
		do
			is_gameover := true
		end

	not_gameover
		do
			is_gameover := false
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

			-- reset explorer state for the turn
			if attached {EXPLORER_ENT} explorer_ent_alpha as explorer then
				explorer.reset_turn_state
			end

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
--		states_msg, movements_msg, sectors_msg, descriptions_msg, deaths_msg (deaths_by_asteroid too)

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
	deaths_by_asteroid_msg: STRING

feature -- clear msgs and output variable
	clear_output_and_msgs
		do
			create output.make_empty
			create movements_msg.make_empty
			create states_msg.make_empty
			create sectors_msg.make_empty
			create descriptions_msg.make_empty
			create deaths_msg.make_empty
			create deaths_by_asteroid_msg.make_empty
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

	deaths_by_asteroid_msg_append (s: STRING)
		do
			deaths_by_asteroid_msg.append (s)
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
		do
			output.append ("%N")
			output.append ("  ")
			output.append ("Movement:")
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
			--		if not star "    [-3,W]->"
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
		local
			all_entities: ARRAY[TUPLE[id: INTEGER; alphabet: detachable ENTITY_ALPHABET]]
		do
			all_entities := entity_ids.sorted_entity_ids

			output.append ("%N")
			output.append ("  ")
			output.append ("Descriptions:")

			across all_entities as tuple loop
				output.append ("%N")
				output.append ("    ")
				if attached {ENTITY_ALPHABET} tuple.item.alphabet as attached_entity_alphabet then
					if attached {ENTITY} attached_entity_alphabet.entity as entity then
						output.append ("[")
						output.append (attached_entity_alphabet.id.out)
						output.append (",")
						output.append (attached_entity_alphabet.item.out)
						output.append ("]")
						output.append ("->")
						if attached_entity_alphabet.id < 0 then
							if attached {STAR_ENT} entity as star then
								output.append ("Luminosity:")
								output.append (star.luminosity.out)
							end
						elseif attached_entity_alphabet.id = 0 then
							if attached {EXPLORER_ENT} entity as explorer then
								output.append ("fuel:")
								output.append (explorer.fuel.out)
								output.append ("/3")
								output.append (", ")
								output.append ("life:")
								output.append (explorer.life.out)
								output.append ("/3")
								output.append (", ")
								output.append ("landed?:")
								output.append (explorer.is_landed.out.at (1).out)
							end
						elseif attached_entity_alphabet.id > 0 then
							if attached {PLANET_ENT} entity as planet then
								output.append ("attached?:")
								output.append (planet.attached_to_star.out.at (1).out)
								output.append (", ")
								output.append ("support_life?:")
								output.append (planet.supports_life.out.at (1).out)
								output.append (", ")
								output.append ("visited?:")
								output.append (planet.visited.out.at (1).out)
								output.append (", ")
								output.append ("turns_left:")
								if planet.attached_to_star then
									output.append ("N/A")
								else
									output.append (planet.turns_left.out)
								end
							elseif attached {BENIGN_ENT} entity as benign then
								output.append ("fuel:")
								output.append (benign.fuel.out)
								output.append ("/3")
								output.append (", ")
								output.append ("actions_left_until_reproduction:")
								output.append (benign.actions_left.out)
								output.append ("/1")
								output.append (", ")
								output.append ("turns_left:")
								output.append (benign.turns_left.out)
							elseif attached {MALEVOLENT_ENT} entity as malevolent then
								output.append ("fuel:")
								output.append (malevolent.fuel.out)
								output.append ("/3")
								output.append (", ")
								output.append ("actions_left_until_reproduction:")
								output.append (malevolent.actions_left.out)
								output.append ("/1")
								output.append (", ")
								output.append ("turns_left:")
								output.append (malevolent.turns_left.out)
							elseif attached {JANITAUR_ENT} entity as janitaur then
								output.append ("fuel:")
								output.append (janitaur.fuel.out)
								output.append ("/5")
								output.append (", ")
								output.append ("load:")
								output.append (janitaur.load_level.out)
								output.append ("/2")
								output.append (", ")
								output.append ("actions_left_until_reproduction:")
								output.append (janitaur.actions_left.out)
								output.append ("/2")
								output.append (", ")
								output.append ("turns_left:")
								output.append (janitaur.turns_left.out)
							elseif attached {ASTEROID_ENT} entity as asteroid then
								output.append ("turns_left:")
								output.append (asteroid.turns_left.out)
							end
						end
					end
				end
			end

--			output.append (descriptions_msg)
		end

	output_deaths -- outputs the deaths of planets and explorer
			-- requires:
			-- 1. entities_died
			--		if no entities_died -> "none"
			-- 		if entities_died -> deaths_msg (deaths_by_asteroid_msg is a special case)
			-- 2. deaths_msg
			--		- custom msg on explorer death?
			--		if death of planets
			--			- "    [19,P]->attached?:F, support_life?:F, visited?:F, turns_left: N/A,"
			--			- "      Planet got devoured by blackhole (id: -1) at Sector:3:3"
			--		- removed entity from the sectors and descriptions
			-- NOTE: when an entity dies, you have to say that it died with their ".died" command
		do
			output.append ("%N")
			output.append ("  ")
			output.append ("Deaths This Turn:")
			if not entities_died then
				output.append ("none")
			else
				output.append (deaths_by_asteroid_msg)
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




