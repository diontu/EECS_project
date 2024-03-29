note
	description: "Summary description for {TURN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TURN

create
	make

feature -- game_state
	game_state: GAME_STATE
	game_state_access: GAME_STATE_ACCESS
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS
	gen: RANDOM_GENERATOR_ACCESS

	-- player commands
	land_command: LAND
	liftoff_command: LIFTOFF
	move_command: MOVE
	pass_command: PASS
	wormhole_command: WORMHOLE

feature -- constructor -- ALWAYS MAKE SURE THE game_state IS ATTACHED
	make
		do
			game_state := game_state_access.gs
			entity_ids := entity_ids_access.entity_ids
			create land_command.make
			create liftoff_command.make
			create move_command.make
			create pass_command.make
			create wormhole_command.make

			new_sector_full := false
		ensure
			attached_game_state: attached game_state
		end

feature -- execute

	execute (action: ACTION)
		local
			explorer_entity_alphabet: ENTITY_ALPHABET
			movable_entities_alphabet: ARRAY[ENTITY_ALPHABET]
			turns_left: INTEGER
			sector: SECTOR -- current sector
			num: INTEGER
			movable_entity_is_dead: BOOLEAN
		do
			-- must attach the game_state here... idk why but the one in constructor is broken
			game_state := game_state_access.gs
			entity_ids := entity_ids_access.entity_ids

			-- next turn state
			game_state.new_turn_state

			-- attach explorer with entity alphabet
			explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)
			-- attach the movable entities
			movable_entities_alphabet := entity_ids.get_movable_entities
--			-- attach current sector
--			sector := game_state.galaxy.grid[]

			--logic
			act(action)
			-- if error exists, then skip entire if block
-------------- print the outputs at the end of the if statement if no errors -------------
			if game_state.ok_or_error.is_equal ("ok") then
				-- perform check(entity), etc
				check_entity (explorer_entity_alphabet)			--
				if attached {EXPLORER_ENT} explorer_entity_alphabet.entity as explorer then
					if not (game_state.is_gameover and explorer.is_landed) then
						across movable_entities_alphabet as entity_alphabet loop
							-- if entity dies,
							-- remove the entity from the board
-- ======================================================================================
-- POSSIBLE SOLUTION: check if it's dead, if not dead, then go through the across
-- ======================================================================================
							-- and from the movable_entities_alphabet
							if attached {PLANET_ENT} entity_alphabet.item.entity as planet_ent then
								movable_entity_is_dead := planet_ent.is_dead
							elseif attached {FUELED_ENT} entity_alphabet.item.entity as fueled_ent then
								movable_entity_is_dead := fueled_ent.is_dead
							elseif attached {ASTEROID_ENT} entity_alphabet.item.entity as asteroid_ent then
								movable_entity_is_dead := asteroid_ent.is_dead
							end

							if not movable_entity_is_dead then
								-- attach current sector with the current movable entity
								if attached {ENTITY} entity_alphabet.item.entity as entity then
									sector := game_state.galaxy.grid[entity.position.row, entity.position.col]

									if attached {PLANET_ENT} entity_alphabet.item.entity as planet then
										turns_left := planet.turns_left
									elseif attached {REPRODUCIBLE_ENT} entity_alphabet.item.entity as reproducible then
										turns_left := reproducible.turns_left
									elseif attached {ASTEROID_ENT} entity_alphabet.item.entity as asteroid then
										turns_left := asteroid.turns_left
									end
									-- if the turns_left is 0...
									if turns_left = 0 then
										-- special case for planet
										if attached {PLANET_ENT} entity_alphabet.item.entity and sector.has_star then
											if attached {PLANET_ENT} entity_alphabet.item.entity as planet then
												-- if the sector has a star
												if not planet.attached_to_star then -- addition start
													planet.attach_to_star
													if sector.has_yd then
														num := gen.rchoose(1,2)
														if num = 2 then
															planet.support_life
														end
													end
												end -- addition end
											end
										else -- else planet doesn't have a star or if it's another movable entity
											if sector.has_wormhole and (attached {BENIGN_ENT} entity_alphabet.item.entity or attached {MALEVOLENT_ENT} entity_alphabet.item.entity) then
												wormhole_command.execute (entity_alphabet.item)
											else
												-- movement for the other movable entities
												new_sector_full := false
												movement (entity_alphabet.item)
											end
											check_entity(entity_alphabet.item)
											-- if the entity did not die
	-- =======================================================================================
	-- PROBLEM: only way the entity dies rn, is by running out of fuel
	-- =======================================================================================
	-- =======================================================================================
	-- SOLUTION: add a command which sets the is_dead to be true
	-- =======================================================================================
											-- movable_entity_is_dead
											if attached {PLANET_ENT} entity as planet_ent then
												movable_entity_is_dead := planet_ent.is_dead
											elseif attached {FUELED_ENT} entity as fueled_ent then
												movable_entity_is_dead := fueled_ent.is_dead
											elseif attached {ASTEROID_ENT} entity as asteroid_ent then
												movable_entity_is_dead := asteroid_ent.is_dead
											end

											if not movable_entity_is_dead then
												reproduce (entity_alphabet.item)
												behave (entity_alphabet.item)
											end
										end
									else
										if attached {PLANET_ENT} entity_alphabet.item.entity as planet then
											planet.decrease_turns
										elseif attached {REPRODUCIBLE_ENT} entity_alphabet.item.entity as reproducible then
											reproducible.decrement_turns
										elseif attached {ASTEROID_ENT} entity_alphabet.item.entity as asteroid then
											asteroid.decrement_turns
										end
									end
								end
							end
						end
					end
					-- display the outputs after the turn
					game_state.output_states
					if not (game_state.is_gameover and explorer.is_landed) then
						game_state.output_movements
						if game_state.mode.is_equal ("test") then
							game_state.output_sectors
							game_state.output_descriptions
							game_state.output_deaths
						end
						game_state.output_galaxy
					end

					-- entering this if statement ends the game
					if game_state.is_gameover then
						if explorer.is_dead and game_state.mode.is_equal ("test") then
							game_state.output_last_message
						end
						game_state.not_in_game_mode
						game_state.not_gameover
					end
				end

