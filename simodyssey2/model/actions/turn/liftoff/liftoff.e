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
		explorer: EXPLORER_ENT
			explorer_entity_alphabet: ENTITY_ALPHABET
			sector : SECTOR
		do
		model := model_access.m
		entity_ids := entity_ids_access.entity_ids
		-- set the explorer
		explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)
		if attached {EXPLORER_ENT} explorer_entity_alphabet.entity as exp then
		explorer := exp
		end

		if attached{EXPLORER_ENT} explorer as exp then
				if model.mode.is_equal ("none") then
						model.update_mini_state
						model.error_state
						model.states_msg_append ("%N")
						model.states_msg_append ("  ")
						model.states_msg_append ("Negative on that request:no mission in progress.")
						model.output_states
				else

				if not exp.is_landed then

					model.update_mini_state
					model.error_state
					model.states_msg_append ("%N")
					model.states_msg_append ("  ")
					model.states_msg_append ("Negative on that request:you are not on a planet at Sector:")
					model.states_msg_append (exp.position.row.out)
					model.states_msg_append (":")
					model.states_msg_append (exp.position.col.out)
					model.output_states
				else
					explorer.liftoff
					model.states_msg_append (explorer.is_landed.out)
					model.update_state
					model.states_msg_append ("%N")
					model.states_msg_append ("  ")
					model.states_msg_append ("Explorer has lifted off from planet at Sector:")
					model.states_msg_append (exp.position.row.out)
					model.states_msg_append (":")
					model.states_msg_append (exp.position.col.out)
				--	model.output_states
				end
				end
				end
		end

end
