# Database

## Sql
### How to improve MySQL Performance?
- System MySQL Performance
    1. Storage -> ssd to improve performance
    2. Processor -> use top -> Pay attention to the MySQL processes and the percentage of processor usage they require
    3. Memory (Ram) -> adjust the memory cache (more on that later) to improve performance
    4. Network -> monitor network traffic to make sure you have sufficient infrastructure to manage the load,
       make sure you have enough network bandwidth to accommodate your normal levels of database traffic
    5. Use InnoDB, Not MyISAM: MyISAM is an older database style used for some MySQL databases. It is a less efficient database design,
       InnoDB uses a clustered index and keeps data in pages, which are stored in consecutive physical blocks. If a value is too large for a page, 
       InnoDB moves it to another location, then indexes the value
- Software MySQL Performance Tuning
    1. Using an Automatic Performance Improvement Tool (mysqltuner/tuning-primer)
    2. Optimize Queries: There are some query operators that, by their very nature, take a long time to run,
    3. Use indexes where appropriate
    4. Avoid using a function in the predicate of a query (UPPER)
       The UPPER notation creates a function, which must operate during the SELECT operation. 
       This doubles the work the query is doing, and you should avoid it if possible
    5. Avoid % Wildcard in a Predicate
    6. Specify Columns in SELECT Function
    7. Use ORDER BY Appropriately: The ORDER BY expression sorts results by the specified column. 
       It can be used to sort by two columns at once.
       These should be sorted in the same order, ascending or descending
    8. GROUP BY Instead of SELECT DISTINCT: The SELECT DISTINCT query comes in handy when trying to get rid of duplicate values. 
       However, the statement requires a large amount of processing power.
    9. JOIN, WHERE, UNION, DISTINCT: Try to use an inner join whenever possible, outer join very costly
    10. MySQL Server Configuration: query_cache_size, max_connection, innodb_buffer_pool_size, innodb_io_capacity
    11. Partitioning
    12. Sharding
    
### Drawback of indexes
- The index itself occupies space on disk and memory (when used)
- When data is inserted/updated/deleted, then the index needs to be updated as well as the original data (re-index)

### References
Ref: [What are the disadvantages to Indexes in database tables?](https://stackoverflow.com/questions/41410482/what-are-the-disadvantages-to-indexes-in-database-tables) \
Ref: [MySQL Performance Tuning and Optimization Tips](https://phoenixnap.com/kb/improve-mysql-performance-tuning-optimization) \
## No Sql