--				-- display the outputs after the turn
--				game_state.output_states
--				game_state.output_movements
--				if game_state.mode.is_equal ("test") then
--					game_state.output_sectors
--					game_state.output_descriptions
--					game_state.output_deaths
--				end
--				game_state.output_galaxy

--				-- entering this if statement ends the game
--				if game_state.is_gameover then
--					game_state.not_in_game_mode
--					game_state.not_gameover
--				end
			end
		end

feature {NONE} -- make private features
	act (action: ACTION)
		local

		explorer_entity_alphabet : ENTITY_ALPHABET

		do
			entity_ids := entity_ids_access.entity_ids
			explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)

			if action.action.is_equal ("land") then
				land_command.execute

			elseif action.action.is_equal ("liftoff") then
				liftoff_command.execute

			elseif action.action.is_equal ("move") then
				if attached {MOVE_ACTION} action as moveAction then
					move_command.add_direction (moveAction.direction)
				end
				move_command.execute

			elseif action.action.is_equal ("pass") then
				pass_command.execute

			elseif action.action.is_equal ("wormhole") then

				wormhole_command.execute(explorer_entity_alphabet)
			end
		end

feature -- movement of other movable entities
	movement (ent_alpha: ENTITY_ALPHABET)
		-- movement by movable entities to neighbouring sector
		local
			mu: MOVEMENT_UTILITY
			du: DIRECTION_UTILITY
			selected_dir: TUPLE [row: INTEGER; col: INTEGER]
			old_pos: TUPLE[row: INTEGER; col: INTEGER]
			new_pos: TUPLE[row: INTEGER; col: INTEGER]
			old_sector: SECTOR -- old sector
			new_sector: SECTOR -- new sector

			quadrant: INTEGER
			loop_counter: INTEGER
			found: BOOLEAN
		do
			create mu.make
			selected_dir := du.num_dir (gen.rchoose (1, 8))
			old_pos := ent_alpha.entity.position
			new_pos := mu.transform (ent_alpha.entity.position, selected_dir)
			old_sector := game_state.galaxy.grid[old_pos.row, old_pos.col]
			new_sector := game_state.galaxy.grid[new_pos.row, new_pos.col]

			game_state.an_entity_moved
			game_state.movements_msg_append ("%N")
			game_state.movements_msg_append ("    ")
			game_state.movements_msg_append ("[")
			game_state.movements_msg_append (ent_alpha.id.out)
			game_state.movements_msg_append (",")
			game_state.movements_msg_append (ent_alpha.item.out)
			game_state.movements_msg_append ("]")
			game_state.movements_msg_append (":")
			game_state.movements_msg_append ("[")
			game_state.movements_msg_append (old_pos.row.out)
			game_state.movements_msg_append (",")
			game_state.movements_msg_append (old_pos.col.out)
			game_state.movements_msg_append (",")
			from
				quadrant := 1
				loop_counter := 1
				found := false
			until
				loop_counter > old_sector.contents.count or found
			loop
				if attached {ENTITY_ALPHABET} old_sector.contents[loop_counter] as ent_alp then
					if ent_alp.id = ent_alpha.id then
						found := true
						quadrant := loop_counter
					end
				end
				loop_counter := loop_counter + 1
			end
			game_state.movements_msg_append (quadrant.out)
			game_state.movements_msg_append ("]")

			if not new_sector.is_full then
				old_sector.delete (ent_alpha)
				new_sector.put (ent_alpha, new_pos)

				game_state.movements_msg_append ("->")
				game_state.movements_msg_append ("[")
				game_state.movements_msg_append (new_pos.row.out)
				game_state.movements_msg_append (",")
				game_state.movements_msg_append (new_pos.col.out)
				game_state.movements_msg_append (",")
				from
					quadrant := 1
					loop_counter := 1
					found := false
				until
					loop_counter > new_sector.contents.count or found
				loop
					if attached {ENTITY_ALPHABET} new_sector.contents[loop_counter] as ent_alp then
						if ent_alp.id = ent_alpha.id then
							found := true
							quadrant := loop_counter
						end
					end
					loop_counter := loop_counter + 1
				end
				game_state.movements_msg_append (quadrant.out)
				game_state.movements_msg_append ("]")
			else
				if attached {FUELED_ENT} ent_alpha.entity then
					new_sector_full := true
				elseif attached {ASTEROID_ENT} ent_alpha.entity then
					new_sector_full := true
				elseif attached {PLANET_ENT} ent_alpha.entity then
					new_sector_full := true
				end
			end
		end

