#!/bin/bash

# concat_sql.sh: Joins SQL migrations in order.

OUTPUT="all_migrations.sql"
rm -f $OUTPUT

for file in $(ls resources/[esf]/*/sql/*.sql | sort -V); do
    cat $file >> $OUTPUT
    echo ";" >> $OUTPUT  # Ensure separation
done

echo "Concatenated to $OUTPUT"