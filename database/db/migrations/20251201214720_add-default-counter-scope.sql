-- migrate:up
insert into counter(scope, current_count) values("default", 1);

-- migrate:down
delete from counter where scope = "default";
