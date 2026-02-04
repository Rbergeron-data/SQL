select vi.make_name , 
( count(*) filter( where si.price_nom = 1) * 1.0 / count(*) ) as price_high_ratio
from sale_info si 
join vehicle_info vi on si.vin = vi.vin
group by vi.make_name
order by price_high_ratio desc;

select count(*) 
from vehicle_info vi 
where vi.make_name = 'Rolls-Royce';

select count(*) 
from vehicle_info vi 
where vi.make_name = 'Porsche';

select count(*) 
from vehicle_info vi 
where vi.make_name = 'Jaguar';

select vi.model_name, 
( count(*) filter( where si.price_nom = 1) * 1.0 / count(*) ) as ratio
from vehicle_info vi 
join sale_info si on vi.vin = si.vin
where vi.make_name = 'Jaguar'
group by vi.model_name
order by ratio desc

select count(*) 
from vehicle_info vi 
where vi.make_name = 'Alfa Romeo';

select count(*) 
from vehicle_info vi 
where vi.make_name = 'Cadillac';

select vi.model_name, 
( count(*) filter( where si.price_nom = 1) * 1.0 / count(*) ) as ratio
from vehicle_info vi 
join sale_info si on vi.vin = si.vin
where vi.make_name = 'Cadillac'
group by vi.model_name
order by ratio desc;

select count(*) filter( where vi.model_name = 'XT6')
from vehicle_info vi;

select count(*) filter( where vi.make_name = 'RAM')
from vehicle_info vi

select vi.model_name,
count(*) filter( where si.price_nom = 1) * 1.0 / count(*) as ratio
from vehicle_info vi 
join sale_info si on vi.vin=si.vin 
where vi.make_name = 'RAM'
group by vi.model_name
order by ratio desc;

select count(*) filter( where vi.model_name = '3500 Chassis')
from vehicle_info vi;

select count(*) filter( where vi.model_name = '3500')
from vehicle_info vi;

select count(*) filter( where vi.model_name = '2500')
from vehicle_info vi;

drop table if exists analysis.ratios_by_model cascade;

create schema  if not exists analysis;

create table analysis.ratios_by_model as
with model_stats as (
select vi.make_name, vi.model_name, 
count(*) filter( where si.price_nom = 1) as occurences_high,
count(*) filter( where si.price_nom = 1) * 1.0 / count(*) as ratio_high,
count(*) as total_count
from vehicle_info vi 
join sale_info si on vi.vin=si.vin
group by vi.make_name, vi.model_name
order by ratio_high desc
)
select make_name, model_name, occurences_high, ratio_high, total_count
from model_stats
order by ratio_high desc;

select rbm.make_name, rbm.model_name, rbm.total_count, rbm.ratio_high 
from analysis.ratios_by_model rbm 
where rbm.ratio_high > 0.5 and rbm.total_count > 30
order by rbm.ratio_high desc;

select vi.make_name , vi.model_name, 
round(AVG(vi.mileage), 0) as avg_mileage, 
round(min(vi.mileage), 0)  as min_mileage,
round(max(vi.mileage), 0) as max_mileage,
si.price_nom
from vehicle_info vi 
join sale_info si on vi.vin =si.vin
join analysis.ratios_by_model rbm  on vi.model_name =rbm.model_name 
where( rbm.model_name in(
'Expedition',
'2500',
'Gladiator',
'Tahoe',
'XC90',
'Sierro 1500');


)
group by vi.make_name, vi.model_name, si.price_nom 
;

