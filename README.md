## Compile
```
git clone https://github.com/ieigen/zkp_sample
cd zkp_sample
docker run --name psi -v $PWD:/app -w /app -it debian:9 bash

apt-get install build-essential cmake git libgmp3-dev libprocps-dev python-markdown libboost-all-dev libssl-dev pkg-config -y

git submodule update --init --recursive
mkdir build && cd build
cmake ..
```

## Test

```
# in build directory
cd helloworld
./vitalik

# or 
cd merkle
./merkle setup
#./merkle prove [data1] [data2] [data3] [data4] [data5] [data6] [data7] [data8] [index]
./merkle prove  1 2 3 4 5 6 7 8 3
# get the root from above
#./merkle verify [root]
./merkle verify f171e00bb40c83de1f09c64e2cc4558e3c327aa9e8525a467c83576071bc1045
```