feature -- reproduce of fueled entities
-- =========================================================================================
-- PROBLEM: after it reproduces, it doesn't update the movable_entities_alphabet in the
-- 'execute' feature of this class... will possibly need to update it?
-- =========================================================================================
	reproduce (ent_alpha: ENTITY_ALPHABET)
		local
			sector: SECTOR -- current sector
			duplicate_ent_alpha: ENTITY_ALPHABET

			quadrant: INTEGER
			loop_counter: INTEGER
			found: BOOLEAN
		do
			sector := game_state.galaxy.grid[ent_alpha.entity.position.row, ent_alpha.entity.position.col]
			if attached {REPRODUCIBLE_ENT} ent_alpha.entity as reproducible then
				if not sector.is_full and (reproducible.actions_left = 0) then
					if attached {BENIGN_ENT} reproducible then
						create duplicate_ent_alpha.make ('B')
					elseif attached {MALEVOLENT_ENT} reproducible then
						create duplicate_ent_alpha.make ('M')
					elseif attached {JANITAUR_ENT} reproducible then
						create duplicate_ent_alpha.make ('J')
					end
					if attached {ENTITY_ALPHABET} duplicate_ent_alpha as attached_dup_ent_alpha then
						sector.put (attached_dup_ent_alpha, ent_alpha.entity.position)
						if attached {REPRODUCIBLE_ENT} duplicate_ent_alpha.entity as duplicate_reproducible then
							duplicate_reproducible.set_turns (gen.rchoose (0, 2))
						end
						reproducible.reset_actions

						-- outputs
						game_state.movements_msg_append ("%N")
						game_state.movements_msg_append ("      ")
						game_state.movements_msg_append ("reproduced [")
						game_state.movements_msg_append (attached_dup_ent_alpha.id.out)
						game_state.movements_msg_append (",")
						game_state.movements_msg_append (attached_dup_ent_alpha.item.out)
						game_state.movements_msg_append ("] at [")
						game_state.movements_msg_append (attached_dup_ent_alpha.entity.position.row.out)
						game_state.movements_msg_append (",")
						game_state.movements_msg_append (attached_dup_ent_alpha.entity.position.col.out)
						game_state.movements_msg_append (",")
						from
							quadrant := 1
							loop_counter := 1
							found := false
						until
							loop_counter > sector.contents.count or found
						loop
							if attached {ENTITY_ALPHABET} sector.contents[loop_counter] as ent_alpha_inner then
								if attached_dup_ent_alpha.id = ent_alpha_inner.id then
									found := true
									quadrant := loop_counter
								end
							end
							loop_counter := loop_counter + 1
						end
						game_state.movements_msg_append (quadrant.out)
						game_state.movements_msg_append ("]")
					end
				else
					if not (reproducible.actions_left = 0) then
						reproducible.decrement_actions
					elseif sector.is_full then
						-- will try to reproduce the next time the entity acts
					end
				end
			end
		end

