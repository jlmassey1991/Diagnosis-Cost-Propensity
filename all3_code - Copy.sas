


****************************************

    Diagnostic Delays and Cost
    Author: Jason Massey (JM)
    Last Edited: 10/24/2024

***************************************;


*Read in Data;
libname all3 "C:\Users\qne4\CDC\NCEZID-MDB - Data Science and Informatics (DSI)\Data Science\people\Massey-Jason\Personal Projects\Diagnostic Delays";
run;

data all3;
set all3.all3 ;
run;




*********************
*   Main Variables  *
********************;

* EXPOSURE: any_compatiable symptom (y/n) if N or =0 then delay time = 0 


* EXPOSURE TIME: delay_time = first_diagnosis_date - any_compatible_date  ;


* OUTCOME: Cost = sum(op_before_cost , hosp_before_cost, 
                        op_after_cost, hosp_after_cost,  
                     antibiotics_cost, antifungals_cost);


* Potential patterns (CONFOUNDERS / STRATIFIERS): 
     Sex, Age, Urbanicity, Region, State, Insurance Type, Antifungal Treatment, Mycosis Type 






************************
*   Descriptive Stats  *
***********************;



*Creating Variables;




data delay;
set all3;

*Create Outcome Cost Variable; 
if op_before_cost = . then cost1 = 0 ; else cost1 = op_before_cost;
if hosp_before_cost = . then cost2 = 0; else cost2 = hosp_before_cost;
if antibiotics_cost = . then cost3 = 0; else cost3 = antibiotics_cost;
if op_after_cost = . then cost4 = 0; else cost4 = op_after_cost;
if hosp_after_cost = . then cost5 = 0; else cost5 = hosp_after_cost;
if antifungals_cost = . then cost6 = 0; else cost6 = antifungals_cost;

*Extract Year and Month from Diagnosis Date;

year = year(FIRST_ENDEMICS_DATE);
month = month(FIRST_ENDEMICS_DATE);

run;



data delay2;
set delay;
*Create Exposure Time Varible;
delay_time = FIRST_ENDEMICS_DATE - ANY_COMPATIBLE_DATE ;

*Create fungal disease type variable;
if blasto = 1 then disease_type = "blasto";
else if cocci = 1 then disease_type = "cocci";
else if histo = 1 then disease_type = "histo";
else disease_type = . ;

*Adjust for Inflation Costs Before Diagnosis;
if year = 2017 and month = 1 then inf_before = (556.811/471.484 + 556.811/470.539 + 556.811/469.914 + 556.811/469.749)/4;
if year = 2017 and month = 2 then inf_before = (556.811/473.139	+ 556.811/471.484 + 556.811/470.539 + 556.811/469.914)/4;
if year = 2017 and month = 3 then inf_before = (556.811/473.685	+ 556.811/473.139 + 556.811/471.484 + 556.811/470.539)/4;
if year = 2017 and month = 4 then inf_before = (556.811/473.007 + 556.811/473.685 + 556.811/473.139 + 556.811/471.484)/4;
if year = 2017 and month = 5 then inf_before = (556.811/472.981	+ 556.811/473.007 + 556.811/473.685 + 556.811/473.139)/4;
if year = 2017 and month = 6 then inf_before = (556.811/474.492 + 556.811/472.981 + 556.811/473.007 + 556.811/473.685)/4;
if year = 2017 and month = 7 then inf_before = (556.811/476.279 + 556.811/474.492 + 556.811/472.981 + 556.811/473.007)/4;
if year = 2017 and month = 8 then inf_before = (556.811/477.199 + 556.811/476.279 + 556.811/474.492 + 556.811/472.981)/4;
if year = 2017 and month = 9 then inf_before = (556.811/477.190 + 556.811/477.199 + 556.811/476.279 + 556.811/474.492)/4;
if year = 2017 and month = 10 then inf_before = (556.811/477.671 + 556.811/477.190 + 556.811/477.199 + 556.811/476.279)/4;
if year = 2017 and month = 11 then inf_before = (556.811/477.791 + 556.811/477.671 + 556.811/477.190 + 556.811/477.199)/4;
if year = 2017 and month = 12 then inf_before = (556.811/478.891 + 556.811/477.791 + 556.811/477.671 + 556.811/477.190)/4;

if year = 2018 and month = 1 then inf_before = (556.811/480.797 + 556.811/478.891 + 556.811/477.791 + 556.811/477.671)/4;
if year = 2018 and month = 2 then inf_before = (556.811/481.600 + 556.811/480.797 + 556.811/478.891 + 556.811/477.791)/4;
if year = 2018 and month = 3 then inf_before = (556.811/483.078 + 556.811/481.600 + 556.811/480.797 + 556.811/478.891)/4;
if year = 2018 and month = 4 then inf_before = (556.811/483.577 + 556.811/483.078 + 556.811/481.600 + 556.811/480.797)/4;
if year = 2018 and month = 5 then inf_before = (556.811/484.543 + 556.811/483.577 + 556.811/483.078 + 556.811/481.600)/4;
if year = 2018 and month = 6 then inf_before = (556.811/486.209 + 556.811/484.543 + 556.811/483.577 + 556.811/483.078)/4;
if year = 2018 and month = 7 then inf_before = (556.811/485.246 + 556.811/486.209 + 556.811/484.543 + 556.811/483.577)/4;
if year = 2018 and month = 8 then inf_before = (556.811/484.273 + 556.811/485.246 + 556.811/486.209 + 556.811/484.543)/4;
if year = 2018 and month = 9 then inf_before = (556.811/485.039 + 556.811/484.273 + 556.811/485.246 + 556.811/486.209)/4;
if year = 2018 and month = 10 then inf_before = (556.811/485.652 + 556.811/485.039 + 556.811/484.273 + 556.811/485.246)/4;
if year = 2018 and month = 11 then inf_before = (556.811/487.615 + 556.811/485.652 + 556.811/485.039 + 556.811/484.273)/4;
if year = 2018 and month = 12 then inf_before = (556.811/488.820 + 556.811/487.615 + 556.811/485.652 + 556.811/485.039)/4;
 
