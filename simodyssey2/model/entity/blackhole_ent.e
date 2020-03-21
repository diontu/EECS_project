note
	description: "Summary description for {BLACKHOLE_ENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLACKHOLE_ENT

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
