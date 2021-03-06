archetype (adl_version=2.0.5; rm_release=1.0.2)
	openEHR-EHR-EVALUATION.annotations_err_line_number.v1.0.0

specialize
	openEHR-EHR-EVALUATION.annotations_parent.v1

language
	original_language = <[ISO_639-1::en]>

description
	original_author = <
		["name"] = <"Thomas Beale">
		["email"] = <"thomas.beale@openEHR.org">
		["organisation"] = <"openEHR Foundation <http://www.openEHR.org>">
		["date"] = <"2010-12-12">
	>
	details = <
		["en"] = <
			language = <[ISO_639-1::en]>
			purpose = <"To test use of annotations in a specialised archetype, on specialised paths.">
			keywords = <"ADL", "test">
		>
	>
	lifecycle_state = <"published">
	other_details = <
		["regression"] = <"PASS">
	>
	copyright = <"copyright © 2010 openEHR Foundation <http://www.openEHR.org>">

definition
	EVALUATION[id1.1] matches {	-- Exclusion statement - Adverse Reaction
		/data[id2]/items matches {
			ELEMENT[id0.7] occurrences matches {0..1} matches {	-- No known adverse reaction to
				value matches {
					DV_TEXT[id0.5] 
				}
			}
			ELEMENT[id0.8] occurrences matches {0..1} matches {	-- No known allergic reaction to
				value matches {
					DV_TEXT[id0.6] 
				}
			}
			ELEMENT[id0.9] occurrences matches {0..1} matches {	-- No known hypersensitivity reaction to
				value matches {
					DV_TEXT[id0.7] 	-- No known adverse reaction to
				}
			}
			ELEMENT[id0.10] occurrences matches {0..1} matches {	-- No known intolerance to
				value matches {
					DV_TEXT[id0.8] 	-- No known allergic reaction to
				}
			}
		}
	}

terminology
	term_definitions = <
		["en"] = <
			["id1.1"] = <
				text = <"Exclusion statement - Adverse Reaction">
				description = <"Statements about Adverse Reactions that need to be positively recorded as absent or excluded.">
			>
			["id0.10"] = <
				text = <"No known intolerance to">
				description = <"Positive statement about intolerances to substances that are explicitly known to have not been identified at the time of recording.">
			>
			["id0.7"] = <
				text = <"No known adverse reaction to">
				description = <"Positive statement about adverse reactions to substances that are explicitly known to have not been identified at the time of recording.">
			>
			["id0.8"] = <
				text = <"No known allergic reaction to">
				description = <"Positive statement about allergic reactions to substances that are explicitly known to have not been identified at the time of recording.">
			>
			["id0.9"] = <
				text = <"No known hypersensitivity reaction to">
				description = <"Positive statement about hypersensitivity reactions to substances that are explicitly known to have not been identified at the time of recording.">
			>
		>
	>

annotations
	documentation = <
		["en"] = <
			["/data[id2]/items[id0.8]" = <
				["design note"] = <"this is a design note on allergic reaction">
				["requirements note"] = <"this is a requirements note on allergic reaction">
				["medline ref"] = <"this is a medline ref on allergic reaction">
			>
			["/data[id2]/items[id0.10]"] = <
				["design note"] = <"this is a design note on intelerance">
				["requirements note"] = <"this is a requirements note on intolerance">
				["national data dictionary"] = <"NDD ref for intolerance">
			>
		>
	>
