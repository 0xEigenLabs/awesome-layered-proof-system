set(CMAKE_CXX_STANDARD 11)

add_definitions(-DCURVE=BN128)

include_directories(/usr/local/include)
include_directories(../libsnark)
include_directories(../libsnark/depends/libfqfft/)
link_directories(/usr/local/lib)

add_executable(vitalik vitalik.cpp)

target_link_libraries(vitalik ff)
target_link_libraries(vitalik gmpxx)
target_link_libraries(vitalik gmp)
target_link_libraries(vitalik procps)
