import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15

import gripper 1.0
import "devices"
import "common"

ApplicationWindow {
    visible: true
    width: 1024
    height: 768
    title: gripper.title + " " + gripper.version

    StackView {
        id: globalStackView
        anchors.fill: parent
        initialItem: gripperComponent
    }

    Gripper {
        id: gripper
    }

    Component {
        id: gripperComponent
        GripperPageQt5 { }
    }

    InfoPopup {
        id: globalInfoPopup
    }
}
