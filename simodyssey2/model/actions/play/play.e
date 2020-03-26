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
	model: ETF_MODEL
	model_access: ETF_MODEL_ACCESS

	--shared info
	shared_info: SHARED_INFORMATION
	shared_info_access: SHARED_INFORMATION_ACCESS

	--entity_ids
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS

feature -- constructor
	make
		do
			model := model_access.m
			shared_info := shared_info_access.shared_info
			entity_ids := entity_ids_access.entity_ids
		end

feature -- execute
	execute
		do
			-- attach model, info and ids here
			model := model_access.m
			shared_info := shared_info_access.shared_info
			entity_ids := entity_ids_access.entity_ids

			-- new turn state
			model.new_turn_state

			if not model.mode.is_equal ("none") then
				model.update_mini_state
				model.error_state

				model.states_msg_append ("%N")
				model.states_msg_append ("  ")
				model.states_msg_append ("To start a new mission, please abort the current one first.")

				model.output_states
			else
				entity_ids.delete_all
				shared_info.reset
				shared_info.test (3, 5, 7, 15, 30)
				model.play_mode

				model.update_state
				model.ok_state
				model.make_new_galaxy

				model.output_states
				model.output_movements
				model.output_galaxy
			end
		end

end
