Spark’s primary abstraction is a distributed collection of items called a Dataset. Datasets can be created from Hadoop InputFormats (such as HDFS files) or by transforming other Datasets. [1](https://spark.apache.org/docs/latest/quick-start.html)
# How does spark relate to hadoop
[2](https://spark.apache.org/faq.html#:~:text=How%20does%20Spark%20relate%20to,Hive%2C%20and%20any%20Hadoop%20InputFormat.)
- Spark is a processing engine compatible with HDFS data.
- It can run in hadoop clusters through YARN.
- It can process data in hdfs, hbase, cassandra, hive and any hadoop InputFormat.

# RDD is outdated. Dataset is new
RDDs has been replaced by Dataset after Spark 2.0 [2](https://spark.apache.org/docs/latest/quick-start.html)
- Dataset has better performance than RDD.


