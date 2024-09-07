#!/bin/bash
mkdir -p src
sudo rosdep update
sudo rosdep install --from-paths /home/race_stack/src --ignore-src -y
sudo chown -R $(whoami) /home/race_stack/
colcon build --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --cmake-clean-cache