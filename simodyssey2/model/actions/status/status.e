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
	model: ETF_MODEL
	model_access: ETF_MODEL_ACCESS
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS

feature -- constructor
	make
		do
			-- attach model
			model := model_access.m
			entity_ids := entity_ids_access.entity_ids
		end

feature -- execute
	execute
	local
		explorer : EXPLORER_ENT
		sector : SECTOR
		explorer_entity_alphabet : ENTITY_ALPHABET
		do
			-- attach model and info here
			model := model_access.m
			entity_ids := entity_ids_access.entity_ids

			-- new turn state
			model.new_turn_state

			if model.mode.is_equal ("none") then
				model.update_mini_state
				model.error_state

				model.states_msg_append ("%N")
				model.states_msg_append ("  ")
				model.states_msg_append ("Negative on that request:no mission in progress.")
				model.output_states
			else
				-- if the mode in in play or test
				model.update_mini_state
				model.ok_state

			explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)
			if attached {EXPLORER_ENT} explorer_entity_alphabet.entity as exp then
			explorer := exp
			end

			if attached{EXPLORER_ENT} explorer as exp then
			sector := model.galaxy.grid[exp.position.row,exp.position.col]
			if exp.is_landed then
				model.states_msg_append ("%N")
				model.states_msg_append ("  ")
				model.states_msg_append ("Explorer status report:Stationary on planet surface at [")
				model.states_msg_append (exp.position.row.out)
				model.states_msg_append (",")
				model.states_msg_append (exp.position.col.out)
				model.states_msg_append (",")
				model.states_msg_append (sector.return_quadrent_exp.out)
				model.states_msg_append ("]")
				model.states_msg_append ("%N")
				model.states_msg_append ("  ")
				model.states_msg_append ("Life units left:")
				model.states_msg_append (exp.life.out)
				model.states_msg_append (", Fuel units left:")
				model.states_msg_append (exp.fuel.out)
				model.output_states
			else
				model.states_msg_append ("%N")
				model.states_msg_append ("  ")
				model.states_msg_append ("Explorer status report:Travelling at cruise speed at [")
				model.states_msg_append (exp.position.row.out)
				model.states_msg_append (",")
				model.states_msg_append (exp.position.col.out)
				model.states_msg_append (",")
				model.states_msg_append (sector.return_quadrent_exp.out)
				model.states_msg_append ("]")
				model.states_msg_append ("%N")
				model.states_msg_append ("  ")
				model.states_msg_append ("Life units left:")
				model.states_msg_append (exp.life.out)
				model.states_msg_append (", Fuel units left:")
				model.states_msg_append (exp.fuel.out)
				model.output_states
			end
			end
			end
		end

end
