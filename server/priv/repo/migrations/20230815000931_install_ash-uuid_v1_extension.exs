defmodule Orcasite.Repo.Migrations.InstallAshUuidV1 do
  @moduledoc """
  Installs any extensions that are mentioned in the repo's `installed_extensions/0` callback

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    execute("""
    CREATE OR REPLACE FUNCTION uuid_generate_v7()
    RETURNS uuid
    AS $$
    DECLARE
      unix_ts_ms BYTEA;
      uuid_bytes BYTEA;
    BEGIN
      unix_ts_ms = substring(int8send(floor(extract(epoch FROM clock_timestamp()) * 1000)::BIGINT) FROM 3);
      uuid_bytes = uuid_send(gen_random_uuid());
      uuid_bytes = overlay(uuid_bytes placing unix_ts_ms FROM 1 FOR 6);
      uuid_bytes = set_byte(uuid_bytes, 6, (b'0111' || get_byte(uuid_bytes, 6)::BIT(4))::BIT(8)::INT);
      RETURN encode(uuid_bytes, 'hex')::UUID;
    END
    $$
    LANGUAGE PLPGSQL
    VOLATILE;
    """)
  end

  def down do
    # Uncomment this if you actually want to uninstall the extensions
    # when this migration is rolled back:
    # execute("DROP FUNCTION IF EXISTS uuid_generate_v7()")
  end
end