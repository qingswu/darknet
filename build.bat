pushd build
del CMakeCache.txt
cmake .. -DRT=/MDd -G"Visual Studio 14 Win64"
cmake --build . --config debug
del CMakeCache.txt
cmake .. -DRT=/MD -G"Visual Studio 14 Win64"
cmake --build . --config release
popd
