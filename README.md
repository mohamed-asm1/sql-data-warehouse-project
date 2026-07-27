# SQL Data Warehouse Project

Welcome to the **SQL Data Warehouse Project** repository! 🚀  
This project demonstrates a comprehensive data warehousing solution built with SQL Server, showcasing industry best practices in data engineering, ETL pipelines, and data analytics. Designed as a portfolio project, it highlights modern approaches to data architecture and warehousing.

---

## 🏗️ Data Architecture

The data architecture for this project follows the **Medallion Architecture** pattern with three distinct layers:

![Data Architecture](docs/high_level_architecture.png)

1. **Bronze Layer**: Stores raw data as-is from source systems. Data is ingested from CSV files directly into SQL Server without any transformation.
2. **Silver Layer**: Implements data cleansing, standardization, validation, and normalization processes to prepare high-quality data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema, optimized for reporting, analytics, and business intelligence applications.

---

## 📖 Project Overview

This comprehensive data warehousing project encompasses:

1. **Data Architecture Design**: Modern data warehouse implementation using Medallion Architecture with Bronze, Silver, and Gold layers.
2. **ETL Pipelines**: Complete extraction, transformation, and loading processes from source systems into the warehouse.
3. **Data Modeling**: Development of fact and dimension tables optimized for analytical queries and reporting (see [Gold Layer Data Catalog](docs/data_catalog_gold_layer.md)).
4. **Data Quality**: Implementation of data validation, cleansing, and quality assurance mechanisms.
5. **Analytics & Reporting**: SQL-based analytics and reports delivering actionable business insights.

🎯 This repository demonstrates expertise in:
- SQL Server Development
- Data Architecture & Design
- ETL Pipeline Development
- Data Modeling & Star Schema Design
- Data Quality & Governance
- Data Analytics & Business Intelligence

---

## 🛠️ Tools & Resources

Everything is accessible and free!

- **[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)**: Lightweight SQL Server edition for database hosting.
- **[SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16)**: GUI tool for database management and SQL development.
- **[Git & GitHub](https://github.com/)**: Version control and repository management.
- **[DrawIO](https://www.drawio.com/)**: Design and edit data architecture diagrams, data flows, and models.
- **[Datasets](datasets/)**: Access to project dataset CSV files from source systems.

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate data from multiple source systems, enabling comprehensive analytical reporting and data-driven decision-making.

#### Specifications
- **Data Sources**: Import data from multiple source systems (ERP, CRM) provided as CSV files.
- **Data Quality**: Implement comprehensive data cleansing and quality validation prior to analysis.
- **Integration**: Combine multiple sources into a unified, analytically-optimized data model.
- **Scope**: Focus on current dataset; historical data tracking not required for initial implementation.
- **Documentation**: Provide detailed documentation of the data model for business stakeholders and analytics teams.

---

### Analytics & Reporting

#### Objective
Develop SQL-based analytics to deliver actionable insights into:
- **Customer Behavior & Segmentation**
- **Product Performance & Trends**
- **Sales Analysis & Revenue Metrics**
- **Operational Efficiency Metrics**

These insights enable stakeholders to make strategic, data-driven business decisions.

---

## 📂 Repository Structure

```
sql-data-warehouse-project/
│
├── datasets/                           # Raw datasets from source systems
│
├── docs/                               # Project documentation and architecture
│   ├── data_warehouse_project.drawio     # Complete project diagram with all layers
│   ├── high_level_architecture.png     # Medallion architecture visualization
│   ├── data_flow_diagram.png           # Data flow visualization
│   ├── star_schema_gold_layer.png      # Star schema diagram for analytics
│   ├── data_catalog_gold_layer.md      # Gold layer tables, fields, and metadata
│   └── naming_conventions.md           # Naming guidelines for database objects
│
├── scripts/                            # SQL scripts organized by Medallion layers
│   ├── init_database.sql               # Database initialization script
│   ├── bronze/                         # Bronze layer: Raw data loading
│   ├── silver/                         # Silver layer: Data transformation & cleansing
│   └── gold/                           # Gold layer: Analytical models & reporting
│
├── tests/                              # Data quality tests and validation scripts
│
├── README.md                           # Project overview and setup instructions
├── LICENSE                             # MIT License
└── .gitignore                          # Git ignore rules
```

---

## 🚀 Getting Started

### Prerequisites
- SQL Server 2019 or higher (Express edition works fine)
- SQL Server Management Studio (SSMS)
- Git
- Basic SQL knowledge

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/mohamed-asm1/sql-data-warehouse-project.git
   cd sql-data-warehouse-project
   ```

2. **Prepare your environment**
   - Install SQL Server and SSMS if not already installed
   - Create a new database in your SQL Server instance

3. **Initialize the database**
   - Execute `scripts/init_database.sql` to set up the initial database structure

4. **Execute scripts in order**
   - Start with **Bronze layer** scripts to load raw data from CSV files
   - Follow with **Silver layer** scripts for data cleaning and transformation
   - Complete with **Gold layer** scripts for creating analytical models and dimension tables

5. **Validate data quality**
   - Run test scripts in the `tests/` directory to ensure data integrity
   - Review data quality reports

---

## 📚 Key Documentation

- **[Data Catalog (Gold Layer)](docs/data_catalog_gold_layer.md)**: Comprehensive documentation of all tables, dimensions, and facts in the analytics layer
- **[Naming Conventions](docs/naming_conventions.md)**: Consistent naming guidelines for tables, columns, and database objects
- **[Project Diagram](docs/DataWarehouseProject.drawio)**: Complete DrawIO diagram with all architectural details

---

## 📊 Key Features

✅ **Medallion Architecture**: Clean separation of concerns across Bronze, Silver, and Gold layers  
✅ **Data Quality Framework**: Comprehensive validation and cleansing processes  
✅ **Star Schema Design**: Optimized dimensional model for analytics  
✅ **Scalable ETL**: Modular scripts supporting future data source additions  
✅ **Comprehensive Documentation**: Complete technical documentation and data catalogs  
✅ **Best Practices**: Industry-standard naming conventions and coding standards  

---

## 🎓 About This Project

This project was developed as part of my data engineering studies at the **National School of Applied Sciences of Al Hoceima** (ENSA Al Hoceima). It represents practical application of modern data warehousing principles, demonstrating proficiency in:

- Designing enterprise data architectures
- Developing ETL pipelines
- Creating analytics-ready data models
- Writing production-quality SQL code
- Documenting complex data systems

---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

---

## 📧 Contact & Social Media

Feel free to reach out and connect with me on the following platforms:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mohamed-aasoum-5ab774286/)
[![GitHub](https://img.shields.io/badge/GitHub-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mohamed-asm1)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:aasoum.mohamed1@gmail.com)

---

## 🙏 Acknowledgments

This project follows industry best practices in data warehousing and draws inspiration from modern data engineering methodologies. Special thanks to all resources and community that made this learning journey possible.

**Happy Learning! 🚀**
