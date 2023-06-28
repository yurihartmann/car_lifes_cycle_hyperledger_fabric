# 🏄🏼‍♂️ Performance Results

## 🔹 In Read method in car chaincode

In this file: `chaincodes/car-chaincode/src/baseContract.ts` 
This method: `Read`


| Entities car number | 1 req (miliseconds) | 30 req simultaneous (miliseconds) | time affected |
|-----------------|---------------------|-----------------------------------|---------------|
| 1_000           | 2163                | 2619                              | + 21%         |
| 10_000          | 2165                | 2589                              | + 19,5%       |
| 100_000         | 2156                | 2632                              | + 22%         |
| 1_000_000       | 2186                | 2553                              | + 16,7%       |

## 🔹 In CreateCar method in car chaincode

In this file: `chaincodes/car-chaincode/src/carContract.ts` 
This method: `AddCar`


| Entities car number | 1 req (miliseconds) | 30 req simultaneous (miliseconds) | time affected |
|-----------------|---------------------|-----------------------------------|---------------|
| 1_000           | 2180                | 3387                              | + 55,3%       |
| 10_000          | 2182                | 3419                              | + 56,6%       |
| 100_000         | 2179                | 3418                              | + 56,8%       |
| 1_000_000       | 2179                | 2277                              | + 54,9%       |