if year = 2019 and month = 1 then inf_before = (556.811/489.968 + 556.811/488.820 + 556.811/487.615 + 556.811/485.652)/4;
if year = 2019 and month = 2 then inf_before = (556.811/490.160 + 556.811/489.968 + 556.811/488.820 + 556.811/487.615)/4;
if year = 2019 and month = 3 then inf_before = (556.811/491.412 + 556.811/490.160 + 556.811/489.968 + 556.811/488.820)/4;
if year = 2019 and month = 4 then inf_before = (556.811/492.970 + 556.811/491.412 + 556.811/490.160 + 556.811/489.968)/4;
if year = 2019 and month = 5 then inf_before = (556.811/494.859 + 556.811/492.970 + 556.811/491.412 + 556.811/490.160)/4;
if year = 2019 and month = 6 then inf_before = (556.811/495.745 + 556.811/494.859 + 556.811/492.970 + 556.811/491.412)/4;
if year = 2019 and month = 7 then inf_before = (556.811/497.714 + 556.811/495.745 + 556.811/494.859 + 556.811/492.970)/4;
if year = 2019 and month = 8 then inf_before = (556.811/500.662 + 556.811/497.714 + 556.811/495.745 + 556.811/494.859)/4;
if year = 2019 and month = 9 then inf_before = (556.811/501.710 + 556.811/500.662 + 556.811/497.714 + 556.811/495.745)/4;
if year = 2019 and month = 10 then inf_before = (556.811/506.433 + 556.811/501.710 + 556.811/500.662 + 556.811/497.714)/4;
if year = 2019 and month = 11 then inf_before = (556.811/508.315 + 556.811/506.433 + 556.811/501.710 + 556.811/500.662)/4;
if year = 2019 and month = 12 then inf_before = (556.811/510.875 + 556.811/508.315 + 556.811/506.433 + 556.811/501.710)/4;
 
if year = 2020 and month = 1 then inf_before = (556.811/511.865 + 556.811/510.875 + 556.811/508.315 + 556.811/506.433)/4;
if year = 2020 and month = 2 then inf_before = (556.811/513.013 + 556.811/511.865 + 556.811/510.875 + 556.811/508.315)/4;
if year = 2020 and month = 3 then inf_before = (556.811/514.725 + 556.811/513.013 + 556.811/511.865 + 556.811/510.875)/4;
if year = 2020 and month = 4 then inf_before = (556.811/516.814 + 556.811/514.725 + 556.811/513.013 + 556.811/511.865)/4;
if year = 2020 and month = 5 then inf_before = (556.811/519.225 + 556.811/516.814 + 556.811/514.725 + 556.811/513.013)/4;
if year = 2020 and month = 6 then inf_before = (556.811/520.957 + 556.811/519.225 + 556.811/516.814 + 556.811/514.725)/4;
if year = 2020 and month = 7 then inf_before = (556.811/522.722 + 556.811/520.957 + 556.811/519.225 + 556.811/516.814)/4;
if year = 2020 and month = 8 then inf_before = (556.811/522.860 + 556.811/522.722 + 556.811/520.957 + 556.811/519.225)/4;
if year = 2020 and month = 9 then inf_before = (556.811/522.666 + 556.811/522.860 + 556.811/522.722 + 556.811/520.957)/4;
if year = 2020 and month = 10 then inf_before = (556.811/520.900 + 556.811/522.666 + 556.811/522.860 + 556.811/522.722)/4;
if year = 2020 and month = 11 then inf_before = (556.811/520.565 + 556.811/520.900 + 556.811/522.666 + 556.811/522.860)/4;
if year = 2020 and month = 12 then inf_before = (556.811/519.907 + 556.811/520.565 + 556.811/520.900 + 556.811/522.666)/4;
 
if year = 2021 and month = 1 then inf_before = (556.811/521.792 + 556.811/519.907 + 556.811/520.565 + 556.811/520.900)/4;
if year = 2021 and month = 2 then inf_before = (556.811/523.471 + 556.811/521.792 + 556.811/519.907 + 556.811/520.565)/4;
if year = 2021 and month = 3 then inf_before = (556.811/523.979 + 556.811/523.471 + 556.811/521.792 + 556.811/519.907)/4;
if year = 2021 and month = 4 then inf_before = (556.811/524.529 + 556.811/523.979 + 556.811/523.471 + 556.811/521.792)/4;
if year = 2021 and month = 5 then inf_before = (556.811/524.088 + 556.811/524.529 + 556.811/523.979 + 556.811/523.471)/4;
if year = 2021 and month = 6 then inf_before = (556.811/523.256 + 556.811/524.088 + 556.811/524.529 + 556.811/523.979)/4;
if year = 2021 and month = 7 then inf_before = (556.811/524.304 + 556.811/523.256 + 556.811/524.088 + 556.811/524.529)/4;
if year = 2021 and month = 8 then inf_before = (556.811/524.761 + 556.811/524.304 + 556.811/523.256 + 556.811/524.088)/4;
if year = 2021 and month = 9 then inf_before = (556.811/524.764 + 556.811/524.761 + 556.811/524.304 + 556.811/523.256)/4;
if year = 2021 and month = 10 then inf_before = (556.811/527.597 + 556.811/524.764 + 556.811/524.761 + 556.811/524.304)/4;
if year = 2021 and month = 11 then inf_before = (556.811/529.512 + 556.811/527.597 + 556.811/524.764 + 556.811/524.761)/4;
if year = 2021 and month = 12 then inf_before = (556.811/531.053 + 556.811/529.512 + 556.811/527.597 + 556.811/524.764)/4;
 
if year = 2022 and month = 1 then inf_before = (556.811/534.704 + 556.811/531.053 + 556.811/529.512 + 556.811/527.597)/4;
if year = 2022 and month = 2 then inf_before = (556.811/536.293 + 556.811/534.704 + 556.811/531.053 + 556.811/529.512)/4;
if year = 2022 and month = 3 then inf_before = (556.811/539.079 + 556.811/536.293 + 556.811/534.704 + 556.811/531.053)/4;
if year = 2022 and month = 4 then inf_before = (556.811/541.633 + 556.811/539.079 + 556.811/536.293 + 556.811/534.704)/4;
if year = 2022 and month = 5 then inf_before = (556.811/543.814 + 556.811/541.633 + 556.811/539.079 + 556.811/536.293)/4;
if year = 2022 and month = 6 then inf_before = (556.811/547.043 + 556.811/543.814 + 556.811/541.633 + 556.811/539.079)/4;
if year = 2022 and month = 7 then inf_before = (556.811/549.741 + 556.811/547.043 + 556.811/543.814 + 556.811/541.633)/4;




