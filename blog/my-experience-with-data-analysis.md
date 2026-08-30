---
author: ["Oscar Marquez"]
title: "My Experience as a Data Analyst"
description: "Why my role as a data analyst is not conventional and what has been my experience in the role."
pubDate: "2026-08-27"
tags:
  - data analysis
  - dbt
  - snowflke
  - fabric
  - airflow
---

> Work in progress !!!

At the time of writing I'm 21 years old and have been in my current position since May 25th, 2025 (~1.4 years).
I started as an intern in the Business Intelligence (BI) department, and the role has grown well beyond what a typical
"data analyst" does. I've done from infrastructure to data modeling and extraction to finance work to dashhboarding.

Here's a rundown of what I worked on during my first year, before getting to the more interesting parts of my
position: migration to Fabric and Snowflake, and being the main adopter of `dbt`.

- **SVG manipulation to create graphs rendered as HTML inside Power BI**. My boss wanted a Sankey diagram he'd seen
  elsewhere. I extracted the SVG, modified it and adapted it to render as an HTMl visual inside Power BI.
- **Service and application management on-site**. The IT department runs an on-site server (a very chunky boy)
  that hosts several of the department's services reside. Airflow in particular was deployed in such a way that
  it was constantly going down because logs kept filling up disk space. I got access to the VM, upgraded what could be upgraded
  and setup up created systemd services to avoid down time.
- **Power BI dashbord development**. With guidance from my boss and colleagues, plus courses and books, I became proficient in
  Power BI. I could quickly connect to our on-site SQL Server database, build the data models, design the visuals,
  and iterate based on feedback from my boss and other departments.
- **Active participation with Finance**. Because my first ~4 months or so I was basically stuck like glue to the finance
  department, I got to pick up a lot of concepts like financial statements, intercompany sales,
  invoices, inventory, and P&L. My understanding on these concepts is still fairly high-level, but
  enough to follow on conversations.
- **Platform and system integrations**. I worked across a wide range of systems using their APIs (and/or designing an API interface
  due to limitations): SAP, Odoo, AS400 and other APIs for company data.
- **ETL/ELT pipelines**. I used Airflow to orchestrate Python scripts (Pandas, SciPy) for extracting, cleaning, and lightly
  transforming data into a raw layer. For the most part I used SAP S/4HANA OData API and the Odoo XML-RPC API. We also used n8n for
  lighter-weight automations, like reports sent through Gmail, so teammates could build automations without needing
  to SSH into the Airflow VM edit DAGs directly with `nano` (though I use `vim` btw). This stopped being an impediment once we installed
  the Airflow Code Editor plugin.
- And a whole lot more, I might add more things as I remember them...

## Fabric and Snowflake

Our department began a migration from our on-site SQL Server instance toward Fabric.

## dbt
