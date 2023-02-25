import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15

import gripper 1.0
import "devices"
import "common"

Item {
    visible: true
    width: Screen.width * 0.3
    height: Screen.height * 0.4

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
        GripperPage { }
    }

    InfoPopup {
        id: globalInfoPopup
    }
}