*Adjust for Inflation Costs After Diagnosis;
if year = 2017 and month = 1 then inf_after = (556.811/471.484 + 556.811/473.139 + 556.811/473.685 + 556.811/473.007 + 556.811/472.981 + 556.811/474.492 + 556.811/476.279 + 556.811/477.199 + 556.811/477.190 + 556.811/477.671 + 556.811/477.791 + 556.811/478.891 + 556.811/480.797)/13;
if year = 2017 and month = 2 then inf_after = (556.811/473.139 + 556.811/473.685 + 556.811/473.007 + 556.811/472.981 + 556.811/474.492 + 556.811/476.279 + 556.811/477.199 + 556.811/477.190 + 556.811/477.671 + 556.811/477.791 + 556.811/478.891 + 556.811/480.797 + 556.811/481.600)/13;
if year = 2017 and month = 3 then inf_after = (556.811/473.685 + 556.811/473.007 + 556.811/472.981 + 556.811/474.492 + 556.811/476.279 + 556.811/477.199 + 556.811/477.190 + 556.811/477.671 + 556.811/477.791 + 556.811/478.891 + 556.811/480.797 + 556.811/481.600 + 556.811/483.078)/13;
if year = 2017 and month = 4 then inf_after = (556.811/473.007 + 556.811/472.981 + 556.811/474.492 + 556.811/476.279 + 556.811/477.199 + 556.811/477.190 + 556.811/477.671 + 556.811/477.791 + 556.811/478.891 + 556.811/480.797 + 556.811/481.600 + 556.811/483.078 + 556.811/483.577)/13;
if year = 2017 and month = 5 then inf_after = (556.811/472.981 + 556.811/474.492 + 556.811/476.279 + 556.811/477.199 + 556.811/477.190 + 556.811/477.671 + 556.811/477.791 + 556.811/478.891 + 556.811/480.797 + 556.811/481.600 + 556.811/483.078 + 556.811/483.577 + 556.811/484.543)/13;
if year = 2017 and month = 6 then inf_after = (556.811/474.492 + 556.811/476.279 + 556.811/477.199 + 556.811/477.190 + 556.811/477.671 + 556.811/477.791 + 556.811/478.891 + 556.811/480.797 + 556.811/481.600 + 556.811/483.078 + 556.811/483.577 + 556.811/484.543 + 556.811/486.209)/13;
if year = 2017 and month = 7 then inf_after = (556.811/476.279 + 556.811/477.199 + 556.811/477.190 + 556.811/477.671 + 556.811/477.791 + 556.811/478.891 + 556.811/480.797 + 556.811/481.600 + 556.811/483.078 + 556.811/483.577 + 556.811/484.543 + 556.811/486.209 + 556.811/485.246)/13;
if year = 2017 and month = 8 then inf_after = (556.811/477.199 + 556.811/477.190 + 556.811/477.671 + 556.811/477.791 + 556.811/478.891 + 556.811/480.797 + 556.811/481.600 + 556.811/483.078 + 556.811/483.577 + 556.811/484.543 + 556.811/486.209 + 556.811/485.246 + 556.811/484.273)/13;
if year = 2017 and month = 9 then inf_after = (556.811/477.190 + 556.811/477.671 + 556.811/477.791 + 556.811/478.891 + 556.811/480.797 + 556.811/481.600 + 556.811/483.078 + 556.811/483.577 + 556.811/484.543 + 556.811/486.209 + 556.811/485.246 + 556.811/484.273 + 556.811/485.039)/13;
if year = 2017 and month = 10 then inf_after = (556.811/477.671 + 556.811/477.791 + 556.811/478.891 + 556.811/480.797 + 556.811/481.600 + 556.811/483.078 + 556.811/483.577 + 556.811/484.543 + 556.811/486.209 + 556.811/485.246 + 556.811/484.273 + 556.811/485.039 + 556.811/485.652)/13;
if year = 2017 and month = 11 then inf_after = (556.811/477.791 + 556.811/478.891 + 556.811/480.797 + 556.811/481.600 + 556.811/483.078 + 556.811/483.577 + 556.811/484.543 + 556.811/486.209 + 556.811/485.246 + 556.811/484.273 + 556.811/485.039 + 556.811/485.652 + 556.811/487.615)/13;
if year = 2017 and month = 12 then inf_after = (556.811/478.891 + 556.811/480.797 + 556.811/481.600 + 556.811/483.078 + 556.811/483.577 + 556.811/484.543 + 556.811/486.209 + 556.811/485.246 + 556.811/484.273 + 556.811/485.039 + 556.811/485.652 + 556.811/487.615 + 556.811/488.820)/13;

if year = 2018 and month = 1 then inf_after = (556.811/480.797 + 556.811/481.600 + 556.811/483.078 + 556.811/483.577 + 556.811/484.543 + 556.811/486.209 + 556.811/485.246 + 556.811/484.273 + 556.811/485.039 + 556.811/485.652 + 556.811/487.615 + 556.811/488.820 + 556.811/489.968)/13;
if year = 2018 and month = 2 then inf_after = (556.811/481.600 + 556.811/483.078 + 556.811/483.577 + 556.811/484.543 + 556.811/486.209 + 556.811/485.246 + 556.811/484.273 + 556.811/485.039 + 556.811/485.652 + 556.811/487.615 + 556.811/488.820 + 556.811/489.968 + 556.811/490.160)/13;
if year = 2018 and month = 3 then inf_after = (556.811/483.078 + 556.811/483.577 + 556.811/484.543 + 556.811/486.209 + 556.811/485.246 + 556.811/484.273 + 556.811/485.039 + 556.811/485.652 + 556.811/487.615 + 556.811/488.820 + 556.811/489.968 + 556.811/490.160 + 556.811/491.412)/13;
if year = 2018 and month = 4 then inf_after = (556.811/483.577 + 556.811/484.543 + 556.811/486.209 + 556.811/485.246 + 556.811/484.273 + 556.811/485.039 + 556.811/485.652 + 556.811/487.615 + 556.811/488.820 + 556.811/489.968 + 556.811/490.160 + 556.811/491.412 + 556.811/492.970)/13;
if year = 2018 and month = 5 then inf_after = (556.811/484.543 + 556.811/486.209 + 556.811/485.246 + 556.811/484.273 + 556.811/485.039 + 556.811/485.652 + 556.811/487.615 + 556.811/488.820 + 556.811/489.968 + 556.811/490.160 + 556.811/491.412 + 556.811/492.970 + 556.811/494.859)/13;
if year = 2018 and month = 6 then inf_after = (556.811/486.209 + 556.811/485.246 + 556.811/484.273 + 556.811/485.039 + 556.811/485.652 + 556.811/487.615 + 556.811/488.820 + 556.811/489.968 + 556.811/490.160 + 556.811/491.412 + 556.811/492.970 + 556.811/494.859 + 556.811/495.745)/13;
if year = 2018 and month = 7 then inf_after = (556.811/485.246 + 556.811/484.273 + 556.811/485.039 + 556.811/485.652 + 556.811/487.615 + 556.811/488.820 + 556.811/489.968 + 556.811/490.160 + 556.811/491.412 + 556.811/492.970 + 556.811/494.859 + 556.811/495.745 + 556.811/497.714)/13;
if year = 2018 and month = 8 then inf_after = (556.811/484.273 + 556.811/485.039 + 556.811/485.652 + 556.811/487.615 + 556.811/488.820 + 556.811/489.968 + 556.811/490.160 + 556.811/491.412 + 556.811/492.970 + 556.811/494.859 + 556.811/495.745 + 556.811/497.714 + 556.811/500.662)/13;
if year = 2018 and month = 9 then inf_after = (556.811/485.039 + 556.811/485.652 + 556.811/487.615 + 556.811/488.820 + 556.811/489.968 + 556.811/490.160 + 556.811/491.412 + 556.811/492.970 + 556.811/494.859 + 556.811/495.745 + 556.811/497.714 + 556.811/500.662 + 556.811/501.710)/13;
if year = 2018 and month = 10 then inf_after = (556.811/485.652 + 556.811/487.615 + 556.811/488.820 + 556.811/489.968 + 556.811/490.160 + 556.811/491.412 + 556.811/492.970 + 556.811/494.859 + 556.811/495.745 + 556.811/497.714 + 556.811/500.662 + 556.811/501.710 + 556.811/506.433)/13;
if year = 2018 and month = 11 then inf_after = (556.811/487.615 + 556.811/488.820 + 556.811/489.968 + 556.811/490.160 + 556.811/491.412 + 556.811/492.970 + 556.811/494.859 + 556.811/495.745 + 556.811/497.714 + 556.811/500.662 + 556.811/501.710 + 556.811/506.433 + 556.811/508.315)/13;
if year = 2018 and month = 12 then inf_after = (556.811/488.820 + 556.811/489.968 + 556.811/490.160 + 556.811/491.412 + 556.811/492.970 + 556.811/494.859 + 556.811/495.745 + 556.811/497.714 + 556.811/500.662 + 556.811/501.710 + 556.811/506.433 + 556.811/508.315 + 556.811/510.875)/13;

