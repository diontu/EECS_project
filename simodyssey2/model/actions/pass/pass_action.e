note
	description: "PASS_ACTION object is only created in ETF_PASS"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PASS_ACTION

inherit
	ACTION

create
	make

feature -- constructor
	make
		do
			action := "pass"
		end

feature -- attribute
	action: STRING

end
