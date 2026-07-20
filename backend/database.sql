-- ============================================
-- CBE BANKING CLONE - DATABASE SCHEMA
-- ============================================

-- Connect to database
\c cbe_banking;

-- ============================================
-- DROP TABLES (for fresh start)
-- ============================================
DROP TABLE IF EXISTS notifications CASCADE;
DROP TABLE IF EXISTS beneficiaries CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ============================================
-- CREATE TABLES
-- ============================================

-- Users table
CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    firebase_uid VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15),
    email VARCHAR(100),
    profile_image TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Accounts table
CREATE TABLE accounts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    account_type VARCHAR(20) DEFAULT 'Savings',
    currency VARCHAR(3) DEFAULT 'ETB',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transactions table
CREATE TABLE transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    transaction_reference VARCHAR(50) UNIQUE,
    sender_account_id UUID REFERENCES accounts(id),
    receiver_account_id UUID REFERENCES accounts(id),
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(30) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    fee DECIMAL(15,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

-- Beneficiaries table
CREATE TABLE beneficiaries (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    beneficiary_account_id UUID REFERENCES accounts(id),
    nickname VARCHAR(50),
    is_favorite BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notifications table
CREATE TABLE notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(100),
    message TEXT,
    type VARCHAR(30),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- CREATE INDEXES
-- ============================================
CREATE INDEX idx_users_firebase_uid ON users(firebase_uid);
CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_accounts_number ON accounts(account_number);
CREATE INDEX idx_transactions_sender ON transactions(sender_account_id);
CREATE INDEX idx_transactions_receiver ON transactions(receiver_account_id);
CREATE INDEX idx_transactions_created ON transactions(created_at DESC);
CREATE INDEX idx_transactions_reference ON transactions(transaction_reference);
CREATE INDEX idx_beneficiaries_user ON beneficiaries(user_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);

-- ============================================
-- CREATE FUNCTIONS
-- ============================================

-- Generate unique transaction reference
CREATE OR REPLACE FUNCTION generate_transaction_reference()
RETURNS VARCHAR AS $$
BEGIN
    RETURN 'TXN-' || TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDDHH24MISS') || '-' || 
           UPPER(SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 6));
END;
$$ LANGUAGE plpgsql;

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- CREATE TRIGGERS
-- ============================================
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_accounts_updated_at 
    BEFORE UPDATE ON accounts 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- CREATE VIEWS
-- ============================================
CREATE OR REPLACE VIEW user_account_summary AS
SELECT 
    u.id as user_id,
    u.full_name,
    u.phone_number,
    a.id as account_id,
    a.account_number,
    a.balance,
    a.account_type,
    COUNT(t.id) as total_transactions,
    SUM(CASE WHEN t.sender_account_id = a.id AND t.status = 'completed' THEN t.amount ELSE 0 END) as total_sent,
    SUM(CASE WHEN t.receiver_account_id = a.id AND t.status = 'completed' THEN t.amount ELSE 0 END) as total_received
FROM users u
JOIN accounts a ON u.id = a.user_id
LEFT JOIN transactions t ON (t.sender_account_id = a.id OR t.receiver_account_id = a.id)
GROUP BY u.id, a.id;

-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

-- Sample users
INSERT INTO users (firebase_uid, full_name, phone_number, email) VALUES
('test_user_1', 'Abebe Kebede', '0912345678', 'abebe@email.com'),
('test_user_2', 'Tigist Hailu', '0923456789', 'tigist@email.com'),
('test_user_3', 'Samuel Tekle', '0934567890', 'samuel@email.com')
ON CONFLICT (firebase_uid) DO NOTHING;

-- Sample accounts
INSERT INTO accounts (user_id, account_number, balance, account_type) VALUES
((SELECT id FROM users WHERE firebase_uid = 'test_user_1'), '1000000001', 5000.00, 'Savings'),
((SELECT id FROM users WHERE firebase_uid = 'test_user_2'), '1000000002', 3000.00, 'Savings'),
((SELECT id FROM users WHERE firebase_uid = 'test_user_3'), '1000000003', 10000.00, 'Savings')
ON CONFLICT (account_number) DO NOTHING;

-- Sample transactions
INSERT INTO transactions (transaction_reference, sender_account_id, receiver_account_id, amount, transaction_type, description, status, completed_at) VALUES
(generate_transaction_reference(), 
 (SELECT id FROM accounts WHERE account_number = '1000000001'), 
 (SELECT id FROM accounts WHERE account_number = '1000000002'), 
 500.00, 'transfer', 'Payment for lunch', 'completed', CURRENT_TIMESTAMP),
(generate_transaction_reference(), 
 (SELECT id FROM accounts WHERE account_number = '1000000002'), 
 (SELECT id FROM accounts WHERE account_number = '1000000001'), 
 200.00, 'transfer', 'Taxi fare', 'completed', CURRENT_TIMESTAMP),
(generate_transaction_reference(), 
 (SELECT id FROM accounts WHERE account_number = '1000000001'), 
 (SELECT id FROM accounts WHERE account_number = '1000000003'), 
 1000.00, 'transfer', 'Rent payment', 'completed', CURRENT_TIMESTAMP);

-- Sample beneficiaries
INSERT INTO beneficiaries (user_id, beneficiary_account_id, nickname, is_favorite) VALUES
((SELECT id FROM users WHERE firebase_uid = 'test_user_1'), 
 (SELECT id FROM accounts WHERE account_number = '1000000002'), 
 'Tigist', TRUE),
((SELECT id FROM users WHERE firebase_uid = 'test_user_1'), 
 (SELECT id FROM accounts WHERE account_number = '1000000003'), 
 'Samuel', FALSE)
ON CONFLICT DO NOTHING;

-- Sample notifications
INSERT INTO notifications (user_id, title, message, type, is_read) VALUES
((SELECT id FROM users WHERE firebase_uid = 'test_user_1'), 
 'Welcome!', 'Welcome to CBE Banking App', 'system', FALSE),
((SELECT id FROM users WHERE firebase_uid = 'test_user_1'), 
 'Transaction Alert', 'You sent 500 ETB to Tigist', 'transaction', TRUE);

-- ============================================
-- VERIFY DATA
-- ============================================

-- Show summary
SELECT '✅ Database setup complete!' as status;
SELECT 'Users:', COUNT(*) FROM users;
SELECT 'Accounts:', COUNT(*) FROM accounts;
SELECT 'Transactions:', COUNT(*) FROM transactions;
SELECT 'Beneficiaries:', COUNT(*) FROM beneficiaries;

-- Show account summary
SELECT * FROM user_account_summary;