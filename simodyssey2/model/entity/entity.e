note
	description: "Summary description for {ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY

feature
	add_pos(pos: TUPLE[INTEGER,INTEGER])
		deferred
		end
		
	position: TUPLE[row: INTEGER; col:INTEGER]
		deferred
		end

end
