# Include all rules
all

# Exclude the rules that refers to the line length
exclude_tag :line_length

# Exclude rules MD002 and MD041 (`hugo` puts metadata at the top of content file which contains the top level title/header)
exclude_rule 'MD002'
exclude_rule 'MD041'

# Allow having multiple headers with the same content
exclude_rule 'MD024'

# Allow punctuation in headers
exclude_rule 'MD026'
