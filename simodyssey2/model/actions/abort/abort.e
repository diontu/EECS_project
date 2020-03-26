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
	model: ETF_MODEL
	model_access: ETF_MODEL_ACCESS
--	shared_info: SHARED_INFORMATION
--	shared_info_access: SHARED_INFORMATION_ACCESS
--	entity_ids: ENTITY_IDS
--	entity_ids_access: ENTITY_IDS_ACCESS

feature -- constructor
	make
		do
			model := model_access.m
--			shared_info := shared_info_access.shared_info
--			entity_ids := entity_ids_access.entity_ids
		end

feature -- execute
	execute
		do
			--attach model here
			model := model_access.m
--			shared_info := shared_info_access.shared_info
--			entity_ids := entity_ids_access.entity_ids

			if model.mode.is_equal ("none") then
				model.new_turn_state
				model.update_mini_state

				model.error_state
				model.states_msg_append ("%N")
				model.states_msg_append ("  ")
				model.states_msg_append ("Negative on that request:no mission in progress.")
				model.output_states
			else
				model.new_game_state
				model.update_mini_state

				model.ok_state
				model.states_msg_append ("%N")
				model.states_msg_append ("  ")
				model.states_msg_append ("Mission aborted. Try test(3,5,7,15,30)")

				model.output_states
			end
		end

end
