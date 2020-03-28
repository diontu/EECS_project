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

feature -- constructor
	make
		do
			model := model_access.m
		end

feature -- execute
	execute
		do
			model := model_access.m
			if model.mode.is_equal ("none") then
					model.update_mini_state
					model.error_state
					model.states_msg_append ("%N")
					model.states_msg_append ("  ")
					model.states_msg_append ("Negative on that request:no mission in progress.")
					model.output_states
			else
				model.update_state
			end
		end

end
