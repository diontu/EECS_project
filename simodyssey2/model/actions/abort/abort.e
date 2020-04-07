note
	description: "Summary description for {ABORT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ABORT

create
	make

feature -- attributes
	game_state: GAME_STATE
	game_state_access: GAME_STATE_ACCESS
--	shared_info: SHARED_INFORMATION
--	shared_info_access: SHARED_INFORMATION_ACCESS
--	entity_ids: ENTITY_IDS
--	entity_ids_access: ENTITY_IDS_ACCESS

feature -- constructor
	make
		do
			game_state := game_state_access.gs
--			shared_info := shared_info_access.shared_info
--			entity_ids := entity_ids_access.entity_ids
		end

feature -- execute
	execute
		do
			--attach game_state here
			game_state := game_state_access.gs
--			shared_info := shared_info_access.shared_info
--			entity_ids := entity_ids_access.entity_ids

			if game_state.mode.is_equal ("none") then
				game_state.new_turn_state
				game_state.update_mini_state

				game_state.error_state
				game_state.states_msg_append ("%N")
				game_state.states_msg_append ("  ")
				game_state.states_msg_append ("Negative on that request:no mission in progress.")
				game_state.output_states
			else
				game_state.new_game_state
				game_state.update_mini_state

				game_state.ok_state
				game_state.states_msg_append ("%N")
				game_state.states_msg_append ("  ")
				game_state.states_msg_append ("Mission aborted. Try test(3,5,7,15,30)")

				game_state.output_states
			end
		end

end
