note
	description: "Summary description for {WORMHOLE_ENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE_ENT

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
