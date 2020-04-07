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
	game_state: GAME_STATE
	game_state_access: GAME_STATE_ACCESS

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
			game_state := game_state_access.gs
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
			-- attach game_state
			game_state := game_state_access.gs
			shared_info := shared_info_access.shared_info
			entity_ids := entity_ids_access.entity_ids

			-- next turn state
			game_state.new_turn_state

			if not game_state.mode.is_equal ("none") then
				game_state.update_mini_state
				game_state.error_state

				game_state.states_msg_append ("%N")
				game_state.states_msg_append ("  ")
				game_state.states_msg_append ("To start a new mission, please abort the current one first.")

				game_state.output_states
			else
				if not thresholds_are_non_decreasing_order then
					game_state.update_mini_state
					game_state.error_state

					game_state.states_msg_append ("%N")
					game_state.states_msg_append ("  ")
					game_state.states_msg_append ("Thresholds should be non-decreasing order.")

					game_state.output_states
				else
					--TODO: implement logic for TEST
					entity_ids.delete_all
					shared_info.reset
					shared_info.test(a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)
					game_state.make_new_galaxy

					game_state.update_state
					game_state.test_mode
					game_state.ok_state

					game_state.output_states
					game_state.output_movements
					game_state.output_sectors
					game_state.output_descriptions
					game_state.output_deaths
					game_state.output_galaxy
				end
			end
		end

end
