from flask import Flask, request, jsonify
from math import radians, cos, sin, sqrt, atan2

HOST = '0.0.0.0'
PORT = 8080
DEBUG = True

R = 6371 # Земной радиус в километрах

app = Flask(__name__)

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
        "description": "Кофейня «Курс Кофе Графика» — это уютное место, где можно насладиться ароматным кофе, почитать книги или комиксы, а также пообщаться с друзьями или коллегами. В меню представлены различные виды кофе, а также чаи, какао, лимонады и другие напитки.",
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
]

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
    per_page = 3  # Количество элементов на страницу

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
