note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_WORMHOLE
inherit
	ETF_WORMHOLE_INTERFACE
create
	make
feature -- command
	wormhole
		local
			wormhole_action: WORMHOLE_ACTION
    	do
			-- perform some update on the model state
			wormhole_action := create {WORMHOLE_ACTION}.make
--			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
