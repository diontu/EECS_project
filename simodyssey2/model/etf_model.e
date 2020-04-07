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
			-- player command classes
			create abort_command.make
			create play_command.make
			create status_command.make
			create test_command.make
			create turn_commands.make
			-- game state output
			game_state := game_state_access.gs
			-- output
			create output.make_empty
			output.append (game_state.output)
		end

feature	-- cannot remove reset
	reset
		do
			make
		end

feature -- player commands classes
	abort_command: ABORT
	play_command: PLAY
	status_command: STATUS
	test_command: TEST
	turn_commands: TURN

feature -- game state output
	game_state: GAME_STATE
	game_state_access: GAME_STATE_ACCESS

feature -- player commands -- ************* in each of the execute commands, remember to add the new_turn_state or new_game_state ***********
		-- new_game_state only used for the abort command

	abort
		do
			abort_command.execute
			create output.make_empty
			output.append (game_state.output)
		end

	play
		do
			play_command.execute
			create output.make_empty
			output.append (game_state.output)
		end

	status
		do
			status_command.execute
			create output.make_empty
			output.append (game_state.output)
		end

	test (a_threshold: INTEGER; j_threshold: INTEGER;  m_threshold: INTEGER; b_threshold: INTEGER; p_threshold: INTEGER)
		do
			test_command.add_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)
			test_command.execute
			create output.make_empty
			output.append (game_state.output)
		end

	turn (action: ACTION)
		do
			turn_commands.execute (action)
			create output.make_empty
			output.append (game_state.output)
		end


feature -- output to the screen
		-- write output
	output: STRING

	out : STRING
		do
			create Result.make_empty
			Result := output
		end

end




