Check_code: $abc matches {[ac3]}

$extended_validity:Boolean := $abc matches {|0.0..30.0|}
$extended_validity_2:Boolean := $abc - 3 matches {|0.0..30.0|}
$variable:Real := $abc
$variable_matches: Boolean := $variable matches {|0.0..30.0|}
