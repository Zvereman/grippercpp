# grippercpp
Gripper ASBIS. Modbus TCP

This is a small gripper control program. It is also an example of using the Modbus TCP protocol developed using C++ and a dynamic chart created using QML.
The connection to the gripper occurs via the Modbus TCP protocol on the host **HOST_ADDRESS** (127.0.0.1) and port **HOST_PORT** (5502). By default, the device has ID = 1. There is **defines.h** in project, so you can find it there.

The following functionality has been implemented:

- Set gripper position
- Set gripper velocity
- Get a chart of gripper position change over the last 10 seconds

This is an open project and anyone can use it for their own purposes. :)


V 1.2.3

- Added 3D demonstration of gripper position
- Moved to Qt6 for better performance
