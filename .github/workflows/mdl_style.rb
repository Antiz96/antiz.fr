# Include all rules
all

# Exclude the rules that refers to the line length
exclude_tag :line_length

# Exclude rule MD041 (`hugo` puts metadata at the top of content file)
exclude_rule 'MD041'

# Set accepted trailing spaces to a maximum of 2 (used to break a line) for the MD009 rule
rule 'MD009', :br_spaces => 2
