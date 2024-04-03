# Include all rules
all

# Exclude the rules that refers to the line length
exclude_tag :line_length

# Exclude rules MD002 and MD041 (`hugo` puts metadata at the top of content file which contains the top level title/header)
exclude_rule 'MD002'
exclude_rule 'MD041'

# Allow question marks (?) in headers
rule 'MD026',  :punctuation => '.,;:!'
