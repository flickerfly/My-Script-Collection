#!/usr/bin/awk -f

# Extract the client's IP address...
/lease / { ip = $2 }

# Extract the ending date & time of the lease
/ends / { date = $3; time = $4;  gsub(";", "", time) }

# Extract the client's hostname...
/client-hostname / { host = $2; gsub("[;\"]", "", host) }

# Extract the ethernet MAC address...
/hardware ethernet / { mac = $3; gsub(";", "", mac) }

# At the end of each "lease" record, print the network information.
/\}/ { print host " is " ip " and " mac " ends " date " " time }
