# cram_avatar
```
cd ~/catkin_ws/src
wstool init
wstool merge https://raw.github.com/abdelker/cram_avatar/neemhub/dependencies.rosinstall
wstool update
rosdep install --ignore-src --from-paths .
cd ~/catkin_ws
catkin_make
```
