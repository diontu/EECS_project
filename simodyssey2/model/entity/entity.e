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
	position: TUPLE[INTEGER,INTEGER]
		deferred
		end

end
