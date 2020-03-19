note
	description: "MOVE_ACTION object is only created in ETF_MOVE"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVE_ACTION

inherit
	ACTION

create
	make

feature -- constructor
	make (dir: TUPLE[INTEGER, INTEGER])
		do
			action := "move"
			direction := dir
		end

feature -- attributes
	action: STRING
	direction: TUPLE[INTEGER, INTEGER]

end