if year = 2019 and month = 1 then inf_after = (556.811/489.968 + 556.811/490.160 + 556.811/491.412 + 556.811/492.970 + 556.811/494.859 + 556.811/495.745 + 556.811/497.714 + 556.811/500.662 + 556.811/501.710 + 556.811/506.433 + 556.811/508.315 + 556.811/510.875 + 556.811/511.865)/13;
if year = 2019 and month = 2 then inf_after = (556.811/490.160 + 556.811/491.412 + 556.811/492.970 + 556.811/494.859 + 556.811/495.745 + 556.811/497.714 + 556.811/500.662 + 556.811/501.710 + 556.811/506.433 + 556.811/508.315 + 556.811/510.875 + 556.811/511.865 + 556.811/513.013)/13;
if year = 2019 and month = 3 then inf_after = (556.811/491.412 + 556.811/492.970 + 556.811/494.859 + 556.811/495.745 + 556.811/497.714 + 556.811/500.662 + 556.811/501.710 + 556.811/506.433 + 556.811/508.315 + 556.811/510.875 + 556.811/511.865 + 556.811/513.013 + 556.811/514.725)/13;
if year = 2019 and month = 4 then inf_after = (556.811/492.970 + 556.811/494.859 + 556.811/495.745 + 556.811/497.714 + 556.811/500.662 + 556.811/501.710 + 556.811/506.433 + 556.811/508.315 + 556.811/510.875 + 556.811/511.865 + 556.811/513.013 + 556.811/514.725 + 556.811/516.814)/13;
if year = 2019 and month = 5 then inf_after = (556.811/494.859 + 556.811/495.745 + 556.811/497.714 + 556.811/500.662 + 556.811/501.710 + 556.811/506.433 + 556.811/508.315 + 556.811/510.875 + 556.811/511.865 + 556.811/513.013 + 556.811/514.725 + 556.811/516.814 + 556.811/519.225)/13;
if year = 2019 and month = 6 then inf_after = (556.811/495.745 + 556.811/497.714 + 556.811/500.662 + 556.811/501.710 + 556.811/506.433 + 556.811/508.315 + 556.811/510.875 + 556.811/511.865 + 556.811/513.013 + 556.811/514.725 + 556.811/516.814 + 556.811/519.225 + 556.811/520.957)/13;
if year = 2019 and month = 7 then inf_after = (556.811/497.714 + 556.811/500.662 + 556.811/501.710 + 556.811/506.433 + 556.811/508.315 + 556.811/510.875 + 556.811/511.865 + 556.811/513.013 + 556.811/514.725 + 556.811/516.814 + 556.811/519.225 + 556.811/520.957 + 556.811/522.722)/13;
if year = 2019 and month = 8 then inf_after = (556.811/500.662 + 556.811/501.710 + 556.811/506.433 + 556.811/508.315 + 556.811/510.875 + 556.811/511.865 + 556.811/513.013 + 556.811/514.725 + 556.811/516.814 + 556.811/519.225 + 556.811/520.957 + 556.811/522.722 + 556.811/522.860)/13;
if year = 2019 and month = 9 then inf_after = (556.811/501.710 + 556.811/506.433 + 556.811/508.315 + 556.811/510.875 + 556.811/511.865 + 556.811/513.013 + 556.811/514.725 + 556.811/516.814 + 556.811/519.225 + 556.811/520.957 + 556.811/522.722 + 556.811/522.860 + 556.811/522.666)/13;
if year = 2019 and month = 10 then inf_after = (556.811/506.433 + 556.811/508.315 + 556.811/510.875 + 556.811/511.865 + 556.811/513.013 + 556.811/514.725 + 556.811/516.814 + 556.811/519.225 + 556.811/520.957 + 556.811/522.722 + 556.811/522.860 + 556.811/522.666 + 556.811/520.900)/13;
if year = 2019 and month = 11 then inf_after = (556.811/508.315 + 556.811/510.875 + 556.811/511.865 + 556.811/513.013 + 556.811/514.725 + 556.811/516.814 + 556.811/519.225 + 556.811/520.957 + 556.811/522.722 + 556.811/522.860 + 556.811/522.666 + 556.811/520.900 + 556.811/520.565)/13;
if year = 2019 and month = 12 then inf_after = (556.811/510.875 + 556.811/511.865 + 556.811/513.013 + 556.811/514.725 + 556.811/516.814 + 556.811/519.225 + 556.811/520.957 + 556.811/522.722 + 556.811/522.860 + 556.811/522.666 + 556.811/520.900 + 556.811/520.565 + 556.811/519.907)/13;

