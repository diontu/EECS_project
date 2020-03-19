note
	description: "Summary description for {ENTITY_IDS_ACCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	ENTITY_IDS_ACCESS

feature
	entity_ids: ENTITY_IDS
		once
			create Result.make
		end

invariant
	entity_ids = entity_ids

end
