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

feature -- constructor
	local
		model_access: ETF_MODEL_ACCESS
	make
		do
			model := model_access.m
		end

feature -- execute
	execute
		do

		end

end
