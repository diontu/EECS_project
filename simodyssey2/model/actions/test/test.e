note
	description: "Summary description for {TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST

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

feature -- thresholds
	a_threshold: INTEGER
	j_threshold: INTEGER
	m_threshold: INTEGER
	b_threshold: INTEGER
	p_threshold: INTEGER

feature -- constructor
	make -- add the formal parameters
		do
			model := model_access.m
			shared_info := shared_info_access.shared_info
			entity_ids := entity_ids_access.entity_ids
		end

feature -- add thresholds
	add_thresholds (a_thresh: INTEGER_32 ; j_thresh: INTEGER_32 ; m_thresh: INTEGER_32 ; b_thresh: INTEGER_32 ; p_thresh: INTEGER_32)
		do
			a_threshold := a_thresh
			j_threshold := j_thresh
			m_threshold := m_thresh
			b_threshold := b_thresh
			p_threshold := p_thresh
		end

	thresholds_are_non_decreasing_order: BOOLEAN
		do
			Result := true
			if a_threshold <= j_threshold  then
				if j_threshold <= m_threshold then
					if m_threshold <= b_threshold then
						if b_threshold <= p_threshold then
							Result := true
						else
							Result := false
						end
					else
						Result := false
					end
				else
					Result := false
				end
			else
				Result := false
			end
		end

feature -- execute
	execute
		do
			-- attach model
			model := model_access.m
			shared_info := shared_info_access.shared_info
			entity_ids := entity_ids_access.entity_ids

			-- next turn state
			model.new_turn_state

			if not model.mode.is_equal ("none") then
				model.update_mini_state
				model.error_state

				model.states_msg_append ("%N")
				model.states_msg_append ("  ")
				model.states_msg_append ("To start a new mission, please abort the current one first.")

				model.output_states
			else
				if not thresholds_are_non_decreasing_order then
					model.update_mini_state
					model.error_state

					model.states_msg_append ("%N")
					model.states_msg_append ("  ")
					model.states_msg_append ("Thresholds should be non-decreasing order.")

					model.output_states
				else
					--TODO: implement logic for TEST
					entity_ids.delete_all
					shared_info.reset
					shared_info.test(a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)
					model.make_new_galaxy

					model.update_state
					model.test_mode
					model.ok_state

					model.output_states
					model.output_movements
					model.output_sectors
					model.output_descriptions
					model.output_deaths
					model.output_galaxy
				end
			end
		end

end
