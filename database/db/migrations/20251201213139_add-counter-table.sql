-- migrate:up
create table counter (
    id primary key,
    scope text not null unique,
    current_count integer
);

-- migrate:down
drop table counter;
