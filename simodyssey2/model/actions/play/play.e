note
	description: "Summary description for {PLAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAY

create
	make

feature -- attributes
	game_state: GAME_STATE
	game_state_access: GAME_STATE_ACCESS

	--shared info
	shared_info: SHARED_INFORMATION
	shared_info_access: SHARED_INFORMATION_ACCESS

	--entity_ids
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS

feature -- constructor
	make
		do
			game_state := game_state_access.gs
			shared_info := shared_info_access.shared_info
			entity_ids := entity_ids_access.entity_ids
		end

feature -- execute
	execute
		do
			-- attach game_state, info and ids here
			game_state := game_state_access.gs
			shared_info := shared_info_access.shared_info
			entity_ids := entity_ids_access.entity_ids

			-- new turn state
			game_state.new_turn_state

			if not game_state.mode.is_equal ("none") then
				game_state.update_mini_state
				game_state.error_state

				game_state.states_msg_append ("%N")
				game_state.states_msg_append ("  ")
				game_state.states_msg_append ("To start a new mission, please abort the current one first.")

				game_state.output_states
			else
				entity_ids.delete_all
				shared_info.reset
				shared_info.test (3, 5, 7, 15, 30)
				game_state.play_mode

				game_state.update_state
				game_state.ok_state
				game_state.make_new_galaxy

				game_state.output_states
				game_state.output_movements
				game_state.output_galaxy
			end
		end

end
