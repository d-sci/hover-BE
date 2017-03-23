# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).


# Options for random stuff
genders = ["M","F"] 
m_names = ["Noah","Liam","Mason","Jacob","William","Ethan","James","Alexander","Michael","Benjamin","Elijah","Daniel","Aiden","Logan","Matthew","Lucas","Jackson","David","Oliver","Jayden","Joseph","Gabriel","Samuel","Carter","Anthony","John","Dylan","Luke","Henry","Andrew","Isaac","Christopher","Joshua","Wyatt","Sebastian","Owen","Caleb","Nathan","Ryan","Jack","Hunter","Levi","Christian","Jaxon","Julian","Landon","Grayson","Jonathan","Isaiah","Charles","Thomas","Aaron","Eli","Connor","Jeremiah","Cameron","Josiah","Adrian","Colton","Jordan","Brayden","Nicholas","Robert","Angel","Hudson","Lincoln","Evan","Dominic","Austin","Gavin","Nolan","Parker","Adam","Chase","Jace","Ian","Cooper","Easton","Kevin","Jose","Tyler","Brandon","Asher","Jaxson","Mateo","Jason","Ayden","Zachary","Carson","Xavier","Leo","Ezra","Bentley","Sawyer","Kayden","Blake","Nathaniel","Ryder","Theodore"]
f_names = ["Emma","Olivia","Sophia","Ava","Isabella","Mia","Abigail","Emily","Charlotte","Harper","Madison","Amelia","Elizabeth","Sofia","Evelyn","Avery","Chloe","Ella","Grace","Victoria","Aubrey","Scarlett","Zoey","Addison","Lily","Lillian","Natalie","Hannah","Aria","Layla","Brooklyn","Alexa","Zoe","Penelope","Riley","Leah","Audrey","Savannah","Allison","Samantha","Nora","Skylar","Camila","Anna","Paisley","Ariana","Ellie","Aaliyah","Claire","Violet","Stella","Sadie","Mila","Gabriella","Lucy","Arianna","Kennedy","Sarah","Madelyn","Eleanor","Kaylee","Caroline","Hazel","Hailey","Genesis","Kylie","Autumn","Piper","Maya","Nevaeh","Serenity","Peyton","Mackenzie","Bella","Eva","Taylor","Naomi","Aubree","Aurora","Melanie","Lydia","Brianna","Ruby","Katherine","Ashley","Alexis","Alice","Cora","Julia","Madeline","Faith","Annabelle","Alyssa","Isabelle","Vivian","Gianna","Quinn","Clara","Reagan"]
last_names = ["Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz"]
radio_stations_s = ["680", "1010", "1050", "88.1", "91.1", "92.5", "93.5", "94.1", "99.1", "104.5"] 
companies = ["U of T", "OSC", "PwC"]
locs = {"U of T"=>"-79.3966807 43.6632732", "OSC"=>"-79.3394846 43.7164057", "PwC"=>"-79.3826534 43.6431971"}
positions = ["CEO", "Student", "Manager", "Director", "Janitor", "Analyst", "Engineer"]
makes = ["Honda", "Toyota", "BMW", "Volvo"]
models = {"Honda"=>"Civic", "Toyota"=>"Corolla", "BMW"=>"x5", "Volvo"=>"V70"}
colours = ["Black", "White", "Silver", "Blue", "Red"]

# Make the (already activated) users
24.times do |n|
  
  password = "password"
  gender = genders.sample
  if gender == 'M'
    first_name = m_names.sample
  else
    first_name = f_names.sample
  end
  last_name = last_names.sample
  has_avatar = [true, false].sample
  phone = "416-"+Random.rand(100..999).to_s+"-"+Random.rand(1000..9999).to_s
  company = companies.sample
  position = positions.sample
  radio_stations = radio_stations_s.sample(Random.rand(5))
  talkativeness = Random.rand(10)
  smoke = [true, false].sample
  ac = [true, false].sample
  
  driving_pref = Random.rand(-1..1)
  driving_hash = {-1=>'p',0=>'b',1=>'d'}
  prefix = driving_hash[driving_pref]
  email = "#{prefix}#{n+1}@example.com"
  if driving_pref >= 0
    make = makes.sample
    model = models[make]
    car = {"make"=>make, "model"=>model, "year"=>Random.rand(2000..2017).to_s, "colour"=>colours.sample}
  else
    car = nil
  end
  
  u = User.create(
    password: password,
    password_confirmation: password,
    first_name: first_name, 
    last_name: last_name,
    has_avatar: has_avatar,
    email: email,
    phone: phone, 
    gender: gender, 
    company: company, 
    position: position,
    driving_pref: driving_pref,
    car: car,
    radio_stations: radio_stations, 
    talkativeness: talkativeness, 
    smoke: smoke, 
    ac: ac
    )
  u.create_activation_digest
  u.activate
  
  lon = (-79.5 + Random.rand(0.3)).round(6)
  lat = (43.6 + Random.rand(0.1)).round(6)
  office = locs[company]
  time1a = ["07","08"].sample + ":" + ["00","15","30","45"].sample + ":00"
  time1b = "0" + (time1a[1].to_i+1).to_s + time1a[2..-1]
  time2a = ["04","05"].sample + ":" + ["00","15","30","45"].sample + ":00"
  time2b = "0" + (time2a[1].to_i+1).to_s + time2a[2..-1]
  t1 = Trip.create(
    waypoints: "MULTIPOINT(#{lon} #{lat}, #{office})",
    waytimes: [time1a, time1b],
    to_work: true
    )
  Pool.create(user_id: u.id, trip_id: t1.id, is_active: true)
  t2 = Trip.create(
    waypoints: "MULTIPOINT(#{office}, #{lon} #{lat})",
    waytimes: [time2a, time2b],
    to_work: false
    )
  Pool.create(user_id: u.id, trip_id: t2.id, is_active: true)

