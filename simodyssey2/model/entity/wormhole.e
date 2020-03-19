note
	description: "Summary description for {WORMHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE

inherit
	ENTITY

create
	make

feature {NONE} -- Constructor
	make
		do
			position := [0,0]
		end

feature -- commands
	add_pos(pos: TUPLE[INTEGER, INTEGER])
		do
			position := pos
		end

feature
	position: TUPLE[INTEGER,INTEGER]

end
