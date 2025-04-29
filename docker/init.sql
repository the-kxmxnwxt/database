-- สร้างตาราง Affiliators (ผู้ใช้ระบบที่รับข้อมูลไปแสดง)
CREATE TABLE affiliators (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    keycloak_id TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL
);

-- สร้างตาราง Referrer Sites (เว็บไซต์ที่ affiliator ลงทะเบียน)
CREATE TABLE referrer_sites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    affiliator_id UUID REFERENCES affiliators(id) ON DELETE CASCADE,
    site_url TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- สร้างตาราง Concerts (ข้อมูลที่ใช้เป็น content)
CREATE TABLE concerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,                  -- ชื่อคอนเสิร์ต
    artist TEXT NOT NULL,                -- ศิลปินที่จัดการแสดง
    location TEXT NOT NULL,              -- สถานที่จัดคอนเสิร์ต
    date DATE NOT NULL,                  -- วันที่จัดคอนเสิร์ต
    description TEXT,                    -- คำอธิบายเพิ่มเติม
    price INT NOT NULL,                  -- ราคาตั๋ว
    image_url TEXT,                      -- URL ของภาพคอนเสิร์ต
    detail_url TEXT,                     -- URL ของรายละเอียดคอนเสิร์ต
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category TEXT CHECK (
        category IN ('Pop', 'Rock', 'Classical', 'Jazz', 'Electronic')
    ) NOT NULL                           -- หมวดหมู่ของคอนเสิร์ต
);