end

  
# Make some extra (non-activated) users
6.times do |n|
  password = "password"
  gender = genders.sample
  if gender == 'M'
    first_name = m_names.sample
  else
    first_name = f_names.sample
  end
  last_name = last_names.sample
  email = "e#{n+1}@example.com"
  User.create(
    password: password,
    password_confirmation: password,
    first_name: first_name, 
    last_name: last_name,
    email: email
    )
end

# -------------------------------------
# OLD VERSION:
#
# d1 = User.create(
#   driving_pref: 1,
#   first_name: "Some", 
#   last_name: "Driver",
#   email: "d1@example.com",
#   password: "password",
#   password_confirmation: "password",
#   phone: "123-456-7890", 
#   gender: "M", 
#   company: "U of T", 
#   position: "TA", 
#   radio_stations: ["104.5", "98.2"], 
#   talkativeness: 4, 
#   smoke: false, 
#   ac: true, 
#   car: {"make"=>"Toyota", "model"=>"Camry", "year"=>"2015", "colour":"Silver"}
#   )

# d2 = User.create(
#   driving_pref: 1,
#   first_name: "Another", 
#   last_name: "Driver",
#   email: "d2@example.com",
#   password: "password",
#   password_confirmation: "password",
#   phone: "123-456-7890", 
#   gender: "F", 
#   company: "U of T", 
#   position: "TA", 
#   radio_stations: ["104.5", "99.1"], 
#   talkativeness: 6, 
#   smoke: true, 
#   ac: true, 
#   car: {"make"=>"Honda", "model"=>"Civic", "year"=>"2010", "colour":"Blue"}
#   )

# p1 = User.create(
#   driving_pref: -1,
#   first_name: "Some", 
#   last_name: "Passenger",
#   email: "p1@example.com", 
#   password: "password",
#   password_confirmation: "password",
#   phone: "123-456-7890", 
#   gender: "F", 
#   company: "U of T", 
#   position: "TA", 
#   radio_stations: ["99.1", "98.2"], 
#   talkativeness: 3, 
#   smoke: false, 
#   ac: false, 
#   )
  
# p2 = User.create(
#   driving_pref: -1,
#   first_name: "Another", 
#   last_name: "Passenger",
#   email: "p2@example.com",
#   password: "password",
#   password_confirmation: "password",
#   phone: "123-456-7890", 
#   gender: "F", 
#   company: "U of T", 
#   position: "TA", 
#   radio_stations: ["104.5", "98.2"], 
#   talkativeness: 7, 
#   smoke: true, 
#   ac: true, 
#   )

# b1 = User.create(
#   driving_pref: 0,
#   first_name: "Some", 
#   last_name: "Both-guy",
#   email: "b1@example.com", 
#   password: "password",
#   password_confirmation: "password",
#   phone: "123-456-7890", 
#   gender: "F", 
#   company: "U of T", 
#   position: "TA", 
#   radio_stations: ["99.1", "98.2"], 
#   talkativeness: 3, 
#   smoke: false, 
#   ac: false, 
#   )
  
# b2 = User.create(
#   driving_pref: 0,
#   first_name: "Another", 
#   last_name: "Both-guy",
#   email: "b2@example.com",
#   password: "password",
#   password_confirmation: "password",
#   phone: "123-456-7890", 
#   gender: "F", 
#   company: "U of T", 
#   position: "TA", 
#   radio_stations: ["104.5", "98.2"], 
#   talkativeness: 7, 
#   smoke: true, 
#   ac: true, 
#   )  
  

# t1 = Trip.create(
#   waypoints: "MULTIPOINT(-79.00000 44.00000 , -79.03000 45.03000 )",
#   waytimes: ["07:26:12", "07:56:12"],
#   to_work: true
#   )

# t2 = Trip.create(
#   waypoints: "MULTIPOINT(-79.01000 44.01000 , -79.03000 45.03000 )",
#   waytimes: ["22:26:12", "22:56:12"],
#   to_work: true
#   )

# t3 = Trip.create(
#   waypoints: "MULTIPOINT(-79.06000 44.06000 , -79.03000 45.03000 )",
#   waytimes: ["22:26:12", "22:56:12"],
#   to_work: true
#   )  
  
# t4 = Trip.create(
#   waypoints: "MULTIPOINT(-79.05000 44.05000 , -79.03000 45.03000 )",
#   waytimes: ["07:26:12", "07:56:12"],
#   to_work: true
#   )
  
# t5 = Trip.create(
#   waypoints: "MULTIPOINT(-79.00000 44.00000 , -79.01000 44.01000, -79.03000 45.03000 )",
#   waytimes: ["07:26:12", "07:56:12"],
#   to_work: true
#   )    


# d1.create_activation_digest
# d1.activate
# d2.create_activation_digest
# d2.activate
# p1.create_activation_digest
# p1.activate
# p2.create_activation_digest
# p2.activate
  
# Pool.create(user_id: d1.id, trip_id: t1.id, is_driver: true, is_active: false)
# Pool.create(user_id: p1.id, trip_id: t2.id, is_driver: false, is_active: false)
# Pool.create(user_id: d2.id, trip_id: t3.id, is_driver: true, is_active: true)
# Pool.create(user_id: p2.id, trip_id: t4.id, is_driver: false, is_active: true)
# Pool.create(user_id: d1.id, trip_id: t5.id, is_driver: true, is_active: true)
# Pool.create(user_id: p1.id, trip_id: t5.id, is_driver: false, is_active: true)