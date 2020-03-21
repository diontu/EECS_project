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

feature -- constructor
	make -- add the formal parameters
		local
			model_access: ETF_MODEL_ACCESS
		do
			model := model_access.m
		end

feature -- execute
	execute
		do

		end

end