-- สร้างตาราง Banners (แบนเนอร์คอนเสิร์ต)
CREATE TABLE banners (
    id SERIAL PRIMARY KEY,
    image_url VARCHAR(255) NOT NULL, -- URL ของแบนเนอร์
    link VARCHAR(255), -- URL สำหรับการเชื่อมโยงจากแบนเนอร์
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Request Logs
CREATE TABLE request_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    affiliator_id UUID REFERENCES affiliators(id) ON DELETE SET NULL,
    website_url TEXT,
    endpoint TEXT NOT NULL,
    method TEXT NOT NULL,
    query_params JSONB,
    referrer TEXT,
    user_agent TEXT,
    ip_address TEXT,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Click Logs
CREATE TABLE click_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    affiliator_id UUID REFERENCES affiliators(id) ON DELETE SET NULL,
    website_url TEXT,
    concert_id UUID REFERENCES concerts(id) ON DELETE SET NULL,
    referrer TEXT,
    user_agent TEXT,
    ip_address TEXT,
    clicked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ข้อมูลตัวอย่าง concert (สำหรับทดสอบ)
INSERT INTO concerts (name, artist, location, date, description, price, image_url, detail_url, category)
VALUES
  (
    'Rock in Bangkok',
    'Bodyslam',
    'Bangkok Arena',
    '2025-06-15',
    'คอนเสิร์ตร็อคสุดมันส์กลางกรุง',
    1500,
    'https://picsum.photos/400/300',
    'https://affiliate-service.com/concerts/1',
    'Rock'
  ),
  (
    'WAVE X FEST PRESENTED BY SURAWIWAT',
    'Three ma down',
    'มหาวิทยาลัยเทคโนโลยีสุรนารี',
    '2025-05-16',
    'ดนตรีบรรยากาศดีที่มหาวิทยาลัย',
    2500,
    'https://res.theconcert.com/w_600,h_800,c_thumb/b68910a4e4ec6ce1f0d4555ee44c3a1ad/s__67706884.jpg',
    'https://affiliate-service.com/concerts/2',
    'Rock'
  ),
  (
    'Kong Saharat & Friends',
    'Kong Saharat & Benja Band, Toon Bodyslam, P.O.P., 2 days ago kids., Triumphs Kingdom, Mr.Team., Jennifer Kim, Nuvo',
    'Triangle Wave Eco Studio',
    '2025-04-28',
    'คอนเสิร์ตเพื่อนกับเพื่อน เพื่อผู้ประสบภัยแผ่นดินไหวไทย-เมียนมา',
    5000,
    'https://res.theconcert.com/w_600,h_800,c_thumb/7937a143676b695472b423efc6dcfab4e/s__9519421.jpg',
    'https://affiliate-service.com/concerts/2',
    'Pop'
  ),
  (
    'COCKTAIL 77 EVER TOUR',
    'COCKTAIL',
    'THE PIRATES PARK หาดใหญ่',
    '2025-04-26',
    'การเดินทางครั้งสุดท้ายของวง COCKTAIL',
    599,
    'https://p-u.popcdn.net/event_details/posters/000/079/723/large/fc1c6990d4fc629392dda0620900274e85763a0e.jpg?1741969222',
    'https://affiliate-service.com/concerts/3',
    'Pop'
  ),
  (
  'Beethoven Symphony No.9',
  'Berlin Philharmonic',
  'Berlin Concert Hall',
  '2025-06-15',
  'การแสดงซิมโฟนีที่ยิ่งใหญ่ที่สุดในโลก โดยวง Berlin Philharmonic',
  2500,
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehTwsAGJT7iSgPdyf3j-GO-iF8TJ5IcW9RQ&s',
  'https://affiliate-service.com/concerts/6',
  'Classical'
),
(
  'The Four Seasons',
  'Vienna Philharmonic',
  'Vienna State Opera',
  '2025-06-30',
  'การแสดงสุดยอดผลงานของ Vivaldi ในคอนเสิร์ตคลาสสิคระดับโลก',
  2200,
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQr5AGBkSe93NI6RkapRbHMwO9DlGSCIIQh7A&s',
  'https://affiliate-service.com/concerts/7',
  'Classical'
),
(
  'Jazz Night at Blue Note',
  'Wynton Marsalis',
  'Blue Note Jazz Club',
  '2025-07-10',
  'คอนเสิร์ตแจ๊สระดับโลกจาก Wynton Marsalis ที่ Blue Note New York',
  1500,
  'https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F997302963%2F146205830528%2F1%2Foriginal.20250331-232737?crop=focalpoint&fit=crop&w=600&auto=format%2Ccompress&q=75&sharp=10&fp-x=0.492424242424&fp-y=0.46828358209&s=cd1d67dcf810a9b8950c2a8235ab1203',
  'https://affiliate-service.com/concerts/8',
  'Jazz'
),
(
  'A Night of Smooth Jazz',
  'John Coltrane Tribute Band',
  'Los Angeles Jazz Hall',
  '2025-07-25',
  'คืนที่เต็มไปด้วยเพลงแจ๊สจาก John Coltrane Tribute Band',
  1800,
  'https://images.squarespace-cdn.com/content/v1/62cbb3ba178d631e0ddd7af1/1693258175068-BB7IG6Q3M74NRO9N1TZP/1691815361883blob.png',
  'https://affiliate-service.com/concerts/9',
  'Jazz'
),
(
  'Tomorrowland 2025',
  'Various Artists',
  'Boom, Belgium',
  '2025-07-30',
  'งาน EDM ที่ยิ่งใหญ่ที่สุดในโลก จัดที่ประเทศเบลเยี่ยม',
  80000,
  'https://images.prismic.io/tomorrowland-next/ZjDuAN3JpQ5PTRRp_PORTRAIT-3-.png?auto=format,compress',
  'https://affiliate-service.com/concerts/10',
  'Electronic'
),
(
  'Ultra Music Festival',
  'David Guetta, Martin Garrix',
  'Miami, USA',
  '2025-03-20',
  'งาน Ultra Music Festival ที่สุดแห่งงาน EDM ในโลก',
  70000,
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgHsEntVrcHIB2HogseC7k9Xz0llegOPgqsQ&s',
  'https://affiliate-service.com/concerts/11',
  'Electronic'
);



-- เพิ่มข้อมูล banners (แบนเนอร์)
INSERT INTO banners (image_url, link) VALUES
('https://example.com/banners/summerpopfest.jpg', 'https://example.com/summer-pop-fest'),
('https://example.com/banners/rockon.jpg', 'https://example.com/rock-on');
