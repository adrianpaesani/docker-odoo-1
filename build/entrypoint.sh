#!/bin/bash
#set -e

if [ $(basename $1) != "/opt/odoo/src/odoo-bin" ] ; then
	exec "$@"
fi

echo "Waiting for postgres server to start"
RETRIES=10
until PGPASSWORD=odoo psql -h db -U odoo -d template1 -c "select 1" > /dev/null 2>&1 || [ $RETRIES -eq 0 ]; do
  echo "$((RETRIES-=1)) remaining attempts..."
  sleep 1
done

echo "Enabling UNACCENT ..."
PGPASSWORD=odoo psql -h db -U odoo -d template1 -c 'CREATE EXTENSION IF NOT EXISTS "unaccent";'

# Start ODOO
exec "$@"