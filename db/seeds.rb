# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).


d1 = User.create(
  driving_pref: 1,
  first_name: "Some", 
  last_name: "Driver",
  email: "d1@example.com",
  password: "password",
  password_confirmation: "password",
  phone: "123-456-7890", 
  gender: "M", 
  company: "U of T", 
  position: "TA", 
  radio_stations: ["104.5", "98.2"], 
  talkativeness: 4, 
  smoke: false, 
  ac: true, 
  car: {"make"=>"Toyota", "model"=>"Camry", "year"=>"2015", "colour":"Silver"}
  )

d2 = User.create(
  driving_pref: 1,
  first_name: "Another", 
  last_name: "Driver",
  email: "d2@example.com",
  password: "password",
  password_confirmation: "password",
  phone: "123-456-7890", 
  gender: "F", 
  company: "U of T", 
  position: "TA", 
  radio_stations: ["104.5", "99.1"], 
  talkativeness: 6, 
  smoke: true, 
  ac: true, 
  car: {"make"=>"Honda", "model"=>"Civic", "year"=>"2010", "colour":"Blue"}
  )

p1 = User.create(
  driving_pref: -1,
  first_name: "Some", 
  last_name: "Passenger",
  email: "p1@example.com", 
  password: "password",
  password_confirmation: "password",
  phone: "123-456-7890", 
  gender: "F", 
  company: "U of T", 
  position: "TA", 
  radio_stations: ["99.1", "98.2"], 
  talkativeness: 3, 
  smoke: false, 
  ac: false, 
  )
  
p2 = User.create(
  driving_pref: -1,
  first_name: "Another", 
  last_name: "Passenger",
  email: "p2@example.com",
  password: "password",
  password_confirmation: "password",
  phone: "123-456-7890", 
  gender: "F", 
  company: "U of T", 
  position: "TA", 
  radio_stations: ["104.5", "98.2"], 
  talkativeness: 7, 
  smoke: true, 
  ac: true, 
  )

b1 = User.create(
  driving_pref: 0,
  first_name: "Some", 
  last_name: "Both-guy",
  email: "b1@example.com", 
  password: "password",
  password_confirmation: "password",
  phone: "123-456-7890", 
  gender: "F", 
  company: "U of T", 
  position: "TA", 
  radio_stations: ["99.1", "98.2"], 
  talkativeness: 3, 
  smoke: false, 
  ac: false, 
  )
  
b2 = User.create(
  driving_pref: 0,
  first_name: "Another", 
  last_name: "Both-guy",
  email: "b2@example.com",
  password: "password",
  password_confirmation: "password",
  phone: "123-456-7890", 
  gender: "F", 
  company: "U of T", 
  position: "TA", 
  radio_stations: ["104.5", "98.2"], 
  talkativeness: 7, 
  smoke: true, 
  ac: true, 
  )  
  

t1 = Trip.create(
  waypoints: "MULTIPOINT(-79.00000 44.00000 , -79.03000 45.03000 )",
  waytimes: ["07:26:12", "07:56:12"],
  to_work: true
  )

t2 = Trip.create(
  waypoints: "MULTIPOINT(-79.01000 44.01000 , -79.03000 45.03000 )",
  waytimes: ["22:26:12", "22:56:12"],
  to_work: true
  )

t3 = Trip.create(
  waypoints: "MULTIPOINT(-79.06000 44.06000 , -79.03000 45.03000 )",
  waytimes: ["22:26:12", "22:56:12"],
  to_work: true
  )  
  
t4 = Trip.create(
  waypoints: "MULTIPOINT(-79.05000 44.05000 , -79.03000 45.03000 )",
  waytimes: ["07:26:12", "07:56:12"],
  to_work: true
  )
  
t5 = Trip.create(
  waypoints: "MULTIPOINT(-79.00000 44.00000 , -79.01000 44.01000, -79.03000 45.03000 )",
  waytimes: ["07:26:12", "07:56:12"],
  to_work: true
  )    


d1.create_activation_digest
d1.activate
d2.create_activation_digest
d2.activate
p1.create_activation_digest
p1.activate
p2.create_activation_digest
p2.activate
  
Pool.create(user_id: d1.id, trip_id: t1.id, is_driver: true, is_active: false)
Pool.create(user_id: p1.id, trip_id: t2.id, is_driver: false, is_active: false)
Pool.create(user_id: d2.id, trip_id: t3.id, is_driver: true, is_active: true)
Pool.create(user_id: p2.id, trip_id: t4.id, is_driver: false, is_active: true)
Pool.create(user_id: d1.id, trip_id: t5.id, is_driver: true, is_active: true)
Pool.create(user_id: p1.id, trip_id: t5.id, is_driver: false, is_active: true)