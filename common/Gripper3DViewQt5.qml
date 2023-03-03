import QtQuick 2.12
import QtQuick3D 1.15
import QtQuick3D.Materials 1.15

View3D {
    property real rotationAngle: -180
    property color mainColor: "#969696"

    property real fingersX: 1.0

    property real leftFingerX: 15.0 - (15.0 * fingersX)
    property real rightFingerX: 15.0 - (15.0 * fingersX)

    DirectionalLight {
        ambientColor: Qt.rgba(0.2, 0.2, 0.2, 1.0)
    }

    PointLight {
        id: topLightLeft
        brightness: 200
        constantFade: 1.0
        position: Qt.vector3d(25, 130, -120)
    }

    PointLight {
        id: topLightRight
        brightness: 200
        constantFade: 1.0
        position: Qt.vector3d(85, 130, -120)
    }

    PerspectiveCamera {
        id: camera
        eulerRotation.x: -40
        eulerRotation.y: -40
        position: Qt.vector3d(-90, 100, 30)
    }

    Model {
        source: "qrc:/objects/body.mesh"
        position: Qt.vector3d(0, 0, 0)
        eulerRotation.x: rotationAngle
        materials: [
            PrincipledMaterial {
                baseColor: mainColor
                metalness: 0.75
                roughness: 0.1
                specularAmount: 1.0
                indexOfRefraction: 2.5
                opacity: 1.0
            }
        ]
    }
    Model {
        source: "qrc:/objects/rotor.mesh"
        position: Qt.vector3d(0, 0, 0)
        eulerRotation.x: rotationAngle
        materials: [
            PrincipledMaterial {
                baseColor: mainColor
                metalness: 0.75
                roughness: 0.1
                specularAmount: 1.0
                indexOfRefraction: 2.5
                opacity: 1.0
            }
        ]
    }
    Model {
        source: "qrc:/objects/finger_left.mesh"
        position: Qt.vector3d(-leftFingerX, 0, 0)
        eulerRotation.x: rotationAngle
        materials: [
            PrincipledMaterial {
                baseColor: mainColor
                metalness: 0.75
                roughness: 0.1
                specularAmount: 1.0
                indexOfRefraction: 2.5
                opacity: 1.0
            }
        ]
    }
    Model {
        source: "qrc:/objects/finger_right.mesh"
        position: Qt.vector3d(rightFingerX, 0, 0)
        eulerRotation.x: rotationAngle
        materials: [
            PrincipledMaterial {
                baseColor: mainColor
                metalness: 0.75
                roughness: 0.1
                specularAmount: 1.0
                indexOfRefraction: 2.5
                opacity: 1.0
            }
        ]
    }
}