if year = 2020 and month = 1 then inf_after = (556.811/511.865 + 556.811/513.013 + 556.811/514.725 + 556.811/516.814 + 556.811/519.225 + 556.811/520.957 + 556.811/522.722 + 556.811/522.860 + 556.811/522.666 + 556.811/520.900 + 556.811/520.565 + 556.811/519.907 + 556.811/521.792)/13;
if year = 2020 and month = 2 then inf_after = (556.811/513.013 + 556.811/514.725 + 556.811/516.814 + 556.811/519.225 + 556.811/520.957 + 556.811/522.722 + 556.811/522.860 + 556.811/522.666 + 556.811/520.900 + 556.811/520.565 + 556.811/519.907 + 556.811/521.792 + 556.811/523.471)/13;
if year = 2020 and month = 3 then inf_after = (556.811/514.725 + 556.811/516.814 + 556.811/519.225 + 556.811/520.957 + 556.811/522.722 + 556.811/522.860 + 556.811/522.666 + 556.811/520.900 + 556.811/520.565 + 556.811/519.907 + 556.811/521.792 + 556.811/523.471 + 556.811/523.979)/13;
if year = 2020 and month = 4 then inf_after = (556.811/516.814 + 556.811/519.225 + 556.811/520.957 + 556.811/522.722 + 556.811/522.860 + 556.811/522.666 + 556.811/520.900 + 556.811/520.565 + 556.811/519.907 + 556.811/521.792 + 556.811/523.471 + 556.811/523.979 + 556.811/524.529)/13;
if year = 2020 and month = 5 then inf_after = (556.811/519.225 + 556.811/520.957 + 556.811/522.722 + 556.811/522.860 + 556.811/522.666 + 556.811/520.900 + 556.811/520.565 + 556.811/519.907 + 556.811/521.792 + 556.811/523.471 + 556.811/523.979 + 556.811/524.529 + 556.811/524.088)/13;
if year = 2020 and month = 6 then inf_after = (556.811/520.957 + 556.811/522.722 + 556.811/522.860 + 556.811/522.666 + 556.811/520.900 + 556.811/520.565 + 556.811/519.907 + 556.811/521.792 + 556.811/523.471 + 556.811/523.979 + 556.811/524.529 + 556.811/524.088 + 556.811/523.256)/13;
if year = 2020 and month = 7 then inf_after = (556.811/522.722 + 556.811/522.860 + 556.811/522.666 + 556.811/520.900 + 556.811/520.565 + 556.811/519.907 + 556.811/521.792 + 556.811/523.471 + 556.811/523.979 + 556.811/524.529 + 556.811/524.088 + 556.811/523.256 + 556.811/524.304)/13;
if year = 2020 and month = 8 then inf_after = (556.811/522.860 + 556.811/522.666 + 556.811/520.900 + 556.811/520.565 + 556.811/519.907 + 556.811/521.792 + 556.811/523.471 + 556.811/523.979 + 556.811/524.529 + 556.811/524.088 + 556.811/523.256 + 556.811/524.304 + 556.811/524.646)/13;
if year = 2020 and month = 9 then inf_after = (556.811/522.666 + 556.811/520.900 + 556.811/520.565 + 556.811/519.907 + 556.811/521.792 + 556.811/523.471 + 556.811/523.979 + 556.811/524.529 + 556.811/524.088 + 556.811/523.256 + 556.811/524.304 + 556.811/524.646 + 556.811/524.764)/13;
if year = 2020 and month = 10 then inf_after = (556.811/520.900 + 556.811/520.565 + 556.811/519.907 + 556.811/521.792 + 556.811/523.471 + 556.811/523.979 + 556.811/524.529 + 556.811/524.088 + 556.811/523.256 + 556.811/524.304 + 556.811/524.646 + 556.811/524.764 + 556.811/527.597)/13;
if year = 2020 and month = 11 then inf_after = (556.811/520.565 + 556.811/519.907 + 556.811/521.792 + 556.811/523.471 + 556.811/523.979 + 556.811/524.529 + 556.811/524.088 + 556.811/523.256 + 556.811/524.304 + 556.811/524.646 + 556.811/524.764 + 556.811/527.597 + 556.811/529.512)/13;
if year = 2020 and month = 12 then inf_after = (556.811/519.907 + 556.811/521.792 + 556.811/523.471 + 556.811/523.979 + 556.811/524.529 + 556.811/524.088 + 556.811/523.256 + 556.811/524.304 + 556.811/524.646 + 556.811/524.764 + 556.811/527.597 + 556.811/529.512 + 556.811/531.053)/13;

if year = 2021 and month = 1 then inf_after = (556.811/521.792 + 556.811/523.471 + 556.811/523.979 + 556.811/524.529 + 556.811/524.088 + 556.811/523.256 + 556.811/524.304 + 556.811/524.646 + 556.811/524.764 + 556.811/527.597 + 556.811/529.512 + 556.811/531.053 + 556.811/534.704)/13;
if year = 2021 and month = 2 then inf_after = (556.811/523.471 + 556.811/523.979 + 556.811/524.529 + 556.811/524.088 + 556.811/523.256 + 556.811/524.304 + 556.811/524.646 + 556.811/524.764 + 556.811/527.597 + 556.811/529.512 + 556.811/531.053 + 556.811/534.704 + 556.811/536.293)/13;
if year = 2021 and month = 3 then inf_after = (556.811/523.979 + 556.811/524.529 + 556.811/524.088 + 556.811/523.256 + 556.811/524.304 + 556.811/524.646 + 556.811/524.764 + 556.811/527.597 + 556.811/529.512 + 556.811/531.053 + 556.811/534.704 + 556.811/536.293 + 556.811/539.079)/13;
if year = 2021 and month = 4 then inf_after = (556.811/524.529 + 556.811/524.088 + 556.811/523.256 + 556.811/524.304 + 556.811/524.646 + 556.811/524.764 + 556.811/527.597 + 556.811/529.512 + 556.811/531.053 + 556.811/534.704 + 556.811/536.293 + 556.811/539.079 + 556.811/541.633)/13;
if year = 2021 and month = 5 then inf_after = (556.811/524.088 + 556.811/523.256 + 556.811/524.304 + 556.811/524.646 + 556.811/524.764 + 556.811/527.597 + 556.811/529.512 + 556.811/531.053 + 556.811/534.704 + 556.811/536.293 + 556.811/539.079 + 556.811/541.633 + 556.811/543.814)/13;
if year = 2021 and month = 6 then inf_after = (556.811/523.256 + 556.811/524.304 + 556.811/524.646 + 556.811/524.764 + 556.811/527.597 + 556.811/529.512 + 556.811/531.053 + 556.811/534.704 + 556.811/536.293 + 556.811/539.079 + 556.811/541.633 + 556.811/543.814 + 556.811/547.073)/13;
if year = 2021 and month = 7 then inf_after = (556.811/524.304 + 556.811/524.646 + 556.811/524.764 + 556.811/527.597 + 556.811/529.512 + 556.811/531.053 + 556.811/534.704 + 556.811/536.293 + 556.811/539.079 + 556.811/541.633 + 556.811/543.814 + 556.811/547.073 + 556.811/549.741)/13;
if year = 2021 and month = 8 then inf_after = (556.811/524.646 + 556.811/524.764 + 556.811/527.597 + 556.811/529.512 + 556.811/531.053 + 556.811/534.704 + 556.811/536.293 + 556.811/539.079 + 556.811/541.633 + 556.811/543.814 + 556.811/547.073 + 556.811/549.741 + 556.811/552.723)/13;
if year = 2021 and month = 9 then inf_after = (556.811/524.764 + 556.811/527.597 + 556.811/529.512 + 556.811/531.053 + 556.811/534.704 + 556.811/536.293 + 556.811/539.079 + 556.811/541.633 + 556.811/543.814 + 556.811/547.073 + 556.811/549.741 + 556.811/552.723 + 556.811/556.125)/13;
if year = 2021 and month = 10 then inf_after = (556.811/527.597 + 556.811/529.512 + 556.811/531.053 + 556.811/534.704 + 556.811/536.293 + 556.811/539.079 + 556.811/541.633 + 556.811/543.814 + 556.811/547.073 + 556.811/549.741 + 556.811/552.723 + 556.811/556.125 + 556.811/553.890)/13;
if year = 2021 and month = 11 then inf_after = (556.811/529.512 + 556.811/531.053 + 556.811/534.704 + 556.811/536.293 + 556.811/539.079 + 556.811/541.633 + 556.811/543.814 + 556.811/547.073 + 556.811/549.741 + 556.811/552.723 + 556.811/556.125 + 556.811/553.890 + 556.811/551.364)/13;
if year = 2021 and month = 12 then inf_after = (556.811/531.053 + 556.811/534.704 + 556.811/536.293 + 556.811/539.079 + 556.811/541.633 + 556.811/543.814 + 556.811/547.073 + 556.811/549.741 + 556.811/552.723 + 556.811/556.125 + 556.811/553.890 + 556.811/551.364 + 556.811/551.950)/13;

