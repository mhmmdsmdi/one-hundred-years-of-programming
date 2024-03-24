# Timescale DB with EF Core

Continuation to previous [timescale db on edge](https://gibinfrancis.medium.com/using-timescale-db-on-edge-device-9b7f5d6ffca3) story, am continuing the same implementation on the EF Core. Please find the points below. Most of the EF Core functionality will be similar even in the case of Time Scale DB also as its an extension over Postgres DB

install “**Npgsql.EntityFrameworkCore.PostgreSQL**” using Nuget

Now we have the Postgres EEF Core is available for us. Now Lets Register the context

```c#
services.AddDbContext<DataContext>(options => options.UseNpgsql(dbConnection, providerOptions => providerOptions.EnableRetryOnFailure()), ServiceLifetime.Transient);
```

Here the IServiceCollection will get added with the Database Context based on the Connection string “dbConnection”.

Now we can create the model for our table, we will add the model here. we will use the same table structure from the previous story. But we will add “Id” column on the same to add complexity.

```c#
public class SensorReadings 
{
   [Column(TypeName = "bigserial")]
   public long Id { get; set; }   [Column(TypeName = "float")]
   public float temperature { get; set; }   [Column(TypeName = "float")]
   public float pressure { get; set; }   [Column(TypeName = "timestamp")]
   public Datetime createdtime { get; set; }
}
```

Now we have the model ready. Now we need to create a hyper table in the migration process. Postgres EF Core will create only normal postgres table using the migration. Once we are in the Migration process. we need to first run the Timescale extension on the database and and also create hyper table for our table.

For the same we will create a new extension with attribute

```c#
namespace YourNameSpace
{
   [AttributeUsage(AttributeTargets.Property)]
   public class HypertableColumnAttribute : Attribute { }   
   public static class TimeScaleExtensions
   {
     public static void ApplyHypertables(this DataContext context)
     {
       //adding timescale extension to the database
       context.Database.ExecuteSqlRaw("CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;");       
       var entityTypes = context.Model.GetEntityTypes();
       foreach (var entityType in entityTypes)
       {
         foreach (var property in entityType.GetProperties())
         {
           if (property.PropertyInfo.GetCustomAttribute( typeof(HypertableColumnAttribute)) != null)
           {
 
             var tableName = entityType.GetTableName();
             var columnName = property.GetColumnName();
             context.Database.ExecuteSqlRaw($"SELECT create_hypertable('\"{tableName}\"', '{columnName}');");
           }
         }
        }
      }
    }
  }
```

Lets discuss the code above

Below code block will create a custom Attribute for our hyper table and this will be decorated on the timestamp column for partitioning.

```c#
public class HypertableColumnAttribute : Attribute { }
```

Now lets add this attribute to our previous entity class, after the change, class will look like below.

```c#
public class SensorReadings 
{
   [Column(TypeName = "bigserial")]
   public long Id { get; set; }   [Column(TypeName = "float")]
   public float temperature { get; set; }   [Column(TypeName = "float")]
   public float pressure { get; set; }   [HypertableColumn]
   [Column(TypeName = "timestamp")]
   public Datetime createdtime { get; set; }
}
```

Now the function which will create hyper tables on the table classes which is having the previous attribute

```c#
public static void ApplyHypertables(this DataContext context)
```

as a next step we will create timescale extension on the database

```c#
context.Database.ExecuteSqlRaw("CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;");
```

This will convert our normal postgres db to timescale db.

Now We will loop through all the Entity types in the context and check for the entity which is having “HypertableColumn” attribute in the property as a decoration. and will create hypertables on teach table.

*as our table name is having both capital and small letter in it, we need to use the table name inside single and double quotes like ‘“TableName”’. Below code have the same implementation.*

```c#
context.Database.ExecuteSqlRaw($"SELECT create_hypertable('\"{tableName}\"', '{columnName}');");
```

Now we have the migration scripts ready to proceed.

But when we run the same we will get error as we using “ID” column in our table and we are partitioning with timestamp column. To solve the same you can choose any following methods based on your convenience

1. **Specify no key and remove “Id” column.**

In some IoT scenarios, there will be less relevance to the Id column, so we can remove the column and specify “HasNoKey()” in the Entity.

```c#
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<SensorReadings>().HasNoKey();
}
```

2. **Specify Composite Column**

As an alternate solution you can create composite key with “Id” and “Timestamp” column like below

```c#
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<SensorReadings>().HasKey(table => new {table.Id, table.createdtime});
}
```

Now we are ready to run the migration on the same

```c#
dataContext.Database.Migrate();
if (dataContext.Database.EnsureCreated())
    dataContext.ApplyHypertables();
```

here we will apply hyper tables extension on the context after the regular migration. This will create hyper tables

Incase if we don’t have the data context and it need to be taken from the serice collection, you can use the below code also

```c#
using DataContext dataContext = services.BuildServiceProvider().GetService<DataContext>();
dataContext.Database.Migrate();
if (dataContext.Database.EnsureCreated())
    dataContext.ApplyHypertables();
```

Now we can insert the data to our TimeScale DB from the Ef Core repository.

**Please note : If you are using the azure Postgres on cloud, you need to be sure that the Postgres is configured with the timescale extension.**

please follow the steps to convert your azure Postgres to timescale DB

```bash
az postgres server configuration set --resource-group mygroup ––server-name myserver --name shared_preload_libraries --value timescaledb
```

Then restart your potgress

```bash
az postgres server restart --resource-group mygroup --name myserver
```

Then use your favourate tool like “[Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio)” to connect to the Postgres and run below command to make the database capable to work with timescale extension

```postgresql
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
```

now you are good and then try connecting to the Postgres on cloud..