drop table if exists public.cardata cascade;

drop table if exists public.seller_info  cascade; 

create table seller_info(
sp_id integer primary key,
sp_name text,
seller_rating real,
franchise_make text,
franchise_dealer bool,
dealer_zip integer,
city text);

insert into seller_info (sp_id, sp_name, seller_rating, franchise_make, franchise_dealer, dealer_zip, city)
select sp_id, max(sp_name), avg(seller_rating), max(franchise_make), bool_or(franchise_dealer), max(dealer_zip), max(city)
from cardata
where sp_id is not null
group by sp_id;


drop table if exists public.vehicle_info cascade;

create table vehicle_info(
vin text primary key,
back_legroom real,
body_type text,
cabin text,
engine_cylinders text,
engine_displacement integer,
engine_type text,
exterior_color text,
fleet bool,
frame_damaged bool,
front_legroom real,
fuel_tank_volume real,
fuel_type text,
has_accidents bool,
height real,
horsepower integer,
interior_color text,
is_cpo bool,
is_new bool,
is_oemcpo bool,
length real,
major_options text,
make_name text,
maximum_seating integer,
mileage integer,
model_name text,
owner_count integer,
salvage bool,
theft_title bool,
transmission text,
transmission_display text,
trim_id text,
trim_name text,
wheel_system text,
wheel_system_display text,
wheelbase real,
width real,
year integer,
power_hp integer,
power_rpm integer,
torque_lbft integer,
torque_rpm integer
);

insert into vehicle_info (vin, back_legroom, 
body_type, cabin, engine_cylinders, 
engine_displacement, engine_type, 
exterior_color, fleet, frame_damaged, front_legroom, 
fuel_tank_volume, fuel_type, has_accidents, height, 
horsepower,interior_color, is_cpo, is_new, is_oemcpo,
length, major_options, make_name, maximum_seating, 
mileage, model_name, owner_count, salvage, 
theft_title, transmission, 
transmission_display, trim_id, trim_name, 
wheel_system, wheel_system_display, wheelbase, width,
year, power_hp, power_rpm, torque_lbft, torque_rpm)
select c.vin, max(c.back_legroom ), max(c.body_type), 
max(c.cabin), max(c.engine_cylinders), 
max(c.engine_displacement), max(c.engine_type), 
max(c.exterior_color), bool_or(c.fleet), 
bool_or(c.frame_damaged), max(c.front_legroom), 
max(c.fuel_tank_volume), max(c.fuel_type), 
bool_or(c.has_accidents), max(c.height), max(c.horsepower),
max(c.interior_color), bool_or(c.is_cpo), bool_or(c.is_new), 
bool_or(c.is_oemcpo), max(c.length), max(c.major_options), 
max(c.make_name), max(c.maximum_seating), max(c.mileage), 
max(c.model_name), max(c.owner_count), bool_or(c.salvage), 
bool_or(c.theft_title), max(c.transmission), max(c.transmission_display), 
max(c."trimId"), max(c.trim_name), max(c.wheel_system), 
max(c.wheel_system_display), max(c.wheelbase), max(c.width), 
max(c.year), max(c.power_hp), max(c.power_rpm), 
max(c.torque_lbft), max(c.torque_rpm)
from cardata c
where c.vin is not null
group by c.vin;



drop table if exists public.facts_table cascade;

create table facts_table(
listing_id integer primary key,
vin text references vehicle_info(vin),
sp_id integer references seller_info(sp_id),
listed_date date,
listing_color text,
mileage integer,
owner_count integer,
salvage bool,
savings_amount integer,
theft_title bool,
daysonmarket integer
);

select vin, count(*)
from cardata
group by cardata.vin 
having count(*)>1
order by count(*) desc;

drop table if exists public.sale_info cascade;

create table sale_info(
listing_id integer primary key,
vin text references vehicle_info(vin),
sp_id integer references seller_info(sp_id),
daysonmarket integer,
listed_date date,
listing_color text,
savings_amount integer,
power text,
torque text,
price_nom integer);

insert into sale_info (listing_id, vin, sp_id, daysonmarket, listed_date, 
listing_color, savings_amount, power, torque, price_nom)
select c.listing_id , c.vin, c.sp_id , c.daysonmarket , c.listed_date,
c.listing_color, c.savings_amount, c.power, c.torque, c.price_nom 
from cardata c 