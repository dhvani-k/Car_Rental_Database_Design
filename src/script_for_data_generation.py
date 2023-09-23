# -*- coding: utf-8 -*-

import random

from faker import Faker

fake = Faker()

fake.name().split(" ")[0]

list = fake.address().split(" ")
print(list)



print(list[0]+" "+list[1]+" "+list[2])

print("('Coblitzallee', 1, 'Mannheim', 'Germany', 68163), ")

for i in range(1000):
  l = fake.address().split(" ")
  s = (l[0]+" "+l[1]+" "+l[2])
  zip = l[-1]
  city = l[-2]
  house_no = random.randint(1,100)
  print("('"+s+"', "+str(house_no)+", '"+city+"', 'USA', "+zip+"), ")

for i in range(10):
  print("(NULL, "+str(random.randint(5,15))+", "+str(i+1)+"),")

for i in range(90):
  name = fake.name().split(" ")
  i1 = random.randint(1970,1999)
  i2 = random.randint(1,12)
  i3 = random.randint(1,12)
  print("('"+name[0]+"', '"+name[1]+"', DATE '"+str(i1)+"-"+str(i2)+"-"+str(i3)+"', "+str(random.randint(1,10))+", "+str(random.randint(10000,50000))+".00 , 0.4, "+str(i+21)+"), ")

import string
for i in range(890):
  name = fake.name().split(" ")
  i1 = random.randint(1970,1999)
  i2 = random.randint(1,12)
  i3 = random.randint(1,12)
  randomstr = ''.join(random.choices(string.ascii_letters+string.digits,k=6)).upper()
  print("('"+name[0]+"', '"+name[1]+"', DATE '"+str(i1)+"-"+str(i2)+"-"+str(i3)+"','"+randomstr+"', "+str(i+111)+"),")

cars = ['Mercedes', 'Opel', 'Audi', 'BMW', 'Chevrolet', 'Dodge', 'Tesla', 'Ford', 'Suzuki', 'Honda', 'Lexus', 'Hyundai', 'Kia', 'Jeep', 'Volkswagen', 'Bentley', 'Porsche', 'Cadillac' , 'GMC', 'Lincoln', 'Ram']
ans = ['TRUE','FALSE']
for i in range(250):
  i1 = random.randint(2000,2015)
  i2 = random.randint(1,12)
  i3 = random.randint(1,12)
  print("('"+cars[random.randint(0,20)]+"', "+str(random.randint(10000,200000))+", DATE '"+str(i1)+"-"+str(i2)+"-"+str(i3)+"', "+str(random.randint(1,3))+","+str(random.randint(1,10))+" , "+ans[(random.randint(0,1))]+" ), ")

comments = ['Good Condition', 'Good', 'Working as Expected', 'Clean', 'Dirty', 'Cleaning pending', 'Windshield broken' ,'All okay', 'Flat Tyre', 'Damaged', 'Null'];
for i in range(500):
  i1 = random.randint(2016,2022)
  i2 = random.randint(1,12)
  i3 = random.randint(1,12)
  print("( "+str(random.randint(11,110))+",  "+str(random.randint(1,250))+", '"+comments[random.randint(0,10)]+"', DATE '"+str(i1)+"-"+str(i2)+"-"+str(i3)+"'), ")

import random

for i in range(499):
  one = str(random.randint(1,250))
  two = str(random.randint(1,890))
  three = str(random.randint(11,100))
  four = str(random.randint(1,10))
  i1 = random.randint(2016,2022)
  i2 = random.randint(1,12)
  i3 = random.randint(1,12)
  five = "DATE"+ " '"+str(i1)+"-"+str(i2)+"-"+str(i3)+"'"
  six = str(random.randint(200000,250000))
  print("""
  call rent_vehicle("""+one+""", """+two+""", """+three+""", """+four+""", """+five+""");

  update RENT 
  set is_returned = true, mileage_returned = """+six+""", 
  date_returned = """+five+""" + INTERVAL '"""+four+""" day',
  staff_id_returned = """+three+"""
  where rent_id = """+str(i+2)+""";
  """)