feature -- behave
	behave (ent_alpha: ENTITY_ALPHABET)
		local
			sector: SECTOR -- current sector
			custom_string: STRING
			num: INTEGER
		do
			create custom_string.make_empty
			sector := game_state.galaxy.grid[ent_alpha.entity.position.row, ent_alpha.entity.position.col]

			if attached {ASTEROID_ENT} ent_alpha.entity  as asteroid_ent then
				across entity_ids.get_entities_at (ent_alpha.entity.position) as possible_void_ent_alpha loop
					if attached {ENTITY_ALPHABET} possible_void_ent_alpha.item as ent_alp then
						if attached {REPRODUCIBLE_ENT} ent_alp.entity as reproducible_ent then
							-- entity dies
							reproducible_ent.died
							game_state.an_entity_died
							create custom_string.make_empty

							if attached {BENIGN_ENT} ent_alp.entity then
								custom_string.append ("Benign ")
							elseif attached {MALEVOLENT_ENT} ent_alp.entity  then
								custom_string.append ("Malevolent ")
							elseif attached {JANITAUR_ENT} ent_alp.entity  then
								custom_string.append ("Janitaur ")
							end

							custom_string.append ("got destroyed by asteroid (id: ")
							custom_string.append (ent_alpha.id.out)
							custom_string.append (") at Sector:")
							custom_string.append (ent_alpha.entity.position.row.out)
							custom_string.append (":")
							custom_string.append (ent_alpha.entity.position.col.out)

							movements_append_deaths (ent_alp, sector)
							deaths_append_deaths (ent_alp, custom_string)

							sector.delete (ent_alp)
						end

						if attached {EXPLORER_ENT} ent_alp.entity as explorer_ent then
							if not explorer_ent.is_landed then
								explorer_ent.died
								game_state.an_entity_died

								explorer_ent.change_life (0)

								custom_string.append ("Explorer ")
								custom_string.append ("got destroyed by asteroid (id: ")
								custom_string.append (ent_alpha.id.out)
								custom_string.append (") at Sector:")
								custom_string.append (ent_alpha.entity.position.row.out)
								custom_string.append (":")
								custom_string.append (ent_alpha.entity.position.col.out)

								movements_append_deaths (ent_alp, sector)
								deaths_append_deaths (ent_alp, custom_string)

								game_state.last_msg_append (custom_string)
								game_state.states_msg_append (game_state.last_message)

								sector.delete (ent_alp)

								-- game is then over
								game_state.gameover
							end
						end
					end
				end
				asteroid_ent.set_turns (gen.rchoose (0, 2))

			elseif attached {JANITAUR_ENT} ent_alpha.entity as janitaur_ent then
				across entity_ids.get_entities_at (ent_alpha.entity.position) as ent_alp loop
					if attached {ENTITY_ALPHABET} ent_alp.item as ea then
						if attached {ASTEROID_ENT} ea.entity and janitaur_ent.load_level < 2 then
							if attached {ASTEROID_ENT} ea.entity as asteroid then
								janitaur_ent.load_janitaur
								asteroid.died
								game_state.an_entity_died
								create custom_string.make_empty

								custom_string.append ("Asteroid ")
								custom_string.append ("imploded by janitaur (id: ")
								custom_string.append (ent_alpha.id.out)
								custom_string.append (") at Sector:")
								custom_string.append (ent_alpha.entity.position.row.out)
								custom_string.append (":")
								custom_string.append (ent_alpha.entity.position.col.out)

								movements_append_deaths (ea, sector)
								deaths_append_deaths (ea, custom_string)

								sector.delete (ea)
							end
						end
					end
				end
				-- if there is a wormhole, dump the load
				if sector.has_wormhole then
					janitaur_ent.empty_janitaur
				end
				janitaur_ent.set_turns (gen.rchoose (0, 2))

			elseif attached {BENIGN_ENT} ent_alpha.entity as benign_ent then
				across entity_ids.get_entities_at (ent_alpha.entity.position) as ent_alp loop
					if attached {ENTITY_ALPHABET} ent_alp.item as ea then
						if attached {MALEVOLENT_ENT} ea.entity as malevolent then
							malevolent.died
							game_state.an_entity_died
							create custom_string.make_empty

							custom_string.append ("Malevolent ")
							custom_string.append ("destroyed by benign (id: ")
							custom_string.append (ent_alpha.id.out)
							custom_string.append (") at Sector:")
							custom_string.append (ent_alpha.entity.position.row.out)
							custom_string.append (":")
							custom_string.append (ent_alpha.entity.position.col.out)

							movements_append_deaths (ea, sector)
							deaths_append_deaths (ea, custom_string)

							sector.delete (ea)
						end
					end
				end
				benign_ent.set_turns (gen.rchoose (0, 2))

			elseif attached {MALEVOLENT_ENT} ent_alpha.entity as malevolent_ent then
				across
					entity_ids.get_entities_at (ent_alpha.entity.position)
				as
					ent_alp
				loop
					if attached {ENTITY_ALPHABET} ent_alp.item as ea then
						if attached {EXPLORER_ENT} ea.entity and not sector.has_benign then
							if attached {EXPLORER_ENT} ea.entity as explorer then
								if not explorer.is_landed then
									explorer.decrement_life_by (1)
									if explorer.life = 0 then
										explorer.died
										game_state.an_entity_died
										create custom_string.make_empty

										custom_string.append ("Explorer got lost in space - out of life support at Sector:")
										custom_string.append (ent_alpha.entity.position.row.out)
										custom_string.append (":")
										custom_string.append (ent_alpha.entity.position.col.out)

										game_state.last_msg_append (custom_string)
										game_state.states_msg_append (game_state.last_message)

										deaths_append_deaths (ea, custom_string)

										sector.delete (ea)

										game_state.gameover
									end
									movements_append_deaths (ea, sector)
								end
							end
						end
					end
				end
				malevolent_ent.set_turns (gen.rchoose (0, 2))

			elseif attached {PLANET_ENT} ent_alpha.entity as planet_ent then
				if sector.has_star then
					planet_ent.attach_to_star
					if sector.has_yd then
						num := gen.rchoose (1, 2)
						if num = 2 then
							planet_ent.support_life
						end
					end
				else
					planet_ent.set_turns (gen.rchoose (0, 2))
				end
			end
		end

