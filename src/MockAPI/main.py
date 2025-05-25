from flask import Flask, request, jsonify
from math import radians, cos, sin, sqrt, atan2

coffee_shops = [
    {
        "id": "0b86bcfb-e9f1-4054-a6f5-22794e013213",
        "name": "Шоколадница",
        "description": "Кофейня «Шоколадница» — это место, где вы можете насладиться ароматным кофе и вкусными десертами.",
        "contacts": {
            "phone": "+7 (985) 369-93-09",
            "website": "shoko.ru"
        },
        "working_hours": {
            "start_time": "10:00",
            "end_time": "21:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.3,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/14295867/2a00000195273bd51a258ece86296b3544e9/XXXL",
            "https://avatars.mds.yandex.net/get-altay/15126910/2a00000195ec0b633f9b19afcb4c76bc3b84/XXXL",
            "https://avatars.mds.yandex.net/get-altay/15074997/2a00000195273bcc9f1dccd6258231f4669d/XXXL",
        ],
        "location": {
            "latitude": 55.887910,
            "longitude": 37.662537,
            "address": "Широкая улица, 13А, Москва"
        }
    },
    {
        "id": "2f10c1ed-07d9-48fe-a121-28a78fcdff51",
        "name": "Cofix",
        "contacts": {
            "phone": "8 (800) 350-84-18",
            "website": "cofix.global"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "22:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 3.8,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/13287730/2a00000192a2c68c7d03cc9d437b3dcc4c63/XXXL"
        ],
        "location": {
            "latitude": 55.886113,
            "longitude": 37.660370,
            "address": "улица Грекова, 3к3, Москва",
        }
    },
    {
        "id": "0f81f46c-a260-4823-9afa-3ba97c5540c7",
        "name": "Курс Кофе графика",
        "description": "Кофейня «К14урс Кофе Графика» — это уютное место, где можно насладиться ароматным кофе, почитать книги или комиксы, а также пообщаться с друзьями или коллегами. В меню представлены различные виды кофе, а также чаи, какао, лимонады и другие напитки.",
        "contacts": {
            "phone": "+7 (951) 695-79-10",
        },
        "working_hours": {
            "start_time": "09:00",
            "end_time": "21:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 5.0,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/14014133/2a00000194e02a78cd2b2bd279bfbbac022e/XXXL",
            "https://avatars.mds.yandex.net/get-altay/13594632/2a00000194e02a54527d933d6122ace5ebda/XXXL",
            "https://avatars.mds.yandex.net/get-altay/14813057/2a00000194e02a63eaa89d3365fe4bc8c34e/XXXL",
        ],
        "location": {
            "latitude": 55.883468,
            "longitude": 37.659154,
            "address": "Заревый проезд, 2, Москва"
        }
    },
    {
        "id": "23747ef4-4467-443f-8722-5e2956774722",
        "name": "Paula Coffee",
        "description": "Paula Coffee — это кофейня, расположенная на территории танцевальной студии Gold & Dance. Она предлагает широкий выбор кофе, включая фильтр-кофе, а также смузи, соки и другие напитки.",
        "contacts": {
            "phone": "+7 (993) 349-07-72",
            "website": "taplink.cc"
        },
        "working_hours": {
            "start_time": "10:00",
            "end_time": "22:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.9,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/10768168/2a0000019247198614238a0c7f9ffcf74927/XXXL",
            "https://avatars.mds.yandex.net/get-altay/10247515/2a00000192472058ea83c340b56e587143b0/XXXL"
        ],
        "location": {
            "latitude": 55.767509,
            "longitude": 37.681326,
            "address": "Бауманская улица, 53с2, Москва"
        }
    },
    {
        "id": "25a1c8c8-10c0-4e59-a5d0-5c94408daef9",
        "name": "Правда Кофе",
        "description": "Кофейня «Правда Кофе» — это место, где вы можете насладиться вкусным кофе и пообщаться с приветливыми бариста.",
        "contacts": {
            "phone": "8 (800) 555-19-81",
            "website": "pravdacoffee.ru"
        },
        "working_hours": {
            "start_time": "07:30",
            "end_time": "21:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.9,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/11187599/2a0000018cb5b149284a2279b3fc1278c8b4/XXXL",
            "https://avatars.mds.yandex.net/get-altay/12814440/2a0000018fc99e95bdb10d41192c4120430f/XXXL"
        ],
        "location": {
            "latitude": 55.768973,
            "longitude": 37.679256,
            "address": "Бауманская улица, 54с1, Москва"
        }
    },
    {
        "id": "2bdeefde-8939-442a-9ab8-63712f584bee",
        "name": "Человек и пароход",
        "description": "Кофейня «Человек и пароход» — это стильное заведение, которое расположено в пространстве «Суперметалл». Интерьер кофейни выполнен в современном стиле, а барная стойка украшена необычной техникой.",
        "contacts": {
            "phone": "+7 (977) 329-01-98",
            "website": "chip.coffee"
        },
        "working_hours": {
            "start_time": "09:30",
            "end_time": "21:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.5,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/14456919/2a00000193fc9a163726151cec1850727a47/XXXL",
            "https://avatars.mds.yandex.net/get-altay/9728306/2a00000189bc8d140edf9fa6c8831d5ef66e/XXXL"
        ],
        "location": {
            "latitude": 55.764216,
            "longitude": 37.682531,
            "address": "2-я Бауманская улица, 9/23с3, Москва"
        }
    },
    {
        "id": "47dfefca-76cf-400d-a598-8ef1cb8a86cb",
        "name": "Croissant Atelier",
        "description": "Croissant Atelier — это кофейня, которая специализируется на круассанах и другой выпечке. Гости отмечают, что круассаны здесь очень вкусные и свежие, а порции большие и сытные.",
        "contacts": {
            "website": "menu.restik.com"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "22:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.9,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/7979597/2a00000191b3297860692eadd124c64ac916/XXXL",
            "https://avatars.mds.yandex.net/get-altay/14064514/2a00000191b32985168679613447412b8e61/XXXL"
        ],
        "location": {
            "latitude": 55.754243,
            "longitude": 37.636719,
            "address": "Солянский проезд, 1, Москва"
        }
    },
    {
        "id": "f3dc7a1a-2495-4e0a-874f-3d2b30ae5b0c",
        "name": "Aspeen coffee",
        "description": "Кофейня Aspeen coffee — это стильное и уютное место, где можно насладиться ароматным кофе и свежей выпечкой, такой как круассаны. Интерьер кофейни выполнен в минималистичном стиле, что создает атмосферу расслабления и общения.",
        "contacts": {
            "phone": "+7 (910) 480-04-09"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "21:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 5.0,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/13322921/2a0000019340572e48d3df2975fffc6914e5/XXXL",
            "https://avatars.mds.yandex.net/get-altay/14021354/2a000001944fe575ebc9420218ac56a601f1/XXXL",
            "https://avatars.mds.yandex.net/get-altay/13786585/2a0000019369bb5ee50defa0f4ac1c1467e5/XXXL"
        ],
        "location": {
            "latitude": 55.771438,
            "longitude": 37.686309,
            "address": "Малая почтовая улица, 8с3, Москва"
        }
    },
    {
        "id": "0e94e65a-520f-45ea-83da-8552a354ae55",
        "name": "CoffeeHub",
        "contacts": {
            "phone": "+7 (926) 868-58-87"
        },
        "working_hours": {
            "start_time": "09:00",
            "end_time": "21:01",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.5,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/11374564/2a000001919ea8588e423ee6837da1b65d52/XXXL",
            "https://avatars.mds.yandex.net/get-altay/11396712/2a0000018ce87f80d3a474bd26e467946139/XXXL"
        ],
        "location": {
            "latitude": 55.773416,
            "longitude": 37.683946,
            "address": "улица Фридриха Энгельса, 23с4, Москва"
        }
    },
    {
        "id": "928cbef9-b7db-4024-85f9-5f8f31332a28",
        "name": "Spirit coffee & cacao bar",
        "description": "Кофейня Spirit coffee — это место, где вы можете насладиться вкусом настоящего кофе, какао и шоколада. Здесь вы найдете широкий выбор напитков, включая капучино, раф, колд-брю и другие.",
        "contacts": {
            "phone": "+7 (965) 230-12-87"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "23:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.9,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/14814101/2a00000193fcee5d6bb0e1e274ed28adc7d9/XXXL",
            "https://avatars.mds.yandex.net/get-altay/10878699/2a00000193fcee69af093006e7595c16d508/XXXL",
            "https://avatars.mds.yandex.net/get-altay/6322664/2a0000019091f7e452c0bf68654f149bdfbf/XXXL"
        ],
        "location": {
            "latitude": 55.847608,
            "longitude": 37.636750,
            "address": "Лазоревый проезд, 5к4, Москва"
        }
    },
    {
        "id": "e5408935-ea74-4f6c-8446-5f31d6e267e9",
        "name": "Merenda",
        "description": "Кофейня Merenda — это уютное место, где можно отдохнуть от городской суеты и выпить вкусный бодрящий кофе с видом на Останкинскую башню. Интерьер кофейни выполнен в современном стиле, что создает приятную атмосферу для отдыха.",
        "contacts": {
            "phone": "+7 (926) 153-93-56",
            "website": "merenda.pro"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "20:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 5.0,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/14730529/2a00000194cd26106620216968c5e4f50c82/XXXL",
            "https://avatars.mds.yandex.net/get-altay/9833880/2a00000190fcd81d79c5783cc1c7cc0456ef/XXXL",
            "https://avatars.mds.yandex.net/get-altay/4699294/2a000001905d70025f8d49d6932879a171ba/XXXL"
        ],
        "location": {
            "latitude": 55.816217,
            "longitude": 37.603424,
            "address": "Огородный проезд, 16/1с3, Москва"
        }
    },
    {
        "id": "f3e5b73c-e0f3-42b3-8a11-39e1afb05803",
        "name": "Fob's",
        "description": "Кофейня Fob's — это уютное место с панорамными окнами, сквозь которые пробивается мягкий свет. Интерьер выполнен в минималистичном стиле, украшенный зеленью.",
        "contacts": {
            "phone": "+7 (916) 222-67-87",
            "website": "fobs-coffee.clients.site"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "22:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 5.0,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/1777247/2a00000185ce413568758109b397a9010961/XXXL",
            "https://avatars.mds.yandex.net/get-altay/758053/2a00000185ce4134f41b97b987da359c7870/XXXL",
            "https://avatars.mds.yandex.net/get-altay/922263/2a0000018789ec31a325928b6f6815f83876/XXXL"
        ],
        "location": {
            "latitude": 55.790403,
            "longitude": 37.567075,
            "address": "Ленинградский проспект, 36с39, Москва"
        }
    },
    {
        "id": "4d9e4d79-6417-4701-9f2f-7b4ef20e6abe",
        "name": "Coffee Way",
        "description": "Кофейня Coffee Way — это место, где вы можете насладиться ароматным кофе и вкусными десертами, такими как эклеры, торты и печенье.",
        "contacts": {
            "phone": "+7 (4742) 55-10-06",
            "website": "coffeeway.ru"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "22:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.3,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/901763/2a00000186838e60b767f0f4c70d7a9a1cc5/XXXL",
            "https://avatars.mds.yandex.net/get-altay/7734890/2a00000185776f11d0c62ae626f8ba4e0dd7/XXXL",
            "https://avatars.mds.yandex.net/get-altay/2424821/2a00000175424ec4a01e950f78d19a894ab8/XXXL"
        ],
        "location": {
            "latitude": 55.800878,
            "longitude": 37.639466,
            "address": "улица Проспект Мира, 102с27, Москва"
        }
    },
    {
        "id": "8ebaadc1-73c2-436d-8e73-8d6338fc88c2",
        "name": "Meet me Coffee",
        "description": "Кофейня Meet me Coffee — это уютное место, где вы можете насладиться ароматным кофе, авторскими чаями и коктейлями.",
        "contacts": {
            "phone": "+7 (926) 103-71-00",
            "website": "meet-me-company-page.tilda.ws"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "21:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.7,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/5098065/2a00000181adf5b63c31ab139c08e7b956bc/XXXL",
            "https://avatars.mds.yandex.net/get-altay/5517598/2a0000017c98c4d536440e71d793be5e1d95/XXXL",
            "https://avatars.mds.yandex.net/get-altay/5488055/2a0000017c98c51b4819f5184d8eaec1bb72/XXXL"
        ],
        "location": {
            "latitude": 55.880550,
            "longitude": 37.694694,
            "address": "улица Малыгина, 7, Москва"
        }
    },
    {
        "id": "80eee62d-6324-429b-b3e7-85fb3f112a26",
        "name": "Котокафе Котофейня",
        "description": "Котокафе Котофейня» — это антикафе, зооцентр и клуб любителей животных, где гости могут пообщаться с ухоженными и дружелюбными кошками, поиграть в настольные игры и приставки, а также выпить кофе или чай с печеньем.",
        "contacts": {
            "phone": "+7 (495) 115-52-38"
        },    
        "working_hours": {
            "start_time": "11:00",
            "end_time": "22:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 5.0,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/2390040/2a000001702eef94ede10a00a06b51276bb2/XXXL",
            "https://avatars.mds.yandex.net/get-altay/2887807/2a000001702eef6ad2a703523ceab13f40a4/XXXL",
            "https://avatars.mds.yandex.net/get-altay/11937297/2a0000018e15005dec9cd8bd72e8b09b4fe2/XXXL"
        ],
        "location": {
            "latitude": 55.757429,
            "longitude": 37.637122,
            "address": "улица Маросейка, 10/1с1, Москва"
        }
    },
    {
        "id": "324b25a1-a8c6-4125-9177-28272331c139",
        "name": "MaxBakery",
        "description": "MaxBakery — это кафе, где можно позавтракать, пообедать или поужинать, а также взять еду с собой.",
        "contacts": {
            "phone": "+7 (495) 668-80-00",
            "website": "maxbakery.ru"
        },
        "working_hours": {
            "start_time": "07:00",
            "end_time": "22:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.9,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/10953738/2a0000018a82eac84e954fad172c72859d1e/XXXL",
            "https://avatars.mds.yandex.net/get-altay/10156117/2a0000018bc883c739ee53345013dbbf6456/XXXL",
            "https://avatars.mds.yandex.net/get-altay/11383855/2a0000018bd88c6e30593d3a51dfa2b84e1c/XXXL"
        ],
        "location": {
            "latitude": 55.821515,
            "longitude": 37.438508,
            "address": "Волоколамское шоссе, 71/22к1, Москва"
        }
    },
    {
        "id": "2df017f1-4865-40f7-b7af-bc0dfb66440c",
        "name": "Кофейня Энергостанция",
        "description": "Кофейня Энергостанция — это уютное место с стильным интерьером, где можно отдохнуть или поработать. В меню представлен широкий выбор кофе: от классического эспрессо до оригинальных авторских напитков.",
        "contacts": {
            "phone": "+7 (968) 669-03-30"
        },
        "working_hours": {
            "start_time": "07:00",
            "end_time": "21:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.9,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/1909414/2a000001865ec6393ca93df0477be81bbeab/XXXL",
            "https://avatars.mds.yandex.net/get-altay/13581124/2a0000018eb9ace72983aa51d4493751a4b7/XXXL"
        ],
        "location": {
            "latitude": 55.808522,
            "longitude": 37.463080,
            "address": "улица Маршала Василевского, 17, Москва"
        }
    },
    {
        "id": "1eaa54f6-b7b6-446d-82d7-ca5bfa2d9435",
        "name": "Colorcoffee",
        "description": "Colorcoffee — это уютная кофейня, где вы можете насладиться ароматным кофе и вкусной едой",
        "contacts": {
            "phone": "+7 (965) 336-80-94"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "21:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.7,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/4660612/2a0000017776fb4ab697a65a13eaae7a299e/XXXL",
            "https://avatars.mds.yandex.net/get-altay/13818104/2a00000192af2bd09c460a4fa51676b9e553/XXXL"
        ],
        "location": {
            "latitude": 55.811325,
            "longitude": 37.498004,
            "address": "улица Дубосековская, 7, Москва"
        }
    },
    {
        "id": "934e08ae-fb59-43bd-a24f-2da84f7714d4",
        "name": "Хуан Кофеман",
        "description": "Кофейня «Хуан Кофеман» — это уютное место с мягким светом и приятной музыкой, где можно отдохнуть и поработать. Гостям нравится местный кофе, особенно цитрусовый раф, раф на шишках и айс-латте с кокосовой сгущенкой и цитрусовыми нотками.",
        "contacts": {
            "phone": "+7 (910) 409-65-02",
            "website": "huan.cafe"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "20:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.3,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/13930885/2a00000191cb86cb286bda2a95d4b873d084/XXXL",
            "https://avatars.mds.yandex.net/get-altay/235931/2a0000015ef66f6598ab126e4356a20bf492/XXXL",
            "https://avatars.mds.yandex.net/get-altay/13754922/2a00000191cb7dbb70ca9756332858620a8e/XXXL"
        ],
        "location": {
            "latitude": 55.809320,
            "longitude": 37.496972,
            "address": "Волоколамское шоссе, 10, Москва"
        }
    },
    {
        "id": "bfe5c5ad-6851-4307-8ff1-2eb349ef60c3",
        "name": "Stars Coffee",
        "description": "Кофейня Stars Coffee — это место, где вы можете насладиться ароматным кофе и вкусной выпечкой.",
        "contacts": {
            "phone": "+7 (952) 217-31-36",
            "website": "stars-coffee.ru"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "22:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.3,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/953593/2a00000187c5ae5c4f021ab7770ad7b46ce3/XXXL",
            "https://avatars.mds.yandex.net/get-altay/10111752/2a0000018db204abbfb20a03b2faf082e10c/XXXL",
            "https://avatars.mds.yandex.net/get-altay/777564/2a00000186fac6b3ff6d23eae672ac2a3bea/XXXL"
        ],
        "location": {
            "latitude": 55.799588,
            "longitude": 37.483023,
            "address": "Улица Маршала Бирюзова, 32, Москва"
        }
    },
    {
        "id": "5f1fa743-b3a4-44ec-a904-5c9cfbcc4bf2",
        "name": "Кофемания",
        "description": "Кофейня «Кофемания» — это место, где вы можете насладиться ароматным кофе и вкусными десертами. В меню представлены различные виды кофе и чая, а также авторские напитки.",
        "contacts": {
            "phone": "+7 (499) 495-15-72",
            "website": "coffeemania.ru"
        },
        "working_hours": {
            "start_time": "09:00",
            "end_time": "23:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.6,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/9717139/2a00000189b9e6dfbe282346f5ceb2ef184b/XXXL",
            "https://avatars.mds.yandex.net/get-altay/9709178/2a0000018a37cb54be9ee240e8bbc8e46b05/XXXL",
            "https://avatars.mds.yandex.net/get-altay/3691419/2a00000179fd0598bb1c49a0bab2bd06f57c/XXXL"
        ],
        "location": {
            "latitude": 55.823216,
            "longitude": 37.497468,
            "address": "Ленинградское шоссе, 16Ас4, Москва"
        }
    },
    {
        "id": "9605ba80-6e44-4edc-be53-70bec11de0e8",
        "name": "Уголок",
        "description": "Кофейня «Уголок» — это место, где вы можете насладиться настоящим, вкусным кофе.",
        "contacts": {
            "phone": "+7 (916) 157-05-69"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "22:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 5.0,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/11564583/2a0000018d47562b79fd8a6dea1ec7208208/XXXL",
            "https://avatars.mds.yandex.net/get-altay/11396712/2a0000018c29f02573546ea6e25ac9760baa/XXXL"
        ],
        "location": {
            "latitude": 55.815340,
            "longitude": 37.513507,
            "address": "улица Космонавта Волкова, 6А, Москва"
        }
    },
    {
        "id": "2a9eca3a-a20d-4beb-8269-3f690ced58dd",
        "name": "Coffeeteabar",
        "description": "Кофейня Coffeeteabar — это уютное место с мятным интерьером, декоративным мхом на стенах и необычным освещением. Гостям нравится местный кофе, особенно сырный кофе с маскарпоне и тыквенный кофе.",
        "contacts": {
            "phone": "+7 (965) 230-19-30",
            "website": "coffeeteabar.clients.site"
        },
        "working_hours": {
            "start_time": "07:30",
            "end_time": "20:30",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.7,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/4303558/2a0000017967796065a12355f58bdf603c28/XXXL",
            "https://avatars.mds.yandex.net/get-altay/5491685/2a0000017d434bbe75cd1d2ea221cb2e36b2/XXXL",
            "https://avatars.mds.yandex.net/get-altay/4079181/2a00000178fb33461518e4a25b0b42665f3d/XXXL"
        ],
        "location": {
            "latitude": 55.799697,
            "longitude": 37.535206,
            "address": "Ленинградский проспект, 60к1, Москва"
        }
    },
    {
        "id": "d2563319-2902-43f1-a4b2-bf9d2b230220",
        "name": "КофеИон",
        "description": "Кофейня «КофеИон» — это уютное место с тремя зонами для посиделок, где можно провести время с друзьями, поработать или просто отдохнуть в одиночестве.",
        "contacts": {
            "phone": "+7 (994) 503-06-31",
            "website": "kofeion.clients.site"
        },
        "working_hours": {
            "start_time": "09:00",
            "end_time": "19:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 5.0,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/10703420/2a0000018b5266e14b0f983309a4d18eb1cb/XXXL",
            "https://avatars.mds.yandex.net/get-altay/1132477/2a00000188155244aa1063caca59f99e0ccd/XXXL",
            "https://avatars.mds.yandex.net/get-altay/7981565/2a0000018815559dac9d2992f88a5439c5aa/XXXL"
        ],
        "location": {
            "latitude": 55.849162,
            "longitude": 37.579812,
            "address": "Нововладыкинский проезд, 1к1, Москва"
        }
    },
    {
        "id": "21df8736-0458-438b-8304-1d1be0883801",
        "name": "Coffee Bean",
        "description": "Кофейня Coffee Bean — это уютное место, где можно насладиться ароматным кофе и вкусными десертами. Гостям нравится разнообразное меню, которое включает в себя множество сортов кофе и кофейных напитков, а также эксклюзивные десерты кофейни.",
        "contacts": {
            "phone": "+7 (499) 907-67-87",
            "website": "coffeebean.ru"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "23:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 4.7,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/9237948/2a000001892ae4a14eb944b4cc959e8f4272/XXXL",
            "https://avatars.mds.yandex.net/get-altay/492546/2a0000015ed05a439f284e4b235bc3f91c0f/XXXL",
            "https://avatars.mds.yandex.net/get-altay/15439859/2a00000195419a16d0976339129b5cf71cdc/XXXL"
        ],
        "location": {
            "latitude": 55.860578,
            "longitude": 37.602898,
            "address": "Улица Хачатуряна, 16, Москва"
        }
    },
    {
        "id": "c12078d2-debf-465e-8708-3668ee455ba0",
        "name": "Латарт",
        "description": "Кофейня «Латарт» — это уютное место, где можно насладиться ароматным кофе и свежей выпечкой. Гости отмечают, что здесь подают не только напитки, но и полноценные обеды, а также рекомендуют попробовать латте с солёной карамелью.",
        "contacts": {
            "phone": "+7 (906) 775-70-93"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "19:00",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница"
            ]
        },
        "rating": 4.9,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/10267222/2a000001921dfe09d3ad4d405b1d56e7801e/XXXL",
            "https://avatars.mds.yandex.net/get-altay/13994056/2a000001946e5813242da5ff32c415583d5a/XXXL"
        ],
        "location": {
            "latitude": 55.848319,
            "longitude": 37.559476,
            "address": "3-й Нижнелихоборский проезд, 1Ас6, Москва"
        }
    },
    {
        "id": "6faa8f78-cb11-4649-8bd7-401a4faf484c",
        "name": "ЭКОХАУС",
        "contacts": {
            "phone": "+7 (965) 137-39-38",
            "website": "eko-haus-gostinichnaja-ulitsa.clients.site"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "21:30",
            "working_days": [
                "Понедельник", 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 5.0,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/9717139/2a000001891a952d520cf3c9f4baa5a64261/XXXL",
            "https://avatars.mds.yandex.net/get-altay/13786585/2a000001935f71e40ffa909a860ad4b65b15/XXXL",
            "https://avatars.mds.yandex.net/get-altay/14731058/2a000001935f71e07ae69e59e8783e87e037/XXXL"
        ],
        "location": {
            "latitude": 55.846677,
            "longitude": 37.580830,
            "address": "Гостиничная улица, 10к5, Москва"
        }
    },
    {
        "id": "e9d09ca5-ab6b-4a01-8026-220ea1198069",
        "name": "Тайна",
        "description": "Кофейня «Тайна» расположена в историческом здании, где изначально в царские времена была Марфо-Мариинская обитель, затем после революции 1917 года — женская тюрьма и тюрьма для политических заключённых. Здесь содержался под стражей Солженицын. Сейчас это музей криптографии.",
        "contacts": {
            "phone": "+7 (926) 841-71-37",
            "website": "tayna.clients.site"
        },
        "working_hours": {
            "start_time": "11:00",
            "end_time": "20:00",
            "working_days": [ 
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 5.0,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/10705374/2a0000018afb60620c623f522c9b22d9c651/XXXL",
            "https://avatars.mds.yandex.net/get-altay/15074997/2a00000196e40f25394cb56df3dfa7ceb1d1/XXXL",
            "https://avatars.mds.yandex.net/get-altay/9753788/2a0000018949f0437863e7d61ed15f7a81ac/XXXL"
        ],
        "location": {
            "latitude": 55.830714,
            "longitude": 37.598118,
            "address": "Ботаническая улица, 25с4, Москва"
        }
    },
    {
        "id": "f578355d-2b2c-4b7a-98ab-14b80d573e67",
        "name": "Kafema",
        "description": "Кофейня Kafema — это место, где вы можете попробовать различные сорта кофе и чая, а также купить их для домашнего приготовления.",
        "contacts": {
            "phone": "+7 (495) 784-08-62",
            "website": "kafema.ru"
        },
        "working_hours": {
            "start_time": "08:00",
            "end_time": "21:00",
            "working_days": [ 
                "Понедельник",
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 5.0,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/13458328/2a0000018ecd061b81058130ce50b124d186/XXXL",
            "https://avatars.mds.yandex.net/get-altay/13457355/2a0000018ecd0643e3e73280de383a4fe586/XXXL",
            "https://avatars.mds.yandex.net/get-altay/11375099/2a0000018ecd06024a5a7262a4ac9c38a89b/XXXL"
        ],
        "location": {
            "latitude": 55.813521,
            "longitude": 37.576781,
            "address": "улица Всеволода Вишневского, 2/7, Москва"
        }
    },
    {
        "id": "fcecd939-34ba-4a38-ad10-a62e3ace5b95",
        "name": "Привет",
        "description": "Кофейня «Привет» — это уютное место, где можно насладиться ароматным кофе и отдохнуть от суеты. Здесь царит непринужденная атмосфера, которая идеально подходит для короткого перерыва.",
        "contacts": {
            "phone": "+7 (916) 875-64-56"
        },
        "working_hours": {
            "start_time": "06:30",
            "end_time": "23:00",
            "working_days": [ 
                "Понедельник",
                "Вторник", 
                "Среда", 
                "Четверг", 
                "Пятница", 
                "Суббота", 
                "Воскресенье"
            ]
        },
        "rating": 5.0,
        "photos": [
            "https://avatars.mds.yandex.net/get-altay/13220782/2a00000192270108506321bb1c5ac4ee385a/XXXL",
            "https://avatars.mds.yandex.net/get-altay/10470901/2a000001914c1e8f98f3d20d5d4797f53a54/XXXL",
            "https://avatars.mds.yandex.net/get-altay/13322921/2a00000194f6a201f911560c35e06bca13f5/XXXL"
        ],
        "location": {
            "latitude": 55.809004,
            "longitude": 37.578985,
            "address": "Дмитровский проезд, 1, Москва"
        }
    }
]

HOST = '127.0.0.1'
PORT = 8080
DEBUG = True

R = 6371 # Земной радиус в километрах

app = Flask(__name__)

# Функция для вычисления расстояния между двумя координатами (Haversine formula)
def haversine(lat1, lon1, lat2, lon2):
    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)
    a = sin(dlat/2) ** 2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon/2) ** 2
    c = 2 * atan2(sqrt(a), sqrt(1-a))

    return R * c  # расстояние в километрах

@app.route('/api/coffeeshops', methods=['GET'])
def get_coffeeshops():
    # Получаем параметры запроса
    page = request.args.get('page', type=int)  # без default
    lat = request.args.get('lat', type=float)
    lon = request.args.get('lon', type=float)
    per_page = 6  # Количество элементов на страницу

    filtered_shops = coffee_shops.copy()

    # Если заданы lat и lon, сортируем по расстоянию от точки
    if lat is not None and lon is not None:
        filtered_shops.sort(key=lambda shop: haversine(lat, lon, shop['location']['latitude'], shop['location']['longitude']))

    if page is None:
        # Если page не указан, возвращаем все
        paged_shops = filtered_shops
    else:
        # Пагинация
        start = (page - 1) * per_page
        end = start + per_page
        paged_shops = filtered_shops[start:end]

    return jsonify(paged_shops)

@app.route('/api/coffeeshops/<shop_id>', methods=['GET'])
def get_coffeeshop_by_id(shop_id):
    shop = next((shop for shop in coffee_shops if shop['id'] == shop_id), None)
    if shop is None:
        abort(404, description="Кофейня не найдена")
    return jsonify(shop)

if __name__ == '__main__':
    app.run(host=HOST, port=PORT, debug=DEBUG)
