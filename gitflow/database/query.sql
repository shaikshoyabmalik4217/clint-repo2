CREATE TABLE users (
    user_id         BIGSERIAL PRIMARY KEY,
    username        VARCHAR(50) NOT NULL UNIQUE,
    email           VARCHAR(100) UNIQUE,
    password_hash   TEXT NOT NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_users_username ON users (username);

CREATE TABLE login_audit (
    audit_id    BIGSERIAL PRIMARY KEY,
    user_id     BIGINT REFERENCES users(user_id) ON DELETE SET NULL,
    username    VARCHAR(50),
    ip_address  INET,
    success     BOOLEAN NOT NULL,
    login_time  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
``
INSERT INTO users (username, email, password_hash)
VALUES (
    'admin',
    'admin@example.com',
    '$2y$10$abcdefghijklmnopqrstuv' -- example hash
);
``
$sql = "SELECT user_id, password_hash
        FROM users 
        WHERE username = $1 AND is_active = TRUE";

$result = pg_query_params($conn, $sql, [$username]);

$row = pg_fetch_assoc($result);

if ($row && password_verify($password, $row['password_hash'])) {
    // Login success
} else {
    // Login failed
}
CREATE TABLE user_sessions (
    session_id      UUID PRIMARY KEY,
    user_id         BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    expires_at      TIMESTAMPTZ NOT NULL
);

