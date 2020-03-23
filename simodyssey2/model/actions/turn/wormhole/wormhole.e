note
	description: "Summary description for {WORMHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE

create
	make

feature -- attributes
	model: ETF_MODEL

feature -- constructor
	make
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
