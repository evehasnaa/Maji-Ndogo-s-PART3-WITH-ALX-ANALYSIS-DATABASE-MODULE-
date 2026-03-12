# Maji Ndogo Water Project: Data Architecture & Key Insights (Part 3) 

## Project Overview
This project focuses on the infrastructure and integrity of the **Maji Ndogo** water source database. As part of the ALX Data Analytics program, I undertook a dual-phase mission: first, to manually refine a complex relational schema to ensure architectural integrity, and second, to perform a forensic audit to uncover data discrepancies and potential corruption in water quality reporting.

---

## 1. Database Architecture & Schema Design

### "Do Not Blindly Trust EER Diagrams"
A pivotal lesson from this project is that automation is not a substitute for architectural understanding. While utilizing MySQL Workbench to model the Part 3 schema, I discovered several critical flaws in auto-generated relationship suggestions:

* **Redundant Columns:** Workbench attempted to force relationships by creating extra columns like `location_location_id` between `auditor_report` and `location`, despite `location_id` already serving as the valid link. This threatened the database's normalization and introduced unnecessary bulk.
* **Normalization & Star Schema Risks:** The tool suggested direct links between tables that should remain independent in a clean Star Schema, which would have compromised the 3rd Normal Form (3NF).
* **Synchronization Failures:** Automated PK/FK enforcement between `global_water_access` and `water_source` caused synchronization errors. These occurred due to pre-existing duplicate records and `NULL` values that conflicted with rigid, auto-applied unique constraints.

**The Solution:** I performed a manual, step-by-step cleanup of the EER diagram. By stripping away redundant relationships and correcting the model logic, I ensured a lean, professional architecture built on sound engineering principles rather than automated "best guesses."

### EER Schema Preview
![Maji Ndogo EER Diagram](schema/EER%20DIAGRAM.png)
*Schema file (PDF): [EER DIAGRAM.pdf](schema/EER%20DIAGRAM.pdf)*

---

## 2. Forensic Data Audit & Insights

With a stable architecture, I moved to the audit phase, comparing internal surveyor data against an independent **Auditor’s Report** to verify the truth behind the numbers.

### Technical Implementation
1.  **Complex Integration:** I utilized advanced `JOIN` logic to merge the `auditor_report` with the `visits` and `water_quality` tables.
2.  **Data Cleaning:** Implemented `WHERE visits.visit_count = 1` to eliminate duplicate location entries and ensure a 1-to-1 comparison per site.
3.  **Encapsulation:** Created a `VIEW` named `Incorrect_records` to isolate every instance where internal surveyor scores diverged from independent auditor findings.

### Key Insights & Findings
* **94% System Integrity:** Analysis showed that 1,518 out of 1,620 records matched the audit, indicating a generally reliable reporting system.
* **The 6% Discrepancy:** 102 records were identified as fraudulent or incorrect. Notably, while the *source type* was usually reported accurately, the *quality scores* were frequently inflated by internal staff.
* **The Suspect List:** Using **CTEs** and **Subqueries**, I identified 4 specific employees whose error rates were statistically significantly higher than the peer average.
* **Corruption Patterns:** By cross-referencing these 102 records with the `statements` column, the data revealed a disturbing narrative pattern—villagers reported "official arrogance" and suspicious behavior, confirming that these discrepancies were likely intentional tampering rather than human error.

---

## 3. SQL Logic Sample: Identifying Anomalies

The following query was instrumental in isolating the "Suspect List" by filtering employees with an above-average frequency of discrepancies:


---

## Tools & Technologies
* **DBMS:** MySQL
* **Modeling:** MySQL Workbench (Manual Schema Refinement)
* **Analytics:** SQL (CTEs, Views, Subqueries, Aggregate Functions)

---

## Conclusion
This project demonstrates that databases are not just sets of tables, but complex architectures that require human oversight. By combining rigorous schema design with forensic SQL analysis, I was able to transform raw data into a tool for transparency and organizational accountability.

**Developed by Hasnaa | ALX Data Analytics**
