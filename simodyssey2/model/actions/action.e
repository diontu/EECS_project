note
	description: "The classes that inherit this class are only used for their 'action' attribute and specific properties associated with their action."
	description2: "All classes that inherit this class constitutes a valid turn"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ACTION

feature -- attribute
	action: STRING
		deferred
		end

end
