import QtQuick 2.12
import Qt3D.Core 2.12
import Qt3D.Input 2.12
import Qt3D.Render 2.12
import Qt3D.Logic 2.12
import Qt3D.Extras 2.12

Entity {
    id: rootEntity

    property real someProp: 0

    property real cameraPosX: -50.0
    property real cameraPosY: 80.0
    property real cameraPosZ: 25.0

    property real cameraViewCenterX: -35.0
    property real cameraViewCenterY: 50.0
    property real cameraViewCenterZ: -8.0

    property real fingersX: 1.0

    property real leftFingerX: 15.0 - (15.0 * fingersX)
    property real rightFingerX: 15.0 - (15.0 * fingersX)

    Camera {
        id: mainCamera
        projectionType: CameraLens.PerspectiveProjection
        fieldOfView: 60.0
        aspectRatio: 16.0 /9.0
        nearPlane: 0.1
        farPlane: 1000.0
        position: Qt.vector3d(cameraPosX, cameraPosY, cameraPosZ)
        upVector: Qt.vector3d(0.0, 1.0, 0.0)
        viewCenter: Qt.vector3d(cameraViewCenterX, cameraViewCenterY, cameraViewCenterZ)
    }

//    // Uncomment if you want to control the view point
//    // Official camera controller
//    OrbitCameraController {
//        camera: mainCamera
//        lookSpeed: 360
//        linearSpeed: 100
//    }

//    // Uncomment if you want to control the view point
//    // Some custom Controller for Mobile devices
//    // On PC use left mouse button
//    CustomCameraController {
//        camera: mainCamera
//        lookSpeed: 360
//        linearSpeed: 100
//    }

    components: [
        RenderSettings {
            activeFrameGraph: ForwardRenderer {
                clearColor: Qt.rgba(1, 1, 1, 1)
                camera: mainCamera
            }
        },
        InputSettings {}
    ]

    Entity {
        PointLight {
            id: firstLight
            intensity: 1
        }

        Transform {
            id: firstLightTransform
            translation: Qt.vector3d(50.0, 100.0, 100.0)
        }

        components: [firstLight, firstLightTransform]
    }

    Entity {
        PointLight {
            id: secLight
            intensity: 1
        }

        Transform {
            id: seclightTransform
            translation: Qt.vector3d(-50.0, -100.0, -100.0)
        }

        components: [secLight, seclightTransform]
    }

    Entity {
        SceneLoader {
            id: bodyLoader
            source: "qrc:/obj/g_body.obj"
        }

        Transform {
            id: bodyTransform
            translation: Qt.vector3d(0.0, 0.0, 0.0)
            rotationX: 270
        }

        components: [bodyLoader, bodyTransform]
    }

    Entity {
        SceneLoader {
            id: leftFingerLoader
            source: "qrc:/obj/g_finger_left.obj"
        }

        Transform {
            id: leftFingerTransform
            translation: Qt.vector3d(-leftFingerX, 0.0, 0.0)
            rotationX: 270
        }

        components: [leftFingerLoader, leftFingerTransform]
    }

    Entity {
        SceneLoader {
            id: rightFingerLoader
            source: "qrc:/obj/g_finger_right.obj"
        }

        Transform {
            id: rightFIngerTransform
            translation: Qt.vector3d(rightFingerX, 0.0, 0.0)
            rotationX: 270
        }

        components: [rightFingerLoader, rightFIngerTransform]
    }
}
