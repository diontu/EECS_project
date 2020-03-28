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
	model: ETF_MODEL
	model_access: ETF_MODEL_ACCESS
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS

feature -- constructor
	make
		do
			model := model_access.m
			entity_ids := entity_ids_access.entity_ids
		end

feature -- execute
	execute
		local
			explorer_entity_alphabet: ENTITY_ALPHABET
		do
			model := model_access.m
			entity_ids := entity_ids_access.entity_ids

			if model.mode.is_equal ("none") then
					model.update_mini_state
					model.error_state
					model.states_msg_append ("%N")
					model.states_msg_append ("  ")
					model.states_msg_append ("Negative on that request:no mission in progress.")
					model.output_states
			else
				model.update_state
				explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)
				if attached {EXPLORER_ENT} explorer_entity_alphabet.entity as explorer then
					explorer.pass_turn
				end
			end
		end

end
