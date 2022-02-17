$bp_list: List<Quantity>
check_bps: assert for_all bp : $bp_list | $bp > 120

check_field_vals: assert for_all event : $bp_list |
    event.data.items.value.magnitude =
		event/data[id4]/items[id5]/value/magnitude - event/data[id4]/items[id6]/value/magnitude
