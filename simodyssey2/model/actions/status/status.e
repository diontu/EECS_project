note
	description: "Summary description for {STATUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATUS

create
	make

feature -- attributes
	game_state: GAME_STATE
	game_state_access: GAME_STATE_ACCESS
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS

feature -- constructor
	make
		do
			-- attach game_state
			game_state := game_state_access.gs
			entity_ids := entity_ids_access.entity_ids
		end

feature -- execute
	execute
	local
		explorer : EXPLORER_ENT
		sector : SECTOR
		explorer_entity_alphabet : ENTITY_ALPHABET
		do
			-- attach game_state and info here
			game_state := game_state_access.gs
			entity_ids := entity_ids_access.entity_ids

			-- new turn state
			game_state.new_turn_state

			if game_state.mode.is_equal ("none") then
				game_state.update_mini_state
				game_state.error_state

				game_state.states_msg_append ("%N")
				game_state.states_msg_append ("  ")
				game_state.states_msg_append ("Negative on that request:no mission in progress.")
				game_state.output_states
			else
				-- if the mode in in play or test
				game_state.update_mini_state
				game_state.ok_state

			explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)
			if attached {EXPLORER_ENT} explorer_entity_alphabet.entity as exp then
			explorer := exp
			end

			if attached{EXPLORER_ENT} explorer as exp then
			sector := game_state.galaxy.grid[exp.position.row,exp.position.col]
			if exp.is_landed then
				game_state.states_msg_append ("%N")
				game_state.states_msg_append ("  ")
				game_state.states_msg_append ("Explorer status report:Stationary on planet surface at [")
				game_state.states_msg_append (exp.position.row.out)
				game_state.states_msg_append (",")
				game_state.states_msg_append (exp.position.col.out)
				game_state.states_msg_append (",")
				game_state.states_msg_append (sector.return_quadrent_exp.out)
				game_state.states_msg_append ("]")
				game_state.states_msg_append ("%N")
				game_state.states_msg_append ("  ")
				game_state.states_msg_append ("Life units left:")
				game_state.states_msg_append (exp.life.out)
				game_state.states_msg_append (", Fuel units left:")
				game_state.states_msg_append (exp.fuel.out)
				game_state.output_states
			else
				game_state.states_msg_append ("%N")
				game_state.states_msg_append ("  ")
				game_state.states_msg_append ("Explorer status report:Travelling at cruise speed at [")
				game_state.states_msg_append (exp.position.row.out)
				game_state.states_msg_append (",")
				game_state.states_msg_append (exp.position.col.out)
				game_state.states_msg_append (",")
				game_state.states_msg_append (sector.return_quadrent_exp.out)
				game_state.states_msg_append ("]")
				game_state.states_msg_append ("%N")
				game_state.states_msg_append ("  ")
				game_state.states_msg_append ("Life units left:")
				game_state.states_msg_append (exp.life.out)
				game_state.states_msg_append (", Fuel units left:")
				game_state.states_msg_append (exp.fuel.out)
				game_state.output_states
			end
			end
			end
		end

end
