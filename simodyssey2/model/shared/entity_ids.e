note
	description: "Summary description for {ENTITY_POSITIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENTITY_IDS

create {ENTITY_IDS_ACCESS}
	make

feature {NONE} -- Constructor
	make
		do
			create entity_ids.make_empty
		end

feature -- commands
	add(id: INTEGER; entity_alphabet: ENTITY_ALPHABET)
		local
			temp: TUPLE[INTEGER, ENTITY_ALPHABET]
		do
			create temp.default_create
			temp := [id, entity_alphabet]
			entity_ids.force (temp, entity_ids.count + 1)
		end

	get_entity_alphabet(id: INTEGER): ENTITY_ALPHABET
		do
			Result := create {ENTITY_ALPHABET}.make ('E')
			across entity_ids as tuple loop
				if attached {INTEGER} tuple.item.at (1) as id_index and attached {ENTITY_ALPHABET} tuple.item.at (2) as entity_alphabet then
					if id_index = id then
						Result := entity_alphabet
					end
				end
			end
		end

	get_entities_at(tuple: TUPLE[INTEGER,INTEGER]): ARRAY[ENTITY_ALPHABET]
		local
			temp_row: INTEGER
			temp_column: INTEGER
		do
			create Result.make_empty
			if attached {INTEGER} tuple.at (1) as row and attached {INTEGER} tuple.at (2) as column then
				temp_row := row
				temp_column := column
			end
			across  entity_ids as tupler loop
				if attached {ENTITY_ALPHABET} tupler.item.at(2) as entity then
					if attached {INTEGER} entity.entity.position.at(1) as row and attached {INTEGER} entity.entity.position.at(2) as column then
						if temp_row = row and temp_column = column then
							Result.force (entity, Result.count + 1)
						end
					end
				end
			end
		end

	get_movable_entities: ARRAY[ENTITY_ALPHABET]
		local
			temp: ARRAY[ENTITY_ALPHABET]
			temp_entity: ENTITY_ALPHABET
		do
			create Result.make_empty
			create temp.make_empty
			across entity_ids as entity_tuple loop
				if attached {INTEGER} entity_tuple.item.at (1) as id and attached {ENTITY_ALPHABET} entity_tuple.item.at(2) as entity then
					if id > 0 then
						temp.force(entity, temp.count + 1)
					end
				end
			end
			--sorting
			across 1 |..| (temp.count - 1) as i_index loop
				across (i_index.item + 1) |..| temp.count as j_index loop
					if attached {INTEGER} temp.at (j_index.item).id as second and attached {INTEGER} temp.at(i_index.item).id as first then
						if first > second then
							temp_entity := temp.at(j_index.item)
							temp.put (temp.at (i_index.item), j_index.item)
							temp.put (temp_entity, i_index.item)
						end
					end
				end
			end
			Result := temp
		end

	delete_entity(id: INTEGER) -- not working properly
		local
			temp: TUPLE[INTEGER, detachable ENTITY_ALPHABET]
		do
			across entity_ids.lower |..| entity_ids.upper as tuple_index loop
				if attached {ENTITY_ALPHABET} entity_ids[tuple_index.item].at (2) as entity then
					if entity.id = id then
						--swap the head and the element and remove the head
						temp := entity_ids[tuple_index.item]
						entity_ids.force (entity_ids[1], tuple_index.item)
						entity_ids.force (temp, 1)
						entity_ids.remove_head (1)
					end
				end
			end
		end

	delete_all
		local
			temp: ARRAY[TUPLE [INTEGER,ENTITY_ALPHABET]]
		do
			create temp.make_empty
			entity_ids := temp
		end

feature -- query
	sorted_entity_ids: ARRAY[TUPLE[INTEGER, detachable ENTITY_ALPHABET]]
		local
			temp_pos: ARRAY[TUPLE[INTEGER, detachable ENTITY_ALPHABET]]
			temp: TUPLE[INTEGER, detachable ENTITY_ALPHABET]
		do
			create Result.make_empty
			create temp_pos.make_empty
			temp_pos := entity_ids.deep_twin
			across 1 |..| (temp_pos.count - 1) as i_index loop
				across (i_index.item + 1) |..| temp_pos.count as j_index loop
					if attached {INTEGER} temp_pos.at (j_index.item).at (1) as first and attached {INTEGER} temp_pos.at(i_index.item).at (1) as second then
						if first < second then
							temp := temp_pos.at(j_index.item)
							temp_pos.at(j_index.item) := temp_pos.at(i_index.item)
							temp_pos.at(i_index.item) := temp
						end
					end
				end
			end
			Result := temp_pos
		end

feature -- attribute
	entity_ids: ARRAY[TUPLE[INTEGER, detachable ENTITY_ALPHABET]]

end
