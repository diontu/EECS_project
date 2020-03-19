note
	description: "Summary description for {BLACKHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLACKHOLE

inherit
	ENTITY

create
	make

feature {NONE} -- Constructor
	make
		do
			position := [0,0]
		end

feature
	position: TUPLE[INTEGER,INTEGER]

feature
	add_pos(pos: TUPLE[INTEGER, INTEGER])
		do
			position := pos
		end

end
