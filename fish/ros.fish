set -e ROS_DISTRO

function use_only_ros1
    set -U use_only_ros1_ 1
end

function ros1_load
    source $fish_scripts_dir/ros1.fish
end

if set -q use_only_ros1_ && test $use_only_ros1_ -ne 0
    source $fish_scripts_dir/ros1.fish
    echo "ROS1 (ROS_MASTER_URI: $ROS_MASTER_URI)"
end
