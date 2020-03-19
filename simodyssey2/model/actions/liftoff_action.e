note
	description: "LIFTOFF_ACTION object is only created in LIFTOFF_MOVE"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIFTOFF_ACTION

inherit
	ACTION

create
	make

feature -- constructor
	make
		do
			action := "liftoff"
		end

feature -- attribute
	action: STRING

end
