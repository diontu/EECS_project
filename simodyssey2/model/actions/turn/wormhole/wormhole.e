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

feature -- execute -- should only allow the explorer, benign and malevolent use
	execute (entity_alphabet: ENTITY_ALPHABET)
		do

		end

end
