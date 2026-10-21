-- ==============================================================================
-- RIDEON SUPABASE DATABASE SCHEMA INITIALIZATION
-- Multi-Service On-Demand Delivery & Ride Platform
-- Supports: Customer, Driver (Titip Belanja Talangan), Merchant Kitchen & Handover
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. USER PROFILES
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
    full_name TEXT,
    phone TEXT,
    role TEXT DEFAULT 'customer' CHECK (role IN ('customer', 'driver', 'merchant', 'admin')),
    avatar_url TEXT,
    wallet_balance NUMERIC(12, 2) DEFAULT 0.00,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. MERCHANTS
CREATE TABLE IF NOT EXISTS public.merchants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    is_open BOOLEAN DEFAULT true,
    close_reason TEXT,
    rating NUMERIC(2, 1) DEFAULT 4.9,
    total_orders INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. MERCHANT MENU ITEMS
CREATE TABLE IF NOT EXISTS public.merchant_menu_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID REFERENCES public.merchants(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(12, 2) NOT NULL,
    category TEXT NOT NULL,
    is_available BOOLEAN DEFAULT true,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. ORDERS
CREATE TABLE IF NOT EXISTS public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    merchant_id UUID REFERENCES public.merchants(id) ON DELETE SET NULL,
    driver_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    order_type TEXT NOT NULL CHECK (order_type IN ('titip_belanja', 'food', 'ride', 'send')),
    status TEXT NOT NULL DEFAULT 'searching_driver' CHECK (
        status IN (
            'searching_driver',
            'driver_assigned',
            'heading_to_merchant',
            'shopping',
            'heading_to_customer',
            'completed',
            'cancelled'
        )
    ),
    delivery_address TEXT NOT NULL,
    delivery_latitude DOUBLE PRECISION,
    delivery_longitude DOUBLE PRECISION,
    items JSONB DEFAULT '[]'::jsonb,
    locations JSONB DEFAULT '[]'::jsonb,
    real_receipt_total NUMERIC(12, 2) DEFAULT 0.00,
    parking_fee NUMERIC(12, 2) DEFAULT 0.00,
    app_delivery_fee NUMERIC(12, 2) DEFAULT 0.00,
    total_amount NUMERIC(12, 2) DEFAULT 0.00,
    is_driver_funded BOOLEAN DEFAULT true,
    payment_method TEXT DEFAULT 'cash' CHECK (payment_method IN ('cash', 'flexpay')),
    receipt_photo_url TEXT,
    pin_handover TEXT,
    rating INT,
    rating_review TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. CHAT MESSAGES
CREATE TABLE IF NOT EXISTS public.chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    sender_role TEXT NOT NULL,
    message TEXT NOT NULL,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. DRIVER LIVE LOCATIONS & CASH CAPITAL LIMIT
CREATE TABLE IF NOT EXISTS public.driver_locations (
    driver_id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    is_active BOOLEAN DEFAULT true,
    max_cash_capital NUMERIC(12, 2) DEFAULT 300000.00,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. WALLET TRANSACTIONS
CREATE TABLE IF NOT EXISTS public.wallet_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    amount NUMERIC(12, 2) NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('credit', 'debit')),
    description TEXT NOT NULL,
    reference_order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. EMERGENCY & BAILOUT CLAIMS (SOS & Klaim Talangan Driver)
CREATE TABLE IF NOT EXISTS public.emergency_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('sos', 'bailout_claim')),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
    claim_amount NUMERIC(12, 2),
    reason TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.merchants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.merchant_menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.driver_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wallet_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.emergency_reports ENABLE ROW LEVEL SECURITY;

-- Allow public read for merchants & menu items
CREATE POLICY "Allow public read merchants" ON public.merchants FOR SELECT USING (true);
CREATE POLICY "Allow public read menu items" ON public.merchant_menu_items FOR SELECT USING (true);

-- Allow authenticated users to view profiles
CREATE POLICY "Allow authenticated read profiles" ON public.profiles FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow users to update own profile" ON public.profiles FOR UPDATE TO authenticated USING (auth.uid() = id);

-- Allow authenticated users to read and insert orders
CREATE POLICY "Allow authenticated read orders" ON public.orders FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated insert orders" ON public.orders FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow authenticated update orders" ON public.orders FOR UPDATE TO authenticated USING (true);

-- Allow authenticated users to read and insert chat messages
CREATE POLICY "Allow authenticated read chat" ON public.chat_messages FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated insert chat" ON public.chat_messages FOR INSERT TO authenticated WITH CHECK (true);

-- Allow authenticated users to view and update driver locations
CREATE POLICY "Allow public read driver locations" ON public.driver_locations FOR SELECT USING (true);
CREATE POLICY "Allow driver update own location" ON public.driver_locations FOR ALL TO authenticated USING (auth.uid() = driver_id);

-- ==============================================================================
-- SUPABASE REALTIME REPLICATION
-- Enable real-time websocket streams for Orders, Chat, and Driver GPS tracking
-- ==============================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'orders'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.orders;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'chat_messages'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_messages;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'driver_locations'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.driver_locations;
  END IF;
END $$;
