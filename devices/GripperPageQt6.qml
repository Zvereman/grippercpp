import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtCharts 2.15
import QtQuick.Scene3D 2.15

import "../common"

Page {
    id: root
    anchors.fill: parent

    property double sliderPosStep: 0.5
    property double sliderVelStep: 1

    // Min gripper position value
    property int minPositionValue: 0
    // Max gripper position value
    property int maxPositionValue: 1000
    // Min gripper velocity value in %
    property int minVelocityValue: 1
    // Max gripper velocity value in %
    property int maxVelocityValue: 100

    property bool inited: false

    function gripperPosition() {
        let tempVal = 0
        tempVal = currentPositionSlider.second.value - currentPositionSlider.first.value
        return tempVal.toFixed(0)
    }

    function setGripper3DPosition(currPosition) {
        gripper3DView.fingersX = currPosition * 0.001
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: 10
        }

        RowLayout {

            Scene3D {
                focus: true
                aspects: ["input", "logic"]
                cameraAspectRatioMode: Scene3D.AutomaticAspectRatio
                Gripper3DViewQt6 {
                    id: gripper3DView
                }

                Layout.fillHeight: true
                Layout.preferredWidth: root.width * 0.5
            }

            ColumnLayout {

                GText {
                    text: qsTr("Last gripper positions:")
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                PositionChartQt6 {
                    id: scopeView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Layout.fillHeight: true
            }

            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        RowLayout {

            // Buttons
            GridLayout {
                rows: 2
                columns: 2

                Button {
                    text: qsTr("Connect Device")
                    onClicked: {
                        gripper.connectDevice()
                    }
                    Layout.fillWidth: true
                }
                Button {
                    text: qsTr("Disconnect Device")
                    onClicked: {
                        gripper.disconnectDevice()
                    }
                    Layout.fillWidth: true
                }

                Button {
                    id: openGripperButton
                    enabled: false
                    text: qsTr("Open gripper")
                    onClicked: {
                        gripper.setPosition(maxPositionValue)
                        currentPositionSlider.setValues(minPositionValue, maxPositionValue)
                    }
                    Layout.fillWidth: true
                }
                Button {
                    id: closeGripperButton
                    enabled: false
                    text: qsTr("Close gripper")
                    onClicked: {
                        gripper.setPosition(minPositionValue)
                        currentPositionSlider.setValues(minPositionValue + (maxPositionValue / 2),
                                                        maxPositionValue / 2)
                    }
                    Layout.fillWidth: true
                }
                Layout.fillWidth: true
            }

            // Position
            ColumnLayout {
                GText {
                    text: qsTr("Gripper position:")
                    Layout.fillWidth: true
                }

                Frame {
                    ColumnLayout {
                        anchors {
                            fill: parent
                        }

                        RowLayout {
                            GText {
                                text: qsTr("Current gripper position:")
                            }
                            GText {
                                id: gripperCurrentPosition
                                Layout.fillWidth: true
                                Layout.alignment: Text.AlignLeft
                            }
                            Layout.fillWidth: true
                        }

                        GText {
                            text: qsTr("Set gripper position to: ") + gripperPosition()
                            Layout.fillWidth: true
                        }

                        RangeSlider {
                            id: currentPositionSlider

                            enabled: false

                            from: minPositionValue
                            to: maxPositionValue

                            stepSize: sliderPosStep
                            snapMode: RangeSlider.SnapAlways

                            Layout.fillWidth: true

                            first.onMoved: {
                                second.value = maxPositionValue - first.value
                                gripper.setPosition(gripperPosition())
                            }
                            second.onMoved: {
                                first.value = maxPositionValue - second.value
                                gripper.setPosition(gripperPosition())
                            }
                        }
                    }
                    Layout.fillWidth: true
                }
                Layout.fillWidth: true
            }

            // Velocity
            ColumnLayout {
                GText {
                    text: qsTr("Gripper velocity:")
                    Layout.fillWidth: true
                }

                Frame {
                    ColumnLayout {
                        anchors {
                            fill: parent
                        }

                        GText {
                            text: qsTr("Set gripper velocity to: ") + gripperVelocitySlider.value.toFixed(0) + "%"
                            Layout.fillWidth: true
                        }

                        Slider {
                            id: gripperVelocitySlider

                            enabled: false

                            value: gripper.currentVelocity

                            from: minVelocityValue
                            to: maxVelocityValue

                            stepSize: sliderVelStep
                            snapMode: RangeSlider.SnapAlways

                            Layout.fillWidth: true
                            onMoved: {
                                gripper.setVelocity(gripperVelocitySlider.value.toFixed(0))
                            }
                        }
                    }
                    Layout.fillWidth: true
                }
                Layout.fillWidth: true
            }
            Layout.fillWidth: true
        }
    }

    Connections {
        target: gripper

        function onIsConnectedChanged(isConnected) {
            if (isConnected) {
                gripperVelocitySlider.enabled = isConnected
                currentPositionSlider.enabled = isConnected
                openGripperButton.enabled = isConnected
                closeGripperButton.enabled = isConnected

                scopeView.getChartInfoTimer.start()

                let tempFirst = minPositionValue + ((maxPositionValue - gripper.currentPosition) / 2)
                let tempSecond = maxPositionValue - ((maxPositionValue - gripper.currentPosition) / 2)
                currentPositionSlider.setValues(tempFirst, tempSecond)
            } else {
                gripperVelocitySlider.enabled = isConnected
                currentPositionSlider.enabled = isConnected
                openGripperButton.enabled = isConnected
                closeGripperButton.enabled = isConnected

                scopeView.getChartInfoTimer.stop()

                currentPositionSlider.setValues(0, 0)
                gripperVelocitySlider.value = 1

                inited = false
            }
        }

        function onCurrentPositionChanged(currPos) {
            gripperCurrentPosition.text = currPos
            setGripper3DPosition(currPos)
            if (!inited) {
                let tempFirst = minPositionValue + ((maxPositionValue - gripper.currentPosition) / 2)
                let tempSecond = maxPositionValue - ((maxPositionValue - gripper.currentPosition) / 2)
                currentPositionSlider.setValues(tempFirst, tempSecond)
                inited = true
            }
        }

        function onCurrentVelocityChanged(currVel) {
            gripperVelocitySlider.value = currVel
        }

        function onInfoMsg(msgText, noError) {
            globalInfoPopup.showMessage(msgText, noError)
        }
    }
}
