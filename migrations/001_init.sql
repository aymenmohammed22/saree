-- migrations/001_init.sql
-- تهيئة قاعدة البيانات لتطبيق السريع ون

-- جدول المستخدمين
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    name TEXT NOT NULL,
    phone TEXT,
    email TEXT,
    address TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- جدول عناوين المستخدمين
CREATE TABLE IF NOT EXISTS user_addresses (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id VARCHAR REFERENCES users(id),
    type TEXT NOT NULL,
    label TEXT NOT NULL,
    address TEXT NOT NULL,
    details TEXT,
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW()
);

-- جدول التصنيفات
CREATE TABLE IF NOT EXISTS categories (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    icon TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true
);

-- جدول المطاعم
CREATE TABLE IF NOT EXISTS restaurants (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    image TEXT NOT NULL,
    rating TEXT DEFAULT '0.0',
    review_count INTEGER DEFAULT 0,
    delivery_time TEXT NOT NULL,
    is_open BOOLEAN DEFAULT true,
    minimum_order INTEGER DEFAULT 0,
    delivery_fee INTEGER DEFAULT 0,
    category_id VARCHAR REFERENCES categories(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- جدول عناصر القائمة
CREATE TABLE IF NOT EXISTS menu_items (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    price INTEGER NOT NULL,
    image TEXT NOT NULL,
    category TEXT NOT NULL,
    is_available BOOLEAN DEFAULT true,
    is_special_offer BOOLEAN DEFAULT false,
    original_price INTEGER,
    restaurant_id VARCHAR REFERENCES restaurants(id)
);

-- جدول السائقين
CREATE TABLE IF NOT EXISTS drivers (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    password TEXT NOT NULL,
    is_available BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    current_location TEXT,
    earnings INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

-- جدول الطلبات
CREATE TABLE IF NOT EXISTS orders (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_name TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    customer_email TEXT,
    delivery_address TEXT NOT NULL,
    notes TEXT,
    payment_method TEXT NOT NULL,
    status TEXT DEFAULT 'pending',
    items TEXT NOT NULL,
    subtotal INTEGER NOT NULL,
    delivery_fee INTEGER NOT NULL,
    total INTEGER NOT NULL,
    estimated_time TEXT DEFAULT '30-45 دقيقة',
    restaurant_id VARCHAR REFERENCES restaurants(id),
    driver_id VARCHAR REFERENCES drivers(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- جدول العروض الخاصة
CREATE TABLE IF NOT EXISTS special_offers (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    image TEXT NOT NULL,
    discount_percent INTEGER,
    discount_amount INTEGER,
    minimum_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    valid_until TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- جدول مستخدمي الأدمن
CREATE TABLE IF NOT EXISTS admin_users (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    user_type TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- جدول جلسات الأدمن
CREATE TABLE IF NOT EXISTS admin_sessions (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id VARCHAR REFERENCES admin_users(id),
    token TEXT NOT NULL UNIQUE,
    user_type TEXT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- إنشاء الفهارس لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_user_addresses_user_id ON user_addresses(user_id);
CREATE INDEX IF NOT EXISTS idx_restaurants_category_id ON restaurants(category_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_restaurant_id ON menu_items(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_orders_restaurant_id ON orders(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_orders_driver_id ON orders(driver_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_admin_users_email ON admin_users(email);
CREATE INDEX IF NOT EXISTS idx_admin_sessions_token ON admin_sessions(token);
CREATE INDEX IF NOT EXISTS idx_admin_sessions_admin_id ON admin_sessions(admin_id);

-- إدراج بيانات أولية للتطوير والاختبار
-- إضافة مستخدم أدمن افتراضي (كلمة المرور: admin123 - يجب تشفيرها في التطبيق الفعلي)
INSERT INTO admin_users (email, password, user_type) 
VALUES ('admin@alsarie-one.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin')
ON CONFLICT (email) DO NOTHING;

-- إضافة تصنيفات افتراضية
INSERT INTO categories (name, icon) VALUES
('مطاعم عربية', '🍽️'),
('وجبات سريعة', '🍔'),
('مشروبات', '☕'),
('حلويات', '🍰'),
('مأكولات بحرية', '🐟')
ON CONFLICT (name) DO NOTHING;

-- إضافة مطاعم افتراضية
INSERT INTO restaurants (name, description, image, delivery_time, category_id) 
SELECT 
    'مطعم اليمن السعيد',
    'أشهى المأكولات اليمنية الأصيلة',
    '/images/restaurants/yemen-saeed.jpg',
    '45-60 دقيقة',
    id
FROM categories WHERE name = 'مطاعم عربية'
ON CONFLICT (name) DO NOTHING;

INSERT INTO restaurants (name, description, image, delivery_time, category_id) 
SELECT 
    'برجر كينج',
    'أشهى الوجبات السريعة العالمية',
    '/images/restaurants/burger-king.jpg',
    '30-45 دقيقة',
    id
FROM categories WHERE name = 'وجبات سريعة'
ON CONFLICT (name) DO NOTHING;

-- إضافة عناصر قائمة افتراضية
INSERT INTO menu_items (name, description, price, image, category, restaurant_id)
SELECT 
    'مندي لحم',
    'أكلة يمنية أصيلة بطعم لا يقاوم',
    25000,
    '/images/menu/mandi.jpg',
    'أطباق رئيسية',
    id
FROM restaurants WHERE name = 'مطعم اليمن السعيد'
ON CONFLICT (name, restaurant_id) DO NOTHING;

INSERT INTO menu_items (name, description, price, image, category, restaurant_id)
SELECT 
    'همبرغر لحم',
    'همبرغر لحم طازج مع الخضار والصلصة',
    15000,
    '/images/menu/hamburger.jpg',
    'ساندويشات',
    id
FROM restaurants WHERE name = 'برجر كينج'
ON CONFLICT (name, restaurant_id) DO NOTHING;

-- إضافة سائق افتراضي
INSERT INTO drivers (name, phone, password) 
VALUES ('أحمد محمد', '+967711223344', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi')
ON CONFLICT (phone) DO NOTHING;

-- إضافة عروض خاصة
INSERT INTO special_offers (title, description, image, discount_percent, minimum_order, valid_until) 
VALUES (
    'خصم 20% على أول طلب',
    'احصل على خصم 20% على طلبك الأول من تطبيق السريع ون',
    '/images/offers/first-order.jpg',
    20,
    10000,
    NOW() + INTERVAL '30 days'
)
ON CONFLICT (title) DO NOTHING;