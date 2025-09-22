ZeRO-DP: ZeRO powered Data parallelism
- It does not use traditional data parallelism. It uses a hybrid between MP and DP.
- Retains communication efficiency of DP by maintaining the computational granularity and communication volume of DP using a *dynamic communication schedule*. 
ZeRO-DP has 3 main optimization stages
1. Optimizer state partitioning.
2. Add Gradient Partitioning.
3. Add Parameter partitioning.
ZeRO-R: Optimizes Memory consumption by residual states.
- Removed activation replication using existing MP approaches through activation partitioning.
- Finds the right buffer size.

ZeRO-R vs MP
- MP has lower memory footprint for larger models.
- ZeRO can be combined with MP to achieve a **maximum theoretical memory reduction** of $N_d \times N_m$ 

