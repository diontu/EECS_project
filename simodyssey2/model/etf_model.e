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

feature -- game state output
	game_state: GAME_STATE
	game_state_access: GAME_STATE_ACCESS

feature -- player commands -- ************* in each of the execute commands, remember to add the new_turn_state or new_game_state ***********
		-- new_game_state only used for the abort command

	abort
		do
			game_state.abort
			create output.make_empty
			output.append (game_state.output)
		end

	play
		do
			game_state.play
			create output.make_empty
			output.append (game_state.output)
		end

	status
		do
			game_state.status
			create output.make_empty
			output.append (game_state.output)
		end

	test (a_threshold: INTEGER; j_threshold: INTEGER;  m_threshold: INTEGER; b_threshold: INTEGER; p_threshold: INTEGER)
		do
			game_state.test(a_threshold, j_threshold,  m_threshold, b_threshold, p_threshold)
			create output.make_empty
			output.append (game_state.output)
		end

	turn (action: ACTION)
		do
			game_state.turn (action)
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




