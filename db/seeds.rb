# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

d1 = Driver.create(
  first_name: "Some", 
  last_name: "Driver",
  email: "d1@example.com", 
  phone: "123-456-7890", 
  gender: "M", 
  company: "U of T", 
  position: "TA", 
  office_lat: 43.6500324, 
  office_lon: -79.391594, 
  home_lat: 43.8500324, 
  home_lon: -79.691594, 
  radio_stations: ["104.5", "98.2"], 
  talkativeness: 4, 
  smoke: false, 
  ac: true, 
  times: {"to_work"=>9, "to_home"=>17} 
  )

d2 = Driver.create(
  first_name: "Another", 
  last_name: "Driver",
  email: "d2@example.com", 
  phone: "123-456-7890", 
  gender: "F", 
  company: "U of T", 
  position: "TA", 
  office_lat: 43.6500324, 
  office_lon: -79.391594, 
  home_lat: 43.1500324, 
  home_lon: -79.191594, 
  radio_stations: ["104.5", "99.1"], 
  talkativeness: 7, 
  smoke: true, 
  ac: true, 
  times: {"to_work"=>9, "to_home"=>17}  
  )

p1 = Passenger.create(
  first_name: "Some", 
  last_name: "Passenger",
  email: "p1@example.com", 
  phone: "123-456-7890", 
  gender: "F", 
  company: "U of T", 
  position: "TA", 
  office_lat: 43.6500324, 
  office_lon: -79.391594, 
  home_lat: 44.1500324, 
  home_lon: -80.191594, 
  radio_stations: ["99.1", "98.2"], 
  talkativeness: 3, 
  smoke: false, 
  ac: false, 
  times: {"to_work"=>10, "to_home"=>18} 
  )
  
p2 = Passenger.create(
  first_name: "Another", 
  last_name: "Passenger",
  email: "p1@example.com", 
  phone: "123-456-7890", 
  gender: "F", 
  company: "U of T", 
  position: "TA", 
  office_lat: 43.6500324, 
  office_lon: -79.391594, 
  home_lat: 43.1500324, 
  home_lon: -79.191594, 
  radio_stations: ["104.5", "98.2"], 
  talkativeness: 7, 
  smoke: true, 
  ac: true, 
  times: {"to_work"=>10, "to_home"=>18} 
  )
  
  
Trip.create(driver_id: d1.id, passenger_id: p1.id)
Trip.create(driver_id: d2.id, passenger_id: p2.id)