feature -- helper variable for check_entity
	new_sector_full: BOOLEAN

feature {NONE} -- check_entity
	check_entity (ent_alpha: ENTITY_ALPHABET)
		local
			sector: SECTOR
			variable_deaths_msg: STRING -- bc the death_msg could change from death by fuel to death by blackhole
			current_entity_died: BOOLEAN
		do
			current_entity_died := false
			-- current sector
			if attached {ENTITY} ent_alpha.entity as ent then
				-- could be somthing wrong OVER HERE
				sector := game_state.galaxy.grid[ent.position.row, ent.position.col]

				-- includes explorer, benign, malevolent, janitaur

				-- if the entity didn't use the wormhole and the explorer did not pass
				if attached {FUELED_ENT} ent as fueled_ent then
					if not fueled_ent.used_wormhole then
						if attached {EXPLORER_ENT} ent as explorer then
							if not explorer.did_pass then
								fueled_ent.decrement_fuel_by (1)
							end
						else
							if not new_sector_full then
								fueled_ent.decrement_fuel_by (1)
							end
						end
					end
					if fueled_ent.used_wormhole then
						fueled_ent.not_in_wormhole
					end
					if attached {EXPLORER_ENT} ent as explorer then
						if explorer.did_pass then
							explorer.did_not_pass_turn
						end

					end
				end

				-- if the entity got to a sector with a star
				if attached {FUELED_ENT} ent as fueled_ent and sector.has_star then
					if sector.has_yd then
						fueled_ent.increment_fuel_by (2)
					elseif sector.has_bg then
						fueled_ent.increment_fuel_by (5)
					end
				end

				-- if the entity ran out of fuel
				create variable_deaths_msg.make_empty
				if attached {FUELED_ENT} ent as fueled_ent then
					if fueled_ent.fuel = 0 then
						-- entity dies
						-- use the sector.delete(ent_alpha)?

						-- deletes the entity_alphabet from the board and entity_ids
