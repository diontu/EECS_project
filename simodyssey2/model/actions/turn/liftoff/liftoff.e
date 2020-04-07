note
	description: "Summary description for {LIFTOFF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIFTOFF

create
	make

feature -- attributes
	game_state: GAME_STATE
	game_state_access: GAME_STATE_ACCESS
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS



feature -- constructor
	make
		do
		game_state := game_state_access.gs
				entity_ids := entity_ids_access.entity_ids
		end

feature -- execute
	execute
	local
		explorer: EXPLORER_ENT
			explorer_entity_alphabet: ENTITY_ALPHABET
			sector : SECTOR
		do
		game_state := game_state_access.gs
		entity_ids := entity_ids_access.entity_ids
		-- set the explorer
		explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)
		if attached {EXPLORER_ENT} explorer_entity_alphabet.entity as exp then
		explorer := exp
		end

		if attached{EXPLORER_ENT} explorer as exp then
				if game_state.mode.is_equal ("none") then
						game_state.update_mini_state
						game_state.error_state
						game_state.states_msg_append ("%N")
						game_state.states_msg_append ("  ")
						game_state.states_msg_append ("Negative on that request:no mission in progress.")
						game_state.output_states
				else

				if not exp.is_landed then

					game_state.update_mini_state
					game_state.error_state
					game_state.states_msg_append ("%N")
					game_state.states_msg_append ("  ")
					game_state.states_msg_append ("Negative on that request:you are not on a planet at Sector:")
					game_state.states_msg_append (exp.position.row.out)
					game_state.states_msg_append (":")
					game_state.states_msg_append (exp.position.col.out)
					game_state.output_states
				else
					game_state.update_state
					game_state.states_msg_append ("%N")
					game_state.states_msg_append ("  ")
					game_state.states_msg_append ("Explorer has lifted off from planet at Sector:")
					game_state.states_msg_append (exp.position.row.out)
					game_state.states_msg_append (":")
					game_state.states_msg_append (exp.position.col.out)
				--	game_state.output_states
					explorer.liftoff
				end
				end
				end
		end

end