if year = 2022 and month = 1 then inf_after = (556.811/534.704 + 556.811/536.293 + 556.811/539.079 + 556.811/541.633 + 556.811/543.814 + 556.811/547.073 + 556.811/549.741 + 556.811/552.723 + 556.811/556.125 + 556.811/553.890 + 556.811/551.364 + 556.811/551.950 + 556.811/551.022)/13;
if year = 2022 and month = 2 then inf_after = (556.811/536.293 + 556.811/539.079 + 556.811/541.633 + 556.811/543.814 + 556.811/547.073 + 556.811/549.741 + 556.811/552.723 + 556.811/556.125 + 556.811/553.890 + 556.811/551.364 + 556.811/551.950 + 556.811/551.022 + 556.811/548.925)/13;
if year = 2022 and month = 3 then inf_after = (556.811/539.079 + 556.811/541.633 + 556.811/543.814 + 556.811/547.073 + 556.811/549.741 + 556.811/552.723 + 556.811/556.125 + 556.811/553.890 + 556.811/551.364 + 556.811/551.950 + 556.811/551.022 + 556.811/548.925 + 556.811/547.250)/13;
if year = 2022 and month = 4 then inf_after = (556.811/541.633 + 556.811/543.814 + 556.811/547.073 + 556.811/549.741 + 556.811/552.723 + 556.811/556.125 + 556.811/553.890 + 556.811/551.364 + 556.811/551.950 + 556.811/551.022 + 556.811/548.925 + 556.811/547.250 + 556.811/547.462)/13;
if year = 2022 and month = 5 then inf_after = (556.811/543.814 + 556.811/547.073 + 556.811/549.741 + 556.811/552.723 + 556.811/556.125 + 556.811/553.890 + 556.811/551.364 + 556.811/551.950 + 556.811/551.022 + 556.811/548.925 + 556.811/547.250 + 556.811/547.462 + 556.811/547.889)/13;
if year = 2022 and month = 6 then inf_after = (556.811/547.073 + 556.811/549.741 + 556.811/552.723 + 556.811/556.125 + 556.811/553.890 + 556.811/551.364 + 556.811/551.950 + 556.811/551.022 + 556.811/548.925 + 556.811/547.250 + 556.811/547.462 + 556.811/547.889 + 556.811/547.832)/13;
if year = 2022 and month = 7 then inf_after = (556.811/549.741 + 556.811/552.723 + 556.811/556.125 + 556.811/553.890 + 556.811/551.364 + 556.811/551.950 + 556.811/551.022 + 556.811/548.925 + 556.811/547.250 + 556.811/547.462 + 556.811/547.889 + 556.811/547.832 + 556.811/546.959)/13;
 
run;




data delay3;
set delay2;

*Removing if had visit or treatement but no associated cost;  
*NOTE: There were 4743 observations read from the data set WORK.DELAY2.
 NOTE: The data set WORK.DELAY3 has 4381 observations and 85 variables.;
if hosp_before_cost = . and hosp_before = 1 then delete;
if antibiotics_cost = . and antibiotics = 1 then delete;
if op_after_cost = . and op_after_num > 0 then delete;
if hosp_after_cost = . and hosp_after = 1 then delete;
if antifungals_cost = . and antifungals = 1 then delete;

*Set those who have no compatible symptoms to a 0 delay time;
if any_compatible = 0 then delay_time = 0 ;

*Create Total Cost Variable;
total_cost = sum(cost1*inf_before, cost2*inf_before, cost3*inf_before, cost4*inf_after, cost5*inf_after, cost6*inf_after) ;

run;





*Next Steps;

*Checking costs between symptomatic and non-symptomatic;
*NOTE: the outliers do not affect the means a lot in the groups;
*NOTE: most costs are really low or zero for those with no symptoms;

*Plotting Costs;
proc sgplot data = delay3;
histogram total_cost;
run;

*Consider removing 13 people who had 0 total cost;
proc print data = delay3;
where total_cost = 0 ;
run;

*Check fequency of delayed days;
*NOTE: consider creating categories of delay if continuous results don't work;
proc sgplot data = delay3;
histogram delay_time;
run;

proc freq data = delay3;
tables any_compatible;
run;



* Potential patterns (CONFOUNDERS / STRATIFIERS): 
   Sex, Age, Urbanicity, Region, State, Insurance Type, Antifungal Treatment, Mycosis Type ;


*Check frequencies;
proc freq data = delay3;
tables any_compatible disease_type sex age_group rural_status region state insurance antibiotics antifungals cond_immunosuppressed ;
run;

proc freq data = delay3;
tables disease_type sex age_group rural_status region state insurance antibiotics antifungals cond_immunosuppressed ;
where any_compatible = 1 ;
run;