--						sector.delete (ent_alpha)

						game_state.an_entity_died
						current_entity_died := true

						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("    ")
						variable_deaths_msg.append ("[")
						variable_deaths_msg.append (ent_alpha.id.out)
						variable_deaths_msg.append (",")
						variable_deaths_msg.append (ent_alpha.item.out)
						variable_deaths_msg.append ("]")
						variable_deaths_msg.append ("->")
						if attached {EXPLORER_ENT} fueled_ent as explorer then
							explorer.died
							variable_deaths_msg.append ("fuel:")
							variable_deaths_msg.append (explorer.fuel.out)
							variable_deaths_msg.append ("/3")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("life:")
							variable_deaths_msg.append (explorer.life.out)
							variable_deaths_msg.append ("/3")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("landed?:")
							variable_deaths_msg.append (explorer.is_landed.out.at (1).out)
							variable_deaths_msg.append (",")
							variable_deaths_msg.append ("%N")
							variable_deaths_msg.append ("      ")
							variable_deaths_msg.append ("Explorer got lost in space - out of fuel at Sector:")
							variable_deaths_msg.append (ent.position.row.out)
							variable_deaths_msg.append (":")
							variable_deaths_msg.append (ent.position.col.out)

							game_state.last_msg_append ("Explorer got lost in space - out of fuel at Sector:")
							game_state.last_msg_append (ent.position.row.out)
							game_state.last_msg_append (":")
							game_state.last_msg_append (ent.position.col.out)
							game_state.states_msg_append (game_state.last_message)

							-- make it so that the game has to end
							game_state.gameover

						elseif attached {BENIGN_ENT} fueled_ent as benign then
							benign.died
							variable_deaths_msg.append ("fuel:")
							variable_deaths_msg.append (benign.fuel.out)
							variable_deaths_msg.append ("/3")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("actions_left_until_reproduction:")
							variable_deaths_msg.append (benign.actions_left.out)
							variable_deaths_msg.append ("/1")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("turns_left:N/A,")
							variable_deaths_msg.append ("%N")
							variable_deaths_msg.append ("      ")
							variable_deaths_msg.append ("Benign got lost in space - out of fuel at Sector:")
							variable_deaths_msg.append (ent.position.row.out)
							variable_deaths_msg.append (":")
							variable_deaths_msg.append (ent.position.col.out)
						elseif attached {MALEVOLENT_ENT} fueled_ent as malevolent then
							malevolent.died
							variable_deaths_msg.append ("fuel:")
							variable_deaths_msg.append (malevolent.fuel.out)
							variable_deaths_msg.append ("/3")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("actions_left_until_reproduction:")
							variable_deaths_msg.append (malevolent.actions_left.out)
							variable_deaths_msg.append ("/1")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("turns_left:N/A,")
							variable_deaths_msg.append ("%N")
							variable_deaths_msg.append ("      ")
							variable_deaths_msg.append ("Malevolent got lost in space - out of fuel at Sector:")
							variable_deaths_msg.append (ent.position.row.out)
							variable_deaths_msg.append (":")
							variable_deaths_msg.append (ent.position.col.out)
						elseif attached {JANITAUR_ENT} fueled_ent as janitaur then
							janitaur.died
							variable_deaths_msg.append ("fuel:")
							variable_deaths_msg.append (janitaur.fuel.out)
							variable_deaths_msg.append ("/5")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("load:")
							variable_deaths_msg.append (janitaur.load_level.out)
							variable_deaths_msg.append ("/2")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("actions_left_until_reproduction:")
							variable_deaths_msg.append (janitaur.actions_left.out)
							variable_deaths_msg.append ("/2")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("turns_left:N/A,")
							variable_deaths_msg.append ("%N")
							variable_deaths_msg.append ("      ")
							variable_deaths_msg.append ("Janitaur got lost in space - out of fuel at Sector:")
							variable_deaths_msg.append (ent.position.row.out)
							variable_deaths_msg.append (":")
							variable_deaths_msg.append (ent.position.col.out)
						end
					end
				end

-- ========================================================================================
-- ERROR: whenever I delete from the entity from above and run the sector.has_bh command
-- I get an infinite loop
-- ========================================================================================
				-- if the entity is in a quadrant with a blackhole
				if sector.has_bh then
					-- entity dies in the blackhole
					-- use the sector.delete(ent_alpha)?
					create variable_deaths_msg.make_empty

