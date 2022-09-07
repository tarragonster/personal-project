# Mongodb Aggregation

### 1. What is aggregation in Mongodb?

- Aggregation is a way of processing a large number of documents in 
a collection by means of passing them through different stages. The 
stages make up what is known as a pipeline. The stages in a pipeline 
can filter, sort, group, reshape and modify documents that pass 
through the pipeline

### 2. aggregate parameters?

```shell
db.collection.aggregate(pipeline, options)
```

| Parameter |   Type   |                                                            Description |
|-----------|:--------:|-----------------------------------------------------------------------:|
| pipeline  |  array   |                A sequence of data aggregation `operations` or `stages` |
| options   | document |    Additional options that aggregate() passes to the aggregate command |

- Ref: [aggregate](https://www.mongodb.com/docs/manual/reference/command/aggregate/)
- Ref: [db.collection.aggregate()](https://www.mongodb.com/docs/manual/reference/method/db.collection.aggregate/)

### 3. Aggregation Pipeline Stages?

- `$match`: Filters the document stream to allow only matching documents to pass unmodified into the next pipeline stage
- `$project`: Reshapes each document in the stream, such as by adding new fields or removing existing fields
- `$group`: Groups input documents by a specified identifier expression and applies the accumulator expression(s)
- `$out`: Writes the resulting documents of the aggregation pipeline to a collection. To use the $out stage, it must be the last stage in the pipeline
- `$unwind`: Deconstructs an array field from the input documents to output a document for each element
- `$sort`: Reorders the document stream by a specified sort key. Only the order changes; the documents remain unmodified. For each input document, outputs one document
- `$limit`: Passes the first n documents unmodified to the pipeline where n is the specified limit
- `$addFields`: Adds new fields to documents. Similar to $project, $addFields reshapes each document in the stream
- `$count`: Returns a count of the number of documents at this stage of the aggregation pipeline
- `$lookup`: Performs a left outer join to another collection in the same database to filter in documents from the "joined" collection for processing
- `$sortByCount`: Groups incoming documents based on the value of a specified expression, then computes the count of documents in each distinct group
- `$facet`: Processes multiple aggregation pipelines within a single stage on the same set of input documents
- `$merge`: Writes the resulting documents of the aggregation pipeline to a collection, it must be the last stage in the pipeline

- Ref: Mongodb - [Aggregation Pipeline Stages](https://www.mongodb.com/docs/manual/reference/operator/aggregation-pipeline/)
- Ref: 3T - [The Beginner’s Guide to MongoDB Aggregation (With Exercise)](https://studio3t.com/knowledge-base/articles/mongodb-aggregation-framework/#mongodb-facet)

### 4. Aggregation Pipeline Operators?

- Arithmetic Expression Operators
- Array Expression Operators
- Boolean Expression Operators
- Comparison Expression Operators
- Conditional Expression Operators
- Custom Aggregation Expression Operators
- Data Size Operators
- Date Expression Operators
- Literal Expression Operator
- Miscellaneous Operators
- Object Expression Operators
- Set Expression Operators
- String Expression Operators
- Text Expression Operator
- Timestamp Expression Operators
- Trigonometry Expression Operators
- Type Expression Operators
- Accumulators ($group, $bucket, $bucketAuto, $setWindowFields)
- Accumulators (in Other Stages)
- Variable Expression Operators
- Window Operators

- Ref: Mongodb - [Aggregation Pipeline Operators](https://www.mongodb.com/docs/manual/reference/operator/aggregation/)

### 5. Indexes?

- Indexes support the efficient execution of queries in MongoDB. Without indexes, MongoDB must perform a collection scan, i.e. scan every document in a collection, to select those documents that match the query statement. If an appropriate index exists for a query, MongoDB can use the index to limit the number of documents it must inspect


- Index Types
  * Single Field
  * Compound Index
  * Multikey Index
  * Geospatial Index
  * Text Indexes
  * Hashed Indexes
  * Clustered Indexes
- Index Properties
  * Partial Indexes
  * Sparse Indexes
  * TTL Indexes
  * Hidden Indexes

### 6. Practicing?

- Ref: [How To Use Aggregations in MongoDB](https://www.digitalocean.com/community/tutorials/how-to-use-aggregations-in-mongodb)