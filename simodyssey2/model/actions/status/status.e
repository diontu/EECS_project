note
	description: "Summary description for {STATUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATUS

create
	make

feature -- attributes
	model: ETF_MODEL
	model_access: ETF_MODEL_ACCESS

feature -- constructor
	make
		do
			-- attach model
			model := model_access.m
			
		end

feature -- execute
	execute
		do
			-- attach model and info here
			model := model_access.m

			-- new turn state
			model.new_turn_state

			if model.mode.is_equal ("none") then
				model.update_mini_state
				model.error_state

				model.states_msg_append ("%N")
				model.states_msg_append ("  ")
				model.states_msg_append ("To start a new mission, please abort the current one first.")
				model.output_states
			else
				-- if the mode in in play or test
				model.update_state
				model.ok_state


			end
		end

end