--					sector.delete (ent_alpha)

					game_state.an_entity_died
					current_entity_died := true

					variable_deaths_msg.append ("%N")
					variable_deaths_msg.append ("    ")
					variable_deaths_msg.append ("[")
					variable_deaths_msg.append (ent_alpha.id.out)
					variable_deaths_msg.append (",")
					variable_deaths_msg.append (ent_alpha.item.out)
					variable_deaths_msg.append ("]")
					variable_deaths_msg.append ("->")
					if attached {EXPLORER_ENT} ent as explorer then
						explorer.died
						variable_deaths_msg.append ("fuel:")
						variable_deaths_msg.append (explorer.fuel.out)
						variable_deaths_msg.append ("/3")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("life:")
						variable_deaths_msg.append (explorer.life.out)
						variable_deaths_msg.append ("/3")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("landed?:")
						variable_deaths_msg.append (explorer.is_landed.out.at (1).out)
						variable_deaths_msg.append (",")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Explorer got devoured by blackhole (id: -1) at Sector:3:3")

						game_state.last_msg_append ("Explorer got devoured by blackhole (id: -1) at Sector:3:3")
						game_state.states_msg_append (game_state.last_message)

						-- make it so that the game has to end
						game_state.gameover

					elseif attached {BENIGN_ENT} ent as benign then
						benign.died
						variable_deaths_msg.append ("fuel:")
						variable_deaths_msg.append (benign.fuel.out)
						variable_deaths_msg.append ("/3")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("actions_left_until_reproduction:")
						variable_deaths_msg.append (benign.actions_left.out)
						variable_deaths_msg.append ("/1")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("turns_left:N/A,")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Benign got devoured by blackhole (id: -1) at Sector:3:3")
					elseif attached {MALEVOLENT_ENT} ent as malevolent then
						malevolent.died
						variable_deaths_msg.append ("fuel:")
						variable_deaths_msg.append (malevolent.fuel.out)
						variable_deaths_msg.append ("/3")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("actions_left_until_reproduction:")
						variable_deaths_msg.append (malevolent.actions_left.out)
						variable_deaths_msg.append ("/1")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("turns_left:N/A,")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Malevolent got devoured by blackhole (id: -1) at Sector:3:3")
					elseif attached {JANITAUR_ENT} ent as janitaur then
						janitaur.died
						variable_deaths_msg.append ("fuel:")
						variable_deaths_msg.append (janitaur.fuel.out)
						variable_deaths_msg.append ("/5")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("load:")
						variable_deaths_msg.append (janitaur.load_level.out)
						variable_deaths_msg.append ("/2")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("actions_left_until_reproduction:")
						variable_deaths_msg.append (janitaur.actions_left.out)
						variable_deaths_msg.append ("/2")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("turns_left:N/A,")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Janitaur got devoured by blackhole (id: -1) at Sector:3:3")
					elseif attached {PLANET_ENT} ent as planet then
						planet.died
						variable_deaths_msg.append ("attached?:")
						variable_deaths_msg.append (planet.attached_to_star.out.at (1).out)
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("support_life?:")
						variable_deaths_msg.append (planet.supports_life.out.at (1).out)
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("visited?:")
						variable_deaths_msg.append (planet.visited.out.at (1).out)
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("turns_left:N/A,")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Planet got devoured by blackhole (id: -1) at Sector:3:3")
					elseif attached {ASTEROID_ENT} ent as asteroid then
						asteroid.died
						variable_deaths_msg.append ("turns_left:N/A,")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Asteroid got devoured by blackhole (id: -1) at Sector:3:3")
					end
				end

				if current_entity_died then
-- ==========================================================================================
-- SOLVED: delete the entity at the end
-- ==========================================================================================
					sector.delete (ent_alpha)
					game_state.deaths_msg_append (variable_deaths_msg)
				end

			end
		end

--------------------------------------------------------------------------------------------------
--------------------------------------------- OUTPUTS --------------------------------------------
--------------------------------------------------------------------------------------------------

