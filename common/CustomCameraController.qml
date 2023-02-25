import QtQuick 2.15
import QtQml 2.15
import Qt3D.Core 2.12
import Qt3D.Input 2.12
import Qt3D.Render 2.12
import Qt3D.Logic 2.12
import Qt3D.Extras 2.12

Entity {
    id: rootEntity

    property Camera camera
    property real lookSpeed: 180.0
    property real linearSpeed: 50.0

    QtObject {
        id: attributes
        property bool keyUpPressed: false
        property bool leftButtonPressed: false
        property real dx: 0.0
        property real dy: 0.0
    }

    MouseDevice {
        id: mouseDevice
    }

    KeyboardDevice {
        id: keyboardDevice
    }

    LogicalDevice {
        id: logicalDevice

        actions: [
            Action {
                inputs: [
                    ActionInput {
                        buttons: [Qt.Key_Up]
                        sourceDevice: keyboardDevice
                    }
                ]

                onActiveChanged: {
                    attributes.keyUpPressed = isActive
                }
            },
            Action {
                inputs: [
                    ActionInput {
                        buttons: [Qt.LeftButton]
                        sourceDevice: mouseDevice
                    }
                ]

                onActiveChanged: {
                    attributes.leftButtonPressed = isActive
                }
            }
        ]

        axes: [
            Axis {
                inputs: [
                    AnalogAxisInput {
                        axis: MouseDevice.X
                        sourceDevice: mouseDevice
                    }
                ]

                onValueChanged: {
                    attributes.dx = value
                }
            },
            Axis {
                inputs: [
                    AnalogAxisInput {
                        axis: MouseDevice.Y
                        sourceDevice: mouseDevice
                    }
                ]

                onValueChanged: {
                    attributes.dy = value
                }
            }
        ]
    }

    FrameAction {
        onTriggered: {
            if (attributes.leftButtonPressed === true) {
                camera.panAboutViewCenter(-attributes.dx * lookSpeed * dt)
                camera.tiltAboutViewCenter(-attributes.dy * lookSpeed * dt)
            }

            if (attributes.keyUpPressed === true) {
                camera.rollAboutViewCenter(0.5 * lookSpeed * dt)
            }
        }
    }
}
