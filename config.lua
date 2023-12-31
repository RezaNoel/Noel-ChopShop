Config = {}

Config.Key =  38 --E

Config.ESX = 'esx:getSharedObject' --your own getSharedObject

Config.Ped = {
    location = { x = -547.42, y = -1641.23, z = 17.99, h =151.87 },
    type=4,
    model="a_m_y_business_01",
    anim="mini@strip_club@idles@bouncer@base",
    dict = "base"
}
Config.Marker = {
    type = 27,
    location={
    x = -570.25,
    y = -1639.27,
    z = 18.43},
    r=255,
    g=0,
    b=0
}

Config.Blip = {
    Car = {
    title = "Car Rob",
    sprite = 794,
    color = 50,
    scale = 1.0
    },
    Home = {
        title = "Chop Shop",
        sprite = 68,
        color = 29,
        scale = 1.0,
    },
    Steal = {
        title = "Car Steal",
        sprite = 761,
        color = 1,
        scale = 1.0,
        location = { x = 98.4, y = -796.15, z = 30.51 }
    }
    
}

Config.Missions = {
    { Name = 't20', Label = 'T20 Robbery', Price = 50000, Car = { Name = "t20", Location = { x = 19.32, y = -740.66, z = 30.41, h = 211.82 } } },
    { Name = 'neon', Label = 'Neon Robbery', Price = 20000, Car = { Name = "neon", Location = { x = 19.32, y = -740.66, z = 30.41, h = 211.82 } } },
}