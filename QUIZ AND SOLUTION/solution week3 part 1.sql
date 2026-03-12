

/* We need to tackle a couple of questions here.
1. Is there a difference in the scores?
2. If so, are there patterns?*/

select r.location_id as audit_location , 
		r.true_water_source_score ,
		v.location_id as visit_location,
        v.record_id
        , w.subjective_quality_score
from auditor_report as r
join visits v
on r.location_id= v.location_id 
join water_quality as w 
on v.record_id= w.record_id;


-- there in a pattern in the previous querey 

-- duplicate information beetween three join taple  
select r.location_id as audit_location , 
		v.record_id
        , w.subjective_quality_score as  surveyor_score,
        r.true_water_source_score as  auditor_score,
        r.type_of_water_source 
from auditor_report as r
join visits v
on r.location_id= v.location_id 
join water_quality as w 
on v.record_id= w.record_id
-- where w.subjective_quality_score =  r.true_water_source_score 
-- (unequal to see uncorect data)--> But that means that 102 records are incorrect.
where w.subjective_quality_score !=  r.true_water_source_score 
and v.visit_count=1;

/* I think there are two reasons this can happen.
1. These workers are all humans and make mistakes so this is expected.
2. Unfortunately, the alternative is that someone assigned scores incorrectly on purpose!
*/

 with Incorrect_records as (
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
and v.visit_count=1
)

-- num of mistake for eash employee 
-- order and limit to get the top 3 employees  make an mistakes 

select employee_name,
count(employee_name) as num_of_mistake 
from Incorrect_records
group by employee_name
order by num_of_mistake desc 
limit 3;

/*select * from Incorrect_records;
-- Let's first get a unique list of employees from this table.

select count( distinct employee_name )
from Incorrect_records;*/



-- but cte is not correct way to ducument taple so we can view to store the infromation