feature -- the outputs for the deaths of things...
	movements_append_deaths (ent_alpha: ENTITY_ALPHABET; sector: SECTOR)
		local
			quadrant: INTEGER
			loop_counter: INTEGER
			found: BOOLEAN
		do
			game_state.movements_msg_append ("%N")
			game_state.movements_msg_append ("      ")
			if attached {EXPLORER_ENT} ent_alpha.entity then
				game_state.movements_msg_append ("attacked ")
			else
				game_state.movements_msg_append ("destroyed ")
			end
			game_state.movements_msg_append ("[")
			game_state.movements_msg_append (ent_alpha.id.out)
			game_state.movements_msg_append (",")
			game_state.movements_msg_append (ent_alpha.item.out)
			game_state.movements_msg_append ("]")
			game_state.movements_msg_append (" at ")
			game_state.movements_msg_append ("[")
			game_state.movements_msg_append (ent_alpha.entity.position.row.out)
			game_state.movements_msg_append (",")
			game_state.movements_msg_append (ent_alpha.entity.position.col.out)
			game_state.movements_msg_append (",")
			from
				quadrant := 1
				loop_counter := 1
				found := false
			until
				loop_counter > sector.contents.count or found
			loop
				if attached {ENTITY_ALPHABET} sector.contents[loop_counter] as ent_alpha_inner then
					if ent_alpha.id = ent_alpha_inner.id then
						found := true
						quadrant := loop_counter
					end
				end
				loop_counter := loop_counter + 1
			end
			game_state.movements_msg_append (quadrant.out)
			game_state.movements_msg_append ("]")
		end


	deaths_append_deaths (ent_alpha: ENTITY_ALPHABET; custom_string: STRING)
		do
			game_state.deaths_msg_append ("%N")
			game_state.deaths_msg_append ("    ")
			game_state.deaths_msg_append ("[")
			game_state.deaths_msg_append (ent_alpha.id.out)
			game_state.deaths_msg_append (",")
			game_state.deaths_msg_append (ent_alpha.item.out)
			game_state.deaths_msg_append ("]")
			game_state.deaths_msg_append ("->")

			if attached {EXPLORER_ENT} ent_alpha.entity as explorer then
				game_state.deaths_msg_append ("fuel:")
				game_state.deaths_msg_append (explorer.fuel.out)
				game_state.deaths_msg_append ("/3")
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("life:")
				game_state.deaths_msg_append (explorer.life.out)
				game_state.deaths_msg_append ("/3")
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("landed?:")
				game_state.deaths_msg_append (explorer.is_landed.out.at (1).out)
				game_state.deaths_msg_append (",")
				game_state.deaths_msg_append ("%N")
				game_state.deaths_msg_append ("      ")
				game_state.deaths_msg_append (custom_string)

			elseif attached {BENIGN_ENT} ent_alpha.entity as benign then
				game_state.deaths_msg_append ("fuel:")
				game_state.deaths_msg_append (benign.fuel.out)
				game_state.deaths_msg_append ("/3")
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("actions_left_until_reproduction:")
				game_state.deaths_msg_append (benign.actions_left.out)
				game_state.deaths_msg_append ("/1")
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("turns_left:N/A,")
				game_state.deaths_msg_append ("%N")
				game_state.deaths_msg_append ("      ")
				game_state.deaths_msg_append (custom_string)
			elseif attached {MALEVOLENT_ENT} ent_alpha.entity as malevolent then
				game_state.deaths_msg_append ("fuel:")
				game_state.deaths_msg_append (malevolent.fuel.out)
				game_state.deaths_msg_append ("/3")
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("actions_left_until_reproduction:")
				game_state.deaths_msg_append (malevolent.actions_left.out)
				game_state.deaths_msg_append ("/1")
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("turns_left:N/A,")
				game_state.deaths_msg_append ("%N")
				game_state.deaths_msg_append ("      ")
				game_state.deaths_msg_append (custom_string)
			elseif attached {JANITAUR_ENT} ent_alpha.entity as janitaur then
				game_state.deaths_msg_append ("fuel:")
				game_state.deaths_msg_append (janitaur.fuel.out)
				game_state.deaths_msg_append ("/5")
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("load:")
				game_state.deaths_msg_append (janitaur.load_level.out)
				game_state.deaths_msg_append ("/2")
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("actions_left_until_reproduction:")
				game_state.deaths_msg_append (janitaur.actions_left.out)
				game_state.deaths_msg_append ("/2")
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("turns_left:N/A,")
				game_state.deaths_msg_append ("%N")
				game_state.deaths_msg_append ("      ")
				game_state.deaths_msg_append (custom_string)
			elseif attached {PLANET_ENT} ent_alpha.entity as planet then
				game_state.deaths_msg_append ("attached?:")
				game_state.deaths_msg_append (planet.attached_to_star.out.at (1).out)
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("support_life?:")
				game_state.deaths_msg_append (planet.supports_life.out.at (1).out)
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("visited?:")
				game_state.deaths_msg_append (planet.visited.out.at (1).out)
				game_state.deaths_msg_append (", ")
				game_state.deaths_msg_append ("turns_left:N/A,")
				game_state.deaths_msg_append ("%N")
				game_state.deaths_msg_append ("      ")
				game_state.deaths_msg_append (custom_string)
			elseif attached {ASTEROID_ENT} ent_alpha.entity as asteroid then
				game_state.deaths_msg_append ("turns_left:N/A,")
				game_state.deaths_msg_append ("%N")
				game_state.deaths_msg_append ("      ")
				game_state.deaths_msg_append (custom_string)

			end
		end

end
