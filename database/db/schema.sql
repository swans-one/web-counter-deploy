CREATE TABLE IF NOT EXISTS "schema_migrations" (version varchar(128) primary key);
CREATE TABLE counter (
    id primary key,
    scope text not null unique,
    current_count integer
);
-- Dbmate schema migrations
INSERT INTO "schema_migrations" (version) VALUES
  ('20251201213139'),
  ('20251201214720');