proc freq data = delay3;
tables disease_type sex age_group rural_status region state insurance antibiotics antifungals cond_immunosuppressed ;
where any_compatible = 0 ;
run;



*Check Continuous Age Distrubution;
*NOTE: 1="0 to 17," 2="18 to 44," 3="45 to 64, 4="65+ ;
proc sgplot data = delay3;
histogram age ;
run; 


*Mean Diagnosis Delays;

*Overall;
proc means data = delay3;
var delay_time ;
run;

proc sort data = delay3; 
by disease_type;
run;

proc means data = delay3;
var delay_time ;
by disease_type;
run;

*Sex - total;
proc means data = delay3;
var delay_time ;
where sex = 0 ;
run;

proc means data = delay3;
var delay_time ;
where sex = 1 ;
run;

*Sex - blasto;
proc means data = delay3;
var delay_time ;
where sex = 0 and disease_type = "blasto" ;
run;

proc means data = delay3;
var delay_time ;
where sex = 1 and disease_type = "blasto" ;
run;

*Sex - cocci;
proc means data = delay3;
var delay_time ;
where sex = 0 and disease_type = "cocci" ;
run;

proc means data = delay3;
var delay_time ;
where sex = 1 and disease_type = "cocci" ;
run;

*Sex - histo;
proc means data = delay3;
var delay_time ;
where sex = 0 and disease_type = "histo" ;
run;

proc means data = delay3;
var delay_time ;
where sex = 1 and disease_type = "histo" ;
run;


*Age - total;
proc means data = delay3;
var delay_time ;
where age_group = 1 ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 2 ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 3 ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 4 ;
run;

*Age - blasto;
proc means data = delay3;
var delay_time ;
where age_group = 1 and disease_type = "blasto" ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 2 and disease_type = "blasto" ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 3 and disease_type = "blasto" ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 4 and disease_type = "blasto" ;
run;

*Age - cocci;
proc means data = delay3;
var delay_time ;
where age_group = 1 and disease_type = "cocci" ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 2 and disease_type = "cocci" ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 3 and disease_type = "cocci" ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 4 and disease_type = "cocci" ;
run;

*Age - histo;
proc means data = delay3;
var delay_time ;
where age_group = 1 and disease_type = "histo" ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 2 and disease_type = "histo" ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 3 and disease_type = "histo" ;
run;

proc means data = delay3;
var delay_time ;
where age_group = 4 and disease_type = "histo" ;
run;


*Insurance Type - total;
proc means data = delay3;
var delay_time ;
where insurance = "Commercial" ;
run;

proc means data = delay3;
var delay_time ;
where insurance = "Medicare" ;
run;


*Insurance Type - blasto;
proc means data = delay3;
var delay_time ;
where insurance = "Commercial" and disease_type = "blasto" ;
run;

proc means data = delay3;
var delay_time ;
where insurance = "Medicare" and disease_type = "blasto" ;
run;

*Insurance Type - cocci;
proc means data = delay3;
var delay_time ;
where insurance = "Commercial" and disease_type = "cocci" ;
run;

proc means data = delay3;
var delay_time ;
where insurance = "Medicare" and disease_type = "cocci" ;
run;

*Insurance Type - histo;
proc means data = delay3;
var delay_time ;
where insurance = "Commercial" and disease_type = "histo" ;
run;

proc means data = delay3;
var delay_time ;
where insurance = "Medicare" and disease_type = "histo" ;
run;


*Region - total - MISSING 155;
proc means data = delay3;
var delay_time ;
where region = "Midwest" ;
run;

proc means data = delay3;
var delay_time ;
where region = "Northeast" ;
run;

proc means data = delay3;
var delay_time ;
where region = "South" ;
run;

proc means data = delay3;
var delay_time ;
where region = "West" ;
run;


*Region - blasto;
proc means data = delay3;
var delay_time ;
where region = "Midwest" and disease_type = "blasto" ;
run;

proc means data = delay3;
var delay_time ;
where region = "Northeast" and disease_type = "blasto" ;
run;

proc means data = delay3;
var delay_time ;
where region = "South" and disease_type = "blasto" ;
run;

proc means data = delay3;
var delay_time ;
where region = "West" and disease_type = "blasto" ;
run;



*Region - cocci;
proc means data = delay3;
var delay_time ;
where region = "Midwest" and disease_type = "cocci" ;
run;

proc means data = delay3;
var delay_time ;
where region = "Northeast" and disease_type = "cocci" ;
run;

proc means data = delay3;
var delay_time ;
where region = "South" and disease_type = "cocci" ;
run;

proc means data = delay3;
var delay_time ;
where region = "West" and disease_type = "cocci" ;
run;



*Region - Histo;
proc means data = delay3;
var delay_time ;
where region = "Midwest" and disease_type = "histo" ;
run;

proc means data = delay3;
var delay_time ;
where region = "Northeast" and disease_type = "histo" ;
run;

proc means data = delay3;
var delay_time ;
where region = "South" and disease_type = "histo" ;
run;

proc means data = delay3;
var delay_time ;
where region = "West" and disease_type = "histo" ;
run;


*Urbanicity - Total - MISSING 630 ;
proc means data = delay3;
var delay_time ;
where rural_status = "Rural" ;
run;

proc means data = delay3;
var delay_time ;
where rural_status = "Nonrural" ;
run;

*Urbanicity - blasto ;
proc means data = delay3;
var delay_time ;
where rural_status = "Rural" and disease_type = "blasto"  ;
run;

proc means data = delay3;
var delay_time ;
where rural_status = "Nonrural" and disease_type = "blasto"  ;
run;

*Urbanicity - cocci ;
proc means data = delay3;
var delay_time ;
where rural_status = "Rural" and disease_type = "cocci"  ;
run;

proc means data = delay3;
var delay_time ;
where rural_status = "Nonrural" and disease_type = "cocci"  ;
run;

*Urbanicity - histo ;
proc means data = delay3;
var delay_time ;
where rural_status = "Rural" and disease_type = "histo"  ;
run;

proc means data = delay3;
var delay_time ;
where rural_status = "Nonrural" and disease_type = "histo"  ;
run;


*Immunosuppressed;
proc means data = delay3;
var delay_time ;
where cond_immunosuppressed = 1  ;
run;

proc means data = delay3;
var delay_time ;
where cond_immunosuppressed = 0  ;
run;

proc means data = delay3;
var delay_time ;
where cond_immunosuppressed = 1 and disease_type = "histo"  ;
run;

proc means data = delay3;
var delay_time ;
where cond_immunosuppressed = 0 and disease_type = "histo"  ;
run;

proc means data = delay3;
var delay_time ;
where cond_immunosuppressed = 1 and disease_type = "cocci"  ;
run;

