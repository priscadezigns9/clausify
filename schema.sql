-- Supabase Schema for Clausify

-- Contracts Table
CREATE TABLE contracts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  contract_type TEXT NOT NULL,
  parties JSONB NOT NULL, -- {creator: "", client: "", jurisdiction: ""}
  content_html TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- DMCA Notices Table
CREATE TABLE dmca_notices (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  infringing_url TEXT NOT NULL,
  content_description TEXT NOT NULL,
  generated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE dmca_notices ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own contracts" ON contracts
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own contracts" ON contracts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own DMCA notices" ON dmca_notices
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own DMCA notices" ON dmca_notices
  FOR INSERT WITH CHECK (auth.uid() = user_id);
