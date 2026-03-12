
-- So, replace WITH with CREATE VIEW like this, and note that I added the statements column to this table in line 8 too:
create view incorrect_reocrds as 
select e.employee_name
-- e.assigned_employee_id
		,r.location_id as audit_location , 
		v.record_id
        ,r.true_water_source_score as  auditor_score
         , w.subjective_quality_score as  surveyor_score
        
from auditor_report as r
join visits v
on r.location_id= v.location_id 
join water_quality as w 
on v.record_id= w.record_id
join employee e 
on v.assigned_employee_id=e.assigned_employee_id
where w.subjective_quality_score !=  r.true_water_source_score 
and v.visit_count=1;

-- -- This view calculates the number of mistakes each employee made
create view count_irror as 
select employee_name,
count(employee_name) as num_of_mistake 
from incorrect_reocrds
group by employee_name;

select  avg(num_of_mistake) as avg_error_count_per_empl
from count_irror;

/* Finaly we have to compare each employee's error_count with avg_error_count_per_empl. We will call this results set our suspect_list.
Remember that we can't use an aggregate result in WHERE, so we have to use avg_error_count_per_empl as a subquery.*/
select employee_name ,
		num_of_mistake
from count_irror 
where num_of_mistake > (select avg(num_of_mistake ) 
							from count_irror);


-- 
select employee_name , 
 num_of_mistake
from count_irror
having num_of_mistake> ( select avg(num_of_mistake ) 
							from count_irror);