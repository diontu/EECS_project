note
	description: "Summary description for {PASS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PASS

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
			explorer_entity_alphabet: ENTITY_ALPHABET
		do
			game_state := game_state_access.gs
			entity_ids := entity_ids_access.entity_ids

			if game_state.mode.is_equal ("none") then
					game_state.update_mini_state
					game_state.error_state
					game_state.states_msg_append ("%N")
					game_state.states_msg_append ("  ")
					game_state.states_msg_append ("Negative on that request:no mission in progress.")
					game_state.output_states
			else
				game_state.update_state
				explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)
				if attached {EXPLORER_ENT} explorer_entity_alphabet.entity as explorer then
					explorer.pass_turn
				end
			end
		end

end
