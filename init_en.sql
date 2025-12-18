CREATE DATABASE IF NOT EXISTS db_ai_local;
USE db_ai_local;
-- =========================================================
-- 1) TABLE DDL
-- =========================================================
DROP TABLE IF EXISTS tb_destination;
DROP TABLE IF EXISTS tb_media;
DROP TABLE IF EXISTS tb_user;

CREATE TABLE tb_user (
                         id         BIGINT NOT NULL AUTO_INCREMENT,
                         session_id VARCHAR(128) NOT NULL,
                         tags       VARCHAR(1000) NULL,
                         PRIMARY KEY (id),
                         UNIQUE KEY uk_tb_user_session_id (session_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tb_media (
                          id    BIGINT NOT NULL AUTO_INCREMENT,
                          title VARCHAR(255) NOT NULL,
                          media_url VARCHAR(1000) NULL,
                          PRIMARY KEY (id),
                          UNIQUE KEY uk_tb_media_title (title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tb_destination (
                                id          BIGINT NOT NULL AUTO_INCREMENT,
                                media_id    BIGINT NOT NULL,
                                name        VARCHAR(255) NOT NULL,
                                address     VARCHAR(255) NOT NULL,
                                description TEXT NOT NULL,
                                tags        VARCHAR(1000) NULL,
                                image_url   VARCHAR(1000) NULL,
                                PRIMARY KEY (id),
                                KEY idx_tb_destination_media_id (media_id),
                                KEY idx_tb_destination_name (name),
                                CONSTRAINT fk_tb_destination_media
                                    FOREIGN KEY (media_id) REFERENCES tb_media(id)
                                        ON UPDATE CASCADE
                                        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO tb_user (session_id, tags) VALUES
                                           ('sess_demo_001', 'romantic,ocean,walk'),
                                           ('sess_demo_002', 'urban,nightview,cafe');

INSERT INTO tb_media (id, title, media_url) VALUES
                                     (1, 'Guardian: The Lonely and Great God', '도깨비'),
                                     (2, 'K-Pop Demon Hunters', '케데헌'),
                                     (3, 'Mr. Sunshine', '미스터션샤인'),
                                     (4, 'Crash Landing on You', '사랑의불시착'),
                                     (5, 'Hometown Cha-Cha-Cha', '갯마을차차차'),
                                     (6, 'Queen of Tears', '눈물의여왕'),
                                     (7, 'My Sweet Mobster', '폭싹속았수다'),
                                     (8, 'Itaewon Class', '이태원클라쓰'),
                                     (9, 'Our Beloved Summer', '그해우리는'),
                                     (10, 'Squid Game', '오징어게임');

INSERT INTO tb_destination (media_id, name, address, description, tags, image_url) VALUES
                                                                            (1, 'Jumunjin Yeongjin Beach Breakwater', '1609 Haean-ro, Jumunjin-eup, Gangneung-si, Gangwon-do',
                                                                             'The iconic location where the Goblin Kim Shin first appeared with buckwheat flowers to Ji Eun-tak on her birthday when she was alone blowing out her cake candles',
                                                                             'ocean,waves,redscarf,buckwheatflower,firstmeeting,romantic,photospotpopular,refreshing', '주문진영진해변방사제'),
                                                                            (1, 'Boryeong Buckwheat Farm', '158 Hakwonnongjanggil, Gongeum-myeon, Gochang-gun, Jeollabuk-do',
                                                                             'The secret buckwheat field of the Goblin and the mystical space accessed through a door. Most beautiful when white buckwheat flowers are in full bloom',
                                                                             'vast,whiteflowers,secretdoor,healing,peaceful,walk,purity,photospot', '고창보리나라학원농장'),
                                                                            (1, 'Unhyeongung Western Hall', '460 Samil-daero, Jongno-gu, Seoul',
                                                                             'The splendid Western-style mansion used as the exterior of the house where the Goblin and the Grim Reaper lived together. Located in Duksung Womens University Jongno Campus',
                                                                             'elegant,westernstyle,mansion,antique,architecture,downtown,mysterious,vintage', '운현궁양관'),
                                                                            (1, 'Incheon Hanmi Bookstore', '9 Geumgok-ro, Dong-gu, Incheon',
                                                                             'A bookstore with a yellow exterior located in Baedari Old Book Street, the background of the famous head-patting scene between Kim Shin and Ji Eun-tak',
                                                                             'yellow,retro,usedbooks,warm,moodphoto,alleytrip,modest,heartflutter', '인천한미서점'),
                                                                            (1, 'Deoksugung Stone Wall Path', '99 Sejong-daero, Jung-gu, Seoul',
                                                                             'The place where the Goblin and the Grim Reaper first met, and where the entrance to the Grim Reapers tea house was located, showcasing Korean beauty',
                                                                             'autumn,fallfoliage,stonewallpath,walkingcourse,classic,grimreaperteahouse,atmospheric,seoultour', NULL),
                                                                            (1, 'Pyeongchang Woljeongsa Fir Forest Trail', '374-8 Odaesan-ro, Jinbu-myeon, Pyeongchang-gun, Gangwon-do',
                                                                             'The beautiful forest path where Kim Shin confirmed his love to Ji Eun-tak while revealing the truth about his sword in the snow',
                                                                             'snowing,forestpath,winterkingdom,majestic,meditation,pristine,beautiflysad,trekking', '평창월정사전나무숲길'),
                                                                            (1, 'Anseong Mirinea Holy Site', '420 Mirinaeseongjiro, Yangseong-myeon, Anseong-si, Gyeonggi-do',
                                                                             'The location where Ji Eun-tak summoned the Goblin by blowing out candles in the church. The majestic and solemn atmosphere of the church interior is impressive',
                                                                             'solemn,church,summoning,candles,magnificent,quiet,architecturalbeauty,peaceful', '안성미래내성지'),
                                                                            (1, 'Anseong Seoknamsa Temple', '3-120 Sangchunsaemal-gil, Geumgwang-myeon, Anseong-si, Gyeonggi-do',
                                                                             'The temple where Kim Shin released sky lanterns for those who have passed. A temple with a long staircase and tranquil mountain atmosphere',
                                                                             'skylanterns,temple,longing,mountaintemple,serene,stairs,scenery,contemplation', '안성석남사'),
                                                                            (1, 'Incheon Cheongna Lake Park', '167 Cheongna-daero, Seo-gu, Incheon',
                                                                             'The park with beautiful night views where drunk Kim Shin walked with Ji Eun-tak while revealing the secret of his sword',
                                                                             'nightview,citynightview,walk,splendid,urbanresort,datespot,fountain,open', '인천청라호수공원'),
                                                                            (1, 'Sinchon Rabbit Hole (Graffiti Tunnel)', '67-11 Sinchon-dong, Seodaemun-gu, Seoul',
                                                                             'The tunnel where the Goblin and the Grim Reaper walked like a runway holding green onions in a comical yet cool scene',
                                                                             'graffiti,hip,greenonionrunway,tunnel,unique,streetart,funny,photozone', '도깨비신촌토끼굴'),
                                                                            (1, 'Incheon Art Platform', '3 Jemullyang-ro 218beon-gil, Jung-gu, Incheon',
                                                                             'An art street lined with red brick buildings where many emotional street walking scenes from the drama were filmed',
                                                                             'redbrick,artiststreet,vintage,modern,exhibition,culturalspace,clean,sophisticated', '인천아트플랫폼'),
                                                                            (1, 'Samcheong-dong Stone Wall Path (Yun Bo-seon Path)', 'Hwa-dong, Jongno-gu, Seoul',
                                                                             'The path where Kim Shin and Ji Eun-tak first brushed past each other on a rainy day, feeling a fateful attraction',
                                                                             'rainyday,destiny,stonewallpath,charming,cafestreet,moodwalk,seouldate,poetic', '삼청동돌담길'),
                                                                            (1, 'Incheon Freedom Park', '25 Jayugongnamnammun-ro, Jung-gu, Incheon',
                                                                             'The park where Kim Shin watched over Ji Eun-tak or was lost in thought alone, with a great view overlooking Incheon Port',
                                                                             'observatory,cherryblossomspot,oceanview,historicalpark,refreshingbreeze,leisure,localrestaurants', '인천자유공원'),
                                                                            (1, 'Yongin Daejanggeum Park', '25 Yongcheon Drama-gil, Baekam-myeon, Cheoin-gu, Yongin-si, Gyeonggi-do',
                                                                             'A large-scale historical drama set where scenes from Kim Shins past as a military officer, including Goryeo Dynasty palaces and battle scenes, were filmed',
                                                                             'historicaldrama,goryeodynasty,magnificent,traditionalarchitecture,battle,experience,historicalexperience,grand', '용인대장금파크'),
                                                                            (1, 'Daegwallyeong Samyang Ranch', '708-9 Kkotbatyangjigil, Daegwallyeong-myeon, Pyeongchang-gun, Gangwon-do',
                                                                             'The snow-covered hills against a vast snowy landscape that maximized the loneliness and mystique of the Goblin',
                                                                             'windturbines,snowfield,ranch,open,nature,sheep,refreshing,lifeshotphoto', '대관령삼양목장'),
                                                                            (1, 'BBQ Olive Chicken Cafe Daecheong Branch', '11 Yangjae-daero 27-gil, Gangnam-gu, Seoul',
                                                                             'The chicken restaurant operated by Sunny (Yoo In-na) and the main living space where Ji Eun-tak worked part-time',
                                                                             'chicken,sunny,parttime,dramalocation,familiar,delicious,downtownfilmingsite', 'BBQ올리브치킨카페대청점'),
                                                                            (1, 'Jongno Dalmoru Cafe (now Kaku)', '241-10 Changgyeonggung-ro, Jongno-gu, Seoul',
                                                                             'The cafe with a tranquil atmosphere where the Grim Reaper and Sunny had dates or meetings',
                                                                             'cafe,coffee,dating,calm,woodtone,goodforconversation,cozy,mood', '종로달모루카페'),
                                                                            (1, 'Naju Film Theme Park', '450 Deogeum-ro, Gongsan-myeon, Naju-si, Jeollanam-do',
                                                                             'The magnificent set where scenes of Kim Shin displaying his authority as a general at fortress walls and gates were filmed',
                                                                             'fortress,general,magnificent,history,panorama,traditional,riverside,grandarchitecture', '나주영상테마파크');
INSERT INTO tb_destination (media_id, name, address, description, tags, image_url) VALUES
                                                                            (2, 'Naksan Park Fortress Path', '41 Naksan-gil, Jongno-gu, Seoul',
                                                                             'The moving location where the main characters sang the song Free together while looking down at the downtown night view. Walk along the fortress wall and feel the romantic night of Seoul.',
                                                                             'nightview,fortresspath,romantic,seoulview,datespot,animationsite,moodexplosion,walk', '낙산공원'),

                                                                            (2, 'Jamsil Sports Complex (Olympic Main Stadium)', '25 Olympic-ro, Songpa-gu, Seoul',
                                                                             'The dream stage where K-Pop idol Huntrix held a massive concert. A place symbolizing the explosive energy and wave of light created by tens of thousands of fans.',
                                                                             'concert,kpopspot,passionate,magnificent,fandom,energy,venue', '잠실주경기장'),

                                                                            (2, 'Cheongdam Bridge', 'Jayang-dong, Gwangjin-gu, Seoul',
                                                                             'The dynamic bridge where members had spectacular chases and battles with demons against a backdrop of glamorous city night views.',
                                                                             'citynightview,actionscene,drive,hanriverbridge,dynamic,thrill,glamorouslights', '청담대교'),

                                                                            (2, 'Ttukseom Hangang Park Pool', '112 Jayang-dong, Gwangjin-gu, Seoul',
                                                                             'An urban summer retreat where members took a break or enjoyed water activities, radiating vibrant energy in the hot summer.',
                                                                             'summer,hanriverpark,waterplay,vibrant,urbanvacation,refreshing,youth', '뚝섬한강공원'),

                                                                            (2, 'Bukchon Hanok Village', '37 Gyedong-gil, Jongno-gu, Seoul',
                                                                             'A tranquil place where members had sincere conversations in alleys with Seoul downtown visible beyond traditional tiled roofs.',
                                                                             'hanok,alley,traditionalbeauty,serene,photogenic,seoulmustsee,calm', '북촌한옥마을'),

                                                                            (2, 'COEX K-POP Square & Media Tower', '513 Yeongdong-daero, Gangnam-gu, Seoul',
                                                                             'The center of Korean pop culture where K-Pop videos flow on giant electronic billboards. A place representing the glamorous city image in the animation.',
                                                                             'kpopspot,glamorousbillboard,gangnamstyle,urban,shopping,trendy,mediaart', '코엑스'),

                                                                            (2, 'N Seoul Tower (Namsan Seoul Tower)', '105 Namsangongwon-gil, Yongsan-gu, Seoul',
                                                                             'Seouls landmark and iconic space. A place that appeared as a location where city views were enjoyed or members made resolutions from high above.',
                                                                             'landmark,panoramaview,seoulview,nightview,lovelocks,dating,mustvisit', '남산타워'),

                                                                            (2, 'Dongdaemun Design Plaza (DDP)', '281 Euljiro, Jung-gu, Seoul',
                                                                             'A futuristic building resembling a spaceship. A venue for fashion weeks and glamorous events, a background matching the stylish aspects of the members.',
                                                                             'architecture,futuristic,fashion,exhibition,nightviewspot,unique,hip', 'DDP'),

                                                                            (2, 'Myeongdong Street', 'Myeong-dong, Jung-gu, Seoul',
                                                                             'Seouls representative bustling district full of crowds and shops. The background for everyday scenes of members walking the streets or enjoying shopping.',
                                                                             'shopping,streetfood,lively,crowded,touristarea,seoulcenter,youth', '명동'),

                                                                            (2, 'Changdeokgung Rear Garden (Secret Garden)', '99 Yulgok-ro, Jongno-gu, Seoul',
                                                                             'A place where traditional rituals to seal demons were performed or clues to mysterious events were found, maximizing Korean beauty.',
                                                                             'secretgarden,worldheritage,traditional,mysterious,beautifulnature,palacewalk,korean', '창덕궁후원'),

                                                                            (2, 'Yeouido Hangang Park (Waterlight Stage)', '330 Yeouidong-ro, Yeongdeungpo-gu, Seoul',
                                                                             'A free-spirited space where busking performances take place or members enjoy outdoor activities with the cool riverside breeze.',
                                                                             'hanriver,picnic,busking,free,waterlightsquare,nightview,chimaek,healing', '여의도물빛축제'),

                                                                            (2, 'Ihwa-dong Mural Village', 'Ihwa-dong, Jongno-gu, Seoul',
                                                                             'Alleys full of charming murals and artworks. A warm background showing the past memories or innocent times of the members.',
                                                                             'mural,artvillage,charming,moodphoto,alleytrip,warm,modest', '이화벽화마을'),

                                                                            (2, 'Banpo Bridge Rainbow Fountain', 'Banpo-dong, Seocho-gu, Seoul',
                                                                             'A place where romantic or touching scenes between members were created against the backdrop of the splendid rainbow fountain pouring over the Han River.',
                                                                             'rainbowfountain,hanrivernightview,romantic,dating,fantastic,moodplace,seoulnight', '반포무지개분수'),

                                                                            (2, 'Hongdae Walking Street', 'Eoulmamdang-ro, Mapo-gu, Seoul',
                                                                             'A street where the heat of youth and busking performances never cease. A free-spirited place alive with indie music and street culture.',
                                                                             'busking,youthstreet,hip,clubculture,streetfashion,lively,free', '홍대버스킹'),

                                                                            (2, 'Insadong Ssamzigil', '44 Insadong-gil, Jongno-gu, Seoul',
                                                                             'A spiral building where traditional crafts and modern design coexist. A place where members browse Korean items or experience culture.',
                                                                             'traditionalculture,crafts,uniquebuilding,shopping,korean,touristspot,charming', '인사동쌈짓길'),

                                                                            (2, 'Lotte World Tower Seoul Sky', '300 Olympic-ro, Songpa-gu, Seoul',
                                                                             'The tallest observatory in Korea. A place that becomes the backdrop for planning overwhelming scale operations or the finale, with all of Seoul downtown under your feet.',
                                                                             'highestfloor,observatory,thrill,overwhelmingview,seoulview,glamorous,luxury', '롯데월드타워'),

                                                                            (2, 'Seoullo 7017', '432 Cheongpa-ro, Jung-gu, Seoul',
                                                                             'An aerial walkway transformed from an urban overpass into a park. A path where members walk while organizing their thoughts, overlooking the complex Seoul Station area.',
                                                                             'skygarden,urbanregeneration,urbanwalk,seoulstationview,nightviewspot,unique,goodforwalking', '서울로'),

                                                                            (2, 'Gangnam-daero (Gangnam Station Area)', 'Gangnam-daero, Gangnam-gu, Seoul',
                                                                             'Seouls busiest street filled with giant buildings and neon signs. A background where the glamour of the city coexists with its dark underside.',
                                                                             'gangnamstyle,downtown,neonsigns,urban,crowded,shopping,meetingplace', '강남역'),

                                                                            (2, 'Seongsu-dong Yeonmujang-gil', 'Yeonmujang-gil, Seongdong-gu, Seoul',
                                                                             'A street mixing old red brick factories with hip pop-up stores. A place with rough charm that members might use as a hideout or have spent trainee days.',
                                                                             'hipplace,popupstores,vintage,industrial,rough,fashion,youth', '성수동'),

                                                                            (2, 'Ikseon-dong Hanok Street', 'Ikseon-dong, Jongno-gu, Seoul',
                                                                             'A place densely packed with cafes and shops converted from hanoks in narrow alleys. An emotional space good for protagonists to disguise and blend into the crowd.',
                                                                             'newtro,hanokalley,charming,mood,lifeshot,dessert,retro', '익선동');

-- Mr. Sunshine destination data (media_id = 3)
INSERT INTO tb_destination (media_id, name, address, description, tags) VALUES
                                                                            (3, 'Nonsan Sunshine Studio', '102 Bonghwang-ro, Yeonmu-eup, Nonsan-si, Chungcheongnam-do',
                                                                             'The main filming site of the drama, the only domestic enlightenment-era filming set perfectly recreating settings like Glory Hotel, Hongyegyo, and Hedeulrio',
                                                                             'enlightenmentera,retro,righteous,lifeshot,gloryhotel,historicalexperience,magnificent'),

                                                                            (3, 'Andong Manhyujeong', '42 Mokgyehari-gil, Giran-myeon, Andong-si, Gyeongsangbuk-do',
                                                                             'The location with the single-log bridge where Eugene Choi confessed to Ae-shin, lets do it, love, showcasing spectacular scenery with forest and waterfall',
                                                                             'singlelogbridge,romantic,letsdolove,forest,serene,couple,photozone'),

                                                                            (3, 'Andong Gosanjeong', '177-42 Gasong-gil, Dosan-myeon, Andong-si, Gyeongsangbuk-do',
                                                                             'The place where Eugene and Ae-shin crossed the river by ferry. Scenery like an ink painting with steep cliff Doksan and river waters',
                                                                             'ferry,cliff,riverside,peaceful,traditional,beautiful,scenicspot'),

                                                                            (3, 'Yecheon Choganjeong', '874 Yongmungyeongcheon-ro, Yongmun-myeon, Yecheon-gun, Gyeongsangbuk-do',
                                                                             'The secret pavilion where Ae-shin read letters from Eugene or studied. A place with scholarly elegance built on rock beside a valley',
                                                                             'valley,pavilion,secret,scholar,leisure,contemplation,traditionalarchitecture'),

                                                                            (3, 'Hamyang Gaepyeong Hanok Village (Ildugotaek)', '50-13 Gaepyeong-gil, Jigok-myeon, Hamyang-gun, Gyeongsangnam-do',
                                                                             'The place that appeared as Ae-shins house in the drama. A noble village with impressive grand gate and hanok beauty preserved through the ages',
                                                                             'hanok,noblemansion,traditionalvillage,elegant,walk,familytrip,hanokexperience'),

                                                                            (3, 'Gyeongju Samneung Forest', 'San 70-1, Bae-dong, Gyeongju-si, Gyeongsangbuk-do',
                                                                             'The mysterious pine forest where young Eugene fled from pursuers. Visiting when foggy maximizes the dreamlike atmosphere',
                                                                             'pinetree,fog,dreamlike,mysterious,photographyspot,nature,trekking'),

                                                                            (3, 'Seosan Haemi Fortress', '143 Nammunoe Maeul 1-gil, Haemi-myeon, Seosan-si, Chungcheongnam-do',
                                                                             'A representative fortress from the Joseon Dynasty that frequently appeared in scenes where righteous soldiers trained or guarded walls',
                                                                             'fortress,lawn,picnic,history,walkingcourse,open,withchildren'),

                                                                            (3, 'Buyeo Galimseong (Seongheungsanseong) Love Tree', '167 Seongheung-ro 97beon-gil, Imcheon-myeon, Buyeo-gun, Chungcheongnam-do',
                                                                             'Called the love tree because its branch shape resembles half a heart. A sunset spot evoking the tender atmosphere between Eugene and Ae-shin',
                                                                             'lovetree,heart,sunsetspot,silhouetteshot,couplespot,hill,romantic'),

                                                                            (3, 'Changnyeong Hwawangsan Fortress', 'San 1, Okcheon-ri, Changnyeong-eup, Changnyeong-gun, Gyeongsangnam-do',
                                                                             'A place with magnificent ridges where righteous soldiers fought against Japanese forces. In autumn, silver pampas grass creates a spectacular sight',
                                                                             'pampasgrass,hiking,majestic,ridge,autumntrip,righteouspath,active'),

                                                                            (3, 'Daegu Keimyung University Seongseong Campus (Adams Hall)', '1095 Dalgubeol-daero, Dalseo-gu, Daegu',
                                                                             'An impressive place with Western-style red brick buildings, used as the American consulate building giving an exotic feel',
                                                                             'exotic,redbrick,university,europeanstyle,sophisticated,walk,classic'),

                                                                            (3, 'Cheongju Unbo House', '92-41 Hyeongdong 2-gil, Naesu-eup, Cheongwon-gu, Cheongju-si, Chungcheongbuk-do',
                                                                             'An art space with well-maintained traditional hanok and beautiful garden, used as Gu Dong-maes house or Japanese-style mansion background',
                                                                             'garden,art,japanesehouse,quiet,atmospheric,exhibition,elegant'),

                                                                            (3, 'Hadong Choi Champan Taek', '66-7 Pyeongsari-gil, Akyang-myeon, Hadong-gun, Gyeongsangnam-do',
                                                                             'Background of the novel Toji and various village scenes from Mr. Sunshine. A view overlooking the Pyeongsari plains',
                                                                             'ruralscenery,folkvillage,thatchedhouse,toji,heartwarming,healing,traditional'),

                                                                            (3, 'Pyeongchang Woljeongsa Fir Forest Trail', '374-8 Odaesan-ro, Jinbu-myeon, Pyeongchang-gun, Gangwon-do',
                                                                             'A beautiful forest path that appeared as a snow-covered winter background. Just walking among straight fir trees feels purifying',
                                                                             'winterkingdom,firtrees,forestpath,healing,goodforwalking,pristine,meditation'),

                                                                            (3, 'Seoul Deoksugung Seokjojeon', '99 Sejong-daero, Jung-gu, Seoul',
                                                                             'A Western-style stone building used as the imperial palace of the Korean Empire. A place holding heartbreaking history related to Emperor Gojong',
                                                                             'palace,koreanempire,renaissancestyle,historyeducation,elegant,downtown,nightview'),

                                                                            (3, 'Seoul Unhyeongung Western Hall', '460 Samil-daero, Jongno-gu, Seoul',
                                                                             'A building boasting gorgeous European-style exterior, a unique spot where you can glimpse the lifestyle of the upper class during the enlightenment era',
                                                                             'westernhall,white,architecture,unique,photozone,jongno,antique'),

                                                                            (3, 'Jeonju Hyanggyo', '139 Hyanggyo-gil, Wansan-gu, Jeonju-si, Jeollabuk-do',
                                                                             'A place where students studied, the large ginkgo tree turns yellow in autumn creating a dramatic atmosphere',
                                                                             'ginkgotree,autumn,traditional,education,warm,calm,photography'),

                                                                            (3, 'Hapcheon Film Theme Park', '757 Hapcheонho-ro, Yongju-myeon, Hapcheon-gun, Gyeongsangnam-do',
                                                                             'A place recreating Seoul streets from the Japanese occupation era, where many tense scenes from the drama with trams and old buildings were filmed',
                                                                             'setlocation,tram,modernhistory,experience,spacious,familytrip,vintage'),

                                                                            (3, 'Jinjuseong Seojangdae', '626 Namgang-ro, Jinju-si, Gyeongsangnam-do',
                                                                             'A command post on a cliff overlooking the Namgang River. Offers majestic scenery evoking the determination of righteous soldiers',
                                                                             'namriver,fortress,nightviewspot,resolute,history,riverwalking,magnificent'),

                                                                            (3, 'Suncheon Nakaneupseong', '30 Chungmin-gil, Nakan-myeon, Suncheon-si, Jeollanam-do',
                                                                             'A thatched house village where residents actually live, the place to most vividly feel the lives of common people at the end of the Korean Empire',
                                                                             'folkvillage,thatchedhouse,heartwarming,traditionalexperience,cozy,fortresspath,modest'),

                                                                            (3, 'Gochang Boryeong Hakwon Farm', '158 Hakwonnongjanggil, Gongeum-myeon, Gochang-gun, Jeollabuk-do',
                                                                             'A place with vast green barley fields or buckwheat flower fields, used as a lyrical background representing seasons in the drama',
                                                                             'greenbarleyfield,buckwheatflower,vast,naturalspot,refreshing,seasonaltrip,greencolor');


-- Crash Landing on You destination data (media_id = 4)
INSERT INTO tb_destination (media_id, name, address, description, tags) VALUES
                                                                            (4, 'Yeongwol Byeolmaro Observatory', '397 Cheonmundae-gil, Yeongwol-eup, Yeongwol-gun, Gangwon-do',
                                                                             'The mountain peak where Yoon Se-ri took off for paragliding in episode 1. Offers an excellent view overlooking Yeongwol town',
                                                                             'paragliding,nightviewspot,sky,open,adventure,stargazing,refreshing'),
                                                                            (4, 'Pocheon Hantangang Sky Bridge', '207 Bidulginang-gil, Yeongbuk-myeon, Pocheon-si, Gyeonggi-do',
                                                                             'The symbolic bridge where Ri Jeong-hyeok and Yoon Se-ri recalled their past encounter on the Sigriswil Bridge in Switzerland',
                                                                             'suspensionbridge,destiny,walk,scenicview,thrilling,riverside,dating'),
                                                                            (4, 'Pocheon Bidulginang Falls', '415-2 Daehoesan-ri, Yeongbuk-myeon, Pocheon-si, Gyeonggi-do',
                                                                             'A mysterious waterfall that appeared in epilogue or flashback scenes. Creates an exotic atmosphere with emerald water color and columnar joints',
                                                                             'scenic,waterfall,mysterious,geopark,bluewater,magnificent,photozone'),
                                                                            (4, 'Chungju Binae Island', 'San 70-2, Boktan-ri, Sotae-myeon, Chungju-si, Chungcheongbuk-do',
                                                                             'The peaceful pampas field where Yoon Se-ri enjoyed a picnic with the unit members she grew fond of before returning to South Korea',
                                                                             'pampasgrass,picnic,riverside,carcampingspot,vintage,peaceful,autumnmood'),
                                                                            (4, 'Chungju Tangeum Lake Rainbow Road', '1-2 Tappyeong-ri, Jungangtap-myeon, Chungju-si, Chungcheongbuk-do',
                                                                             'A night view spot where Seo Dan and Gu Seung-jun confirmed their feelings for each other with a kiss. Gorgeous lights illuminate the lake at night',
                                                                             'nightview,walkingpath,romantic,lakeview,glamorous,kissscene,nightwalk'),
                                                                            (4, 'Jeju Seogwipo Healing Forest', '2271 Sannongnam-ro, Seogwipo-si, Jeju Special Self-Governing Province',
                                                                             'The actual background of the North Korean DMZ forest where Yoon Se-ri first opened her eyes after a paragliding accident. Full of lush cypress trees',
                                                                             'forestpath,healing,phytoncide,cypresstrees,refreshing,walk,nature'),
                                                                            (4, 'Taean Sinduri Coastal Dune', '201-122 Sinduhaebyeon-gil, Wonbuk-myeon, Taean-gun, Chungcheongnam-do',
                                                                             'The place where North Korean coastal scenes were filmed, with massive sand dunes rare in Korea giving an exotic feeling',
                                                                             'desert,exotic,sanddunes,coastal,vast,mysterious,walkingcourse'),
                                                                            (4, 'Busan Como Hotel', '151 Jung-gu-ro, Jung-gu, Busan',
                                                                             'The place where lobby and interior scenes of the top luxury hotel located in Pyongyang were filmed. Features unique interior design incorporating Korean traditional style',
                                                                             'hotel,pyongyang,traditionalarchitecture,glamorous,luxury,magnificent,busantrip'),
                                                                            (4, 'Incheon Seonnyeobawi Beach', '678-188 Eulwang-dong, Jung-gu, Incheon',
                                                                             'The beach where Ri Jeong-hyeok first set foot after infiltrating South Korea through an underwater tunnel to protect Yoon Se-ri',
                                                                             'ocean,infiltration,winterocean,sunset,nearincheonairport,desolate,resilient'),
                                                                            (4, 'Seoul Buam-dong 7', '7 Buam-dong, Jongno-gu, Seoul',
                                                                             'The place that appeared as the exterior of chaebol heiress Yoon Se-ris glamorous mansion. Sophisticated architecture with an upscale atmosphere overlooking Seoul downtown',
                                                                             'mansion,luxury,sophisticated,architecture,downtownview,upscale,yoonserieshouse'),
                                                                            (4, 'Ulsan Seuldo Island', 'San 1-1, Bangeo-dong, Dong-gu, Ulsan',
                                                                             'A location filmed to create a North Korean coastal feel where Gu Seung-jun waited for Seo Dan. Beautiful lighthouse and wave sounds',
                                                                             'lighthouse,wavesounds,oceanwalk,refreshing,fishing,peaceful,quiet'),
                                                                            (4, 'Incheon Jemulpo Club', '25 Jayugongnam-ro, Jung-gu, Incheon',
                                                                             'A modern architecture utilized in scenes of Gu Seung-juns hideout or antique buildings in North Korea',
                                                                             'modernarchitecture,antique,history,secretive,calm,culturalspace,incheonsstation'),
                                                                            (4, 'Wonju Museum SAN', '260 Oak Valley 2-gil, Jijeong-myeon, Wonju-si, Gangwon-do',
                                                                             'An architectural background symbolizing the sophisticated image of Yoon Se-ris company Seris Choice or her modern lifestyle',
                                                                             'artmuseum,architecture,andotadao,sophisticated,art,upscale,healing'),
                                                                            (4, 'Incheon Paradise City', '186 Yeongjong-haean Namno 321beon-gil, Jung-gu, Incheon',
                                                                             'A luxurious background showcasing Yoon Se-ris glamorous return to South Korea and her life as a chaebol',
                                                                             'hotel,glamorous,luxury,shopping,artwork,staycation,urban'),
                                                                            (4, 'Damyang Metasequoia Road', '633 Hakdong-ri, Damyang-eup, Damyang-gun, Jeollanam-do',
                                                                             'A place used when portraying Ri Jeong-hyeok and Yoon Se-ri walking side by side or the atmosphere of North Koreas quiet tree-lined streets',
                                                                             'treelinedstreet,walk,greencolor,fresh,datespot,photospot,leisure'),
                                                                            (4, 'Seogwipo Seobokjeon Exhibition Hall', '156-8 Chilsimniro, Seogwipo-si, Jeju Special Self-Governing Province',
                                                                             'A classic building utilized to film border areas or wall scenes between North and South Korea in the drama',
                                                                             'hanok,garden,oceanview,serene,jejutrip,exhibition,quiet'),
                                                                            (4, 'Suncheon Nakaneupseong', '30 Chungmin-gil, Nakan-myeon, Suncheon-si, Jeollanam-do',
                                                                             'Partially filmed as North Koreas marketplace or showing common peoples lives',
                                                                             'folkvillage,heartwarming,traditional,market,thatchedhouse,historicalexperience,cozy'),
                                                                            (4, 'Incheon Gyeongin Ara Waterway', '24 Arabi-ro, Gyeyang-gu, Incheon',
                                                                             'Background of scenes where Ri Jeong-hyeok and unit members rode bicycles or searched for directions in the unfamiliar urban environment after coming to South Korea',
                                                                             'waterway,bicyclepath,urbanwalk,refreshing,riverbreeze,nightview,goodforexercise'),
                                                                            (4, 'Seoul Wolfgang Steakhouse', '21 Seolleung-ro 152-gil, Gangnam-gu, Seoul',
                                                                             'The actual location of high-end restaurant scenes where Yoon Se-ri had business meetings or showed her power',
                                                                             'steak,cheongdam,luxury,finerestaurant,atmosphere,business,delicious'),
                                                                            (4, 'Paju Byeokchoji Arboretum', '242 Buheung-ro, Gwangtan-myeon, Paju-si, Gyeonggi-do',
                                                                             'Has European-style gardens, partially used as background for Se-ris glamorous childhood or Swiss flashback scenes',
                                                                             'arboretum,europeanstyle,garden,flowerviewing,glamorous,photogenic,familytrip');

INSERT INTO tb_destination (media_id, name, address, description, tags) VALUES
                                                                            (5, 'Pohang Cheongha Gongjin Market', '6 Cheongha-ro 200beon-gil, Cheongha-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'The actual background of Gongjin Market in the drama. The main filming location where you can feel the squid tower at the market entrance and heartwarming market atmosphere',
                                                                             'retro,traditionalmarket,heartwarming,gongjin,grocery,bustling,foodie'),

                                                                            (5, 'Sabang Memorial Park Mugeunbong', '1801 Haean-ro, Heunghae-eup, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'The place where Chief Hongs grandfathers boat was on the mountain peak. Climbing the steep stairs offers a view of the entire Pohang ocean',
                                                                             'boatonhill,oceanview,lifeshot,open,refreshing,hiking,cool'),

                                                                            (5, 'Yoon Dental Clinic (Cheongjin 3-ri Fishermens Welfare Center)', '1884-2 Haean-ro, Cheongha-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'The building where protagonist Hye-jin ran Yoon Dental Clinic. The ocean view right in front makes the window scenery picturesque',
                                                                             'oceanview,whitetone,clean,hyejin,walkingcourse,romantic,mustvisit'),

                                                                            (5, 'Red Lighthouse (Cheongjinhang Breakwater)', '71-12 Cheongjin-ri, Cheongha-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'The place where Chief Hong and Hye-jin had conversations or went fishing, an impressive photo zone with the red lighthouse contrasting with the blue ocean',
                                                                             'redlighthouse,breakwater,fishingspot,wind,photozone,blueandred,leisurely'),

                                                                            (5, 'Wolpo Beach', '2308 Haean-ro, Cheongha-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'The beach where Hye-jin and Chief Hong first met and where Chief Hong enjoyed surfing. A lively beach popular with surfers',
                                                                             'surfing,firstmeeting,widesandy,lively,waterplay,youthfulvibe,summerocean'),

                                                                            (5, 'Gonryunsan Launching Site', 'San 92-1, Chilpo-ri, Heunghae-eup, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'A place that showed refreshing views in the drama. From the top with artificial turf, you can enjoy a 360-degree view of Pohang coastline including Chilpo Beach',
                                                                             'viewspot,paragliding,artificialgrass,greencolor,lifephoto,exercise,magnificent'),

                                                                            (5, 'Igari Anchor Observatory', 'San 67-3, Igari, Cheongha-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'A unique anchor-shaped observatory. Not a major drama background, but a good Pohang landmark to visit with nearby filming locations',
                                                                             'anchor,unique,oceanwalkway,bluewaves,coastalwalk,popularspot,pristinearea'),

                                                                            (5, 'Chief Hongs House (Guryongpo Seokbyeong 1-ri)', '18-20 Ilchul-ro 210beon-gil, Guryongpo-eup, Nam-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'Hong Du-shiks modest house holding traces of his life. A peaceful fishing village atmosphere with low stone walls and ocean views',
                                                                             'modest,fishingvillage,stonewall,hongdusik,cozy,alleytrip,quiet'),

                                                                            (5, 'Yoon Hye-jin House (Seokbyeongri Guesthouse)', 'Ilchul-ro 210beon-gil, Guryongpo-eup, Nam-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'The house where Hye-jin from Seoul stayed. Close to Chief Hongs house and Chief Kams house, enjoyable to walk village alleys',
                                                                             'villagescenery,redroof,neighborhoodwalk,mood,warm,alley,peaceful'),

                                                                            (5, 'Chief Kim House', '15 Ilchul-ro 204beon-gil, Guryongpo-eup, Nam-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'Gongjins elder Chief Kams house. A heartwarming place evoking scenes of sitting on the wooden porch eating corn',
                                                                             'grandmothershouse,woodenporch,heartwarming,corn,memories,modest,comforting'),

                                                                            (5, 'Seokbyeong 1-ri Village Hall', '1 Ilchul-ro 210beon-gil, Guryongpo-eup, Nam-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'The place where Gongjin village people gathered for meetings or held feasts. An actual resting place for village residents',
                                                                             'meeting,villagecommunity,bustling,humantouch,heartwarming,livingspace,friendly'),

                                                                            (5, 'Bora Super', '1 Cheongha-ro 200beon-gil, Cheongha-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'A small supermarket located in Cheongha Gongjin Market. An essential course where drama fans take verification shots, filled with old-fashioned snacks and toys',
                                                                             'nostalgicsnacks,supermarket,charming,bora,verificationshot,cute,alleyshop'),

                                                                            (5, 'Gongjin Banjeom', '5 Cheongha-ro 200beon-gil, Cheongha-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'A Chinese restaurant background located in market alleys. Not an actual restaurant, but the signboard and exterior are preserved, maintaining the drama atmosphere',
                                                                             'chineserestaurant,jajangmyeon,marketalley,signboard,dramabackground,familiar,vintage'),

                                                                            (5, 'Cheongho Hardware Store', 'Cheongha-ro 200beon-gil, Cheongha-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'The hardware store run by Chief Hongs friend. One of the main places composing Gongjin Market street in the drama',
                                                                             'hardwarestore,chiefhongsfriend,liferelated,retro,alleysightseeing,rugged,realistic'),

                                                                            (5, 'Coffee in Daytime Beer at Night (Cafe Sanbada)', '7 Cheongha-ro 200beon-gil, Cheongha-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'The live cafe run by Oh Yoon (Jo Han-cheol). Vintage exterior wall and climbing plants create an exotic yet warm feeling',
                                                                             'livecafe,coffeeandeer,ohyoon,music,vintage,climbingplants,atmosphere'),

                                                                            (5, 'Ara Square Squid Statue', 'Cheongjin-ri, Cheongha-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'A giant squid statue near Gongjin Port. A humorous spot symbolizing Gongjin as a fishing village famous for squid',
                                                                             'squid,statue,humorous,seasidepublic,landmark,photozone,gonjinsymbol'),

                                                                            (5, 'Pohang Bogyeongsa Temple', '523 Bogyeongsa-ro, Songna-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'A place where main characters went hiking or enjoyed the serenity of the temple. Famous for hiking trail connected to 12 waterfalls',
                                                                             'temple,hiking,waterfall,valley,forest,calm,naturehealing,gothic'),

                                                                            (5, 'Cheongjin 3-ri Breakwater Walking Path', 'Cheongjin-ri Coastal Area, Cheongha-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'A quiet seaside walking path where Hye-jin walked alone looking at the ocean or accidentally encountered Chief Hong',
                                                                             'wavesounds,coastalwalk,contemplation,quiet,leisure,wind,oceanscent'),

                                                                            (5, 'Odori Beach', '1732beon-gil Haean-ro, Heunghae-eup, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'A quiet beach near Yoon Dental Clinic. Many charming cafes, good for resting after touring drama filming locations',
                                                                             'cafestreet,quietbeach,moodcafe,oceanview,dating,resting,clearocean'),

                                                                            (5, 'Cafe 1703', '2662 Haean-ro, Songna-myeon, Buk-gu, Pohang-si, Gyeongsangbuk-do',
                                                                             'An ocean view cafe frequently used by drama filming staff and actors or utilized as background. White and blue tones reminiscent of Greeces Santorini',
                                                                             'santorinistyle,oceanviewcafe,brunch,refreshingview,whiteandblue,summeratmosphere,lifeshort');

-- Queen of Tears destination data (images excluded, no single quotes)
INSERT INTO tb_destination (media_id, name, address, description, tags) VALUES
                                                                            (6, 'Under Yanghwa Bridge Walking Path', 'Yanghwa-dong, Mapo-gu, Seoul',
                                                                             'An urban walking spot that captured major drama scenes. A great place to walk emotionally while viewing the Han River',
                                                                             'hanriver,walk,urbanmood,photospot,dating,nightview,seoul,mood'),

                                                                            (6, 'Yeouido Park', '2 Yeouido-dong, Yeongdeungpo-gu, Seoul',
                                                                             'A representative urban park of Yeouido where you can enjoy different atmospheres each season',
                                                                             'urbanpark,picnic,walk,dating,seoul,healing'),

                                                                            (6, 'Seogang Bridge Night View Point', 'Yeouido-dong, Yeongdeungpo-gu, Seoul',
                                                                             'A night view spot where you can feel the vast scale of the Han River, a place where emotional drama scenes frequently appeared',
                                                                             'hanriver,nightview,photospot,dating,urban'),

                                                                            (6, 'Conrad Seoul', '10 Gukjegeumyung-ro, Yeongdeungpo-gu, Seoul',
                                                                             'A sophisticated downtown luxury hotel, a city view spot where various drama scenes were filmed',
                                                                             'luxury,hotelview,nightview,urban,dating,instamood'),

                                                                            (6, 'The Hyundai Seoul', '108 Yeoui-daero, Yeongdeungpo-gu, Seoul',
                                                                             'A complex space where you can enjoy shopping, dining, and relaxation, a filming location for everyday scenes',
                                                                             'shopping,downtown,cafe,familytrip,healing'),

                                                                            (6, 'Yeouido Transfer Center Scenery', '122-2 Yeoui-daero, Yeongdeungpo-gu, Seoul',
                                                                             'A road and bus platform scenery where you can feel the rhythm of urban transportation and daily life',
                                                                             'urbanlife,photospot,mood'),

                                                                            (6, 'Under Mapo Bridge Night View', 'Yanghwa-dong, Mapo-gu, Seoul',
                                                                             'Another night view point of the Han River, a place alive with calm drama emotions',
                                                                             'hanriver,nightview,mood'),

                                                                            (6, 'Yeouinaru Station Area Cafe Street', 'Yeouido-dong, Yeongdeungpo-gu, Seoul',
                                                                             'A street with many terrace and mood cafes, a good space for walking while having coffee',
                                                                             'cafe,mood,dating'),

                                                                            (6, 'Han River Bicycle Path', 'Seoul City',
                                                                             'A bicycle course along the Han River where you can enjoy both exercise and scenery',
                                                                             'bicycle,exercise,hanriver,healing'),

                                                                            (6, '63 Square Observatory', '63-ro, Yeongdeungpo-gu, Seoul',
                                                                             'A representative observation spot where you can look down at the city view and Han River at once',
                                                                             'observatory,photospot,nightview,seoul'),

                                                                            (6, 'Han River Cruise', 'Seoul City',
                                                                             'A tourism course where you can spend leisurely time enjoying city scenery on the Han River',
                                                                             'cruise,hanriver,dating,tourism'),

                                                                            (6, 'Seogang Bridge North End Park', 'Mapo-gu, Seoul',
                                                                             'A Han River park where you can rest relatively quietly in the city',
                                                                             'park,healing,urban'),

                                                                            (6, 'Yeouido Flower Road', 'Yeongdeungpo-gu, Seoul',
                                                                             'A walking spot where you can enjoy different flower scenery each season',
                                                                             'flowerroad,walk,photospot'),

                                                                            (6, 'Han River Night Goblin Night Market', 'Seoul City',
                                                                             'A popular market where you can enjoy food and performances together while admiring Han River night views',
                                                                             'nightmarket,hanriver,food'),

                                                                            (6, 'Mapo Bridge Walking Course', 'Mapo-gu, Seoul',
                                                                             'A walking path along the river, good for walking alone or with a partner',
                                                                             'walk,hanriver,healing'),

                                                                            (6, 'Yeouido Art Museum', 'Yeongdeungpo-gu, Seoul',
                                                                             'An exhibition space where you can spend cultural time appreciating contemporary art',
                                                                             'museum,culture,dating'),

                                                                            (6, 'Han River Fountain Show', 'Seoul City',
                                                                             'A Han River spot where you can enjoy seasonal performances of water and light combined',
                                                                             'fountain,performance,familytrip'),

                                                                            (6, 'Seoullo 7017', 'Jung-gu, Seoul',
                                                                             'An aerial walking path crossing above downtown, a space where you can enjoy both views and rest',
                                                                             'walk,urban,view'),

                                                                            (6, 'Nodeul Island Music Fountain', 'Yongsan-gu, Seoul',
                                                                             'A particularly beautiful place at night with music, lights, and water combined in performance',
                                                                             'nightview,music,fountain');

-- My Sweet Mobster travel destination data (images excluded, no single quotes used)
INSERT INTO tb_destination (media_id, name, address, description, tags) VALUES
                                                                            (7, 'International Youth Marine Training Center', '313 Jangsu-ri, Hwayang-myeon, Yeosu-si, Jeollanam-do',
                                                                             'A training center that appeared as the first scene filming location of the drama, a resort spot with beautiful South Sea blue ocean scenery',
                                                                             'ocean,healing,trainingcenter,yeosu,nature,photospot'),

                                                                            (7, 'Gochang Hakwon Farm Rapeseed Flower Field', '158-6 Hakwonnongjanggil, Gongeum-myeon, Gochang-gun, Jeollabuk-do',
                                                                             'A rapeseed flower scene filming location in the drama, a photo spot where yellow flowers bloom in full spring',
                                                                             'flowerfield,rapeseedflower,spring,photospot,healing,romantic,gochang'),

                                                                            (7, 'Jeju Beach Walking Path', 'Seogwipo-si, Jeju',
                                                                             'A coastal walking course where you can feel the drama background atmosphere, a good place to walk listening to wave sounds',
                                                                             'ocean,jeju,walk,healing,photospot'),

                                                                            (7, 'Yeosu Night Sea Photo Zone', 'Jungang-dong, Yeosu-si, Jeollanam-do',
                                                                             'A place where you can feel Yeosus unique night sea emotions, where the scenery sparkling under lights is impressive',
                                                                             'nightsea,mood,photospot,dating,yeosu'),

                                                                            (7, 'Yeosu Leisure Experience Marine Park', 'Yeosu-si, Jeollanam-do',
                                                                             'A marine park where ocean leisure and experience activities are possible, a place suitable for family and couple trips',
                                                                             'leisure,experience,ocean,familytrip,healing'),

                                                                            (7, 'Yeosu Dolsan Park', 'Dolsan-eup, Yeosu-si, Jeollanam-do',
                                                                             'A panoramic park where you can look down at the beautiful scenery of Hallyeohaesang at once',
                                                                             'observatory,nature,healing'),

                                                                            (7, 'Yeosu Aqua Planet', 'Yeosu-si, Jeollanam-do',
                                                                             'A large aquarium where you can see various marine life, a place suitable for education and experience',
                                                                             'family,experience,education'),

                                                                            (7, 'Gochang Seonunsa Temple', 'Asan-myeon, Gochang-gun, Jeollabuk-do',
                                                                             'An ancient temple where you can enjoy different natural scenery each season, a space where calm drama emotions are felt',
                                                                             'temple,nature,healing'),

                                                                            (7, 'Gochang Dongho Beach', 'Dongho-ri, Gochang-gun, Jeollabuk-do',
                                                                             'A quiet beach where wide sandy beach and gentle waves harmonize',
                                                                             'beach,ocean,healing'),

                                                                            (7, 'Jeju Hamdeok Beach', 'Jeju-si, Jeju',
                                                                             'A representative Jeju beach famous for emerald ocean, suitable for photography and water play',
                                                                             'ocean,swimming,photospot'),

                                                                            (7, 'Jeju Oreum Trekking', 'Jeju',
                                                                             'A trekking course along gentle oreum where you can fully enjoy Jeju nature',
                                                                             'trekking,nature,healing'),

                                                                            (7, 'Yeosu Cable Car', 'Yeosu-si, Jeollanam-do',
                                                                             'A romantic transportation means where you can enjoy Yeosu panorama while crossing over the ocean',
                                                                             'cablecar,view,romantic'),

                                                                            (7, 'Yeosu Odongdo', 'Yeosu-si, Jeollanam-do',
                                                                             'An island-shaped coastal park famous for Hallyeohaesang scenery and camellia flowers',
                                                                             'island,nature,photospot'),

                                                                            (7, 'Jeju Seopjikoji', 'Seogwipo-si, Jeju Special Self-Governing Province',
                                                                             'A representative eastern Jeju scenery spot where open coastal cliffs and grasslands harmonize',
                                                                             'scenic,ocean,photospot'),

                                                                            (7, 'Gochang Dolmen Sites', 'Gochang-gun, Jeollabuk-do',
                                                                             'A prehistoric site designated as UNESCO World Heritage with great historical significance',
                                                                             'history,culture,photozone'),

                                                                            (7, 'Jeju Cafe Street', 'Seogwipo-si, Jeju',
                                                                             'A street where emotional cafes gather, a good space to enjoy leisurely rest',
                                                                             'cafe,mood,healing');

-- Squid Game Season 2 travel destination data (images excluded, no single quotes used)
-- media_id = 8 assumed
INSERT INTO tb_destination (media_id, name, address, description, tags) VALUES
                                                                            (8, 'Incheon International Airport', '272 Gonghang-ro, Jung-gu, Incheon',
                                                                             'The place where Squid Game Season 2 first scene was filmed. Good for starting travel feeling Koreas gateway.',
                                                                             'airport,urban,photospot,entrycourse'),
                                                                            (8, 'Daejeon Expo Science Park', '480 Daedeok-daero, Yuseong-gu, Daejeon',
                                                                             'Where some drama game sets were installed. Science park exploration and experience destination.',
                                                                             'experience,sciencepark,familytrip,photospot'),
                                                                            (8, 'Namsan Seoul Tower & Namsan Park', '105 Namsangongwon-gil, Yongsan-gu, Seoul',
                                                                             'A panoramic spot looking down at Seoul at once. City views appeared in several drama scenes.',
                                                                             'observatory,urban,photospot,dating'),
                                                                            (8, 'Seoul Subway Station Street Scenery', 'Seoul City',
                                                                             'Where you can feel subway scenery that became the background of ddakji scenes in the drama.',
                                                                             'urban,photospot,culturalexperience'),
                                                                            (8, 'Incheon Wolmido', 'Wolmigongwon-ro, Jung-gu, Incheon',
                                                                             'A tourist spot where you can enjoy coastal and amusement park scenery.',
                                                                             'ocean,amusementpark,photospot'),
                                                                            (8, 'Gwangalli Beach', 'Gwanganhaebyeon-ro, Suyeong-gu, Busan',
                                                                             'Busans representative beach, excellent beach walking and night view.',
                                                                             'ocean,beach,nightview'),
                                                                            (8, 'Dongdaemun Design Plaza', '281 Euljiro, Jung-gu, Seoul',
                                                                             'DDP boasting futuristic architectural style. Urban mood photo spot.',
                                                                             'urban,photospot,architecture'),
                                                                            (8, 'Seoul Forest', '273 Ttukseom-ro, Seongdong-gu, Seoul',
                                                                             'A spot where nature and downtown harmonize, walking and picnic destination.',
                                                                             'park,walk,healing'),
                                                                            (8, 'Han River Cruise', 'Seoul City',
                                                                             'Seoul panorama travel course viewed from the Han River.',
                                                                             'cruise,hanriver,tourism'),
                                                                            (8, 'Gwanghwamun Square', 'Sejong-daero, Jongno-gu, Seoul',
                                                                             'A square where history and modernity coexist, Seoul core spot.',
                                                                             'history,urban,photospot'),
                                                                            (8, 'Busan Gukje Market', 'Chungjangtaero, Jung-gu, Busan',
                                                                             'A traditional market atmosphere and various food experience spot.',
                                                                             'market,food,culture'),
                                                                            (8, 'Jeju Jungmun Tourist Complex', 'Jungmungwangwang-ro, Seogwipo-si, Jeju Special Self-Governing Province',
                                                                             'Jeju representative tourist site, good for enjoying ocean culture activities.',
                                                                             'jeju,touristcomplex,ocean'),
                                                                            (8, 'Busan Haeundae Beach', 'Haeundaehaebyeon-ro, Haeundae-gu, Busan',
                                                                             'Busans representative beach, summer travel spot.',
                                                                             'beach,ocean,resort'),
                                                                            (8, 'Gyeongbokgung Palace', 'Sajik-ro, Jongno-gu, Seoul',
                                                                             'A Joseon Dynasty palace travel destination where you can feel Korean traditional architecture.',
                                                                             'history,culture,photospot'),
                                                                            (8, 'Busan Gamcheon Culture Village', 'Gamcheonmunhwa-ro, Saha-gu, Busan',
                                                                             'Colorful alley scenery is an Instagram mood spot.',
                                                                             'alley,photospot,culture'),
                                                                            (8, 'Jeonju Hanok Village', 'Cheonjam-ro, Wansan-gu, Jeonju-si, Jeollabuk-do',
                                                                             'Korean traditional hanok scenery and food travel spot.',
                                                                             'hanok,traditional,food'),
                                                                            (8, 'Seoul Namsangol Hanok Village', 'Toegye-ro 34-gil, Jung-gu, Seoul',
                                                                             'Traditional hanok experience and small village mood walking.',
                                                                             'hanok,traditional,walk');

-- Our Beloved Summer travel destination data (images excluded, no single quotes used)
-- media_id = 9 assumed
INSERT INTO tb_destination (media_id, name, address, description, tags) VALUES
                                                                            (9, 'Seoul Jungang High School', '1 Gyedong, Jongno-gu, Seoul',
                                                                             'The school that became the background of two protagonists school days. Classic building and mood scenery are charming.',
                                                                             'school,mood,photospot,downtown'),
                                                                            (9, 'Bukchon Hanok Village Gamgodanggil', 'Yulgok-ro 3-gil, Jongno-gu, Seoul',
                                                                             'A walking path where hanok and alleys harmonize beautifully. A space alive with drama emotions.',
                                                                             'hanok,alley,walk,photospot,seoul'),
                                                                            (9, 'Suwon Hwaseong Fortress', 'Yeonghwa-dong, Jangan-gu, Suwon-si, Gyeonggi-do',
                                                                             'A UNESCO World Heritage fortress wall where both picnic and walking are possible.',
                                                                             'history,culture,walk,photospot'),
                                                                            (9, 'Suwon Jidong Mural Village', '75-5 Changyongmun-ro, Paldal-gu, Suwon-si, Gyeonggi-do',
                                                                             'A village with impressive colorful alley murals, popular as a photo spot.',
                                                                             'mural,alley,photospot,mood'),
                                                                            (9, 'Osan Dolmen Park', '449 Sumogwon-ro, Osan-si, Gyeonggi-do',
                                                                             'A park where nature and relics coexist. A place remembered for dramas rainy scenes.',
                                                                             'park,history,nature'),
                                                                            (9, 'Jahasuper Street', '57 Jahamun-ro 42-gil, Jongno-gu, Seoul',
                                                                             'A small alley and supermarket with retro mood, famous as drama background.',
                                                                             'retro,alley,photospot'),
                                                                            (9, 'Suwon Haenggung-dong', 'Suwon-si, Gyeonggi-do',
                                                                             'A street where history and modernity harmonize, walking and photography spot.',
                                                                             'street,photospot'),
                                                                            (9, 'Yonsei University Campus Walking Path', '50-1 Yonsei-ro, Seodaemun-gu, Seoul',
                                                                             'A harmonious campus course of greenery and architecture.',
                                                                             'campus,walk,healing'),
                                                                            (9, 'Cheonggyecheon Walking Path', 'Jongno-gu, Seoul',
                                                                             'A natural stream walking path in downtown.',
                                                                             'downtown,walk,healing'),
                                                                            (9, 'Namsan Park Observatory', 'Yongsan-gu, Seoul',
                                                                             'A viewpoint where you can see Seoul panorama at once.',
                                                                             'view,urban'),
                                                                            (9, 'Gyeonggi Osan Cafe Street', 'Osan-si, Gyeonggi-do',
                                                                             'A local walking destination where mood cafes gather.',
                                                                             'cafe,mood'),
                                                                            (9, 'Suwon Local Market', 'Suwon-si, Gyeonggi-do',
                                                                             'A local atmosphere and food experience spot.',
                                                                             'market,food'),
                                                                            (9, 'In Front of Changdeokgung', 'Yulgok-ro, Jongno-gu, Seoul',
                                                                             'Traditional scenery walking point in front of palace.',
                                                                             'palace,history,walk'),
                                                                            (9, 'Namdaemun Market', 'Jung-gu, Seoul',
                                                                             'Korean representative traditional market street.',
                                                                             'market,shopping'),
                                                                            (9, 'Jeonju Hanok Village', 'Wansan-gu, Jeonju-si, Jeollabuk-do','Traditional hanok/food experience destination.','hanok,traditional,food'),
                                                                            (9, 'Paldalmun Square', 'Suwon-si, Gyeonggi-do','Suwon Hwaseong central square walk/photo spot.', 'square,photospot'),
                                                                            (9, 'Osan Bridge View Point', 'Osan-si, Gyeonggi-do','River view scenery viewing destination.','view,nature');

-- Squid Game travel destination data (images excluded, no single quotes used)
-- media_id = 10 assumed
INSERT INTO tb_destination (media_id, name, address, description, tags) VALUES
  (10, 'Itaewon Street', 'Itaewon-dong, Yongsan-gu, Seoul',
   'A street where diverse cultures and youthful energy coexist, a space where you can feel a lively atmosphere both day and night',
   'youth,challenge,urban,nightview,walk,restaurant,multicultural,seoul,vibrant'),
  (10, 'Gyeongridan-gil', 'Hoenamu-ro, Yongsan-gu, Seoul',
   'An alley commercial area where sophisticated cafes and restaurants gather, a space continuing Itaewon emotions',
   'alley,cafe,mood,dating,walk,youth,healing,seoul'),
  (10, 'Noksapyeong Station Overpass Observatory', '195 Noksapyeong-daero, Yongsan-gu, Seoul',
   'A viewpoint where you can see Itaewon panorama at once, a place where city energy is well felt',
   'view,nightview,photospot,urbanmood,walk,dating,youth'),
  (10, 'Danbam Street Food Filming Location Alley', 'Itaewon-ro 20-gil area, Yongsan-gu, Seoul',
   'An alley near drama filming location evoking the beginning and challenge of youth',
   'dramafilmingsite,alley,youth,challenge,mood,photospot'),
  (10, 'Haebangchon Shinheung Market', 'Shinheung-ro, Yongsan-gu, Seoul',
   'A unique market where local mood and young startup culture coexist',
   'market,local,youth,challenge,food,alley'),
  (10, 'Haebangchon Uphill Road', 'Yongsan-dong 2-ga, Yongsan-gu, Seoul',
   'A hill road overlooking Seoul downtown, a place evoking growth narrative',
   'hillroad,view,mood,walk,healing,youth'),
  (10, 'Namsan Park', 'Namsangongwon-gil, Yongsan-gu, Seoul',
   'A representative natural resting space near Itaewon, a healing place in downtown',
   'park,nature,healing,walk,dating'),
  (10, 'Namsan Seoul Tower Observatory', '105 Namsangongwon-gil, Yongsan-gu, Seoul',
   'A representative landmark observatory where you can see Seoul panorama at once',
   'observatory,nightview,dating,photospot,seoul'),
  (10, 'Yongsan Family Park', '221 Seobinggo-ro, Yongsan-gu, Seoul',
   'A quiet and spacious green space suitable for walking and rest',
   'park,walk,healing,nature'),
  (10, 'Itaewon Antique Furniture Street', 'Itaewon-ro, Yongsan-gu, Seoul',
   'A distinctive street where exotic atmosphere furniture shops gather',
   'exotic,street,photospot,culture'),
  (10, 'Yongridan-gil', 'Hangang-daero, Yongsan-gu, Seoul',
   'An emerging Yongsan commercial area where unique restaurants and cafes gather',
   'restaurant,cafe,youth,trendy,seoul'),
  (10, 'Ichon Han River District Walking Path', 'Ichon-dong, Yongsan-gu, Seoul',
   'A walking path along the Han River, a healing course in downtown',
   'hanriver,walk,healing,nightview'),
  (10, 'National Museum of Korea', '137 Seobinggo-ro, Yongsan-gu, Seoul',
   'A representative museum where you can see Korean history and culture at once',
   'culture,history,exhibition,familytrip'),
  (10, 'Yongsan Electronics Market', 'Cheongpa-ro, Yongsan-gu, Seoul',
   'A commercial space where old commercial area and modern changes coexist',
   'urban,commercial,retro,seoul'),
  (10, 'Itaewon Rooftop Bar Street', 'Itaewon-ro area, Yongsan-gu, Seoul',
   'An area where rooftop bars where you can enjoy Itaewon night views gather',
   'rooftop,nightview,dating,urbanmood'),
  (10, 'Hannam-dong Cafe Street', 'Hannam-dong, Yongsan-gu, Seoul',
   'A trendy neighborhood with many sophisticated mood cafes and galleries',
   'cafe,mood,dating,trendy'),
  (10, 'Hannam Bridge View Point', 'Yongsan-gu, Seoul',
   'A viewing place where you can view Han River and downtown together',
   'view,nightview,photospot'),
  (10, 'Itaewon World Food Street', 'Itaewon-dong, Yongsan-gu, Seoul',
   'A global gourmet street where you can taste food from various countries',
   'restaurant,worldfood,multicultural,gourmet'),
  (10, 'Yongsan Railroad Walking Path', 'Yongsan-gu, Seoul',
   'A unique walking course along railroad in downtown',
   'walk,unique,photospot,urban'),
  (10, 'Seoullo 7017', 'Mangnijae-ro, Jung-gu, Seoul',
   'An aerial walking path above downtown, a space symbolizing Seouls change and challenge',
   'walk,urban,view,youth,seoul');
