psql postgres -c "SELECT pg_drop_replication_slot('pg_slot_1');"
psql postgres -c "SELECT pg_create_physical_replication_slot('pg_slot_1');"
psql postgres -c "CREATE USER streaming_user WITH REPLICATION PASSWORD 'password3'"
psql postgres -c "CREATE USER barman WITH SUPERUSER PASSWORD 'password1'"
psql postgres -c "CREATE USER barman_streaming_user WITH REPLICATION PASSWORD 'password2'"
