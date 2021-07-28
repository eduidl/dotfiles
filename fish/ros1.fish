for dist in melodic noetic
    set -l path /opt/ros/$dist/setup.bash
    if test -f $path
        bass source $path
        break
    end
end

function ros1_local
    set -e ros1_master_ip ros1_local_ip
    exec fish
end

function ros1_server
    set -U ros1_master_ip (hostname -I| cut -d' ' -f1)
    set -e ros1_local_ip
    exec fish
end

function ros1_client
    set -U ros1_master_ip $argv[1]
    set -U ros1_local_ip (hostname -I| cut -d' ' -f1)
    exec fish
end

if command_exist roscore
    if set -q ros1_master_ip
        set -x ROS_MASTER_URI http://$ros1_master_ip:11311
    else
        set -x ROS_MASTER_URI http://localhost:11311
    end

    if set -q ros1_local_ip
        set -x ROS_IP $ros1_local_ip
        set -e ROS_HOSTNAME
    else if set -q ros1_master_ip
        set -x ROS_IP $ros1_master_ip
        set -e ROS_HOSTNAME
    else
        set -x ROS_HOSTNAME localhost
        set -e ROS_IP
    end

    set -l path /opt/ros/$ROS_DISTRO/share/rosbash/rosfish
    if test -f $path
        source $path
    end

    set -l path ~/catkin_ws/devel/setup.bash
    if test -f $path
        bass source $path
    end
end
