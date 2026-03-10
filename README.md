# Maji Ndogo Part 3 - ALX Analysis Database Module

## Do Not Blindly Trust EER Diagrams

One of the biggest mistakes you can make while working with MySQL Workbench is trusting auto-generated EER diagrams without validating the database logic.

In Week 3 of the ALX Data Analytics course, I worked on the schema for the Maji Ndogo water source project (Part 3). During modeling, I found multiple issues caused by automatic relationship suggestions:

- Extra columns were added without real need.
- A table that should not have a direct relationship in the star schema was linked anyway.
- This forced a manual, step-by-step cleanup of the diagram.

For example, Workbench tried to add a redundant column like `location_location_id` to create a relationship between `auditor_report` and `location`, even though `location_id` already represented the needed relation. This introduced redundancy and hurt normalization.

Even worse, it attempted to enforce an automatic PK/FK relationship between `global_water_access` and `water_source`. That caused synchronization/update errors when exposing a created view, due to duplicated records or attempts to enforce unique constraints on columns containing `NULL` values.

I fixed this manually by removing unnecessary relationships and correcting the model logic.

Databases are not just diagrams. They are architecture, and architecture must be built and reviewed carefully, step by step.

## EER Schema

Schema file (PDF): [EER DIAGRAM.pdf](schema/EER%20DIAGRAM.pdf)

> Note: GitHub does not reliably render PDF files as inline images in README files. Use the link above to open the schema directly.

## Tags

`SQL` `DatabaseDesign` `MySQL` `DataAnalysis` `TechnicalArchitecture` `ProblemSolving` `DataEngineering` `DatabaseNormalization` `ALX` `MajiNdogo`