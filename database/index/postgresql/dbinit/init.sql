CREATE TABLE Towns (
                       id SERIAL UNIQUE NOT NULL,
                       code VARCHAR(10) NOT NULL, -- not unique
                       article TEXT,
                       name TEXT NOT NULL, -- not unique
                       department VARCHAR(4),
                       UNIQUE (code, department)
);

CREATE INDEX idx_name ON towns(name);

INSERT INTO towns (
    code, article, name, department
)
SELECT
    left(md5(i::text), 10),
    md5(random()::text),
    md5(random()::text),
    left(md5(random()::text), 4)
FROM generate_series(1, 1000000) s(i)