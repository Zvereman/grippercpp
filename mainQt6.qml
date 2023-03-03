import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15

import gripper 1.0
import "devices"
import "common"

Item {
    visible: true

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
        GripperPageQt6 { }
    }

    InfoPopup {
        id: globalInfoPopup
    }
}