proc means data = delay3;
var delay_time ;
where cond_immunosuppressed = 0 and disease_type = "cocci"  ;
run;

proc means data = delay3;
var delay_time ;
where cond_immunosuppressed = 1 and disease_type = "blasto"  ;
run;

proc means data = delay3;
var delay_time ;
where cond_immunosuppressed = 0 and disease_type = "blasto"  ;
run;




*DELAY TIME AND COST;
proc univariate data = delay3;
var delay_time;
where delay_time > 0 ;
run;

proc means data = delay3;
var total_cost;
where delay_time = 0 ;
run;

proc means data = delay3;
var total_cost;
where 0 < delay_time <=21  ;
run;

proc means data = delay3;
var total_cost;
where 21 < delay_time <=46  ;
run;

proc means data = delay3;
var total_cost;
where 46 < delay_time <=73  ;
run;

proc means data = delay3;
var total_cost;
where 73 < delay_time   ;
run;


*DELAY TIME AND COST - Boxplots;
data delay4;
set delay3;

*Creating Delay Categories and Log Cost Variables ;
if delay_time = 0 then delay_cat = 0 ;
else if 0 < delay_time <=21 then delay_cat = 1 ;
else if 21 < delay_time <=46 then delay_cat = 2 ;
else if 46 < delay_time <=73 then delay_cat = 3 ;
else if 73 < delay_time then delay_cat = 4 ;
else delay_cat = . ;

if total_cost = 0 then log_cost = 0 ;
else if total_cost > 0 then log_cost = log(total_cost);
else log_cost = . ;

if delay_time = 0 then delay_trunc = . ;
else if delay_time > 0 then delay_trunc = delay_time;
else delay_trunc = . ;

run;

*Panel of costs;
PROC SGPLOT  DATA = delay4;
   VBOX log_cost
   / category = delay_cat;

   title 'Total Cost by Delay Time';
RUN; 




********************
 Creating Quantiles
********************;

*Create three separate datasets;
data blasto;
set delay4;
where disease_type = "blasto";
run;

data cocci;
set delay4;
where disease_type = "cocci";
run;

data histo;
set delay4;
where disease_type = "histo";
run;

data combined;
set delay4;
where disease_type = "histo" or disease_type = "blasto";
run;




/*********** ALL ************/

*Q5;
* Create quantiles using PROC RANK ;
proc rank data = delay4 out = quantiles groups = 5 ;     
    var delay_trunc;                                  
    ranks delay_q5 ;                                   
run;
* Assign proper values and labels ;
data all_path; 
set quantiles;
if delay_trunc = . then delay_q5 = 0 ;
else delay_q5 = delay_q5 +1  ;                   
label delay_q5 = "delay_q5";  
run;



/*********** BLASTO ************/

*Q5;
* Create quantiles using PROC RANK ;
proc rank data = blasto out = quantiles groups = 5 ;     
    var delay_trunc;                                  
    ranks delay_q5 ;                                   
run;
* Assign proper values and labels ;
data blasto; 
set quantiles;
if delay_trunc = . then delay_q5 = 0 ;
else delay_q5 = delay_q5 +1  ;                   
label delay_q5 = "delay_q5";  
run;


/*********** COCCI ************/

*Q3;
* Create quantiles using PROC RANK ;
proc rank data = cocci out = quantiles groups = 3 ;     
    var delay_trunc;                                  
    ranks delay_q3 ;                                   
run;

* Assign proper values and labels ;
data cocci; 
set quantiles;
if delay_trunc = . then delay_q3 = 0 ;
else delay_q3 = delay_q3 +1  ;                   
label delay_q3 = "delay_q3";    
run;


*Q5;
* Create quantiles using PROC RANK ;
proc rank data = cocci out = quantiles groups = 5 ;     
    var delay_trunc;                                  
    ranks delay_q5 ;                                   
run;
* Assign proper values and labels ;
data cocci; 
set quantiles;
if delay_trunc = . then delay_q5 = 0 ;
else delay_q5 = delay_q5 +1  ;                   
label delay_q5 = "delay_q5";  
run;


/*********** HISTO ************/

*Q5;
* Create quantiles using PROC RANK ;
proc rank data = histo out = quantiles groups = 5 ;     
    var delay_trunc;                                  
    ranks delay_q5 ;                                   
run;
* Assign proper values and labels ;
data histo; 
set quantiles;
if delay_trunc = . then delay_q5 = 0 ;
else delay_q5 = delay_q5 +1  ;                   
label delay_q5 = "delay_q5";  
run;


/*********** COMBINED ************/

*Q5;
* Create quantiles using PROC RANK ;
proc rank data = combined out = quantiles groups = 5 ;     
    var delay_trunc;                                  
    ranks delay_q5 ;                                   
run;
* Assign proper values and labels ;
data combined; 
set quantiles;
if delay_trunc = . then delay_q5 = 0 ;
else delay_q5 = delay_q5 +1  ;                   
label delay_q5 = "delay_q5";  
run;



*Export excel docs;

/*

proc export 
  data=delay4
  dbms=csv 
  outfile="C:\Users\qne4\CDC\NCEZID-MDB - Data Science and Informatics (DSI)\Data Science\people\Massey-Jason\Personal Projects\Diagnostic Delays\delays.csv" 
  replace;
run;


proc export 
  data=all_path
  dbms=csv 
  outfile="C:\Users\qne4\CDC\NCEZID-MDB - Data Science and Informatics (DSI)\Data Science\people\Massey-Jason\Personal Projects\Diagnostic Delays\all_path.csv" 
  replace;
run;

proc export 
  data=blasto
  dbms=csv 
  outfile="C:\Users\qne4\CDC\NCEZID-MDB - Data Science and Informatics (DSI)\Data Science\people\Massey-Jason\Personal Projects\Diagnostic Delays\blasto.csv" 
  replace;
run;

proc export 
  data=cocci
  dbms=csv 
  outfile="C:\Users\qne4\CDC\NCEZID-MDB - Data Science and Informatics (DSI)\Data Science\people\Massey-Jason\Personal Projects\Diagnostic Delays\cocci.csv" 
  replace;
run;

proc export 
  data=histo
  dbms=csv 
  outfile="C:\Users\qne4\CDC\NCEZID-MDB - Data Science and Informatics (DSI)\Data Science\people\Massey-Jason\Personal Projects\Diagnostic Delays\histo.csv" 
  replace;
run;

proc export 
  data=combined
  dbms=csv 
  outfile="C:\Users\qne4\CDC\NCEZID-MDB - Data Science and Informatics (DSI)\Data Science\people\Massey-Jason\Personal Projects\Diagnostic Delays\combined.csv" 
  replace;
run;


*/
