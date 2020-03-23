note
	description: "Summary description for {MOVE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVE

create
	make

feature  -- attributes
	-- model
	model: ETF_MODEL
	model_access: ETF_MODEL_ACCESS

	-- direction
	direction: TUPLE[left_right_dir: INTEGER; up_down_dir: INTEGER]

	-- explorer
--	explorer: EXPLORER_ENT

feature -- constructor
	make
		do
			model := model_access.m
			create direction.default_create
		end

feature -- add direction
	add_direction (dir: TUPLE[INTEGER, INTEGER])
		do
			direction := dir
		end

feature -- execute
	execute
		local
			mu: MOVEMENT_UTILITY
			new_pos: TUPLE[new_pos_row: INTEGER; new_pos_col: INTEGER]
		do
			-- must attach model in whichever function it was used
			model := model_access.m

			-- check if in play or test mode
			if model.mode.is_equal ("none") then
				model.update_mini_state
				model.error_state
				model.states_msg_append ("%N")
				model.states_msg_append ("  ")
				model.states_msg_append ("Negative on that request:no mission in progress.")
				model.output_states
			else
				create mu.make
				new_pos := mu.transform ([1,1], direction)
			end

		end


end
